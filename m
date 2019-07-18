Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5632DC76195
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 19:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C488208C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 19:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfGRTjl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 15:39:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54732 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbfGRTjl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 15:39:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 75B9515280425;
        Thu, 18 Jul 2019 12:39:40 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:39:39 -0700 (PDT)
Message-Id: <20190718.123939.886909513952061536.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        jiri@resnulli.us, jakub.kicinski@netronome.com, pshelar@ovn.org
Subject: Re: [PATCH net,v4 0/4] flow_offload fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190718175931.13529-1-pablo@netfilter.org>
References: <20190718175931.13529-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 12:39:40 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 18 Jul 2019 19:59:27 +0200

> The following patchset contains fixes for the flow_offload infrastructure:
> 
> 1) Fix possible build breakage before patch 3/4. Both the flow_offload
>    infrastructure and OVS define the flow_stats structure. Patch 3/4 in
>    this batch indirectly pulls in the flow_stats definition from
>    include/net/flow_offload.h into OVS, leading to structure redefinition
>    compile-time errors.
> 
> 2) Remove netns parameter from flow_block_cb_alloc(), this is not
>    required as Jiri suggests. The flow_block_cb_is_busy() function uses
>    the per-driver block list to check for used blocks which was the
>    original intention for this parameter.
> 
> 3) Rename tc_setup_cb_t to flow_setup_cb_t. This callback is not
>    exclusive of tc anymore, this might confuse the reader as Jiri
>    suggests, fix this semantic inconsistency.
> 
> 4) Fix block sharing feature: Add flow_block structure and use it,
>    update flow_block_cb_lookup() to use this flow_block object.
> 
> Please, apply, thanks.

Series applied, thank you.
