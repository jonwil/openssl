#! /usr/bin/env perl
# Copyright 2016-2018 The OpenSSL Project Authors. All Rights Reserved.
#
# Licensed under the OpenSSL license (the "License").  You may not use
# this file except in compliance with the License.  You can obtain a copy
# in the file LICENSE in the source distribution or at
# https://www.openssl.org/source/license.html

use strict;
use warnings;

use OpenSSL::Test qw/:DEFAULT srctop_file/;
use OpenSSL::Test::Utils;

setup("test_pkcs12");

plan skip_all => "The PKCS12 command line utility is not supported by this OpenSSL build"
    if disabled("des");

my $pass = "σύνθημα γνώρισμα";

my $savedcp;
    # Running MinGW tests transparently under Wine apparently requires
    # UTF-8 locale...

    foreach(`locale -a`) {
        s/\n\z//;
        if ($_ =~ m/^C\.UTF\-?8/i) {
            $ENV{LC_ALL} = $_;
            last;
        }
    }
$ENV{OPENSSL_WIN32_UTF8}=1;

plan tests => 1;

# just see that we can read shibboleth.pfx protected with $pass
ok(run(app(["openssl", "pkcs12", "-noout",
            "-password", "pass:$pass",
            "-in", srctop_file("test", "shibboleth.pfx")])),
   "test_pkcs12");

SetConsoleOutputCP($savedcp) if (defined($savedcp));
