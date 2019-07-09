Return-Path: <SRS0=D85U=VG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B5BC606CF
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 01:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3675921537
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 01:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="1qwLneeR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfGIBaR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 21:30:17 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45241 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGIBaR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 21:30:17 -0400
Received: by mail-qk1-f196.google.com with SMTP id s22so14822596qkj.12
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jul 2019 18:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=uCEbtA75Ael5y4+z+7n5Z0ycdNpv0CfLqobd2CKCLp8=;
        b=1qwLneeR0XKyd6i1rkBvZLtJdqv1eET3aaxyDBZ9FrwSgJVB237c2NbfMEjRsrQhM+
         r4z6eOwUz9Q22y3a6Kydv2NP63w2IsT1mxHlp1GLIyx2hTt/83anoSygcFNcByoLkqC+
         gRJ+83Fr+U3cNVN9qmDHkKtYj428c+hoO2MFRmyJePMFH/hZvJ7px6m9k0H7ljnYz3X0
         HpbglFIXUy9INFhnyGY/4D/adwhTNjAmHXBa/arfwvb4uZSHi9iw96lPZ2ZPDAPqhe6Z
         2jzzNCOfz5n3J0kNC9CARUDq58vDcSbeig26tONN5E0aUFTJsk+YWlgNI+rR3PmLTjQt
         SeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uCEbtA75Ael5y4+z+7n5Z0ycdNpv0CfLqobd2CKCLp8=;
        b=BbSWc0uks9jxzA3cHLxD3NE8SLk1SExvJ4tPIuDmXUdqmgplLkiTPnKP1PARy4/bd7
         y9roLg7whraQZSKDJA+iQWfQqBAI6ZpEHyj+m9BAK3kT+d2BeiG8Njlr8HaGklhdvJGT
         HnS2LxF6snloY1FkGZHckU9T6nYjof60Zj8SfHq0k86SKUJzOxsbyADQK+jJNY9PlVRH
         uXQ0zCAlIG/95PywiQB3Zy59NngoOGRiXXdhwVzfbQ1/CtE7jxE9Gz7KLCux/rorl5Yc
         gB7FFL4zkSmJmWcm9R+VwNJ/l5d2VVG8NHnoo1d+lNe8ynMV9bOT+hY/3Yc2LEza0T2V
         GlJQ==
X-Gm-Message-State: APjAAAXdsVbR3BwWM5HYCV9KRUNS8u6kuyPmm83DYHBDhUHqrzaflYXD
        i7d4/m/JkS34iHAqhaO3hxCjqQ==
X-Google-Smtp-Source: APXvYqxbmDX1xRPTxA/Yqj/vJSXzkICYrhT0+m81XA5JW/VNB5MrWvnw9EXLErfv7HWG0xcFaq2q1A==
X-Received: by 2002:a05:620a:13b9:: with SMTP id m25mr16892608qki.246.1562635816836;
        Mon, 08 Jul 2019 18:30:16 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z4sm6260684qtd.60.2019.07.08.18.30.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 18:30:16 -0700 (PDT)
Date:   Mon, 8 Jul 2019 18:30:11 -0700
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
Subject: Re: [PATCH net-next,v3 01/11] net: flow_offload: add
 flow_block_cb_setup_simple()
Message-ID: <20190708183011.0d369613@cakuba.netronome.com>
In-Reply-To: <20190708160614.2226-2-pablo@netfilter.org>
References: <20190708160614.2226-1-pablo@netfilter.org>
        <20190708160614.2226-2-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon,  8 Jul 2019 18:06:03 +0200, Pablo Neira Ayuso wrote:
> Most drivers do the same thing to set up the flow block callbacks, this
> patch adds a helper function to do this.
> 
> This preparation patch reduces the number of changes to adapt the
> existing drivers to use the flow block callback API.
> 
> This new helper function takes a flow block list per-driver, which is
> set to NULL until this driver list is used.
> 
> This patch also introduces the flow_block_command and
> flow_block_binder_type enumerations, which are renamed to use
> FLOW_BLOCK_* in follow up patches.
> 
> There are three definitions (aliases) in order to reduce the number of
> updates in this patch, which go away once drivers are fully adapted to
> use this flow block API.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thanks!
