Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB59EC433EB
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Mar 2021 14:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3D7461A2B
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Mar 2021 14:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhCZOfu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Mar 2021 10:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhCZOf2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Mar 2021 10:35:28 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A115C0613AA
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Mar 2021 07:35:28 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lPnYb-0000C3-06; Fri, 26 Mar 2021 15:35:25 +0100
Date:   Fri, 26 Mar 2021 15:35:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/8] netfilter: merge nf_log_proto modules
Message-ID: <20210326143524.GB26422@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20210325172512.17729-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325172512.17729-1-fw@strlen.de>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Mar 25, 2021 at 06:25:04PM +0100, Florian Westphal wrote:
[...]
> Last patch allows to move log backend module load
> to nft_log to avoid a deadlock that can occur when request_module()
> is called with the nft transaction mutex held.

With this series applied, my reproducer doesn't lock up anymore. In
addition to that, neither iptables nor nftables testsuites seem unhappy
with the change. Hence:

Tested-by: Phil Sutter <phil@nwl.cc>

Thanks a lot,

Phil
