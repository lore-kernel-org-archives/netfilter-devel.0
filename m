Return-Path: <SRS0=MMpb=TO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC66DC04AB7
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 14:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E4102084E
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 14:57:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="ep9j6gGE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfENO5W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 May 2019 10:57:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35202 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfENO5W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 May 2019 10:57:22 -0400
Received: by mail-wr1-f67.google.com with SMTP id w12so19615554wrp.2
        for <netfilter-devel@vger.kernel.org>; Tue, 14 May 2019 07:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G7His5KcVqi9kclJutiM1FAAK2hRmQuy58jfnCXc4K4=;
        b=ep9j6gGEFfyteSBR+XYYyYtFle7zv+d93YY5K3kRvnvMlGhmotlnKETMYAXvJuPHrS
         IQQMQId1okgrCeB+9Ztg9ERLhuWlnBxJlBhdK/w+evfGXZtammEMKLixEg/fpL5VhFYs
         D75Yei3XPzZRbs0g9fYkcqRngSoDJ2CmXS/+L3u+v6lyUJejR+38sNoGS0hr6U9jLKeu
         AnJMULKF6K12vnGqH1mgy9EvJTYEHHDm+9U9Mf+p/uro+uyXyyEhcdkL4jU/LN7X0RNV
         weFxf4FeqNxzj50Cgg5Bh1rotSRaHNeY56NEOlEv2+VQGkc/z1jgSFe9Vz6XJYj78R39
         NVpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=G7His5KcVqi9kclJutiM1FAAK2hRmQuy58jfnCXc4K4=;
        b=Rz01DiHJjLVUmm9S5Lje4N2HI7L6u2oy808FpQ5XO7uT3dW+TVCnq+OWRrY9+wpJXn
         Ny5udxiUR1a8d8LD2z4zLSyvv/MwUdN6HNSBuu2ZMKGumfDjwWSKjpGVZfX+YjqMgDpD
         VlQ5nIoskT557UY+jEEqmtEwNM0gIHzeC+fbzB0YHwC6gW5JmTwL2G/WWYOX7EkTFFip
         J8+AKfoBK4k0Qx94l0cvRNgcy2QX91DSswWCtm9BiN5c4HyW2d5nFf6CnizRRenBtU/L
         u8jTIgIBSRFvjq595c9MZNi3ae4DfAx5uyMKQXVsqALz1mJDvjFu6Y8by76JiV98wJ/V
         b68g==
X-Gm-Message-State: APjAAAVUOazL44nrDOfKnrBYCYYyurmqTa/4ocIzfbtN+JQBUPy1Y8Wt
        JMAr2EmSh2mcBdjO50v4paHu9AEtJnk=
X-Google-Smtp-Source: APXvYqxxEnhyLRJB/npVQgobjuw2ph6/BCHfLX2eTq6ePsh1GtYHQYm598iVM23FYSHcQ85gReFj+A==
X-Received: by 2002:adf:edce:: with SMTP id v14mr18965373wro.94.1557845840705;
        Tue, 14 May 2019 07:57:20 -0700 (PDT)
Received: from localhost (ip-89-177-139-111.net.upcbroadband.cz. [89.177.139.111])
        by smtp.gmail.com with ESMTPSA id d72sm1546097wmd.12.2019.05.14.07.57.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 07:57:20 -0700 (PDT)
Date:   Tue, 14 May 2019 16:57:19 +0200
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
Subject: Re: [PATCH net-next,RFC 1/2] net: flow_offload: add flow_block_cb API
Message-ID: <20190514145719.GE2238@nanopsycho>
References: <20190509163954.13703-1-pablo@netfilter.org>
 <20190509163954.13703-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509163954.13703-2-pablo@netfilter.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thu, May 09, 2019 at 06:39:50PM CEST, pablo@netfilter.org wrote:
>This patch renames:
>
>* struct tcf_block_cb to flow_block_cb.
>* struct tc_block_offload to flow_block_offload.
>
>And it exposes the flow_block_cb API through net/flow_offload.h. This
>renames the existing codebase to adapt it to this name.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

[...]

	
>+
>+void *flow_block_cb_priv(struct flow_block_cb *block_cb)
>+{
>+	return block_cb->cb_priv;
>+}
>+EXPORT_SYMBOL(flow_block_cb_priv);
>+
>+LIST_HEAD(flow_block_cb_list);
>+EXPORT_SYMBOL(flow_block_cb_list);

I don't understand, why is this exported?


>+
>+struct flow_block_cb *flow_block_cb_lookup(u32 block_index, tc_setup_cb_t *cb,
>+					   void *cb_ident)

2 namespaces may have the same block_index, yet it is completely
unrelated block. The cb_ident


>+{	struct flow_block_cb *block_cb;
>+
>+	list_for_each_entry(block_cb, &flow_block_cb_list, list)
>+		if (block_cb->block_index == block_index &&
>+		    block_cb->cb == cb &&
>+		    block_cb->cb_ident == cb_ident)
>+			return block_cb;
>+	return NULL;
>+}
>+EXPORT_SYMBOL(flow_block_cb_lookup);

[...]
