Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA967C468AA
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 23:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A18B62147A
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 23:27:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="guhlpDtM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfGEX1g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 19:27:36 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35292 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfGEX1g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 19:27:36 -0400
Received: by mail-qt1-f196.google.com with SMTP id d23so12761259qto.2
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2019 16:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mwg+ztVOA+vaS7NvwRZje9clNsDiQtGyZWkfd3T57lE=;
        b=guhlpDtMlf9u7YLUfgzCNu6nZgskp9CuuNrGcHVP8fo+T1PL8W48f511Lq3lW4rtAr
         SRWvyy9S876g0tfr9M/QQNqRIpMz7oP9JElZvy7PAEzYtLP/j6WZ+kfChU0Di8Q8M3ue
         y4w7yAnN2gOmeOmeMBeS4tZYAvoqudT83KOKk1vh5P4KaAZtoV0ureXi6q165+91xBF8
         5Gwoho4MPbVXSgQX7QSM3mIoumDu7p+TNdNoKAAxC3wfm03Eu7y5+x9H+Vl4uTfJ0HBy
         8RVno9aOzXYmev5xP5M9Xv3dmlyj1iIaHm0xxikZVQQCHSRP0b2fYSi5Bj8L7hnozNZM
         THOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mwg+ztVOA+vaS7NvwRZje9clNsDiQtGyZWkfd3T57lE=;
        b=KmBLT3dc26dbizPLmR2+lpOI+lRf/BEawhJHlrMd1hCgTS+nQD7zpYXd1Tiqg5mXNf
         z+S1iAefyVIlJYAPY16b8Z36EPOiY5C4LwDaON0VgxLty1Wzd+gA2lIN02Jvj6x6dnhY
         dYnXxec7n3OKE9CsvQDAK5cInvh0Y+hP937T8V4VCuHbKEWLBtJ/V6QVbEKAEwb+hYOi
         LfhwnEcdK+DEg+6oPp5on1tLt0T2vcm9Pzt/ij6IuiTMJCZIr/hx2w2yFEqVoJcPVrjT
         ggoUMYrYv9ciqLbmuxaHniD4bKxILU5bmdUBbKw8Efj+CUKiJDmWLV+BqK1pRoPeVSd1
         xdww==
X-Gm-Message-State: APjAAAVZJuZ5vYXqSkhijN/OntpNRqRJktLF8lO8lVVViYoFIOqorIJw
        WZWZLv+FiLvttI/ye5zhwLvC+Q==
X-Google-Smtp-Source: APXvYqz5kCJja49nxO5AbpOLhFikbGxoNkoiSNQI1UlUs834S4nln1XgYHl9at/wZFblV15pqKgN6g==
X-Received: by 2002:ac8:3006:: with SMTP id f6mr4750546qte.122.1562369255378;
        Fri, 05 Jul 2019 16:27:35 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h8sm1633583qto.45.2019.07.05.16.27.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 16:27:35 -0700 (PDT)
Date:   Fri, 5 Jul 2019 16:27:29 -0700
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
Subject: Re: [PATCH 06/15 net-next,v2] net: sched: add
 tcf_setup_block_offload()
Message-ID: <20190705162729.67ee3d66@cakuba.netronome.com>
In-Reply-To: <20190704234843.6601-7-pablo@netfilter.org>
References: <20190704234843.6601-1-pablo@netfilter.org>
        <20190704234843.6601-7-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri,  5 Jul 2019 01:48:34 +0200, Pablo Neira Ayuso wrote:
> Most drivers do the same thing to set up the block, add a helper
> function to do this.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 534a545ea51e..003f24a1323f 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -922,6 +922,26 @@ static int tcf_block_setup(struct tcf_block *block, struct tc_block_offload *bo)
>  	return err;
>  }
>  
> +int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
> +			    void *cb_ident, void *cb_priv, bool ingress_only)
> +{
> +	if (ingress_only &&
> +	    f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
> +		return -EOPNOTSUPP;
> +
> +	switch (f->command) {
> +	case TC_BLOCK_BIND:
> +		return tcf_block_cb_register(f->block, cb, cb_ident, cb_priv,
> +					     f->extack);
> +	case TC_BLOCK_UNBIND:
> +		tcf_block_cb_unregister(f->block, cb, cb_ident);
> +		return 0;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +EXPORT_SYMBOL(tcf_setup_block_offload);
> +
>  static struct rhashtable indr_setup_block_ht;
>  
>  struct tc_indr_block_dev {

This change is pretty much unrelated to the rest of the series, isn't
it?  Can you please post it separately and make the series smaller
this way?

Perhaps tcf_setup_block_offload_simple() would be a good name for this
helper?
