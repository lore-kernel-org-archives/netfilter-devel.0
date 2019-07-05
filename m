Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,URIBL_SBL,URIBL_SBL_A autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDEB0C46499
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 23:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 953802147A
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 23:25:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="KscIoRjB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfGEXZk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 19:25:40 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43058 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfGEXZk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 19:25:40 -0400
Received: by mail-qt1-f196.google.com with SMTP id w17so9569094qto.10
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2019 16:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Mb3z/7cZ2uBzdtbi+RB8Lh7XAGAzpZXQt/EgN83/SoE=;
        b=KscIoRjBP7P6l/tvumJTVHtu7QDY1KK1LvdQ8cSEWA29JHA+1qpdekdMeW3Vesc2Bs
         4G/qh5LQWlDGxVsT416B83du5iwsJk9HMSoRQAGqMs51a6SWap+yQijTkUNAQ3lK1WHm
         V6DRKNyIK6lLWaWFRfulDQxVjEyeL5+8dHO/fxvJvf44AIhT2QTkRAtZ1Tvhhrr3/AJQ
         9FXgmYemmnZkkd197Tg/NxGqWtm6ViQguIcpM+Xrf0utv4TtRnfbHG99s173eNyI2SJr
         EzeRROW843AcfmTnoRg60jZKBkYuP+79iaEwfDgVQARCR8V6JVIi22IAs+PJ67fvB4EO
         wofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Mb3z/7cZ2uBzdtbi+RB8Lh7XAGAzpZXQt/EgN83/SoE=;
        b=IP71CiuBvZGsMx0m6/xMSja7oktkcL/Oow8dgzZfFNccMW4LYLGr2wQzYttXWbhk34
         jebGPGUZFKn0pK5iVGWQjnnWxjzUvYb+64q80ga1jYv7kfoBr4YlaR6InkfHcHNEc3bm
         7woWKoiqQ/m5DbxqT4Fv3q3wMNqd3hyB9bbAySEPXgn4U/Ltf7+u2V/dwFPGZFySbzqt
         msoyNsGmn2y3lwyMLqKi3G5R/rdKMxxBJUnPcqjCaCsWF3sZLxzuaF1TqjsH4M9WmvIl
         Wxa7pGi7cPC7dOy7O28+tmPAxg95P8UYM5hKRna/l5fD5IQgrZsb0r7g91q2nPEte2sS
         qCNw==
X-Gm-Message-State: APjAAAU13GwOpGOQzZjpU4P1TId2r/j8/kBsIgQfFL4c/AHHpXfrwxgn
        XSFJWbiC7NUJhhmmebDjF+LhPA==
X-Google-Smtp-Source: APXvYqyTI9oT4h/hAqOLpTYo96beun96wBRFt1bdRp+p/GJI12Yraq8FuoC6WRtkCYXnI0pwK5BnLg==
X-Received: by 2002:a0c:b12b:: with SMTP id q40mr5628941qvc.0.1562369139390;
        Fri, 05 Jul 2019 16:25:39 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n184sm4276537qkc.114.2019.07.05.16.25.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 16:25:39 -0700 (PDT)
Date:   Fri, 5 Jul 2019 16:25:33 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        linux-net-drivers@solarflare.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        maxime.chevallier@bootlin.com, cphealy@gmail.com
Subject: Re: [PATCH 12/15 net-next,v2] net: flow_offload: make flow block
 callback list per-driver
Message-ID: <20190705162533.7a8818f7@cakuba.netronome.com>
In-Reply-To: <20190704234843.6601-13-pablo@netfilter.org>
References: <20190704234843.6601-1-pablo@netfilter.org>
        <20190704234843.6601-13-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri,  5 Jul 2019 01:48:40 +0200, Pablo Neira Ayuso wrote:
> Remove the global flow_block_cb_list, replace it by per-driver list
> of flow block objects. This will make it easier later on to support
> for policy hardware offload of multiple subsystems.
> 
> Suggested-by: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

I don't understand the need for a per driver list of callbacks.
Your concern seems to be that drivers will get confused by multiple
subsystems trying to bind blocks.  We have a feature flag for TC
offloads, why can't netfilter have one too?  Way simpler.

If I may comment on the patches in general this series is really hard
to follow.  Changes are split into patches in a strange way, and the
number of things called some combination of block cb and list makes my
head hurt :/
