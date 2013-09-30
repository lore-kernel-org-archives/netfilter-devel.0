From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH net-next 1/1] sip: introduce nf_nat_sip_hooks
Date: Mon, 30 Sep 2013 15:03:09 +0100
Message-ID: <20130930140309.GA28301@macbook.localnet>
References: <20130930135150.440707982@eitzenberger.org>
 <20130930135559.077109518@eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38692 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab3I3ODS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:03:18 -0400
Content-Disposition: inline
In-Reply-To: <20130930135559.077109518@eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 30, 2013 at 03:51:51PM +0200, Holger Eitzenberger wrote:
> There are currently seven different NAT hooks used in both
> nf_conntrack_sip and nf_nat_sip, each of the hooks is exported in
> nf_conntrack_sip, then set from the nf_nat_sip NAT helper.

Thanks Holger, I wanted to do the same for a long time now. It actually
also fixes a minor race condition, when the NAT helper is loaded or
unloaded while a packet is processed the hooks may be invoked only
partially.

Just one request:

> +struct nf_nat_sip_hooks {
> +	unsigned int (* nsh_msg)(struct sk_buff *skb,
> +				 unsigned int protoff,
> +				 unsigned int dataoff,
> +				 const char **dptr,
> +				 unsigned int *datalen);

I really hate unpronouncable abbrevations, it hurts my eyes and IMO makes
it harder to read the code. Please use something nicer or get rid of the
prefix entirely.

Thanks!
