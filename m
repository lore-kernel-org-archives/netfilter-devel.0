From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Re: [PATCH nf-next 2/3] netfilter: nf_tables: fix a endless jump
 loop when use vmap
Date: Wed, 15 Jun 2016 11:40:44 +0200
Message-ID: <20160615094044.GC2533@salvia>
References: <1465618828-22162-1-git-send-email-zlpnobody@163.com>
 <1465618828-22162-3-git-send-email-zlpnobody@163.com>
 <20160613181902.GA2699@salvia>
 <6baeab0c.14c4e.1554ecf5f06.Coremail.zlpnobody@163.com>
 <20160614153851.GA4582@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54550 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbcFOJkv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2016 05:40:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BFB61100797
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:40:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A2EBD9EBB0
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:40:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F32EAC21A2
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:40:45 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160614153851.GA4582@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 14, 2016 at 05:38:51PM +0200, Pablo Neira Ayuso wrote:
> From e067bde1535ca78d9c8fea9f49f86c0731274732 Mon Sep 17 00:00:00 2001
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Sat, 11 Jun 2016 12:20:27 +0800
> Subject: [PATCH] netfilter: nf_tables: reject loops from set element jump to
>  chain
> 
> Liping Zhang says:
> 
> "Users may add such a wrong nft rules successfully, which will cause an
> endless jump loop:
> 
>   # nft add rule filter test tcp dport vmap {1: jump test}
> 
> This is because before we commit, the element in the current anonymous
> set is inactive, so osp->walk will skip this element and miss the
> validate check."
> 
> To resolve this problem, this patch passes the generation mask to the
> walk function through the iter container structure depending on the code
> path:
> 
> 1) If we're dumping the elements, then we have to check if the element
>    is active in the current generation. Thus, we check for the current
>    bit in the genmask.
> 
> 2) If we're checking for loops, then we have to check if the element is
>    active in the next generation, as we're in the middle of a
>    transaction. Thus, we check for the next bit in the genmask.
> 
> Based on original patch from Liping Zhang.
> 
> Reported-by: Liping Zhang <liping.zhang@spreadtrum.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Tested-by: Liping Zhang <liping.zhang@spreadtrum.com>
> ---
> v2: Simplify previous patch through using ctx->net instead of set_pnet().

I have applied this to nf.
