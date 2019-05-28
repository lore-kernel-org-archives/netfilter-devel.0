Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE41C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 16:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B84292166E
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 16:36:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IobNFj5k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfE1Qgs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 12:36:48 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40272 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfE1Qgs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 12:36:48 -0400
Received: by mail-ot1-f67.google.com with SMTP id u11so18364400otq.7
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2019 09:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QNw1CrZvG4FOG+EUxpRjwhI0LdWrdLQtU5EJ5rvN/Ow=;
        b=IobNFj5k0SU+gSl3RRF7+cMBX4ph9nRhnxLv11pgYWr2GxJnl3SHElYK8REO/WJpYK
         nsTYw9s8WasJsVYfJDcO6ybdaj33urGOzPeJuQGdBHm7kNcWp8CLzMAY/O4g/TmP+reM
         woSVUGhHLmWImIMKQQJ5p/ugTIJQVOFS0W2DLn1qghwc1Eh23UKVYSbkBfDgCIXI8VNO
         nUBmsPU9JQgaODt3vBjl5GPwSDSG8JsOk6hxUfYePpvtstHFCWBgSMAf2boSkLI68c+d
         iBa4dsxOIx6fPn02wD34MBXaUJnw96Kt+g5Dh+URWEqIJbPKIV7hfJazFdir4lYqrLl+
         WEwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QNw1CrZvG4FOG+EUxpRjwhI0LdWrdLQtU5EJ5rvN/Ow=;
        b=c6GCdZWMhIWpEWMaqw3w15La6h+/gqj9lEUt67e+JxgB+L+JrjEWTTFZgbz8mLEKvh
         H7wWSVR3AU19TMu6hFE/rhYXKHlmuQNeAJupOQVfWj7KTDHsZMJxdQHvgVEjMJrTXnzZ
         nRsF1gFEOUlgFUXiUwO6uMWBmPATxvufzHKC1VAiIpE0Ve8zjRa9SkgTYlHZJOZsOPe5
         z7mU/UVd/w/nHnhuz00EKk3pQ5vdEto5YLsfsfhl6v2DD6nYQTBbXclM0CXXzjrEV4ef
         44fYP+/pP9UhiugE40UUBJZVSDFcnmK0fOKMYjQ87Hu87JxnXJgkgRccsiqrPkyTNhyO
         vULA==
X-Gm-Message-State: APjAAAWBkonHZDynnN56Oj2N/p3KDgYWybujOtK6SNXBOG0RLjdAhJN+
        /VuC12CLKoT7IQUyvFR1O8bE0Sy4QVty7OqH8J8=
X-Google-Smtp-Source: APXvYqwCJSDq61PtYZYqZ3weJv/mrdmXlm2FlVW70JXssm3ywymo93HD1xZQEF7VjNH5cPCCTgB8r3TlgAuYfmd8SVM=
X-Received: by 2002:a05:6830:1d5:: with SMTP id r21mr23061240ota.155.1559061407090;
 Tue, 28 May 2019 09:36:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190527235021.6874-1-shekhar250198@gmail.com> <CAKHNQQFzECQLWRBmraZozQsMr7fAOdTV=j7FpvAasNaXo0Dhag@mail.gmail.com>
In-Reply-To: <CAKHNQQFzECQLWRBmraZozQsMr7fAOdTV=j7FpvAasNaXo0Dhag@mail.gmail.com>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Tue, 28 May 2019 22:06:33 +0530
Message-ID: <CAN9XX2oCyzN-RMFF5Sfk7NOY9hyvfKTCStBS7FzwpdfxtvxHyA@mail.gmail.com>
Subject: Re: [PATCH nft v5] tests: py: fix python3
To:     Shivani Bhardwaj <shivanib134@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 28, 2019 at 9:57 PM Shivani Bhardwaj <shivanib134@gmail.com> wrote:
>
> On Tue, May 28, 2019 at 5:21 AM Shekhar Sharma <shekhar250198@gmail.com> wrote:
> >
> > This patch converts the 'nft-test.py' file to run on both python 2 and python3.
> >
> > The version hystory of this patch is:
> > v1:conversion to py3 by changing the print statements.
> > v2:add the '__future__' package for compatibility with py2 and py3.
> > v3:solves the 'version' problem in argparse by adding a new argument.
> > v4:uses .format() method to make print statements clearer.
> > v5: updated the shebang and corrected the sequence of import statements.
> >
> >
> > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > ---
> >  tests/py/nft-test.py | 44 +++++++++++++++++++++++---------------------
> >  1 file changed, 23 insertions(+), 21 deletions(-)
> >
> > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > index 1c0afd0e..fe56340c 100755
> > --- a/tests/py/nft-test.py
> > +++ b/tests/py/nft-test.py
> > @@ -1,4 +1,4 @@
> > -#!/usr/bin/python2
> > +#!/usr/bin/python
> >  #
> >  # (C) 2014 by Ana Rey Botello <anarey@gmail.com>
> >  #
> > @@ -13,6 +13,7 @@
> >  # Thanks to the Outreach Program for Women (OPW) for sponsoring this test
> >  # infrastructure.
> >
> > +from __future__ import print_function
> >  import sys
> >  import os
> >  import argparse
> > @@ -436,7 +437,7 @@ def set_delete(table, filename=None, lineno=None):
> >      '''
> >      Deletes set and its content.
> >      '''
> > -    for set_name in all_set.keys():
> > +    for set_name in list(all_set.keys()):
> What exactly is this list() for? This is not a generator expression.
>
The .keys() method returns a list in python2 whereas in python3 it
does not do that.
So, i just wanted to be sure that whatever is returned is used as a list.
(but now it turns out that even without that, the code is running
perfectly in python3!)

> >          # Check if exists the set
> >          if not set_exist(set_name, table, filename, lineno):
> >              reason = "The set %s does not exist, " \
> > @@ -1002,9 +1003,9 @@ def execute_cmd(cmd, filename, lineno, stdout_log=False, debug=False):
> >      :param debug: temporarily set these debug flags
> >      '''
> >      global log_file
> > -    print >> log_file, "command: %s" % cmd
> > +    print("command: {}".format(cmd), file = log_file)
> >      if debug_option:
> > -        print cmd
> > +        print(cmd)
> >
> >      if debug:
> >          debug_old = nftables.get_debug()
> > @@ -1198,7 +1199,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
> >          sys.stdout.flush()
> >
> >          if signal_received == 1:
> > -            print "\nSignal received. Cleaning up and Exitting..."
> > +            print("\nSignal received. Cleaning up and Exitting...")
> >              cleanup_on_exit()
> >              sys.exit(0)
> >
> > @@ -1305,13 +1306,13 @@ def run_test_file(filename, force_all_family_option, specific_file):
> >
> >      if specific_file:
> >          if force_all_family_option:
> > -            print print_result_all(filename, tests, total_warning, total_error,
> > -                                   total_unit_run)
> > +            print(print_result_all(filename, tests, total_warning, total_error,
> > +                                   total_unit_run))
> >          else:
> > -            print print_result(filename, tests, total_warning, total_error)
> > +            print(print_result(filename, tests, total_warning, total_error))
> >      else:
> >          if tests == passed and tests > 0:
> > -            print filename + ": " + Colors.GREEN + "OK" + Colors.ENDC
> > +            print(filename + ": " + Colors.GREEN + "OK" + Colors.ENDC)
> >
> >      f.close()
> >      del table_list[:]
> > @@ -1322,7 +1323,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
> >
> >
> >  def main():
> > -    parser = argparse.ArgumentParser(description='Run nft tests', version='1.0')
> > +    parser = argparse.ArgumentParser(description='Run nft tests')
> >
> >      parser.add_argument('filenames', nargs='*', metavar='path/to/file.t',
> >                          help='Run only these tests')
> > @@ -1341,6 +1342,10 @@ def main():
> >                          dest='enable_json',
> >                          help='test JSON functionality as well')
> >
> > +    parser.add_argument('-v', '--version', action='version',
> > +                        version= '1.0',
> > +                        help='prints the version information')
> Since this message is for the user, it should be "print" IMO.
>

True. Will change it.

> > +
> >      args = parser.parse_args()
> >      global debug_option, need_fix_option, enable_json_option
> >      debug_option = args.debug
> > @@ -1353,15 +1358,15 @@ def main():
> >      signal.signal(signal.SIGTERM, signal_handler)
> >
> >      if os.getuid() != 0:
> > -        print "You need to be root to run this, sorry"
> > +        print("You need to be root to run this, sorry")
> >          return
> >
> >      # Change working directory to repository root
> >      os.chdir(TESTS_PATH + "/../..")
> >
> >      if not os.path.exists('src/.libs/libnftables.so'):
> > -        print "The nftables library does not exist. " \
> > -              "You need to build the project."
> > +        print("The nftables library does not exist. "
> > +              "You need to build the project.")
> >          return
> >
> >      global nftables
> > @@ -1411,18 +1416,15 @@ def main():
> >              run_total += file_unit_run
> >
> >      if test_files == 0:
> > -        print "No test files to run"
> > +        print("No test files to run")
> >      else:
> >          if not specific_file:
> >              if force_all_family_option:
> > -                print "%d test files, %d files passed, %d unit tests, " \
> > -                      "%d total executed, %d error, %d warning" \
> > -                      % (test_files, files_ok, tests, run_total, errors,
> > -                         warnings)
> > +                print("{} test files, {} files passed, {} unit tests,".format(test_files, files_ok, tests))
> > +                print("{} total executed, {} error, {} warning".format(run_total, errors, warnings))
> >              else:
> > -                print "%d test files, %d files passed, %d unit tests, " \
> > -                      "%d error, %d warning" \
> > -                      % (test_files, files_ok, tests, errors, warnings)
> > +                print("{} test files, {} files passed, {} unit tests".format(test_files, files_ok, tests))
> > +                print("{} error, {} warning".format(errors, warnings))
> >
> >
> >  if __name__ == '__main__':
> > --
> > 2.17.1
> >
>
>
> --
> Shivani
> https://about.me/shivani.bhardwaj

Thanks!
Shekhar
