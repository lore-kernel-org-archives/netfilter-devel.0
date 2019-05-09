Return-Path: <SRS0=htyh=TJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBABC04AB2
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 18:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53864217D9
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 18:29:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="rm0RHv9+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfEIS3Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 May 2019 14:29:25 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:32901 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfEIS3Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 May 2019 14:29:25 -0400
Received: by mail-qt1-f195.google.com with SMTP id m32so618385qtf.0
        for <netfilter-devel@vger.kernel.org>; Thu, 09 May 2019 11:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=6TX4Ch/ylEGR/Zx4Bl/32H7rH72Gvc2EMOaKvQY0xYk=;
        b=rm0RHv9+nNMEUumQ8Wd2a7wBOk3foOGmNUNn6lIs7a2nTmvFYHzSASv+yoGVKTCDcW
         btUAvTHvi9zBkbSm0EKqBckHjj9ODqEjOCohCRM2e9CpBQOmyFRtLTADbI6PudjjMm5b
         ijHUHy52TesO9t7BuSGiDtDA9w3U2vlBpQ+kqQfL8DpozcB12loX8h6t9R/fPYf+1dSV
         lpcsVU1OHMA1zqw6uzBHy7lR9ZXUAzESYnLP+RLXb/3lZ6cXRTa0JBWWspdqjxh0p9b2
         OQVKaNPhc88GHMvCf/sSl4zTsUx72gC5Lu6HkuzbZhhAyOrpL2zb3Jpqcrcky8g/fA1Q
         mvDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6TX4Ch/ylEGR/Zx4Bl/32H7rH72Gvc2EMOaKvQY0xYk=;
        b=U+2THfNYTlesr7hy5m6x6oiZHKOOKftAalvphsmFZXwnidk7hnzVDtTeBPj4lYDTTd
         Af9WLvig7g51kOC6XF7xYLk3AwgNicd5d3KljNh5efOFpJrfws9xT5m9KRRzgffV+Qla
         VV+3K+OrW3L+CNgu63k1SM++8iMLkw10kZq7R3h1LXO+OWE/GSacXzyCfYAzrrrV/Ibe
         gahT2fdXTQcKEOkO2pXwfcpIy//xULxpNbLPaIBo/l475VsEPmkx3bnFi+2Ls4wx3wPP
         Gtht6FhuiXtlAm5MdGCA8AZ11l+4k3QACYK/z2qLIBRliYXBJRf5WY72wjhX4XNt9MSy
         rTTg==
X-Gm-Message-State: APjAAAUutALGYpJzCbfzgdxBXrGKKKp4ImfNZTtqlXmNcBNHa0S9UFUK
        VRhuOzBZGd7nlB8PzgLat4qlIA==
X-Google-Smtp-Source: APXvYqyZd60imGGU8w6kQMAUYW3jSOGxaqipnd66iyZkJafJVkxIZZU6QJmzan0XNSKocv+UGsdXhQ==
X-Received: by 2002:ac8:411e:: with SMTP id q30mr5091947qtl.319.1557426564395;
        Thu, 09 May 2019 11:29:24 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p19sm1626014qtp.19.2019.05.09.11.29.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 09 May 2019 11:29:24 -0700 (PDT)
Date:   Thu, 9 May 2019 11:29:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, thomas.lendacky@amd.com,
        f.fainelli@gmail.com, ariel.elior@cavium.com,
        michael.chan@broadcom.com, santosh@chelsio.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        julia.lawall@lip6.fr, john.fastabend@gmail.com
Subject: Re: [PATCH net-next,RFC 0/2] netfilter: add hardware offload
 infrastructure
Message-ID: <20190509112902.2691c690@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20190509163954.13703-1-pablo@netfilter.org>
References: <20190509163954.13703-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu,  9 May 2019 18:39:49 +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> This patchset adds initial hardware offload support for nftables through
> the existing netdev_ops->ndo_setup_tc() interface, the TC_SETUP_CLSFLOWER
> classifier and the flow rule API.
> 
> Patch 1 move the flow block callback infrastructure to
> 	net/core/flow_offload.c. More structure and enumeration definitions
> 	currently in include/net/pkt_cls.h can be also there to reuse this from
> 	the netfilter codebase.
> 
> Patch 2 adds hardware offload support for nftables.
> 
> This patchset depends on a previous patchset:
> 
> 	[PATCH net-next,RFC 0/9] net: sched: prepare to reuse per-block callbacks from netfilter
> 
> More information at: https://marc.info/?l=netfilter-devel&m=155623884016026&w=2
> 
> Comments welcome, thanks.

Jiri requested the drivers remember the block info, so we can't have
multiple block binds right now, unless we fix drivers.  See:

commit d6787147e15d ("net/sched: remove block pointer from common
offload structure")

for example.
