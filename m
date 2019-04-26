Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9AF2C4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 14:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79D712089E
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 14:27:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="PnYhHkte"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfDZO1S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 10:27:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36797 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfDZO1S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 10:27:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id b1so4755361wru.3
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 07:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LLelNqIf7DvXo4EY+VW6G+GNKK19dHx34gDsr8BJauM=;
        b=PnYhHktehqWCFXIoQdl/23jBpHZYwEo3yxR6c3Mb48d0l/xdxyKi9M5Fg032pYNgAo
         6O//je8MO5tJzeqh1dY1EYhS41WJPN4dixgNipNYPxxCiFCQCioJN3DfP93Lthv8GXGm
         WvwDx6gU1j6/wDGPNrCgZN4S0XhswpGMhGkNFVbtZzeSJV/O3AEah/QHWBSlnuoUMqGU
         2N6QetEPWEljtWAuQMMNwhIsujnrV8P5IzdxXDGaPRk3siXfnZJWM9oG2qrg+dCrTIb2
         NXpoREEcdPzD9k3stMj5VwN+vnAaWtRe0Ifcfx38ncV7hUhTHstd7PQFO8oaS80mndDN
         anpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LLelNqIf7DvXo4EY+VW6G+GNKK19dHx34gDsr8BJauM=;
        b=iSXD+Cnd9mt8NY0jKEjdxe0kf3S4KAkogafopCWpZvwzg3a3JKYT/YeG7z00ARVb7C
         kGVwVAIGDP2Gq1LgIhN95h+44LvbW5f35pXOB3yBsUABoLcKfKOsqo/SlR1u4YvYtUGP
         8tG55GlD9mVBX+WNjpknGMIijaKeQh/e6PcTI427nQUVOjZ+XPIsjUJ0GIu3yg2+3SV4
         Qu2FT8wfg+RJXcF4kpxMvUeCEY22gRHmsAAaucHwKOlnHFMc/mwjalTobwJCKUKk1Cwu
         pbhrt2csO5n8TweEiSSqd1/NPtNUBLMsPsIXINLkwXkcOHiXgeZXdfBTjTWNzcVKEAxh
         JLXA==
X-Gm-Message-State: APjAAAXSD/pgYDtFVTS/nNpB8rBu7MGTfZ0SsntFQGQqe+QkJrpWSwgR
        D1QJv3bFmrmFOzXduCC0e2/7Tg==
X-Google-Smtp-Source: APXvYqwEiOXE12aNgtKAdLGqIeOIpBebvmRbl70/yRfhnGxBC0wHERdxqlWgnyWf9JQxoU7SFV9cDA==
X-Received: by 2002:adf:dd85:: with SMTP id x5mr4276438wrl.172.1556288836888;
        Fri, 26 Apr 2019 07:27:16 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z11sm24610115wmf.12.2019.04.26.07.27.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Apr 2019 07:27:16 -0700 (PDT)
Date:   Fri, 26 Apr 2019 16:27:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@mellanox.com,
        john.hurley@netronome.com, jakub.kicinski@netronome.com,
        ogerlitz@mellanox.com
Subject: Re: [PATCH net-next,RFC 7/9] net: use tcf_block_setup()
 infrastructure
Message-ID: <20190426142715.GB2249@nanopsycho.orion>
References: <20190426003348.30745-1-pablo@netfilter.org>
 <20190426003348.30745-8-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426003348.30745-8-pablo@netfilter.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fri, Apr 26, 2019 at 02:33:44AM CEST, pablo@netfilter.org wrote:
>This allows us to register / unregister tcf_block_cb objects from the
>core. The idea is to allocate the tcf_block_cb object from the driver,
>attach it to the tc_block_offload->cb_list, then the core registers
>them.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>---

[...]


>--- a/net/dsa/slave.c
>+++ b/net/dsa/slave.c
>@@ -902,6 +902,7 @@ static int dsa_slave_setup_tc_block_cb_eg(enum tc_setup_type type,
> static int dsa_slave_setup_tc_block(struct net_device *dev,
> 				    struct tc_block_offload *f)
> {
>+	struct tcf_block_cb *block_cb;
> 	tc_setup_cb_t *cb;
> 
> 	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
>@@ -913,9 +914,19 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
> 
> 	switch (f->command) {
> 	case TC_BLOCK_BIND:
>-		return tcf_block_cb_register(f->block, cb, dev, dev, f->extack);
>+		block_cb = tcf_block_cb_alloc(f->block->index, cb, dev, dev,
>+					      NULL);
>+		if (!block_cb)
>+			return -ENOMEM;
>+
>+		tcf_block_cb_list_add(block_cb, &f->cb_list);
>+		return 0;
> 	case TC_BLOCK_UNBIND:
>-		tcf_block_cb_unregister(f->block, cb, dev);
>+		block_cb = tcf_block_cb_lookup(f->block->index, cb, dev);
>+		if (!block_cb)
>+			return -ENOENT;
>+
>+		tcf_block_cb_list_move(block_cb, &f->cb_list);

What you are trying to achieve with list_move here, wrapped by
tcf_block_cb_list_move() for some reason is a mystery for me.
You are moving to &f->cb_list, but you are already there...

The whole work with lists here, including tcf_block_cb_list is very
confusing for me.


> 		return 0;
> 	default:
> 		return -EOPNOTSUPP;
>diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>index a00463c8cfa9..f7f6f42d58d1 100644
>--- a/net/sched/cls_api.c
>+++ b/net/sched/cls_api.c
>@@ -714,6 +714,7 @@ struct tcf_block_cb {
> 	void (*release)(void *cb_priv);
> 	void *cb_ident;
> 	void *cb_priv;
>+	u32 block_index;
> 	unsigned int refcnt;
> };
> 
>@@ -730,12 +731,14 @@ EXPORT_SYMBOL(tcf_block_cb_priv);
> 
> static LIST_HEAD(tcf_block_cb_list);
> 
>-struct tcf_block_cb *tcf_block_cb_lookup(struct tcf_block *block,
>-					 tc_setup_cb_t *cb, void *cb_ident)
>+struct tcf_block_cb *tcf_block_cb_lookup(u32 block_index, tc_setup_cb_t *cb,
>+					 void *cb_ident)
> {	struct tcf_block_cb *block_cb;
> 
>-	list_for_each_entry(block_cb, &block->cb_list, list)
>-		if (block_cb->cb == cb && block_cb->cb_ident == cb_ident)
>+	list_for_each_entry(block_cb, &tcf_block_cb_list, list)
>+		if (block_cb->block_index == block_index &&
>+		    block_cb->cb == cb &&
>+		    block_cb->cb_ident == cb_ident)
> 			return block_cb;
> 	return NULL;
> }

[...]
