Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3B9C31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 17:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1475020B1F
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 17:07:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a5OXnHvz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbfFRRHC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 13:07:02 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37166 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729541AbfFRRHC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 13:07:02 -0400
Received: by mail-ot1-f67.google.com with SMTP id s20so15937693otp.4
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 10:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ayCM+ugx4bZwjcrKw9cchXnqkW9DR+HqZ+k5WzprEmA=;
        b=a5OXnHvzapS+Lt8ZjwEeBRMr7oiHjhZU0VJFZm1Ym2ooKKhB/ai1kKuJbx2bQaxgLM
         0xi3iSXTB5L3reqh7xLt63rXiWrVzeSfADhAWMFenkTlmP1BVxokbTCIaS3Njpu6VCq9
         tMVtpc4P4gegoFTyNL4+AREi1jkmwvjvSAmIKf6nFyVBlgf6wTuj79Si/Mt0bYD+4C03
         JwK/0U8E949yQa4lsTN8AQD7KmTTjU2yHlq1ecVVBMBMAShJ22fHiuJdLGEsG6mOHhJN
         Lzo2PBgvhR25utPGgvSXG/k+XB9wnoAN5iOlvgsQZp3BG7fiDrupFYtQ3fbH40E9FKxT
         M38g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ayCM+ugx4bZwjcrKw9cchXnqkW9DR+HqZ+k5WzprEmA=;
        b=a/xS6Yv9NjqrYQiUWHbnDlYXKPRYoeq5812JXEVdOFwKTbmn0d6PN0m3ZS8Ni/tZxn
         gYLVsMGARos5MkeBodXCkLCDffWS7jyOw08miVbsKnVC1Z4PltyG5JgN6weKPgBXrhpX
         0nea2tDC05zHTuoKxnHf64QE9eU18MuvuFaQHS1xdijjm+J4vTBH6hAn0eFVAdrMmFZl
         AvsE7aTeYnt3OkEq4DkF0X7BhnrFvGbEnwfj2HepyD/FVox1XadsdawdNFwxTHoYmpv9
         pdVxG7vnoO3cIQpmrGGli3RYaalom4OljJNrxBID+MyktD3HP/IkEBOqV8MKEwyzpBlk
         WTLQ==
X-Gm-Message-State: APjAAAXMou2EG5AKpMevaR/kWB44irM+ENhpZGjKA3WbyJdBBNrvC5c3
        pb8V9Vo+7YJuaSmyx54PB+TWsqCGc/Aps10eR0hP6AT9
X-Google-Smtp-Source: APXvYqwftP0EI0alo7E5OVo70RF6hJjEG4lB0CqMEqEnunhL4/HC9GTrJ5if8efqU+WAumWclwBHROnF1vx1vnn0WbY=
X-Received: by 2002:a9d:5911:: with SMTP id t17mr16513662oth.159.1560877621426;
 Tue, 18 Jun 2019 10:07:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190617141558.2994-1-shekhar250198@gmail.com> <20190618144720.taadv3cawuqp5xka@egarver.localdomain>
In-Reply-To: <20190618144720.taadv3cawuqp5xka@egarver.localdomain>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Tue, 18 Jun 2019 22:36:49 +0530
Message-ID: <CAN9XX2qhd73k5XmwxucKYPdGe_cV6EZN7RP62LKWGBfYgaNsOA@mail.gmail.com>
Subject: Re: [PATCH nft v8]tests: py: add netns feature
To:     Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Eric!
On Tue, Jun 18, 2019 at 8:17 PM Eric Garver <eric@garver.life> wrote:
>
> On Mon, Jun 17, 2019 at 07:45:58PM +0530, Shekhar Sharma wrote:
> > This patch adds the netns feature to the 'nft-test.py' file.
> >
> >
> > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > ---
> > The version history of the patch is :
> > v1: add the netns feature
> > v2: use format() method to simplify print statements.
> > v3: updated the shebang
> > v4: resent the same with small changes
> > v5&v6: resent with small changes
> > v7: netns commands changed for passing the netns name via netns argument.
> > v8: correct typo error
> >
> >  tests/py/nft-test.py | 140 +++++++++++++++++++++++++++++++------------
> >  1 file changed, 101 insertions(+), 39 deletions(-)
> >
> > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > index 09d00dba..bf5e64c0 100755
> > --- a/tests/py/nft-test.py
> > +++ b/tests/py/nft-test.py
> [..]
> > @@ -1359,6 +1417,13 @@ def main():
> >                          dest='enable_schema',
> >                          help='verify json input/output against schema')
> >
> > +    parser.add_argument('-N', '--netns', action='store_true',
> > +                        help='Test namespace path')
>
> AFAICS, this new option is not being used - it's not passed to
> run_test_file() or other functions. Will that be done in a follow up
> patch?
>

True. I just saw that '-N', '-V' are also not added in the lines below
this as in
debug_option= args.debug
i need to add that as well and then use it in the functions.
I think that will be covered in another patch.

> > +
> > +    parser.add_argument('-v', '--version', action='version',
> > +                        version='1.0',
> > +                        help='Print the version information')
> > +
> >      args = parser.parse_args()
> >      global debug_option, need_fix_option, enable_json_option, enable_json_schema
> >      debug_option = args.debug
> [..]
> > @@ -1434,18 +1499,15 @@ def main():
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
> > +                print("{} test files, {} files passed, {} unit tests, ".format(test_files,files_ok,tests))
> > +                print("{} total executed, {} error, {} warning".format(run_total, errors, warnings))
> >              else:
> > -                print "%d test files, %d files passed, %d unit tests, " \
> > -                      "%d error, %d warning" \
> > -                      % (test_files, files_ok, tests, errors, warnings)
> > +                print("{} test files, {} files passed, {} unit tests, ".format(test_files,files_ok,tests))
> > +                print("{} error, {} warning".format(errors, warnings))
> >
>
> Please drop this hunk. It was already addressed in your patch "[PATCH
> nft v7 1/2]tests:py: conversion to  python3". As such this patch doesn't
> apply on top of your previous patch.

Ok. Will re-post the patch with out this bit.

Thanks!
Shekhar
