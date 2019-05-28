Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CFC1C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 16:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C98D2070D
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 16:27:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MVL1X4Pj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfE1Q1n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 12:27:43 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:46438 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfE1Q1m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 12:27:42 -0400
Received: by mail-oi1-f194.google.com with SMTP id 203so14728556oid.13
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2019 09:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MbLTZs5RdUHuUtreDeeGCkiUvCRi2kbONWg19odSeTs=;
        b=MVL1X4PjKN4FMBQDu4aiBTHpxUlVxbfbwh6DLMQiKgcDsLCSRWrvTcRB1D/Oh32nsX
         0Gyuc3T0cv4KdVcSjHXOALyyjC5byf6YBb9s6zbmXXAC9y7HiekYeu9fDVZav3bWU0nj
         RoGnb2w6uqm+f4IyiFhnTdYFpdigYiQzIMBpvy0PR6BTly2uA5eQiaJPBvgOxyxMHQg8
         HTkIOuf64SDWLA3SONexYBFIdD7ptHtdzhQXgfSYoxiet8VcJ9LuCWAXXR2WnEpnoGpr
         5RBuUHOJL7lZNN2DeJOo6tv2N8+TvNeU5ASFf/uvummKlet5t8gsHkLUB3x27qB/tR6L
         0kfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MbLTZs5RdUHuUtreDeeGCkiUvCRi2kbONWg19odSeTs=;
        b=YCCfSqVQX6wCLkVQwCKqcChCNnuL/5RfSESvAbIuRSTO1WS9iRDpkgVBuJhIttt8zV
         veWiaI2TikbVoUIMj2ErEVQwSm3qI5jh6HW6N+l4lQhLZrd9Iyf6ofh+n7/b3uwIdqzv
         3ply3w7gEsvW8wgLEexj6OV32DJLKb1g4PZsp8QgfB2Uai7na+1RrfGbYuiSTj2ZlmC6
         Qab3QsyYOjBmv4FezVmcbMcPY3Gg8B4yAFO6fjPYWW2fzPW8aiw020zXlMH+6cYQlOwW
         HvrvEkltBjDshxlWyeaL9DL3SE77pyIxWcacQUYkAV6kzidhbGBG5+8G/guxYQYcsebB
         t+Xw==
X-Gm-Message-State: APjAAAVFnHrCb5mdH7KWNmwg/pCrarQVWSNGbWRmnwFpIJdZxclwnm5r
        X+xXQeAxxKAhVoTav4C+xmiYvckV7T/v2fk/D5o=
X-Google-Smtp-Source: APXvYqwMa2v4r7L/xY4/c+oWsEz2K4LHd46AOgGPH8xAf2mx7X32nOwOD2Yj89y3JMU4gzi+d8e8JkuMxz6Boi9hF4M=
X-Received: by 2002:aca:4dc2:: with SMTP id a185mr3097307oib.50.1559060861922;
 Tue, 28 May 2019 09:27:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190527235021.6874-1-shekhar250198@gmail.com>
In-Reply-To: <20190527235021.6874-1-shekhar250198@gmail.com>
From:   Shivani Bhardwaj <shivanib134@gmail.com>
Date:   Tue, 28 May 2019 21:57:37 +0530
Message-ID: <CAKHNQQFzECQLWRBmraZozQsMr7fAOdTV=j7FpvAasNaXo0Dhag@mail.gmail.com>
Subject: Re: [PATCH nft v5] tests: py: fix python3
To:     Shekhar Sharma <shekhar250198@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 28, 2019 at 5:21 AM Shekhar Sharma <shekhar250198@gmail.com> wrote:
>
> This patch converts the 'nft-test.py' file to run on both python 2 and python3.
>
> The version hystory of this patch is:
> v1:conversion to py3 by changing the print statements.
> v2:add the '__future__' package for compatibility with py2 and py3.
> v3:solves the 'version' problem in argparse by adding a new argument.
> v4:uses .format() method to make print statements clearer.
> v5: updated the shebang and corrected the sequence of import statements.
>
>
> Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> ---
>  tests/py/nft-test.py | 44 +++++++++++++++++++++++---------------------
>  1 file changed, 23 insertions(+), 21 deletions(-)
>
> diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> index 1c0afd0e..fe56340c 100755
> --- a/tests/py/nft-test.py
> +++ b/tests/py/nft-test.py
> @@ -1,4 +1,4 @@
> -#!/usr/bin/python2
> +#!/usr/bin/python
>  #
>  # (C) 2014 by Ana Rey Botello <anarey@gmail.com>
>  #
> @@ -13,6 +13,7 @@
>  # Thanks to the Outreach Program for Women (OPW) for sponsoring this test
>  # infrastructure.
>
> +from __future__ import print_function
>  import sys
>  import os
>  import argparse
> @@ -436,7 +437,7 @@ def set_delete(table, filename=None, lineno=None):
>      '''
>      Deletes set and its content.
>      '''
> -    for set_name in all_set.keys():
> +    for set_name in list(all_set.keys()):
What exactly is this list() for? This is not a generator expression.

