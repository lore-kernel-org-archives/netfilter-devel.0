Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE647C468AA
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 22:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6C772133F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 22:32:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="cZU9DAtU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfGEWcG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 18:32:06 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45385 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbfGEWcG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 18:32:06 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so12588409qtr.12
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2019 15:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=QDzJAMlc1egGCnAxpTgp9BwHtWQa4Okwh7ZN5p0YX5w=;
        b=cZU9DAtUTj+jYjD83zqZqWf2kkPfu3DiY4YGI5kba9cvXCAAUDiTXEFngeRCOhJtoQ
         PhapfFZlL+pqWmUrr0wChNWB8gci/9Rwt01lmmJphU6PxNyUiX752ltIkMnZwxaPn/7B
         ut2SM822MgJ7yTs83dkW8gGdprTJS8A489R5DDRz8XIbeRh0zjMF948eauk162C20KVq
         MIkGGHslI94th4aGFQ5RIYyUsoYxtu3vLCCC6nymIiUQx7rlZMbN8cCoQNursXqkMn/S
         5JocL9lnmvZiquXHQOO0vcMfsqh5PwoLvPTGh7i0Y+qZNsbWUBhMyX31dSL7FdwzFlnP
         ndIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QDzJAMlc1egGCnAxpTgp9BwHtWQa4Okwh7ZN5p0YX5w=;
        b=ktBzlAm598JUHScX06Gg/OJolJaUv1pT64OVLs7eJes3cQ4PjNCIDKgv2sWnMAcKr0
         rkhAZ1QvZr+zgY+7GT83D3CaBOKE5P22QO3qp1Fcw/O2BDSttDxHO7QNP9xft1c7WBgN
         7SRAox5HD4XlQ6ibZVIH4HQ3PInlgJPsT+shsKhc/oPGXCVjADVfWoGwMUdn/UkxK98S
         c1Zyx3xKTiXtMIkPR4f/UuT85MWAbP5kAtS3FVUWdOU3G2xePDKRW9+EABvfAwxUsSjj
         vdpaXHCwTMU9bGI/O2BCZQnjBz9OptchMSZzv8tpsm3ax0qiGPgQ0Jw+4rBJu/+idY/O
         okgg==
X-Gm-Message-State: APjAAAX8ZR0dpHEg6HGxvRdNRfmWjNuvT3O07cN7TgH9IQeWQr2eOGqN
        fu0z2mbzXdTJSmvMWk4oPH6Nqg==
X-Google-Smtp-Source: APXvYqzexEGcTA0xuEKg6KjOL6wus6BDN9vOxwg3C5u1oUb+CPffkzX2b8pg7DNBSk56atQAi6biVg==
X-Received: by 2002:ac8:6601:: with SMTP id c1mr4259778qtp.93.1562365925634;
        Fri, 05 Jul 2019 15:32:05 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g54sm4908791qtc.61.2019.07.05.15.32.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 15:32:05 -0700 (PDT)
Date:   Fri, 5 Jul 2019 15:31:59 -0700
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
Subject: Re: [PATCH 04/15 net-next,v2] net: sched: add tcf_block_setup()
Message-ID: <20190705153159.6b9a8297@cakuba.netronome.com>
In-Reply-To: <20190704234843.6601-5-pablo@netfilter.org>
References: <20190704234843.6601-1-pablo@netfilter.org>
        <20190704234843.6601-5-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri,  5 Jul 2019 01:48:32 +0200, Pablo Neira Ayuso wrote:
> +static int tcf_block_bind(struct tcf_block *block, struct tc_block_offload *bo)
> +{
> +	struct tcf_block_cb *block_cb, *next;
> +	int err, i = 0;
> +
> +	list_for_each_entry(block_cb, &bo->cb_list, global_list) {
> +		err = tcf_block_playback_offloads(block, block_cb->cb,
> +						  block_cb->cb_priv, true,
> +						  tcf_block_offload_in_use(block),
> +						  bo->extack);
> +		if (err)
> +			goto err_unroll;
> +
> +		list_add(&block_cb->list, &block->cb_list);
> +		i++;
> +	}
> +	list_splice(&bo->cb_list, &tcf_block_cb_list);
> +
> +	return 0;
> +
> +err_unroll:
> +	list_for_each_entry_safe(block_cb, next, &bo->cb_list, global_list) {
> +		if (i-- > 0) {
> +			list_del(&block_cb->list);
> +			tcf_block_playback_offloads(block, block_cb->cb,
> +						    block_cb->cb_priv, false,
> +						    tcf_block_offload_in_use(block),
> +						    NULL);
> +		}
> +		kfree(block_cb);

Is this not a tcf_block_cb_free() on purpose?

> +	}
> +
> +	return err;
> +}
