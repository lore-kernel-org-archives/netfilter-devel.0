Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DC9C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 01:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02EC660187
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 01:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbhJ0BTv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Oct 2021 21:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237197AbhJ0BTu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Oct 2021 21:19:50 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F4EC061570
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Oct 2021 18:17:26 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id om14so787131pjb.5
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Oct 2021 18:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=xGkr+rbuELXnpBMPima3FP/tb9AVnqHx1mOKL+T3Vkk=;
        b=mKxR5uv/WUEybKoxLxL0SqUHR3djEKTBJy6fAhd5xg3YSIFx8/EkKW6yyyddMXCi/R
         ix9XIT/+w4nik+xOfOhtADzFqcLf6gyaTvxLlvwHnCT5zkq1bWhUcIUiXsuCFAsXjrCp
         I7rBvlkBliMaInJEx/2UDvXVnCR2+MOljI9acYFamGYhTO51Yh1ZWg7pCVaah1hEzEwv
         l0i0g+6W3A6bDhp1ID4mtMyaYqcwFArkSVQp17Rziioleuxa5iQeqXPuO0k+TIOzD+NK
         8RfPv+31Qc47TT3uJlSvFCIj00CZV1tMKDFSDxgWTUWKfavpsVAkJ0Nw47zgKhyLYFRi
         988A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=xGkr+rbuELXnpBMPima3FP/tb9AVnqHx1mOKL+T3Vkk=;
        b=GcGfUFGQQ2xpc8/lMxVawtBqKEW7YCL7BStUGO/lzOoHIbEmk0MAORUghf1aVThqza
         zzQUAmg6o0zLPKQYQype+jz6/0vYM5KwV/p27HxqF/RgkS6+xwntmb5CT3p9PrBXsUtE
         6vkB88C2MzjHjQ6knNlTr9bqV8vqc0veFvzT2VrMFYLmhUoUq21GAqwL6G8UZ1dkCniO
         trtEZ8SeysdWJFCebRMwPf66hOK7z/2PnY9btVmdbUevw2q3O2H2pdMixSfgsa19vh11
         srWFLAWGJLkGNuRcgTL9WprKH/bxuS8NFkYlo4ermcBiXJlV9wIUg7c75EPiySfCLvIC
         jbXQ==
X-Gm-Message-State: AOAM531GX0LucVGeb4+MAXt+QQhWfAx8IRp2XV2jh1dTouJFrPKqruvB
        r/zAhVNnd/sfo2MzPcEmqzWGqjv2+Hg=
X-Google-Smtp-Source: ABdhPJzOdNie+KdxmmzkSBYyO8jMaR8qgGimPVXh2E1sSjwigDcRYlrqtDTNU4p4cNlhTLP8orDz7g==
X-Received: by 2002:a17:902:ced0:b0:140:48e7:d2bf with SMTP id d16-20020a170902ced000b0014048e7d2bfmr17342689plg.13.1635297445788;
        Tue, 26 Oct 2021 18:17:25 -0700 (PDT)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id h10sm25086682pfi.208.2021.10.26.18.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 18:17:25 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 27 Oct 2021 12:17:21 +1100
To:     pupilla@libero.it
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: capwap protocol nested header
Message-ID: <YXiooQbkRNpffSY/@slk1.local.net>
Mail-Followup-To: pupilla@libero.it,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <352502450.203840.1635260072685@mail1.libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <352502450.203840.1635260072685@mail1.libero.it>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Marco,

On Tue, Oct 26, 2021 at 04:54:32PM +0200, pupilla@libero.it wrote:
> Hello everyone,
>
> I would like to know if it's possible to mangle a
> packet like this one with linux netfilter (linux
> kernel 5.14 or 5.15).
>
> My goal is to match the innermost ip header
> (23.200.208.68/10.18.102.237) and then change the
> mss of the tcp packet.
>
> Frame 48007: 1450 bytes on wire (11600 bits), 1450 bytes captured (11600 bits)
> Ethernet II, Src: LcfcHefe_32:48:cf, Dst: HewlettP_da:f5:07
> Internet Protocol Version 4, Src: 10.18.46.63, Dst: 10.18.153.156
> User Datagram Protocol, Src Port: 5247, Dst Port: 5248
> Control And Provisioning of Wireless Access Points - Data
> IEEE 802.11 Data, Flags: ......F.
> Logical-Link Control
> Internet Protocol Version 4, Src: 23.200.208.68, Dst: 10.18.102.237
> Transmission Control Protocol, Src Port: 443, Dst Port: 52500, Seq: 2753105, Ack: 1818, Len: 1316
>
> Is there any way to do this?
>
> Thanks in advance
> Marco

Certainly it can be done, on the basis that "you can change anything" using a
netfilter-queue program.

The question is, how much work is involved? With the current libnetfilter_queue
API, the answer is "maybe more than it should". So if I was trying to do this, I
would be hacking the libnetfilter_queue source first.

For a project of this complexity, you want the source anyway. The deprecated
functions can't do packet mangling, so start with examples/nf-queue.c which uses
the modern libmnl-based interface. You need an nft rule to queue UDP according
to some filter maybe e.g. spt 5247 & dpt 5248 (iptables would also work).

So your nfq program gets a UDP packet with an IP4 frame as data. The UDP frame
is described by a struct pktbuff (an opaque structure you can read about at
<https://netfilter.org/projects/libnetfilter_queue/index.html>).

What you want, but we don't provide at the moment, is a struct pktbuff that
describes the inner frame. Then mangle using the API and the TCP checksum will
get updated. The current API always makes a copy of whatever the struct pktbuff
describes, so you would have to move the updated frame back into the outer one.
You have changed UDP data so mangle the outer frame to fix its checksum.

How I would do it: I would apply my yet-to-be-accepted patch
<https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210518030848.17694-2-duncan_roe@optusnet.com.au/>.
Now packets are mangled in_situ and struct pktbuff is purely a descriptor
instead of having a buffer tacked on the end of it, so no more need to move the
mangled inner frame. The new pktb_populate() function can set up a struct
pktbuff for the tunnelled IP, although I might make struct pktbuff publically
visible if only so I can declare the inner one using `sizeof(struct pktbuff)`.
(I find the procedural interface to get values out of a struct pktbuff to be a
pain but that's just me: I realise that stuff is fashionable).

Cheers ... Duncan.
