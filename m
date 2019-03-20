Return-Path: <SRS0=0f1v=RX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DA8C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 17:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5FE32184D
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 17:46:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KAIFbxk9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfCTRqY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 13:46:24 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:51555 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbfCTRqY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 13:46:24 -0400
Received: by mail-it1-f193.google.com with SMTP id e24so173591itl.1
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 10:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=41xLks7oVSuKzSw5hgsxqYtNfhOWq8kXPBCt5sn5LSw=;
        b=KAIFbxk9yNSnt38tMfBn8LhG22AruFfLrXPkbe8wWNAmnudVE5T0NEiifKHgCIL6i2
         PN/fkp74dmA4rXJYOJX6LTtlzz/zHL2LQ0uqtwXtX47oh+1zjetwGxj+2tgS1KR47Ps1
         j/+v04+ui3uXK16pZ0YidyXjg5RCeVALxl+FDkreh6kSqnddAEu7LkRyDqQ8eHIGJ0gH
         +REbpB4HkorV8D8ZBfGTXn0h3pF/QGBEyOshNA9x7pRy3h6oHerh4Dn/lQ9mtFR8pbV8
         Sr2PoPe52VesC/UN9c60WT9yaRTqkWg87PqRkArWLS9QbpMon2x/4elMxo1/XkEiZCN8
         GcNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=41xLks7oVSuKzSw5hgsxqYtNfhOWq8kXPBCt5sn5LSw=;
        b=JR3BTPUWfYvsVYcwk6iU0PaBbk0WXxUBGFzGjkbM53XXgDZ3mjmPgVXjtcYd1kKKXG
         1adA2GYbglkW5QVwfjvNrhFJY0FdGswb9T3km7uW1UgXDANwnzANEkeeH4Zy9xQVNHR0
         LQ5P3uPjI9/fGiYb4it8th9IivfDdeea8c/nsR/lDDvVVnneBoV+K4OWQTlubXPVZUhi
         o6OxOu/zbgqsjxkaU5OAFddEtv4pJidokglBtfm8sF8PmOgYH3zto//RG2U4teUJWyuz
         l692jz5vpgpfF8VSLdpKgQ4ubUVEShL/yKru+pq6x1+vKG1LHpy8v6VOXBzIcGRGu7uD
         DkTQ==
X-Gm-Message-State: APjAAAUsiMxU3btIXJWfqzbrbZ5bb6N9OeJz/RPSJrA9obRt7bObxDws
        RSxvGkJJJ4huzTTkTSZNbKReNwZvVxwOVzQNg8c=
X-Google-Smtp-Source: APXvYqwY7Fpar2vxL19K7RQ23BvwvArvVM84MD4qWPoWUZdnxUhxucVnBheWfpASUb9qlYT8QJ/L+4gX7gyn8TBh01I=
X-Received: by 2002:a24:4fc3:: with SMTP id c186mr6280230itb.71.1553103983327;
 Wed, 20 Mar 2019 10:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190301104331.GA26805@nebula> <20190301110000.ofmenn5hjxf4nvb4@breakpoint.cc>
 <CAHRz_yZ4esKR2TJ=9AqtYbc5awDaNKHW6iuLXVLFZcuFAWLW1Q@mail.gmail.com> <20190305101225.u72vgdapppkl24ce@breakpoint.cc>
In-Reply-To: <20190305101225.u72vgdapppkl24ce@breakpoint.cc>
From:   Karuna Grewal <karunagrewal98@gmail.com>
Date:   Wed, 20 Mar 2019 23:16:11 +0530
Message-ID: <CAHRz_ybqUaoKyV7OaVWAYqqpnKf2p=1tTsBCdA1NKQ0aTevr4w@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nft_meta: Extend support for NFT_META_TSTAMP_NS
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 5, 2019 at 3:42 PM Florian Westphal <fw@strlen.de> wrote:
>
> Karuna Grewal <karunagrewal98@gmail.com> wrote:
> > I've a doubt in the nftables implementation for implementing the `-m
> > time` support.
>
> Full -m time is complicated, do not worry about this yet.
>
> > I'm unable to get a proper idea of where the start and
> > stop time comparison with the dest register's value takes place.
>
> Via the nftables evaluation loop.  You only need to worry about placing
> the value (timestamp) in the dst register (on kernel side), so your
> patch looks pretty complete aside from the missing 'break'.
>
> Its userspace (nftables) responsibility to tell kernel to do something
> with the register, such as a compare or range.
>
> Have a look at
> http://git.netfilter.org/nftables/commit/src/meta.c?id=512795a673f999fb04b84dbbbe41174e9c581430
>
> It should be enough to follow this approach, adding e.g.
> META_TEMPLATE("timestamp", ..
>
> we have TYPE_TIME already, even though its a relative one, it
> would/should work for a quick prototype.

I had sent the patch for this basic case of simply comparing one timestamp.
As the startdate and stopdate options need to implemented completely,
should I make use of an interval
or is using two different tokens viz. START_TSTAMP and STOP_TSTAMP the
preferred option.
