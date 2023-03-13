package Samizdat::Controller::Markdown;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub geturi ($self) {
  my $docpath = $self->stash('docpath');
  my $html = $self->app->__x("The page {docpath} wasn't found.", docpath => '/' . $docpath);
  my $title = $self->app->__('404: Missing document');

  my $docs = $self->app->markdown->list($docpath, {
    language => $self->app->language,
    languages => $self->app->{config}->{locale}->{languages},
  });
  my $path = sprintf("%s%s", $docpath, 'index.html');
  $self->stash(template => 'index');

  if (!exists($docs->{$path})) {
    $path = '404.html';
    $self->stash('status', 404);
    $docs->{'404.html'} = {
      url         => $docpath,
      docpath     => '404.html',
      title       => $title,
      main        => $html,
      children    => [],
      subdocs     => [],
      description => $self->app->__('Missing file, our bad?'),
      keywords    => [],
      language => $self->app->language,
    };
  } else {
    $docs->{$path}->{canonical} = sprintf('%s%s', $self->config->{siteurl}, $docpath);
    $docs->{$path}->{meta}->{property}->{'og:title'} = $docs->{$path}->{title};
    $docs->{$path}->{meta}->{property}->{'og:url'} = $docs->{$path}->{canonical};
    $docs->{$path}->{meta}->{property}->{'og:canonical'} = $docs->{$path}->{canonical};
    $docs->{$path}->{meta}->{name}->{'twitter:url'} = $docs->{$path}->{canonical};
    $docs->{$path}->{meta}->{name}->{'twitter:title'} = $docs->{$path}->{title};
    $docs->{$path}->{meta}->{itemprop}->{'name'} = $docs->{$path}->{title};
    if (exists $docs->{$path}->{meta}->{name}->{description}) {
      $docs->{$path}->{meta}->{property}->{'og:description'} = $docs->{$path}->{meta}->{name}->{description};
      $docs->{$path}->{meta}->{name}->{'twitter:description'} = $docs->{$path}->{meta}->{name}->{description};
      $docs->{$path}->{meta}->{itemprop}->{'description'} = $docs->{$path}->{meta}->{name}->{description};
    }
    if ($#{$docs->{$path}->{subdocs}} > -1) {
      my $sidebar = '';
      for my $subdoc (sort {$a->{docpath} cmp $b->{docpath}} @{ $docs->{$path}->{subdocs} }) {
        $sidebar .= $self->render_to_string(template => 'chunks/sidecard', card => $subdoc);
      }
      $docs->{$path}->{sidebar} = $sidebar;
      $self->stash(template => 'twocolumn');
    }
  }
  $self->stash(web => $docs->{$path});
  $self->stash(title => $docs->{$path}->{title} // $title);
  $self->render();
}

1;
