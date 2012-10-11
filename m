From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Netfilter/IPVS updates for stable 3.4 onwards
Date: Thu, 11 Oct 2012 15:09:14 -0400 (EDT)
Message-ID: <20121011.150914.2287282974329140985.davem@davemloft.net>
References: <1349950054-12353-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: stable@kernel.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:38694 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901Ab2JKTJQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2012 15:09:16 -0400
In-Reply-To: <1349950054-12353-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: pablo@netfilter.org
Date: Thu, 11 Oct 2012 12:07:31 +0200

> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Hi!
> 
> The following patchset contain fixes for stable 3.4 onwards.
> 
> The selected three patches are:
> 
> 283283c ipvs: fix oops in ip_vs_dst_event on rmmod
> 66b6aaf netfilter: nf_conntrack: fix racy timer handling with reliable events
> a73f89a netfilter: ipset: timeout fixing bug broke SET target special timeout value [REQUIRES 127f559 netfilter: ipset: fix timeout value overflow bug]
> 
> Please, cherry-pick them. Thanks!

Acked-by: David S. Miller <davem@davemloft.net>
