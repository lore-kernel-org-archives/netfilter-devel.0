Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D21C606BD
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 17:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 166F3217D8
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 17:42:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="IY+VaTm6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbfGHRmJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 13:42:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50980 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbfGHRmJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 13:42:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so376403wml.0
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jul 2019 10:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ye/ao4wrW+EUCxOtSAz3cL/mCw3UELfD0/7EA13+7ME=;
        b=IY+VaTm6YIzbox7XK448KVefzqd5kcSp7gecKsSU/OI4jZ+FnI8tbYpZypbMGQ0qFb
         nQCPv6r3tfaTnfEoFr16NXNlaxLHXCOhjU/qdWuGrTkotdQAeZcCuRaRyluusRnd2dl4
         azwgGpCp7q0nNyedInzjEGk3EMrhHfZeEgIi5Gjkr9e6ZVQfvRMgXs0SFYCC9HZjzJQN
         5JXM9hqJNhRFyABX8hsiPpzw+ZEW1hHDd3tb5S2zO6phyzoVEVtxNu4Qb5pIXBuP+7jN
         4Gp5UwmIBckGXHenyuhJe+3ma80GWxkgGVSEotiaK81rdX9qPwvZ6bw4UakhaKeQPcXU
         jh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ye/ao4wrW+EUCxOtSAz3cL/mCw3UELfD0/7EA13+7ME=;
        b=QfosJzxGnVnG8EDofqXK+GK8fwppgHBMdOjLZS8qNfmss378KUwXavGuj1zJg5fUmp
         Mc5CxZdeVeRSZtpRhe1zR1cFIZNu0/T/NK4O3ZFdaWeBx2F4gcaOT+YL1Q1DxltKqZ0f
         yXiDrPA9Mme+ToPEPX3BqhK2Ii7h3cjz+XZ6JG2X3E3RhUC0NozfwmhsZUQuQPYpmL23
         7+tupZ9IgVQgR9+vogiEX0tuwSbc4crwzndOyys+Xwy7CF5OfuCZUja52dtrut1LQHJ+
         jt3b35108QeHVp5YIbVYkN23T4uvz7sORpNejd56JjWTR+CD768SUgv74SCdbiH+jVJp
         4z4Q==
X-Gm-Message-State: APjAAAVav4JvdTpku2JP90D8P15JcaTh0vb6LoSVVG9zoHpws+Ilhhxu
        nKhJzaAVem0dd8xqnLflVQnO4A==
X-Google-Smtp-Source: APXvYqyoDcfjbc5Jjj+wWrqlUumG0wn7U2u7ZZLPzrfGGDQIrVQ7L+7CEe4cZBozdheh3Kd/XPOh2A==
X-Received: by 2002:a05:600c:da:: with SMTP id u26mr17133667wmm.108.1562607727394;
        Mon, 08 Jul 2019 10:42:07 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t17sm24535673wrs.45.2019.07.08.10.42.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 10:42:06 -0700 (PDT)
Date:   Mon, 8 Jul 2019 19:42:06 +0200
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
        cphealy@gmail.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v3 07/11] net: sched: use flow block API
Message-ID: <20190708174206.GC2282@nanopsycho.orion>
References: <20190708160614.2226-1-pablo@netfilter.org>
 <20190708160614.2226-8-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708160614.2226-8-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mon, Jul 08, 2019 at 06:06:09PM CEST, pablo@netfilter.org wrote:
>This patch adds tcf_block_setup() which uses the flow block API.
>
>This infrastructure takes the flow block callbacks coming from the
>driver and register/unregister to/from the cls_api core.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

[...]


>+static int tcf_block_bind(struct tcf_block *block,
>+			  struct flow_block_offload *bo)
>+{
>+	struct flow_block_cb *block_cb, *next;
>+	int err, i = 0;
>+
>+	list_for_each_entry(block_cb, &bo->cb_list, driver_list) {
>+		err = tcf_block_playback_offloads(block, block_cb->cb,
>+						  block_cb->cb_priv, true,
>+						  tcf_block_offload_in_use(block),
>+						  bo->extack);
>+		if (err)
>+			goto err_unroll;
>+
>+		list_add(&block_cb->list, &block->cb_list);
>+		i++;
>+	}
>+	list_splice(&bo->cb_list, bo->driver_block_list);

This cl/driver_block list magic is really very hard to follow. Could you
please make it more clear?



>+
>+	return 0;
>+
>+err_unroll:
>+	list_for_each_entry_safe(block_cb, next, &bo->cb_list, driver_list) {
>+		if (i-- > 0) {
>+			list_del(&block_cb->list);
>+			tcf_block_playback_offloads(block, block_cb->cb,
>+						    block_cb->cb_priv, false,
>+						    tcf_block_offload_in_use(block),
>+						    NULL);
>+		}
>+		flow_block_cb_free(block_cb);
>+	}
>+
>+	return err;
>+}
>+
>+static void tcf_block_unbind(struct tcf_block *block,
>+			     struct flow_block_offload *bo)
>+{
>+	struct flow_block_cb *block_cb, *next;
>+
>+	list_for_each_entry_safe(block_cb, next, &bo->cb_list, driver_list) {
>+		list_del(&block_cb->driver_list);
>+		tcf_block_playback_offloads(block, block_cb->cb,
>+					    block_cb->cb_priv, false,
>+					    tcf_block_offload_in_use(block),
>+					    NULL);
>+		list_del(&block_cb->list);
>+		flow_block_cb_free(block_cb);
>+	}
>+}

[...]
