Return-Path: <SRS0=BUQT=24=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DF2C33C8C
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 13:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5E9B2080A
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 13:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T9nYi5u5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgAGNA5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 08:00:57 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:41120 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbgAGNA5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 08:00:57 -0500
Received: by mail-vs1-f65.google.com with SMTP id f8so33761879vsq.8
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jan 2020 05:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RKigfDZvfxJSV13mMFe+G/ZCSnMsIg2to3WYyDqdLYs=;
        b=T9nYi5u5PECWXCSBtcdefHNVTGoT4Na2GMenbzcV07qQTGS4stj0/PpA6cDtaPH5kU
         lr36p1BHSydQoekzOstJYeoILk3gyuq+raS88t3gm9zHHFG+cKbfRfvaXgMBJ7lK50iq
         DiLXZdVEOZp6AWxzCkcEsUXoRwQ/1QZRfOsxwS9FVveg1MSwjpBJYn0zWjhRvba89Ecl
         AKC1xBBDQ5DCOF89MjNBQwWc0+HLWkOdpNY1M1qCei5NhnVWxI9lca1q2MZ8+wciQXDa
         /VloF6LL7mj56ikJXd0tDCesvbwlUjRSgCkFFS3qTrpjFLIHZ0eJZNlRIFYUzRzQChD/
         8R8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RKigfDZvfxJSV13mMFe+G/ZCSnMsIg2to3WYyDqdLYs=;
        b=PN25gt8Uhq0Ljodh9dGZs9FJqXAcWSyDLgRow/PCircMuElkRZldY/xLBWZCcl0LTF
         qJsZ6hN+bmDw9HU/32oguz4XyXwiKULI78UK882svH/nAWRZ0GIadQ7/KEBQ4U7hUNzU
         F0ks7+ztVy9BUZ19+XW/DnWny57AOZCVNJYINFbmjhVzqjWNyxKdY5sd6UYb2PRfpPfQ
         bm/LFz4NLSflCtLi0l2lz2excd1a8BGGVNp4hCmkAZw0eH9kHJAILbY6VU8lbjeB5g6c
         2ZRhA51HAKFnqk4dzV/s3c3F7bgxT8JA1gvZHOom1EMAOjCSkP2tfDkUhOhV8sxDDXbq
         3mMw==
X-Gm-Message-State: APjAAAWB/qKryYYVqzXyMVgYkdyJ+MXyoZlOau2i6na4Hf37IVe1JJWa
        rCw+U+sB4GPBr3kzJie/vPA9x4sjQvsc5F6YWio=
X-Google-Smtp-Source: APXvYqw8RLzXMs6Ea+cPXCcq9jLWO9EXeFkwzdb1hx8ejLLSHyI0LXmJ+TwM/j7jiViD/RaQZxn0IUzl8gSxo7dnX0Q=
X-Received: by 2002:a67:f84e:: with SMTP id b14mr56349961vsp.126.1578402056035;
 Tue, 07 Jan 2020 05:00:56 -0800 (PST)
MIME-Version: 1.0
References: <CAA0dE=UFhDmAnoOQpR33S59dP_v3UVrkX29YMJyqOYc3YF1FPA@mail.gmail.com>
In-Reply-To: <CAA0dE=UFhDmAnoOQpR33S59dP_v3UVrkX29YMJyqOYc3YF1FPA@mail.gmail.com>
From:   Laura Garcia <nevola@gmail.com>
Date:   Tue, 7 Jan 2020 14:00:44 +0100
Message-ID: <CAF90-Wj6zvyDkcX=Zt5XcS0MYTj2J5tKpPCtOXTEfaeNfhyMFQ@mail.gmail.com>
Subject: Re: Adding NAT64 to Netfilter
To:     Alberto Leiva <ydahhrk@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 3, 2020 at 7:10 PM Alberto Leiva <ydahhrk@gmail.com> wrote:
>
> Hello
>
> I've been working on Jool, an open source IP/ICMP translator for a
> while ([0]). It currently implements SIIT, NAT64 and (if everything
> goes according to plan) will later this year also support MAP-T. It
> currently works both as a Netfilter module (hooking itself to
> PREROUTING) or as an xtables target, and I'm soon going to start
> integrating it into nftables.
>

Hi Alberto, I was analyzing the impact to add support NAT64/46 several
months ago. It seems that you've done a very good job.

In regards to the iptables approach, do you have any benchmark
compared to the NAT in the same stack?

In regards to the nftables approach, do you mean to integrate the RFC
implementations natively into the nftables infrastructure?

Checking your code, it seems that you use several user space tools
(jool, joold) and a conntrack-like table to store the connection data.
As you know, in the nftables project it has been done a great effort
to avoid several tools for packet mangling so something natively like
the following would be probably required.

nft add table ip6 nat
nft add chain ip6 nat postrouting { type nat hook postrouting priority 100 \; }
nft add rule ip6 nat postrouting oif eth0 snat 1.2.3.4

More thorough study would be the possibility of supporting the
sessions in conntrack and conntrackd but, I believe a first approach
with stateless NAT from ingress could be a great achievement.

Cheers.


> Actually, it's the same software once advertised by this guy: [1]
>
> Several people have approached me over the years expressing their
> desire to have it integrated into the kernel by default. The intent of
> this mail is to query whether a merge of Jool into the Netfilter
> project woud be well-received. Of course, I'm willing to make
> adjustments if needed.
>
> Here are some justifications that have been listed to me. For the sake
> of credit, these are all stolen from [2]:
>
> 1. IPv6 is getting significantly more exposure
> 2. NAT64 is getting more required / will be a default thing to do,
> along with MAP-E/T
> 3. OpenBSD already has the functionality in pf
> 4. Enabling it upstream can potentially help IPv6 migration world wide
>
> Thoughts?
>
> [0] https://jool.mx
> [1] https://marc.info/?l=netfilter-devel&m=136271576812278&w=2
> [2] https://github.com/NICMx/Jool/issues/273#issuecomment-568721875
