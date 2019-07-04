Return-Path: <SRS0=ip/f=VB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB2FC0651F
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 16:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 718F7218B8
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 16:37:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jfz+teKZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfGDQhH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Jul 2019 12:37:07 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38007 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfGDQhH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jul 2019 12:37:07 -0400
Received: by mail-oi1-f196.google.com with SMTP id v186so5316285oie.5
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jul 2019 09:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mDrwz0d/Z9+t+xfaYNJgMLcf3TAbXpWzR+eMPfkG1bA=;
        b=Jfz+teKZd7WXkGCVacKYkxSs3Zi7AnUCQYsSEwBQjHDm4NH36nfLxUpGcTQns5MIoT
         Gcy2gd7AbKOP0qyOzFl4DV/Ssal9yBIgCy8WVvApjbTVgNWX4zTJZ+zEDZ2/P3/sIIW9
         R1LFxxjowtGF46ahOpwTu/wOC8h9qXqMj9IS+CHpGpJs1lQOW4XkzSypYlUq4T5VJxlm
         ayZ9+Hy0Pbd1X8JObATYs8XmAMKxZSDWytjXplNuqrwB3VCVscTQBsJTccDojmJBCvzF
         3/Ad5Tu3MHpkPqwCu/mqe7Zd+ySxUy5i7wfPIAPdtbcXmxvO0GN2rlXovA++oPIOUXDJ
         bkTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mDrwz0d/Z9+t+xfaYNJgMLcf3TAbXpWzR+eMPfkG1bA=;
        b=c0I5aA99beHafPwYmYzoFZWTYaE+9OpcBX7QkIt6o8UN/E/kl3RVT0bNDAmmN6yFra
         NTkb//Kom7X6duwzGIDWa4W/pB+rJUdwegSZAgdWZiHYCt1uLQR+g1r/F8fWpEmn5SI9
         1x8R54e+REnWmN2EP3GaVW3/uHYkHVRIo4JA4Eyx79nxypZ+5WbXXIILtxfqts5sD3Al
         ONlf0dQfev+BTWA6lYGrpGTuaBHWsTEhXVZCZpRJ5c8JdKKQPnkYqRlbibE3MLK4gJBQ
         oVasOP7iaR2STO5MXAPTYpWf7GFz0sv8CrHwI87PP5ponF4B6yaQytXLM2LrVfs8OZQZ
         VxVw==
X-Gm-Message-State: APjAAAWlZOG+WnYfNJ7fONdhNYFkFGh2JO6CUQx1FQOfRf+lU3x169Yx
        0f8K0OT8YRQvgsHXr66QBibGF9ZTtG3vHmEHO7Khbfm5
X-Google-Smtp-Source: APXvYqx7Qn2yfcrHhA9ZJW11AuJ+XAeTwZWwYMFVAnfvG49jKKIoYPEzgcT66rdJSAzZxsbsHQQDeQsoRYDklGdJQ20=
X-Received: by 2002:aca:5a41:: with SMTP id o62mr278912oib.110.1562258226206;
 Thu, 04 Jul 2019 09:37:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190702192045.16537-1-shekhar250198@gmail.com> <20190704131421.sejz6sby3odwl6yx@salvia>
In-Reply-To: <20190704131421.sejz6sby3odwl6yx@salvia>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Thu, 4 Jul 2019 22:06:54 +0530
Message-ID: <CAN9XX2peYg8rr4ix+DZ_XZSix8hrWBNcQeA78bV6cjjjZDoFYQ@mail.gmail.com>
Subject: Re: [PATCH nft v12]tests: py: add netns feature
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 4, 2019 at 6:44 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Jul 03, 2019 at 12:50:45AM +0530, Shekhar Sharma wrote:
> > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > index fcbd28ca..8076ce78 100755
> > --- a/tests/py/nft-test.py
> > +++ b/tests/py/nft-test.py
> > @@ -174,27 +174,31 @@ def print_differences_error(filename, lineno, cmd):
> [...]
> > -def table_create(table, filename, lineno):
> > +def table_create(table, filename, lineno, netns=""):
> >      '''
> >      Adds a table.
> >      '''
> > @@ -208,6 +212,8 @@ def table_create(table, filename, lineno):
> >
> >      # We add a new table
> >      cmd = "add table %s" % table
> > +    if netns:
> > +        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
> >      ret = execute_cmd(cmd, filename, lineno)
> >
> >      if ret != 0:
>
> You're missing updates of table_create() invocations, because you are
> setting a default value to the netns parameter to "", this never runs
> the netns patch I'm afraid.
Ok. I will correct it and send the patch again.
