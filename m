From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: bridge: reduce nf_bridge_info to 32
 bytes again
Date: Thu, 30 Jul 2015 13:56:27 +0200
Message-ID: <20150730115627.GA7066@salvia>
References: <1437661290-28802-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54312 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbbG3Lue (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jul 2015 07:50:34 -0400
Content-Disposition: inline
In-Reply-To: <1437661290-28802-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 23, 2015 at 04:21:30PM +0200, Florian Westphal wrote:
> We can use union for most of the temporary cruft (original ipv4/ipv6
> address, source mac, physoutdev) since they're used during different
> stages of br netfilter traversal.
> 
> Also get rid of the last two ->mask users.
> 
> Shrinks struct from 48 to 32 on 64bit arch.

Applied, thanks.

