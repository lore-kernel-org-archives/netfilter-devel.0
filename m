Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC0EC07E96
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 00:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81E2461C3C
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 00:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhGGAEf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 20:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhGGAEe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 20:04:34 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B90C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jul 2021 17:01:55 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h4so430332pgp.5
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Jul 2021 17:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=VYJv6M9ZtT3oNVQQ9Zvt19en78zvadggr4cYthcp9lw=;
        b=ak25FL1tJi06wVZLqrk8pDOJ147b3Xt7yCxcfbGn31Sydjpmm3bk1VymItynxa6tkk
         jVEXhXB5+L7ivvY2bsXDdBOGIlWshwnjPuxOVfQrmFD6XGVgGHPGySvN3w9UgT/3FR2J
         rgfmoeqQt1nnO6GfqfCslBGsjgU4K9afcibQGKTbvhKOL7ooVmlegrEsuNaTMPENGY6Y
         2Y/5m2BiP3sFFLXAgKAj6zWXlrAZnCr30hJQ6a3x/F/Ypp9SGhhp8wm9bFmdzWMu9r2t
         l5mkqcDI/TOGt9pFwGP+o6KVU3EpQVWSNvmpV2PYVWSwiO1EB8ylrWn0Tq1xdxVx+McT
         anKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=VYJv6M9ZtT3oNVQQ9Zvt19en78zvadggr4cYthcp9lw=;
        b=TX1TecswvyAbYrsyUjkeDUT2lxoxCK6qThdcQ1ROTUCXUOsmydre21ecDjOvRbuNRe
         7i2e1qMS3gjH80ssGQVHWpBANzV6JNkoHS98JQ058eZBoXzdxNTNDfK6gCwKGM81EbJs
         RBGENl3+xki8MFvLnljoO0IGbvFwzknWtw67GBgBxDGTCSUnfrk0YqlSBZBp1WiqZNeb
         EMU18miqq15p6FxSU4S3AwqwdNOsKEXW3R+AqKmEi1fNtkeZRQh4uzP854Ho3CEiH3Qf
         q7fLqR+iq0eCyfUXzMfXeJj0789ZKHUV0D7oKveId1G1sxw6nqwJp+oj7k8P4BP7HfSn
         /sog==
X-Gm-Message-State: AOAM531aeO74d1E3aGKCbaYjWZPpu69/pby0CUyuuiSEVhkYMvXR9aTE
        Gm6PbrSHceeaCYIR3KkmumB1wIVPJt8=
X-Google-Smtp-Source: ABdhPJzlV7uCr5CJJc2v8TywiR+gI4blaYDK07MMbzqw+gqUomn7DtPaWIxGbu0MBeSyQ32RzFsLxg==
X-Received: by 2002:a62:bd05:0:b029:30a:dc6:88b7 with SMTP id a5-20020a62bd050000b029030a0dc688b7mr23209832pff.51.1625616115049;
        Tue, 06 Jul 2021 17:01:55 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id n59sm3915416pji.46.2021.07.06.17.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 17:01:54 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Wed, 7 Jul 2021 10:01:50 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2] src: annotation: Correctly
 identify item for which header is needed
Message-ID: <YOTu7qROo1iL/09T@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <YOL6jXNMeRGh+BlX@slk1.local.net>
 <20210706013656.10833-1-duncan_roe@optusnet.com.au>
 <20210706224657.GA12859@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706224657.GA12859@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 07, 2021 at 12:46:57AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 06, 2021 at 11:36:56AM +1000, Duncan Roe wrote:
> > Also fix header annotation to refer to nfnetlink_conntrack.h,
> > not nf_conntrack_netlink.h
>
> Please, split this in two patches. See below. Thanks.
>
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> >  examples/nf-queue.c                                | 2 +-
> >  include/libnetfilter_queue/linux_nfnetlink_queue.h | 4 ++--
> >  include/linux/netfilter/nfnetlink_queue.h          | 4 ++--
> >  3 files changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/examples/nf-queue.c b/examples/nf-queue.c
> > index 3da2c24..5b86e69 100644
> > --- a/examples/nf-queue.c
> > +++ b/examples/nf-queue.c
> > @@ -15,7 +15,7 @@
> >
> >  #include <libnetfilter_queue/libnetfilter_queue.h>
> >
> > -/* only for NFQA_CT, not needed otherwise: */
> > +/* NFQA_CT requires CTA_* attributes defined in nfnetlink_conntrack.h */
> >  #include <linux/netfilter/nfnetlink_conntrack.h>
> >
> >  static struct mnl_socket *nl;
>
> This chunk belongs to libnetfilter_queue.
>
> > diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
> > index 1975dfa..caa6788 100644
> > --- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
> > +++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
>
> This chunk below, belongs to the nf tree. You have to fix first the
> kernel UAPI, then you can refresh this copy that is stored in
> libnetfilter_queue.

I already sent you an nf-next patch which you said you would forward to nf.

I don't have the nf tree here but I guess the nf-next package will apply if
I re-package.

Will send 3 patches as you request.

Cheers ... Duncan.
>
> > @@ -46,11 +46,11 @@ enum nfqnl_attr_type {
> >  	NFQA_IFINDEX_PHYSOUTDEV,	/* __u32 ifindex */
> >  	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
> >  	NFQA_PAYLOAD,			/* opaque data payload */
> > -	NFQA_CT,			/* nf_conntrack_netlink.h */
> > +	NFQA_CT,			/* nfnetlink_conntrack.h */
> >  	NFQA_CT_INFO,			/* enum ip_conntrack_info */
> >  	NFQA_CAP_LEN,			/* __u32 length of captured packet */
> >  	NFQA_SKB_INFO,			/* __u32 skb meta information */
> > -	NFQA_EXP,			/* nf_conntrack_netlink.h */
> > +	NFQA_EXP,			/* nfnetlink_conntrack.h */
> >  	NFQA_UID,			/* __u32 sk uid */
> >  	NFQA_GID,			/* __u32 sk gid */
> >  	NFQA_SECCTX,			/* security context string */
> > diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
> > index 030672d..8e2e469 100644
> > --- a/include/linux/netfilter/nfnetlink_queue.h
> > +++ b/include/linux/netfilter/nfnetlink_queue.h
> > @@ -42,11 +42,11 @@ enum nfqnl_attr_type {
> >  	NFQA_IFINDEX_PHYSOUTDEV,	/* __u32 ifindex */
> >  	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
> >  	NFQA_PAYLOAD,			/* opaque data payload */
> > -	NFQA_CT,			/* nf_conntrack_netlink.h */
> > +	NFQA_CT,			/* nfnetlink_conntrack.h */
> >  	NFQA_CT_INFO,			/* enum ip_conntrack_info */
> >  	NFQA_CAP_LEN,			/* __u32 length of captured packet */
> >  	NFQA_SKB_INFO,			/* __u32 skb meta information */
> > -	NFQA_EXP,			/* nf_conntrack_netlink.h */
> > +	NFQA_EXP,			/* nfnetlink_conntrack.h */
> >  	NFQA_UID,			/* __u32 sk uid */
> >  	NFQA_GID,			/* __u32 sk gid */
> >  	NFQA_SECCTX,
> > --
> > 2.17.5
> >
