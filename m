Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D2B9C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jun 2022 02:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbiFRCAv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jun 2022 22:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbiFRCAu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jun 2022 22:00:50 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209F66B7CF
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2022 19:00:49 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id h34-20020a17090a29a500b001eb01527d9eso4717218pjd.3
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2022 19:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=Qgtj6G9oJfTjzkLDgbvMlJZMzhvJVp3tqlZJlNbzVCg=;
        b=KkPloncU19lc586C6a4Fr8aRrS1s9N6i5HkmwXG3buXZR49D5Ej1UnUZbQUSyd+xoU
         kWanRWUSbXISqoFysOnzHHQTKYVpeEKYREFfZiLO79LZPikongw40nTYugPdAzB1JinZ
         0uGEAOiotZSaT9BPB2pnVBlzQz1bddPhM4fqYqQdZqmCh9ZOxh5MQLxQwMCvdjAiHOKE
         w/vwL+o9P0kUz/RMFw3dE5rFhVw8Itz3NaW7NtIm7PrwztochqI73fKJFC+xSFb4BEga
         41sH/d8stVi4D9bIzpivtmuTxf1pzgrhc1aKWnJP6z240R5OGeB6xFBB+6MbwEl4byJ5
         s1Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :reply-to:mail-followup-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qgtj6G9oJfTjzkLDgbvMlJZMzhvJVp3tqlZJlNbzVCg=;
        b=fGNcdos/IUcLFsMswIp9Ec17ugQiH9AIEEUrtWBB5eKYKwfW76mRS/XSE6ZqXdExR0
         dWHAaB9XG2OthdAleOXZZebFOtcangN+A9GZCEs4kEllkYbGfz57SAfTy/t2S349hTFR
         S3ZPe/vJxneNgXUnySwYVUpkmXuU9npviac7Tj/AaGgjtvP8B+sszO+Fnj6f/RQdZ8z+
         3ldcHh9zNdypjuhfxLz1QLoK9sRD98iE5E7xehnC3pwNHBKikza/z//DhWGdhZw3uu76
         UbdJXU4pORUHVXYGk2EYJ4igbefE+e6OlWOePkWoqOuVrtZ8Ar6ZgvaaJ/HnrCSIj+PQ
         +cUg==
X-Gm-Message-State: AJIora9B4coJSnYEs6vsHpwannbOAYu+BCMrq3TrQYM6Ej+DNEbfqodn
        HN08eVP3jalPzImZkNeeNL3CKvr5VIE=
X-Google-Smtp-Source: AGRyM1u/RvgJUwbnm9ZxnlorwvlsDaaG/7QOMqhGnIKDrnexKOZbYUtTFJp3aDY678sWSJqm8dEMzg==
X-Received: by 2002:a17:90b:4b02:b0:1e2:ff51:272a with SMTP id lx2-20020a17090b4b0200b001e2ff51272amr13686380pjb.56.1655517648554;
        Fri, 17 Jun 2022 19:00:48 -0700 (PDT)
Received: from slk15.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id h189-20020a62dec6000000b0050dc762813csm4376002pfg.22.2022.06.17.19.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 19:00:47 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Sat, 18 Jun 2022 12:00:44 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH libnetfilter_queue v4] src: eliminate packet copy when
 constructing struct pktbuff
Message-ID: <Yq0xzEkd7SF+vUwO@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
References: <20220328024821.9927-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328024821.9927-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Mar 28, 2022 at 01:48:21PM +1100, Duncan Roe wrote:
> To avoid a copy, the new code takes advantage of the fact that the netfilter
> netlink queue never returns multipart messages.
> This means that the buffer space following that callback data is available for
> packet expansion when mangling.
>
> nfq_cb_run() is a new nfq-specific callback runqueue for netlink messages.
> The principal function of nfq_cb_run() is to pass to the called function what is
> the length of free space after the packet.
>
> pktb_setup is a new function to initialise a new struct pkt_buff.
>
> pktb_head_size() is a new function to return the amount of memory to reserve
> for a new struct pkt_buff.
>
> nfq_cb_t is a new typedef for the function called by nfq_cb_run()
> [c.f. mnl_cb_t / mnl_cb_run].
>
> examples/nf-queue.c is updated to demonstrate the new API.
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
> v4:
> New functions have man pages / html doc
> struct pkt_buff remains opaque
> pktb_populate renamed pktb_setup
[...]

This patch locks in that the netfilter queue will never batch multiple packets:
is that a problem?

If you like I could send a v5 documenting that programs that hold on to multiple
packets should [continue to] use mnl_cb_run / pktb_alloc / pktb_free.

Re documentation: of course I would like to rework it to replace "deprecated"
with e.g. "old interface". There would be a section comparing the old and new
interfaces. I would rather not have to write in that section that the old
interface is faster (but can't mangle).

If you apply this patch, the old interface would no longer be faster.

Cheers ... Duncan.
