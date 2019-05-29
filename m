Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D8BDC28CC0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 09:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 339C320B7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 09:46:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="carDbDQk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfE2JqI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 05:46:08 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35194 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfE2JqI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 05:46:08 -0400
Received: by mail-oi1-f193.google.com with SMTP id a132so1510509oib.2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 02:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jbloYh7E0k2aBQLv+hMcQbeVcmezkGFqiKyZUGTZBeo=;
        b=carDbDQk9UV4viR+AgYKKtSwSFzTKCkleJeoVM0/dk++RxvwEOnTdM042rmdwk97tX
         JIfNMZpPccEP5Qi6Sey2cFVlIZlVNpjgy41upLBuSGW3J92i4omiu0BkfG17GnLq03KW
         6ynyYbWuIe+yRaZVT/bmR4v/d7NBALC2l3La3Zl5a3POrHswV1CUsZLW0GkStPSC84mW
         wnPGFzmCSjbwmyo7/v+nSUSX+1EC9E+LmB8nhtBJnoTkizBUvUDU1zQpM0qRif4+ttqu
         UzAzKfaRmfcnAY+KnyxTpqk86KnnnJqEU6pxk9FFFv/0WmvgdBsWzOyQ20El9pS7jZgn
         I52w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jbloYh7E0k2aBQLv+hMcQbeVcmezkGFqiKyZUGTZBeo=;
        b=es6ZDtpSP+Z8q9iQRFxxcA+VL35DckCY39Ph/60a+dY/DIsjJEKrA+1twOtKpgniW8
         NnGTNmplyaKRD4lxC+CmW7yqiFkFvH8U4lo+AjgwLPHY7/jemGejeS25kfk3MWU1t1Is
         Z0bZW5LLFQfu1O2P8qD9vu9agmhlIu54AjGoyd6pWgQkk0w6MMOi4KaF4GWa+xPGX6fF
         gUGFV+uEXheQIxz/XjrMGC4LUeIPWhT5IHSOgoeZxSx+6J4CYR4NWR9yrGQWZVOSyhJK
         ABW86+opSkOrNCRE7/8k2RVVgxdsnZWCSshPKvGG+kO9tZUwfcvFtIOdXD2jcHZ0p9eR
         jvig==
X-Gm-Message-State: APjAAAXVo/s7B+vTm+pyenEpyQY9eJY9KUUdizfBFNILWDtOH6GzviF8
        ovJNjHhUjlqn32fVqKFI5BeYP8uuGTTS85J/d+G9kA==
X-Google-Smtp-Source: APXvYqylElASpm+4tdlZsnS/HvCpIjxlE0zizHshkoElnb9tFcgrrO22bBAux8kq7aAF21z/X9iWIe0gsPnOlsYUGJs=
X-Received: by 2002:aca:4202:: with SMTP id p2mr5744755oia.85.1559123167692;
 Wed, 29 May 2019 02:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190528003653.7565-1-shekhar250198@gmail.com>
 <20190529074851.sjmnulacdufhhlmx@salvia> <20190529074909.uf5jujqvz26nuswi@salvia>
In-Reply-To: <20190529074909.uf5jujqvz26nuswi@salvia>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Wed, 29 May 2019 15:15:55 +0530
Message-ID: <CAN9XX2rjzqmEGrWdtVppq7e1ekiKCk7_=5bHbGbZpKkUGb+Vdg@mail.gmail.com>
Subject: Re: [PATCH nft v2]tests: json_echo: convert to py3
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 29, 2019 at 1:19 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Tue, May 28, 2019 at 06:06:53AM +0530, Shekhar Sharma wrote:
> > diff --git a/tests/json_echo/run-test.py b/tests/json_echo/run-test.py
> > index 0132b139..dd7797fb 100755
> > --- a/tests/json_echo/run-test.py
> > +++ b/tests/json_echo/run-test.py
> > @@ -1,5 +1,6 @@
> > -#!/usr/bin/python2
> > +#!/usr/bin/python
> >
> > +from __future__ import print_function
> >  import sys
> >  import os
> >  import json
> > @@ -13,8 +14,8 @@ from nftables import Nftables
> >  os.chdir(TESTS_PATH + "/../..")
> >
> >  if not os.path.exists('src/.libs/libnftables.so'):
> > -    print "The nftables library does not exist. " \
> > -          "You need to build the project."
> > +    print("The nftables library does not exist. "
> > +          "You need to build the project.")
> >      sys.exit(1)
> >
> >  nftables = Nftables(sofile = 'src/.libs/libnftables.so')
> > @@ -79,26 +80,26 @@ add_quota = { "add": {
> >  # helper functions
> >
> >  def exit_err(msg):
> > -    print "Error: %s" % msg
> > +    print("Error: %s" %msg)
> >      sys.exit(1)
> >
> >  def exit_dump(e, obj):
> > -    print "FAIL: %s" % e
> > -    print "Output was:"
> > +    print("FAIL: {}".format(e))
> > +    print("Output was:")
> >      json.dumps(out, sort_keys = True, indent = 4, separators = (',', ': '))
> >      sys.exit(1)
> >
> >  def do_flush():
> >      rc, out, err = nftables.json_cmd({ "nftables": [flush_ruleset] })
> >      if not rc is 0:
> > -        exit_err("flush ruleset failed: %s" % err)
> > +        exit_err("flush ruleset failed: {}".format(err))
> >
> >  def do_command(cmd):
> >      if not type(cmd) is list:
> >          cmd = [cmd]
> >      rc, out, err = nftables.json_cmd({ "nftables": cmd })
> >      if not rc is 0:
> > -        exit_err("command failed: %s" % err)
> > +        exit_err("command failed: {}".format(err))
> >      return out
> >
> >  def do_list_ruleset():
> > @@ -123,7 +124,7 @@ def get_handle(output, search):
> >              if not k in data:
> >                  continue
> >              found = True
> > -            for key in search[k].keys():
> > +            for key in list(search[k].keys()):
>
> list() is not necessary, as Eric already mentioned, right?
>
> Your patch is already in git.netfilter.org, so I have already pushed
> it out BTW. If this is the case, just avoid this in your follow up
> patches for other existing scripts. Thanks.

Sure, I will change it in the follow up patches.

Thanks!
Shekhar
