Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235C9C433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 01:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED07520679
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 01:45:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="D5MI5hS3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfHNBpE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 21:45:04 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33771 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfHNBpD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 21:45:03 -0400
Received: by mail-qt1-f193.google.com with SMTP id v38so16140936qtb.0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 18:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=TaeTgbEgKeuniyhRwODvYXoOfpd7liiFN1SmAcX8His=;
        b=D5MI5hS3Z1Jgemg4DrYqGP17fMcHm0JpxwJcpNvoWNsj9m55kKOhGNz7Ta26mGwbzK
         TDVNht+PlBGpX4kqCxct5XbJEvEw9LSvyjNG2LRVYHr2UTeggtsx6y/4RBCKuCpNtF2U
         RXRknaznhjOiORNj8Wi96Qtaim/55hfk5lf4n+HjxI0nsI04U863RMOEW/EnK1H+11mt
         ABIdwf6vbmUkMW4Gfaowf51vrgv3RkqSNpPoliP/NqjpKufiphtFymGJ1x2uH540o0Cw
         eNBd7C43j8TKQqqcFbb517ucRt5YGX+hhmUOcMDHJtu0EuP3XPFHBNyaUMx8v0z4sxU7
         +tDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=TaeTgbEgKeuniyhRwODvYXoOfpd7liiFN1SmAcX8His=;
        b=Vaj7U0AhQUyUmI/x4ceor5janljlVefE56ATgIC8Dt1ryEP1+ccHzwEWHmARn1DLhW
         v/BKzwRe83uwkkW/YDHGKMd+b3bDXUVOLqtAH1sfwcfc22S5wHUgSMd8u9Y3TRPVeAW3
         3qh8L+0ZGiEg5gPff7RF/qdU1XB95b34OAG0OJ+AuHRJuxUbcyAFudkMRJebLv4usHEb
         fCccl2ps0iqZUEnx1s0/157gvA7lVPWNDdgszaZWlTDliWhZDyINvklYPwnGUHSSEO3e
         QRFo8sYJ6QkjMZ6ZDTkxqZ1eYqjjXGIa7Yr2L/qFAQrBuru3x/89rMa8DURBNG8Q2J0d
         8ClA==
X-Gm-Message-State: APjAAAVBt3YK0TIg1ZZMrst9CsZ8FpkhmVuOVsuaT5t5gwpAFO1PafKq
        Bw3IHlbW/RbxmLiR9+tqyPcPYKSe0vg=
X-Google-Smtp-Source: APXvYqzbhn8NqzEGJVbU57O7LKKv9OdJArZr/SzVPFpL91z597fJFlJVlO75QdF3OHLAsBg++MaU8A==
X-Received: by 2002:ac8:22b9:: with SMTP id f54mr10674838qta.45.1565747102917;
        Tue, 13 Aug 2019 18:45:02 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z2sm12025172qtq.7.2019.08.13.18.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 18:45:02 -0700 (PDT)
Date:   Tue, 13 Aug 2019 18:44:50 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/17] Netfilter/IPVS updates for net-next
Message-ID: <20190813184450.3e818068@cakuba.netronome.com>
In-Reply-To: <20190813183701.4002-1-pablo@netfilter.org>
References: <20190813183701.4002-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 13 Aug 2019 20:36:44 +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter/IPVS updates for net-next:
> 
> 1) Rename mss field to mss_option field in synproxy, from Fernando Mancera.
> 
> 2) Use SYSCTL_{ZERO,ONE} definitions in conntrack, from Matteo Croce.
> 
> 3) More strict validation of IPVS sysctl values, from Junwei Hu.
> 
> 4) Remove unnecessary spaces after on the right hand side of assignments,
>    from yangxingwu.
> 
> 5) Add offload support for bitwise operation.
> 
> 6) Extend the nft_offload_reg structure to store immediate date.
> 
> 7) Collapse several ip_set header files into ip_set.h, from
>    Jeremy Sowden.
> 
> 8) Make netfilter headers compile with CONFIG_KERNEL_HEADER_TEST=y,
>    from Jeremy Sowden.
> 
> 9) Fix several sparse warnings due to missing prototypes, from
>    Valdis Kletnieks.
> 
> 10) Use static lock initialiser to ensure connlabel spinlock is
>     initialized on boot time to fix sched/act_ct.c, patch
>     from Florian Westphal.

Pulled, thanks.
