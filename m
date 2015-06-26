From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 nf] netfilter: nft_queue: restrict queueing to
 supported families
Date: Fri, 26 Jun 2015 10:36:53 +0200
Message-ID: <20150626083653.GA15225@salvia>
References: <1435305700-8768-1-git-send-email-pablo@netfilter.org>
 <20150626080201.GA10981@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55519 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbbFZIb2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 04:31:28 -0400
Content-Disposition: inline
In-Reply-To: <20150626080201.GA10981@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 26, 2015 at 10:02:01AM +0200, Patrick McHardy wrote:
> On 26.06, Pablo Neira Ayuso wrote:
> > We only support IPv4 and IPv6 at this moment.
> 
> That's not a restriction but just a module alias. If the module is
> already loaded it will still be usable for any family.
> 
> Packets will of course simply get dropped by nf_queue(). If we
> really want to restrict this, we'd also have to restrict queueing
> verdict codes for other families.

I was trying to provide a simple way to avoid that users get this
loaded into their ruleset meanwhile.
