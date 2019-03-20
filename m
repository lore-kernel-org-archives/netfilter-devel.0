Return-Path: <SRS0=0f1v=RX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B96C7C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 18:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91D6F218AC
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 18:17:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FGDJxDlM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfCTSRx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 14:17:53 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:35418 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfCTSRx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 14:17:53 -0400
Received: by mail-it1-f193.google.com with SMTP id w15so330484itc.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 11:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=heFS2vx5g3E6IreUepRsfABcZ+n1OFzZ2SOPQQNZpX4=;
        b=FGDJxDlMIUKKpKVH1p+k7VALtrqg9sO4DEjQ/GpeNd7Rnzxk5Lu9BM9zRJaq6UasFR
         nLKajEBhbm7mfBtUGAY2KLB/l9u+K4JQX8DBSuHVrvT0hK06d6J9k9hOijtbcws51FCB
         7iBug5nXNQxof5jWTbwl87jJphLdkvaSEU1EntP/geWMsxNR2LvOIDc64T/H0UR1srgn
         Y7/GeRo63bnWfeQjoUHy6GetQloKyk8OpiW9SJ1mRWbGqM+ivTvpjGxhFij2ehoLbaKL
         7VAxTdqmqnjI1IlOthv6wZ37SQeRDM6QjYLGeNd648ZrVipmbNLM5F5t7WoV93oNUvOR
         wTfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=heFS2vx5g3E6IreUepRsfABcZ+n1OFzZ2SOPQQNZpX4=;
        b=g1Fwcv8IvgKtWyNxGDQlyAup6aSgQE5JlirxLxhWiIv2+yeyqbp/wMWk8PJTbk/T/u
         zZmAzQQ7oiNxQZmgdohXv8lpe5Hur8s8bB7mBqE8af8oRnQv1TUC5yg6cky2+oAKAtyJ
         bsIbdOvNesINKz3O+z4vUU1Ve+o9eYUKOAodANgYX3+XCifIT5mf8F1XgAf7F3cMDzB6
         eqFMvxyX/E0sB5OrmjgXthjCW9++yG4P8gdi33pS5wIsPHcWsLn079DQdvT86qfhxtmB
         9z3GRnIcipiEK8HGOO9QpwRKKd0QyfJDtCQYn6R99FEUmSYAxQq9bZvIVdMN308/MJGe
         sHxQ==
X-Gm-Message-State: APjAAAX2RjLhnIodcdL65kU2x4rJ1WO+RAlheqIMVxJzhCKhuM4eH3rP
        uQc4lLzcLxhlJsNRsYlvUXj0ah26hWthZErk2QxnlBaw
X-Google-Smtp-Source: APXvYqw+JCE98yK8zo1k/jKU3+6t9d6QlwxDLnLLmNbx4J5hcF7X/wBeE+7vJa1m4BUWN9A38C4mhsqfccr01sUee44=
X-Received: by 2002:a05:660c:743:: with SMTP id a3mr5777601itl.7.1553105872119;
 Wed, 20 Mar 2019 11:17:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190301104331.GA26805@nebula> <20190301110000.ofmenn5hjxf4nvb4@breakpoint.cc>
 <CAHRz_yZ4esKR2TJ=9AqtYbc5awDaNKHW6iuLXVLFZcuFAWLW1Q@mail.gmail.com>
 <20190305101225.u72vgdapppkl24ce@breakpoint.cc> <CAHRz_ybqUaoKyV7OaVWAYqqpnKf2p=1tTsBCdA1NKQ0aTevr4w@mail.gmail.com>
In-Reply-To: <CAHRz_ybqUaoKyV7OaVWAYqqpnKf2p=1tTsBCdA1NKQ0aTevr4w@mail.gmail.com>
From:   Karuna Grewal <karunagrewal98@gmail.com>
Date:   Wed, 20 Mar 2019 23:47:40 +0530
Message-ID: <CAHRz_ybWm6UQyCHH6DATHryGFuKVwrEzivgG9_t==+_27H1wzQ@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nft_meta: Extend support for NFT_META_TSTAMP_NS
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 20, 2019 at 11:16 PM Karuna Grewal <karunagrewal98@gmail.com> wrote:
>
> On Tue, Mar 5, 2019 at 3:42 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > Karuna Grewal <karunagrewal98@gmail.com> wrote:
> > > I've a doubt in the nftables implementation for implementing the `-m
> > > time` support.
> >
> > Full -m time is complicated, do not worry about this yet.
> >
> > > I'm unable to get a proper idea of where the start and
> > > stop time comparison with the dest register's value takes place.
> >
> > Via the nftables evaluation loop.  You only need to worry about placing
> > the value (timestamp) in the dst register (on kernel side), so your
> > patch looks pretty complete aside from the missing 'break'.
> >
> > Its userspace (nftables) responsibility to tell kernel to do something
> > with the register, such as a compare or range.
> >
> > Have a look at
> > http://git.netfilter.org/nftables/commit/src/meta.c?id=512795a673f999fb04b84dbbbe41174e9c581430
> >
> > It should be enough to follow this approach, adding e.g.
> > META_TEMPLATE("timestamp", ..
> >
> > we have TYPE_TIME already, even though its a relative one, it
> > would/should work for a quick prototype.
>
> I had sent the patch for this basic case of simply comparing one timestamp.
> As the startdate and stopdate options need to implemented completely,
> should I make use of an interval
> or is using two different tokens viz. START_TSTAMP and STOP_TSTAMP the
> preferred option.
Sorry, I had mistaken the way intervals were scanned in the rule. This
above doubt is cleared.
Moving on to the part of not using relative times would it be required
to first implement it in the nftables datatypes or is there another
available workaround using the existing nftables code?
