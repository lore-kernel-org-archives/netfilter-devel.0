Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F9CC31E5E
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CEED2080A
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfFROr2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:47:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbfFROr2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:47:28 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 76D373003B36;
        Tue, 18 Jun 2019 14:47:22 +0000 (UTC)
Received: from egarver.localdomain (ovpn-121-240.rdu2.redhat.com [10.10.121.240])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1177C179E3;
        Tue, 18 Jun 2019 14:47:20 +0000 (UTC)
Date:   Tue, 18 Jun 2019 10:47:20 -0400
From:   Eric Garver <eric@garver.life>
To:     Shekhar Sharma <shekhar250198@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v8]tests: py: add netns feature
Message-ID: <20190618144720.taadv3cawuqp5xka@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <20190617141558.2994-1-shekhar250198@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617141558.2994-1-shekhar250198@gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 18 Jun 2019 14:47:27 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 17, 2019 at 07:45:58PM +0530, Shekhar Sharma wrote:
> This patch adds the netns feature to the 'nft-test.py' file.
> 
> 
> Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> ---
> The version history of the patch is :
> v1: add the netns feature
> v2: use format() method to simplify print statements.
> v3: updated the shebang
> v4: resent the same with small changes
> v5&v6: resent with small changes
> v7: netns commands changed for passing the netns name via netns argument.
> v8: correct typo error 
> 
>  tests/py/nft-test.py | 140 +++++++++++++++++++++++++++++++------------
>  1 file changed, 101 insertions(+), 39 deletions(-)
> 
> diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> index 09d00dba..bf5e64c0 100755
> --- a/tests/py/nft-test.py
> +++ b/tests/py/nft-test.py
[..]
> @@ -1359,6 +1417,13 @@ def main():
>                          dest='enable_schema',
>                          help='verify json input/output against schema')
>  
> +    parser.add_argument('-N', '--netns', action='store_true',
> +                        help='Test namespace path')

AFAICS, this new option is not being used - it's not passed to
run_test_file() or other functions. Will that be done in a follow up
patch?

> +
> +    parser.add_argument('-v', '--version', action='version',
> +                        version='1.0',
> +                        help='Print the version information')
> +
>      args = parser.parse_args()
>      global debug_option, need_fix_option, enable_json_option, enable_json_schema
>      debug_option = args.debug
[..]
> @@ -1434,18 +1499,15 @@ def main():
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
> +                print("{} test files, {} files passed, {} unit tests, ".format(test_files,files_ok,tests))
> +                print("{} total executed, {} error, {} warning".format(run_total, errors, warnings))
>              else:
> -                print "%d test files, %d files passed, %d unit tests, " \
> -                      "%d error, %d warning" \
> -                      % (test_files, files_ok, tests, errors, warnings)
> +                print("{} test files, {} files passed, {} unit tests, ".format(test_files,files_ok,tests))
> +                print("{} error, {} warning".format(errors, warnings))
>  

Please drop this hunk. It was already addressed in your patch "[PATCH
nft v7 1/2]tests:py: conversion to  python3". As such this patch doesn't
apply on top of your previous patch.
