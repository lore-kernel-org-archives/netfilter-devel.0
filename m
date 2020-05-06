Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66180C47256
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 18:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48AD42078C
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 18:16:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="p14/TxlH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbgEFSQ1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 14:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728834AbgEFSQ1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 14:16:27 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188CEC061A10
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 11:16:27 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g12so3819287wmh.3
        for <netfilter-devel@vger.kernel.org>; Wed, 06 May 2020 11:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gEsdkbpjSSud3rBKiZEKc6BAa94PnVJY+KjLicPdAok=;
        b=p14/TxlHuHfyz77uSOpupAaWfxDx/OQ/URKaInfN6cjbSQCrdfCroZkEmtp6bjG0ea
         htjmSRr9Fa9Zj3SAN+rEyevU3ugJTWWNIDQAjeTIgcWJTHZbjJCP2d1maclZDUR9pqNi
         /hRCuPOmQFFXhIJqCDVCJ6zvpqPmpQY3pkhTHQsgJ3rgzunR/stdkohoTHfKB/F2bLwc
         dmwshWE//QtgqRxn5Vjrp4syWcWKO+4ER7o7TuCf8NCVrOcwS+OdD+pd0MgqTG5FhzjS
         FnCuv1R1xUG2pau/QSqJHcEGTjMy9+aMOnoIjgW3RmrZU3rk55d2cNlyhsuP8oYsqXTf
         X3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gEsdkbpjSSud3rBKiZEKc6BAa94PnVJY+KjLicPdAok=;
        b=jdheeZ/Fu8BdQypTIysxC1SBzSrchv4QC0KvdGZKZDc6/VsZC4VXAgO8Zuv66UZvzL
         lF5QSGsOmeeMebbnwMPv54u73ZT/tsCCFUxuiFSGGa+EPa9s5WTICsi7AWYdhUzki0wV
         IdBb++DXHr12AdXMxFETcQ/5woqs2LHFrqxCrIWDFkUxh+/le9z/ZFhFMQu2S+njt/lw
         QewZ0otEpg8wLXwxWzQf6x+1M+2u633uOrrsry3g2LD83h3FpzrWIseWcgvC/Cdh174/
         7nQY1xdsYr8PYG1QyUEyJU6IgTRt+kgvW9mlBWZ1bcHGpsZjopjl2/zGyiXS2KMb88ny
         Mcyg==
X-Gm-Message-State: AGi0PuZ2A7ofNCy3DQcNjSNTwSRNBypTfhLm3QPh67ejxmmgfpdvVnRE
        OD04PtepVdEBrQcEvxzXM9Fzzw==
X-Google-Smtp-Source: APiQypLFsR+p/YR8vk2oyyPjQ3oflcDldNRNiRy/olMaH3pCQSBZNRnrs0Hh/emY5jFHAi28Itmpjw==
X-Received: by 2002:a7b:c7d2:: with SMTP id z18mr6151593wmk.72.1588788985747;
        Wed, 06 May 2020 11:16:25 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id d5sm3953874wrp.44.2020.05.06.11.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 11:16:25 -0700 (PDT)
Date:   Wed, 6 May 2020 20:16:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, ecree@solarflare.com, kuba@kernel.org
Subject: Re: [PATCH net,v3] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200506181624.GC2269@nanopsycho.orion>
References: <20200506115539.21018-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506115539.21018-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wed, May 06, 2020 at 01:55:39PM CEST, pablo@netfilter.org wrote:
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
>---
>v3: update mlxsw to handle _DONT_CARE.
>
> .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |  2 +-
> include/net/flow_offload.h                         |  9 ++++++++-
> net/sched/cls_api.c                                | 14 ++++++++++++--
> 3 files changed, 21 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
>index 51117a5a6bbf..81d0b3481479 100644
>--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
>+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
>@@ -36,7 +36,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
> 		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
> 		if (err)
> 			return err;
>-	} else if (act->hw_stats != FLOW_ACTION_HW_STATS_DISABLED) {
>+	} else if (act->hw_stats == FLOW_ACTION_HW_STATS_DELAYED) {

I think that better is:
	} else if (act->hw_stats != FLOW_ACTION_HW_STATS_DISABLED &&
		   act->hw_stats != FLOW_ACTION_HW_STATS_DONT_CARE) {

> 		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
> 		return -EOPNOTSUPP;
> 	}