>          # Check if exists the set
>          if not set_exist(set_name, table, filename, lineno):
>              reason = "The set %s does not exist, " \
> @@ -1002,9 +1003,9 @@ def execute_cmd(cmd, filename, lineno, stdout_log=False, debug=False):
>      :param debug: temporarily set these debug flags
>      '''
>      global log_file
> -    print >> log_file, "command: %s" % cmd
> +    print("command: {}".format(cmd), file = log_file)
>      if debug_option:
> -        print cmd
> +        print(cmd)
>
>      if debug:
>          debug_old = nftables.get_debug()
> @@ -1198,7 +1199,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
>          sys.stdout.flush()
>
>          if signal_received == 1:
> -            print "\nSignal received. Cleaning up and Exitting..."
> +            print("\nSignal received. Cleaning up and Exitting...")
>              cleanup_on_exit()
>              sys.exit(0)
>
> @@ -1305,13 +1306,13 @@ def run_test_file(filename, force_all_family_option, specific_file):
>
>      if specific_file:
>          if force_all_family_option:
> -            print print_result_all(filename, tests, total_warning, total_error,
> -                                   total_unit_run)
> +            print(print_result_all(filename, tests, total_warning, total_error,
> +                                   total_unit_run))
>          else:
> -            print print_result(filename, tests, total_warning, total_error)
> +            print(print_result(filename, tests, total_warning, total_error))
>      else:
>          if tests == passed and tests > 0:
> -            print filename + ": " + Colors.GREEN + "OK" + Colors.ENDC
> +            print(filename + ": " + Colors.GREEN + "OK" + Colors.ENDC)
>
>      f.close()
>      del table_list[:]
> @@ -1322,7 +1323,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
>
>
>  def main():
> -    parser = argparse.ArgumentParser(description='Run nft tests', version='1.0')
> +    parser = argparse.ArgumentParser(description='Run nft tests')
>
>      parser.add_argument('filenames', nargs='*', metavar='path/to/file.t',
>                          help='Run only these tests')
> @@ -1341,6 +1342,10 @@ def main():
>                          dest='enable_json',
>                          help='test JSON functionality as well')
>
> +    parser.add_argument('-v', '--version', action='version',
> +                        version= '1.0',
> +                        help='prints the version information')
Since this message is for the user, it should be "print" IMO.

> +
>      args = parser.parse_args()
>      global debug_option, need_fix_option, enable_json_option
>      debug_option = args.debug
> @@ -1353,15 +1358,15 @@ def main():
>      signal.signal(signal.SIGTERM, signal_handler)
>
>      if os.getuid() != 0:
> -        print "You need to be root to run this, sorry"
> +        print("You need to be root to run this, sorry")
>          return
>
>      # Change working directory to repository root
>      os.chdir(TESTS_PATH + "/../..")
>
>      if not os.path.exists('src/.libs/libnftables.so'):
> -        print "The nftables library does not exist. " \
> -              "You need to build the project."
> +        print("The nftables library does not exist. "
> +              "You need to build the project.")
>          return
>
>      global nftables
> @@ -1411,18 +1416,15 @@ def main():
>              run_total += file_unit_run
>
>      if test_files == 0:
> -        print "No test files to run"
> +        print("No test files to run")
>      else:
>          if not specific_file:
>              if force_all_family_option:
> -                print "%d test files, %d files passed, %d unit tests, " \
> -                      "%d total executed, %d error, %d warning" \
> -                      % (test_files, files_ok, tests, run_total, errors,
> -                         warnings)
> +                print("{} test files, {} files passed, {} unit tests,".format(test_files, files_ok, tests))
> +                print("{} total executed, {} error, {} warning".format(run_total, errors, warnings))
>              else:
> -                print "%d test files, %d files passed, %d unit tests, " \
> -                      "%d error, %d warning" \
> -                      % (test_files, files_ok, tests, errors, warnings)
> +                print("{} test files, {} files passed, {} unit tests".format(test_files, files_ok, tests))
> +                print("{} error, {} warning".format(errors, warnings))
>
>
>  if __name__ == '__main__':
> --
> 2.17.1
>


-- 
Shivani
https://about.me/shivani.bhardwaj
