From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: bridge: neigh_head and physoutdev can't
 be used at same time
Date: Thu, 14 May 2015 12:52:26 +0200
Message-ID: <20150514105226.GA4832@salvia>
References: <1430683528-29050-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35743 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627AbbENKrr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 May 2015 06:47:47 -0400
Content-Disposition: inline
In-Reply-To: <1430683528-29050-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 03, 2015 at 10:05:28PM +0200, Florian Westphal wrote:
> The neigh_header is only needed when we detect DNAT after prerouting
> and neigh cache didn't have a mac address for us.
> 
> The output port has not been chosen yet so we can re-use the storage
> area, bringing struct size down to 32 bytes on x86_64.

Applied, thanks for your patience.

