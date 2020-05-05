Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4481DC47256
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 18:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2357D206FA
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 18:36:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="0bBF1w2q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgEESgq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 14:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbgEESgq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 14:36:46 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FD7C061A0F
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 11:36:45 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id y24so3457533wma.4
        for <netfilter-devel@vger.kernel.org>; Tue, 05 May 2020 11:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sJPpDHeX2aoj+DGjkdKLPpH7q4rX80l4P9E7ER8uxmk=;
        b=0bBF1w2qPmFKDoAvPl8cy0F5j2WmIPAuIaFEznkGyRy/zIBAhYwu7yFuLrQHXqWE1U
         8hj/XhBHaP8UoaN14tlFc4RZGA3C7xfLd4ZM9pKbAv0q42PsAJNYGinGOPUvgQOrlOoA
         TWbZagugd+34BAKsy1pLLMg0+QvkpVhTH76lRCQCOLkbVYw25f1lCUj4NRCO09XdLq6V
         wRmvZCc+Eidg2qkLVed25fGJwvS6Kuj9PN85aDMl2/4uzdxo/EkP+VtqzGGuRu6VLcgP
         AdgK69dAgnrEc3f7WLg05lwRBxlS8phIOY9mURdY+dqMaOfJ8EmDgOFc76jm0VujcieU
         2nSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sJPpDHeX2aoj+DGjkdKLPpH7q4rX80l4P9E7ER8uxmk=;
        b=Lkj7T3CfrIsu4woKmroNQeOqQwILvAt+PDeCjFfm0ZcCNu1FiV38oh+/ylwdDZj/ss
         PfsjK4L6Npwk6yrsx8hg1GSauokfieA+EhlngtfFj0Kd40n0E0bJkdHY4+6Rs/pAqVp8
         zxjaVS+8dKAZdFVzfcsHflJ7iq0uUJs2/60qwTReVHb/nZdgDc5YwiMcieIZP/4Ud/PV
         w6vrqBylvCjd2JiT57PpLOZboQk9T9ByKwmMYq9KRTdBZ4zJopGJuCs360GSzKmxBosb
         7l2NyQNX0fggVavoVTxzTls/3KmB+O3hZqSpuS8K+Lr0svibEvSPIciBrrCQU3jWalp2
         h59A==
X-Gm-Message-State: AGi0PubkkaHpv5Dxlonapwb+52BVXoWF6IL9nr17ZkdgjgZzVi/E1Ov1
        nuDKKFN/1XwBPCn+EzIHj6atgFmKqHwJ2Q==
X-Google-Smtp-Source: APiQypJiIfTBLt/aj4qgymQlu59qSNxm77/D0iTgA/c+OxvvZz/BO8MtU9qB42NqDwaQY+DmS5pAaA==
X-Received: by 2002:a1c:770e:: with SMTP id t14mr4515133wmi.187.1588703804607;
        Tue, 05 May 2020 11:36:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o129sm5341367wme.16.2020.05.05.11.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 11:36:44 -0700 (PDT)
Date:   Tue, 5 May 2020 20:36:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, ecree@solarflare.com, kuba@kernel.org
Subject: Re: [PATCH net,v2] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200505183643.GI14398@nanopsycho.orion>
References: <20200505174736.29414-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505174736.29414-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Tue, May 05, 2020 at 07:47:36PM CEST, pablo@netfilter.org wrote:
>This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
>that the frontend does not need counters, this hw stats type request
>never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly requests
>the driver to disable the stats, however, if the driver cannot disable
>counters, it bails out.
>
>TCA_ACT_HW_STATS_* maintains the 1:1 mapping with FLOW_ACTION_HW_STATS_*
>except by disabled which is mapped to FLOW_ACTION_HW_STATS_DISABLED
>(this is 0 in tc). Add tc_act_hw_stats() to perform the mapping between
>TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*.
>
>Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Looks great. Thanks!

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
