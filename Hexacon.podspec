Pod::Spec.new do |spec|
  spec.name = "Hexacon"
  spec.version = "1.0.0"
  spec.summary = "A fancy hexagonal layout for displaying data like your Apple Watch"
  spec.homepage = "https://github.com/gautier-gdx/Hexacon"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Gautier Gédoux" => 'gautier@swapcard.com' }
  spec.social_media_url = "https://twitter.com/gautgaut"

  spec.platform = :ios, "8.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/gautier-gdx/Hexacon.git", tag: "{spec.version}", submodules: true }
  spec.source_files = "Hexacon/*.{h,swift}"
end