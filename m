Return-Path: <SRS0=MMpb=TO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFBAC04AB4
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 17:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEC202084A
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 17:01:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="DBn77Du5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfENRBN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 May 2019 13:01:13 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40293 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfENRBM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 May 2019 13:01:12 -0400
Received: by mail-lj1-f195.google.com with SMTP id d15so15001403ljc.7
        for <netfilter-devel@vger.kernel.org>; Tue, 14 May 2019 10:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M+asgOjKkxyJidGL/Vv7sfbCymMBgR+wKAqUoHiQtxQ=;
        b=DBn77Du5EqyM2uvrG7eNPNaGA/tGHGSxA8hp3ANygkA973XM0lNus2cMRlzwlDI1Vs
         6B5lPIMBoAobVSKlb3sHrqvhtG3QySxMFNeNZgcZ2AYY5sQn3NVdjVrH5ZvEZESxX6MU
         bBWfK4seR2BkvMlCaRNR41y4ezetAKHIfA6LcpjpEZYIJxsrHd2ot6uMhUXdkbou8YDA
         WvPj/8iY0LyBlF6+4e0RVUe6TX+wf/Nk3tHqaTDusW0lHQ8s1tNc1bAcRo2nkEi/YCP/
         BKUtQh9CGohGpAQQ4Z3cRTud+07RkzCITxFuqaHf323bt1CeTqhSuAfOdBTy4AIAHW8R
         8EGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M+asgOjKkxyJidGL/Vv7sfbCymMBgR+wKAqUoHiQtxQ=;
        b=hUjWizzNJ1NkIZUAi58V04INiSLAmF3YR32k8azwZeRA4Ci+7bV/w6T/4GrqYOd6rI
         fW3ZADaTSGpHZlRMm7M7fcJgT2yl2hTyqgv3Y1H6Bg7XTUdcwTxphugOycdtkGJLvrAi
         8oftvS0xX69SPOiulvy+CrdIDTYr/i+Ipbgu3Fz4I2HnPwS05zLPwwqHdgUGoW1d4UPF
         GrzB+hdw2mQiUoQyIfoDkDOhcUS0oahvo5q7RpTC8Pv03Bkr29rHWYQ324hKoqFailfm
         M5kA7kLTgQ9yAH6Yfn48ij1YBC34AO8Ss7as+8/020gRTp32KbQyT7elmpa9RLLJvAIF
         +ekg==
X-Gm-Message-State: APjAAAV3DcGybOydmsn+lNfjRABqGLrw6PbXueJGCeOFDcL2WIhEbnjq
        t2GKOHRjFNZfrDZNKwm4Zaeylg==
X-Google-Smtp-Source: APXvYqyZO1556MZKXsal2lV5RL+zHNQ5YneIp2bnTiE535h27p9BAdsFS0cmUdvm/v9YvwPJBHwjAQ==
X-Received: by 2002:a2e:568b:: with SMTP id k11mr17600632lje.124.1557853270761;
        Tue, 14 May 2019 10:01:10 -0700 (PDT)
Received: from localhost ([5.180.201.3])
        by smtp.gmail.com with ESMTPSA id q26sm2413815lfd.54.2019.05.14.10.01.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 10:01:10 -0700 (PDT)
Date:   Tue, 14 May 2019 19:01:08 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, thomas.lendacky@amd.com,
        f.fainelli@gmail.com, ariel.elior@cavium.com,
        michael.chan@broadcom.com, santosh@chelsio.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        julia.lawall@lip6.fr, john.fastabend@gmail.com
Subject: Re: [PATCH net-next,RFC 2/2] netfilter: nf_tables: add hardware
 offload support
Message-ID: <20190514170108.GC2584@nanopsycho>
References: <20190509163954.13703-1-pablo@netfilter.org>
 <20190509163954.13703-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509163954.13703-3-pablo@netfilter.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thu, May 09, 2019 at 06:39:51PM CEST, pablo@netfilter.org wrote:
>This patch adds hardware offload support for nftables through the
>existing netdev_ops->ndo_setup_tc() interface, the TC_SETUP_CLSFLOWER
>classifier and the flow rule API. This hardware offload support is
>available for the NFPROTO_NETDEV family and the ingress hook.
>
>Each nftables expression has a new ->offload interface, that is used to
>populate the flow rule object that is attached to the transaction
>object.
>
>There is a new per-table NFT_TABLE_F_HW flag, that is set on to offload
>an entire table, including all of its chains.
>
>This patch supports for basic metadata (layer 3 and 4 protocol numbers),
>5-tuple payload matching and the accept/drop actions; this also includes
>basechain hardware offload only.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

[...]

>+static int nft_flow_offload_chain(struct nft_trans *trans,
>+				  enum flow_block_command cmd)
>+{
>+	struct nft_chain *chain = trans->ctx.chain;
>+	struct netlink_ext_ack extack = {};
>+	struct flow_block_offload bo = {};
>+	struct nft_base_chain *basechain;
>+	struct net_device *dev;
>+	int err;
>+
>+	if (!nft_is_base_chain(chain))
>+		return -EOPNOTSUPP;
>+
>+	basechain = nft_base_chain(chain);
>+	dev = basechain->ops.dev;
>+	if (!dev)
>+		return -EOPNOTSUPP;
>+
>+	bo.command = cmd;
>+	bo.binder_type = TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
>+	bo.block_index = (u32)trans->ctx.chain->handle;
>+	bo.extack = &extack;
>+	INIT_LIST_HEAD(&bo.cb_list);
>+
>+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);

Okay, so you pretend to be clsact-ingress-flower. That looks fine.
But how do you ensure that the real one does not bind a block on the
same device too?


>+	if (err < 0)
>+		return err;
>+
>+	list_splice(&bo.cb_list, &basechain->cb_list);
>+	return 0;
>+}
>+

[...]
