Return-Path: <SRS0=D85U=VG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 517FCC73C41
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 13:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 259182080C
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 13:36:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="swVKRig3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfGINg6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 09:36:58 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45881 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfGINg6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 09:36:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so21058124wre.12
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jul 2019 06:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mapTixTrDXxjke3qFfFxnsQjvfj+IddECOYJD1EKo3I=;
        b=swVKRig3g+jfOKk8GEplgPnDkbqC8LdaJiZ3JsT8ovr3eV384gH2/Le+Am0PVdDscI
         WZ1B18bZOPTMey6jYVSb4WsbtcI2mGsHvt+FwPqKr2zfeHHjmdCNDGEnQmk4Z1Bldxl6
         kze/TSeZX3a65ko5PVqSfM/bjxx6sWf3gbezmntEjRvckgnIPAFW6rK9jaMd4B4PZkxs
         Nx2259oAD7FahpaacYnRWP3YGNEsR/xgnWGWEtPgI7GpmKydHOvST2kpN5KC4xbj/OBx
         g7HkFU3SVno1y/HWxgvS62xfEYE8ZYwYkwoNNc7zBsue6xlZ8EQlk3cS8vTPAbQoBDlX
         EZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mapTixTrDXxjke3qFfFxnsQjvfj+IddECOYJD1EKo3I=;
        b=mABQGM/2w3GCLd4y+jQ0P8PHemVkzxN3piNa9RwJOcYQ3Wa4BdRwBzKYDb/hQ3zvn4
         1PQcEJOikecJTBa0+QX+ryYnyp8iT/oJkbz7Qc/6fhKm4gfveS7PY7aSX6mdDSfGy7Wt
         CwLuIV4CdrbFCdGOlh/Xbs7vTS3KRy0mbu98dT1RxofXY9u5p99sijvrh/tP+V3TAMrY
         iyMVca3MJ/5H7gxScDpBIkV8CQIt2ZMColSezk2/r/1EB3jQn1Drf4Ey5L6sBME1GnJv
         BaHXWtmBuIPN3riqWtXxYMWUP0sIQi7aTxIfAwA7FYtDMVMWHhL755Ju1gK/OcDRMRmT
         eUWQ==
X-Gm-Message-State: APjAAAVd31fj0/junFvArtSq35XSLUXLjXkQ9k4JJZG/KU3EBLPsJHEe
        NHBuVbTQsiwABt8G1Tlymq6dQg==
X-Google-Smtp-Source: APXvYqyS5csTOPqaonVD5h7+CScSvN8r6CUv2JLjRyreI8Bk5Ej/nWRyy6MZ9uRf88oPZGtbslOZ4w==
X-Received: by 2002:adf:a70b:: with SMTP id c11mr26584919wrd.172.1562679415685;
        Tue, 09 Jul 2019 06:36:55 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t15sm20824876wrx.84.2019.07.09.06.36.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 06:36:55 -0700 (PDT)
Date:   Tue, 9 Jul 2019 15:36:54 +0200
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
Subject: Re: [PATCH net-next,v3 10/11] net: flow_offload: add
 flow_block_cb_is_busy() and use it
Message-ID: <20190709133654.GA2301@nanopsycho.orion>
References: <20190708160614.2226-1-pablo@netfilter.org>
 <20190708160614.2226-11-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708160614.2226-11-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mon, Jul 08, 2019 at 06:06:12PM CEST, pablo@netfilter.org wrote:
>This patch adds a function to check if flow block callback is already in
>use.  Call this new function from flow_block_cb_setup_simple() and from
>drivers.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>---
>v3: formerly known as "net: flow_offload: don't allow subsystem to reuse blocks"
>    add flow_block_cb_is_busy() helper. Call it per driver to make it easier
>    to remove this whenever the first driver client support for multiple
>    subsystem offloads.
>
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c    |  4 ++++
> drivers/net/ethernet/mellanox/mlxsw/spectrum.c      |  4 ++++
> drivers/net/ethernet/mscc/ocelot_tc.c               |  3 +++
> drivers/net/ethernet/netronome/nfp/flower/offload.c |  4 ++++
> include/net/flow_offload.h                          |  3 +++
> net/core/flow_offload.c                             | 18 ++++++++++++++++++
> net/dsa/slave.c                                     |  3 +++
> 7 files changed, 39 insertions(+)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>index 19133b9e121a..e303149053e4 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>@@ -721,6 +721,10 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
> 		if (indr_priv)
> 			return -EEXIST;
> 
>+		if (flow_block_cb_is_busy(mlx5e_rep_indr_setup_block_cb,
>+					  indr_priv, &mlx5e_block_cb_list))

As I already asked for in another patch in this set, it would be really
much much better to have some wrapping struct instead of plain list
head here. 

[...]
