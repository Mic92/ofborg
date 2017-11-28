let
  p = import <nixpkgs> {};
  pkgs = import (if false
    then p.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs-channels";
      rev = "cfafd6f5a819472911eaf2650b50a62f0c143e3e";
      sha256 = "10xgiyh4hbwwiy8qg70ma1f27nd717aflksk9fx3ci8bmxmqbkkn";
    }
    else p.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";

      # Latest commit of https://github.com/NixOS/nixpkgs/pull/31150
      # as of 2017-11-28, 07:45 EST
      rev = "7e6e3b5cb94663a37a3999f9e8d920207b51ae79";
      sha256 = "05n8x8b17jrdmf2kxhib30k2wmsyabhsdsx0az6fnmas0v76qvc2";
    }) {};


  inherit (pkgs) stdenv;

  phpEnv = stdenv.mkDerivation rec {
    name = "gh-event-forwarder";
    src = null;
    buildInputs = with pkgs; [
      php
      phpPackages.composer
      nix
      git
      php
      curl
      bash
    ];

    HISTFILE = "${src}/.bash_hist";
    passthru.rustEnv = rustEnv;
  };

  rustEnv = stdenv.mkDerivation rec {
    name = "gh-event-forwarder";
    buildInputs = with pkgs; [
      #php
      #phpPackages.composer
      rust.rustc
      rust.cargo
      carnix
      openssl.dev
      pkgconfig
    ];

    HISTFILE = "${toString ./.}/.bash_hist";
  };


in phpEnv
