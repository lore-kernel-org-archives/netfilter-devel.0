From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 4/4] netfilter: nft_meta: add explicitly
 nf_logger_find_get call
Date: Wed, 8 Jun 2016 14:59:32 +0200
Message-ID: <20160608125932.GA29699@breakpoint.cc>
References: <1465389800-27842-1-git-send-email-zlpnobody@163.com>
 <1465389800-27842-5-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59374 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbcFHM7z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 08:59:55 -0400
Content-Disposition: inline
In-Reply-To: <1465389800-27842-5-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Like xt_TRACE do, we should request related nf_log module appropriately.
> Otherwise, if the nf_log_ipv4 kernel module is not installed, and the
> user add the following nft rule:
>   # nft add rule filter input nftrace set 1
> 
> There will be no trace log generated until we install nf_log_ipv4 module
> manually.

With nftables we have a new infrastructure in place that emits trace info via
nfnetlink.

So loading nf_log_ipX isn't needed anymore in nft.
