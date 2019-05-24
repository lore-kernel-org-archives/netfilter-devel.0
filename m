Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829A9C282E1
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 21:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 605CB206BA
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 21:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404250AbfEXVdf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 17:33:35 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:36591 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404234AbfEXVdf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 17:33:35 -0400
Received: from [31.4.219.201] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hUHoh-0000eR-Ui; Fri, 24 May 2019 23:33:33 +0200
Date:   Fri, 24 May 2019 23:33:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: kill anon sets with one element
Message-ID: <20190524213330.xfa2xj2gjdxusico@salvia>
References: <20190519171838.3811-1-fw@strlen.de>
 <20190524192146.phnh4cqwelnpxdrp@salvia>
 <20190524210634.64txxzs2kivhlwre@breakpoint.cc>
 <20190524212506.vkpqe74fjojq7e6c@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524212506.vkpqe74fjojq7e6c@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 24, 2019 at 11:25:06PM +0200, Pablo Neira Ayuso wrote:
[...]
> We can add a new parameter to optimize rulesets, we can start with
> something simple, ie.
> 
> * collapse consecutive several rules that come with the same
>   selectors, only values change.
> 
> * turn { 22 } into 22.
> 
> * turn ct state {new, established } into ct new,established.

This new optimization option would work both for "nft add rule" and
"nft -f", and we can also include a mode that just prints the
optimization, similar to iptables-translate. So users can diff their
rulesets before and after.
