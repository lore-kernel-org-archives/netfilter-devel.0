Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0860C468AA
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 22:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B817D2147A
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 22:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="NoRNJ1aw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfGEWmU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 18:42:20 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41833 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGEWmU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 18:42:20 -0400
Received: by mail-qt1-f193.google.com with SMTP id d17so11239168qtj.8
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2019 15:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0ds8qr6RFgNS2kAGsSoGJEwX8z3ghXIJ1DdBUAr2K6s=;
        b=NoRNJ1aw+dJHwKbcl5kmQBMQQz/lxc1zgNblkp+CFbIbK91qQ3yWsoPd3yaC5gbXA4
         6WICw72IQR3EDNdvE/kwfnADcr0IpU6HKizMqKJCXJkmwF0CtdY+EOxAQkJMWE84HG3d
         9jrS288nF9JgtzmNRQLghNvKTdEGI6aMhTOBTfQ5Idn/cFAQjyZwZe+6nQJoh8KE4UJO
         FDIBeBPUL4v0L/1A28lFFpLLJvZQdfneoA+BM4phVqCuKt+Z/YHSxWIqgheLLDGeSEbg
         DsDAGzy0cflR6vuJYbhJqsmR2TBDWCxFx4WEZ7yGRT90ufBtU1ggqL0Ct0bbF/s8iG+S
         V5hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0ds8qr6RFgNS2kAGsSoGJEwX8z3ghXIJ1DdBUAr2K6s=;
        b=Wyo8uke/+q9xF689D1K844g09vEv8fluH6RC31/zxPFjmK8EwrZf2Wa/dNWhZ9lS25
         Rg94kycfPsLt5pI8zAU7sLOesg71AF+eFF9vy8BALFYA62jC+0PSRq4/8BNZRF8Io3CF
         oMCihyFX5gWIvfCP1oHEdPdcuBR6aet3zkJm+ZQewM7Wj1OtvCs2q0IYErP19m2wyq30
         k16sJ53t13hcEJ5RG7seYxNlwEwvWVrVsXSEckz6ZQCCbXwCV05K6LcGVKq1pIiLnshA
         J1QQHWsiJXVP5goryf1cBE0ltUIj7Ivs2VFL5IXkZpuPhO1We2ZKMSZC5M0C8pxRmmSt
         jnzQ==
X-Gm-Message-State: APjAAAUWDtcLqWrSyBbk7Jy/zNn42bE6+osCmyYpANYvcU1sKR1HCw6k
        vgN2/EuVp/a3XMkMxF0y54ZD8w==
X-Google-Smtp-Source: APXvYqx+hO5H/Sv9QASck6nFwotcyzSTW/VWJ4Iytsp5V7ui0wMm5k6Vbwj7ZFJQ5SOz47F+GU/TLw==
X-Received: by 2002:a0c:b66f:: with SMTP id q47mr5380180qvf.102.1562366539074;
        Fri, 05 Jul 2019 15:42:19 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w16sm4051491qki.36.2019.07.05.15.42.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 15:42:18 -0700 (PDT)
Date:   Fri, 5 Jul 2019 15:42:13 -0700
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
Message-ID: <20190705154213.7fcb5f6e@cakuba.netronome.com>
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
> diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
> index 96b89a7c468b..a42f92318b7a 100644
> --- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
> +++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
> @@ -262,9 +262,12 @@ static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
>  	}
>  }
>  
> +static LIST_HEAD(nfp_abm_vf_block_cb_list);

s/_vf//

>  int nfp_abm_setup_cls_block(struct net_device *netdev, struct nfp_repr *repr,
>  			    struct flow_block_offload *f)
>  {
> -	return flow_block_setup_offload(f, nfp_abm_setup_tc_block_cb,
> +	return flow_block_setup_offload(f, &nfp_abm_block_cb_list,
> +					nfp_abm_setup_tc_block_cb,
>  					repr, repr, true);
>  }
> diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
> index 3897cc4f7a7e..5316d85261c0 100644
> --- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
> +++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
> @@ -160,6 +160,8 @@ static int nfp_bpf_setup_tc_block_cb(enum tc_setup_type type,
>  	return 0;
>  }
>  
> +static LIST_HEAD(nfp_bfp_block_cb_list);

s/bfp/bpf/

>  static int nfp_bpf_setup_tc(struct nfp_app *app, struct net_device *netdev,
>  			    enum tc_setup_type type, void *type_data)
>  {
> @@ -168,6 +170,7 @@ static int nfp_bpf_setup_tc(struct nfp_app *app, struct net_device *netdev,
>  	switch (type) {
>  	case TC_SETUP_BLOCK:
>  		return flow_block_setup_offload(type_data,
> +						&nfp_bfp_block_cb_list,
>  						nfp_bpf_setup_tc_block_cb,
>  						nn, nn, true);
>  	default:

