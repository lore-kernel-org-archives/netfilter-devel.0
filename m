Return-Path: <SRS0=DUCC=6V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6063FC54E49
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 May 2020 03:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4147C20838
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 May 2020 03:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgEGDOR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 23:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727967AbgEGDOR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 23:14:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D91C061A0F;
        Wed,  6 May 2020 20:14:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 592F1120477C4;
        Wed,  6 May 2020 20:14:16 -0700 (PDT)
Date:   Wed, 06 May 2020 20:14:15 -0700 (PDT)
Message-Id: <20200506.201415.143642826953424088.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        jiri@resnulli.us, kuba@kernel.org, ecree@solarflare.com
Subject: Re: [PATCH net,v4] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506183450.4125-1-pablo@netfilter.org>
References: <20200506183450.4125-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 20:14:16 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed,  6 May 2020 20:34:50 +0200

> This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
> that the frontend does not need counters, this hw stats type request
> never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly requests
> the driver to disable the stats, however, if the driver cannot disable
> counters, it bails out.
> 
> TCA_ACT_HW_STATS_* maintains the 1:1 mapping with FLOW_ACTION_HW_STATS_*
> except by disabled which is mapped to FLOW_ACTION_HW_STATS_DISABLED
> (this is 0 in tc). Add tc_act_hw_stats() to perform the mapping between
> TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*.
> 
> Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v4: Update mlxsw as Jiri prefers.

Applied, thank you.
