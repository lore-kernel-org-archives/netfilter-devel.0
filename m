Return-Path: <SRS0=hDGH=VH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2895C73C7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jul 2019 07:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2E282064A
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jul 2019 07:36:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="y9Kqc87Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfGJHg4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 03:36:56 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39891 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfGJHgz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 03:36:55 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so1112186wma.4
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2019 00:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NjpSGEczEId2PQwar/5LWdtOmNofLO7pyo56IkyyIWo=;
        b=y9Kqc87YgmxNlr6wLj1yxouqe+suFSz4+Od/x/mFLDSuqwPAqd870MNLIiO2//2kNV
         LfBuOdS2UnTiOCFUzxYX0JEAu0jqbfGWIbTNgsg7Sp+0u/RDAIBBbYexvtzTkl26KVO3
         KdyZvQrEV+05RvK0gyvd7xVgbU/WDjUzrAzRyB8TJqvRDBPTigvK4Lxahj+heLiBhd3R
         /AH3B5UgrTLQMsuX+zMgjch2xkH8FBh1tWyt9henefeopQ/nXg/PZwYBpCIoqrVlVKjf
         gyvzd7rBXjbia2hmnQuktJgnPODqG34IaRTkqE0ZcT0Wo8XW/Co2P2FdwWrA3XVrJtSS
         0S0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NjpSGEczEId2PQwar/5LWdtOmNofLO7pyo56IkyyIWo=;
        b=bkwik2Pas+kSpEJteNVFtviz6FeE2jXmnDd0UvXHg+mV/7HwFY89oDbcxPdKHy+/S8
         E/9Htv2OAagmfvCH5JJ3p2wKRlqwuz61vmqyjavsGBhk/CDYzQEQBn/+yuvoIr72xffv
         rocKZzrD7IWLL1M4rdYh0VuaknFeYmJgd07WtqPujlzi8qz98dtuUbZHW0WprIPeuRlI
         cU5BXKJrG9NK2rrYWny9zeVzZ9Zg+WzSeJEpJpnR019EdFWQq4brjYWRh64P2xbA711K
         lJ6taa/Y3q046lPSZevbjByTREOpHPUvVPMnpVwYW1u4nglx/YzOxFb2BYOD3pXToO6r
         MlMg==
X-Gm-Message-State: APjAAAW84x0QkrrYKIs3BPsQppfoig/lPQGoJvBA8d2xh+6Aye18HcoH
        T84jHYamL0kctwT2gB/Gyw0=
X-Google-Smtp-Source: APXvYqyTOKVnK8n4aBpvuH7eSxAZE/7FGrSr1W6GM7I1zKit+sD4lhU3GukEFhwZ7aSZodKwIk6L3Q==
X-Received: by 2002:a7b:c251:: with SMTP id b17mr3704761wmj.143.1562744213519;
        Wed, 10 Jul 2019 00:36:53 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w23sm1327674wmi.45.2019.07.10.00.36.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 00:36:53 -0700 (PDT)
Date:   Wed, 10 Jul 2019 09:36:52 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com, phil@nwl.cc, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v4 05/12] net: flow_offload: add list handling
 functions
Message-ID: <20190710073652.GD2282@nanopsycho>
References: <20190709205550.3160-1-pablo@netfilter.org>
 <20190709205550.3160-6-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709205550.3160-6-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Tue, Jul 09, 2019 at 10:55:43PM CEST, pablo@netfilter.org wrote:

[...]


>@@ -176,6 +176,7 @@ struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
> 	if (!block_cb)
> 		return ERR_PTR(-ENOMEM);
> 
>+	block_cb->net = net;
> 	block_cb->cb = cb;
> 	block_cb->cb_ident = cb_ident;
> 	block_cb->cb_priv = cb_priv;
>@@ -194,6 +195,22 @@ void flow_block_cb_free(struct flow_block_cb *block_cb)
> }
> EXPORT_SYMBOL(flow_block_cb_free);
> 
>+struct flow_block_cb *flow_block_cb_lookup(struct flow_block_offload *f,
>+					   tc_setup_cb_t *cb, void *cb_ident)
>+{
>+	struct flow_block_cb *block_cb;
>+
>+	list_for_each_entry(block_cb, f->driver_block_list, driver_list) {
>+		if (block_cb->net == f->net &&

I don't understand why you need net for this. You should have a list of
cbs per subsystem (tc/nft) go over it here.

The clash of 2 suybsytems is prevented later on by
flow_block_cb_is_busy().

Am I missing something?
If not, could you please remove use of net from flow_block_cb_alloc()
and from here and replace it by some shared flow structure holding the
cb list that would be used by both tc and nft?



>+		    block_cb->cb == cb &&
>+		    block_cb->cb_ident == cb_ident)
>+			return block_cb;
>+	}
>+
>+	return NULL;
>+}
>+EXPORT_SYMBOL(flow_block_cb_lookup);
>+

[...]
