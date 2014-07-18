From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [GIT PULL nf] Second Round of IPVS Fixes for v3.16
Date: Fri, 18 Jul 2014 12:24:17 +0200
Message-ID: <20140718102417.GA4209@salvia>
References: <1405472168-25192-1-git-send-email-horms@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Wensong Zhang <wensong@linux-vs.org>,
	Julian Anastasov <ja@ssi.bg>
To: Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33461 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760968AbaGRKYQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:24:16 -0400
Content-Disposition: inline
In-Reply-To: <1405472168-25192-1-git-send-email-horms@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 16, 2014 at 09:56:07AM +0900, Simon Horman wrote:
> Hi Pablo,
> 
> Please consider this IPVS fix for v3.16.
> 
> It resolves a problem that was introduced in v3.0.
> 
> I would like this fix considered for -stable and I have checked that it
> applies cleanly on top of v3.15.5, v3.14.12, v3.12.24, v3.10.48,
> v3.4.98 and v3.2.61.

Pulled and enqueue to -stable, thanks.
