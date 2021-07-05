Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10E2C07E99
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jul 2021 12:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5DFF6135D
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jul 2021 12:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhGEM3g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jul 2021 08:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhGEM3g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jul 2021 08:29:36 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7ACFC061574
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jul 2021 05:26:59 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id h6so9033532plf.11
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jul 2021 05:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=oQbAk9/aw9tzWebdmQ0A8Iv1hnWXcpsJ+fLLtrF5EbU=;
        b=XSMKNcwvOFCqrD/OkqyxV0tQh8kO0Jwsbkhzos3V7bXJfmXrwtPWbvjib9MYaA0O90
         /jH8uIUpEYOmChZSbwQpi9r3/l1JJeQTAGTA7C7gqZRFZS8cEKyAftoo1CcmKS1v0HF2
         hfHUsZvwmnv+KVfuCrlSucpTmB1Po7M178IAUumIUnLQ7m6ZLSYcz1VaZ6mY/Y2rxgU2
         63ofqPq3uRRV827OJ7WZ+6tIJOhDp26n+qrg7IXRf41dZjtHbydvXCC5NruRrCsHDPi7
         obf7yCBxDKyS5M1uAQpvaZS3t9UoaJwoKaM4R37n7JC7dvlOWm2xqib1jria0xuH/IJb
         bdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=oQbAk9/aw9tzWebdmQ0A8Iv1hnWXcpsJ+fLLtrF5EbU=;
        b=A2sa8q//fbsdsUvAO58PIBZBDxwY3fey23Jf0PNLdfiCjOmNOi6kA5/0/RmtGQCC2s
         0jf1Mqrcc+Bd348BS6qPdWDu9A6aip5MIOr82nuOLC6p7lCCblnpxkA1nwHWXYRZ/PFW
         Gj0F1TlNShw7MHvMsHjdPDbHeE3SYUY2FFVJuPp+KNm9Zmzd+5xvkXj6NuYRYVIfw4Vm
         x9RBl1XmVHEEbm4um0AY+JLZipG6T89rz4z7jSjzFZThFjD/D6AagDqrXSzk+xgSPqQJ
         UDmjnkzVYxgWT5nyX+W7p5pL9FUIPp6475C6zaZsCe48GqyLtp/qSRpZW29HGqwr6f/E
         2Mhw==
X-Gm-Message-State: AOAM531YMPv4EP22VEzR369vVbmMqXpMGZ1kabzfxj90HOrf7PKFe9W3
        TfrQEJN9e3qnwb3R8AqzWzqd9wg9idQ=
X-Google-Smtp-Source: ABdhPJy0vhC2nBICQKxZe6px5KdIw7DPgmQm0stS5PHVLM8vewR0+CSf3npuSqs9FiHRHhRIfsnAGg==
X-Received: by 2002:a17:902:7b93:b029:127:8c1b:ea76 with SMTP id w19-20020a1709027b93b02901278c1bea76mr12658404pll.52.1625488019125;
        Mon, 05 Jul 2021 05:26:59 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id q17sm4972619pfh.30.2021.07.05.05.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 05:26:58 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 5 Jul 2021 22:26:53 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] src: annotation: Correctly identify
 item for which header is needed
Message-ID: <YOL6jXNMeRGh+BlX@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210704054708.8495-1-duncan_roe@optusnet.com.au>
 <20210705085246.GA16975@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705085246.GA16975@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 05, 2021 at 10:52:46AM +0200, Pablo Neira Ayuso wrote:
> On Sun, Jul 04, 2021 at 03:47:08PM +1000, Duncan Roe wrote:
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> >  examples/nf-queue.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/examples/nf-queue.c b/examples/nf-queue.c
> > index 3da2c24..7d34081 100644
> > --- a/examples/nf-queue.c
> > +++ b/examples/nf-queue.c
> > @@ -15,7 +15,7 @@
> >
> >  #include <libnetfilter_queue/libnetfilter_queue.h>
> >
> > -/* only for NFQA_CT, not needed otherwise: */
> > +/* only for CTA_MARK, not needed otherwise: */
>    #include <linux/netfilter/nfnetlink_conntrack.h>
>
> The reference to NFQA_CT is correct.

If I comment out the #include, the compiler complains about CTA_MARK. It does
not complain about NFQA_CT. Perhaps:
> -/* only for NFQA_CT, not needed otherwise: */
> +/* only for conntrack attribute CTA_MARK, not needed otherwise: */

In any case:
>
> enum nfqnl_attr_type {
[...]
>         NFQA_CT,                        /* nf_conntrack_netlink.h */
>
The header is nfnetlink_conntrack.h, not nf_conntrack_netlink.h.

I can submit a v2 to also fix nf_conntrack_netlink in the cached headers.

Cheers ... Duncan.
