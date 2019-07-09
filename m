Return-Path: <SRS0=D85U=VG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF882C606CF
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 01:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98BAA21537
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 01:35:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="m6jgncgu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfGIBfm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 21:35:42 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39900 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfGIBfm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 21:35:42 -0400
Received: by mail-qk1-f195.google.com with SMTP id w190so2344190qkc.6
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jul 2019 18:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Cb2dddoti7YGRSOZwHdkhuGfGb9RZ6NmxAXuZNqQSLE=;
        b=m6jgncgukFgZm+xW9SmQ7E0cFhkR9pd4NxXBOMmaMkbcTY3Hb/RleN4/ZMZX0MQrtf
         i4h3tXVzHeh9yA5abOgX6DwgOizbz0+HBMtE6rFZiyJs12jsKu24MZQGYcHnbV5Ysl/t
         Q/b2aJMD2gf1tQh5Yj4wDbWt4C8yclC7SmClZOcgFNiXGOv53vKv3sJ13NxzXJJjiJII
         3Kn7S8qQb4/mHPvls8JFduxQVVi2yRHWCj3WAB9JtyKNoNZtl55JCA1ligIVcO1nh+g1
         3ZsgnWAwQEDrthu55hkSJKiXXueq2b1xQHPGXz2XTAl9Pr3lLKenfKtvmy9nE6HxIMVj
         xirw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Cb2dddoti7YGRSOZwHdkhuGfGb9RZ6NmxAXuZNqQSLE=;
        b=hTz2vLyp+JExZngCnFdIU+VbzlJnHJ6x0h+vYCOQaZfpXVPh+Z3Qab4Jr59EiTLCgk
         UECIqtUvpdFTEjuWTW7b4Ycz1Fi8WFkuFOGdGMb0MAC2S3xGy7Bp3Ht0HmjqbnQsWuk7
         czKgInzs4REiGVQomGUOU5LZ4rYp2vGSozzEGqRIrDsot+SaY8wf8N3Omjk5sIHZm/Z5
         1/99zfehCR3rBUiMhakWFWyDC1QdAMZqgEWQqS/8VqXLT0KN/8iluqUc5r57a4vIX7C2
         CRdE7C1XsxKibkQ0YbFZDhwu4T/xM8PXl204XpycAOom+41Fl3nxFNN8TjKzNji9+xaC
         r7yA==
X-Gm-Message-State: APjAAAV8g2gtczhszLkhjRLwiMqE1G3NVgwNRGxu/ZP+KUJhyyDb2wsh
        NQ/s1EgSpl5JTUw1/g6VWAq4Iw==
X-Google-Smtp-Source: APXvYqzLtP/3KLDMLg1oczan6Qjcn8hU8Nskau519g5Y76r8W0jCjw99dVHSe27WUg0lGj1UXS9q6w==
X-Received: by 2002:a37:dcc7:: with SMTP id v190mr16922738qki.169.1562636141114;
        Mon, 08 Jul 2019 18:35:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n184sm8303767qkc.114.2019.07.08.18.35.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 18:35:41 -0700 (PDT)
Date:   Mon, 8 Jul 2019 18:35:34 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
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
        maxime.chevallier@bootlin.com, cphealy@gmail.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v3 08/11] drivers: net: use flow block API
Message-ID: <20190708183534.12ed0acc@cakuba.netronome.com>
In-Reply-To: <20190708160614.2226-9-pablo@netfilter.org>
References: <20190708160614.2226-1-pablo@netfilter.org>
        <20190708160614.2226-9-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon,  8 Jul 2019 18:06:10 +0200, Pablo Neira Ayuso wrote:
> diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
> index 0c93c84a188a..7549547c4ef0 100644
> --- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
> +++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
> @@ -160,6 +160,8 @@ static int nfp_bpf_setup_tc_block_cb(enum tc_setup_type type,
>  	return 0;
>  }
>  
> +static LIST_HEAD(nfp_bfp_block_cb_list);

This still says bfp.

> +
>  static int nfp_bpf_setup_tc(struct nfp_app *app, struct net_device *netdev,
>  			    enum tc_setup_type type, void *type_data)
>  {
> @@ -167,7 +169,8 @@ static int nfp_bpf_setup_tc(struct nfp_app *app, struct net_device *netdev,
>  
>  	switch (type) {
>  	case TC_SETUP_BLOCK:
> -		return flow_block_cb_setup_simple(type_data, NULL,
> +		return flow_block_cb_setup_simple(type_data,
> +						  &nfp_bfp_block_cb_list,
>  						  nfp_bpf_setup_tc_block_cb,
>  						  nn, nn, true);
>  	default:

