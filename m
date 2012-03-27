From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH] netfilter: bridge: change indev name to vlan if
 vlan tag present
Date: Tue, 27 Mar 2012 17:37:35 +0200
Message-ID: <20120327153735.GA18821@1984>
References: <20120326202124.GA15638@Chamillionaire.breakpoint.cc>
 <20120326202326.GB15638@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48419 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab2C0Phh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:37:37 -0400
Content-Disposition: inline
In-Reply-To: <20120326202326.GB15638@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 26, 2012 at 10:23:26PM +0200, Florian Westphal wrote:
> If net.bridge.bridge-nf-filter-vlan-tagged is on, bridge
> netfilter will remove skbs vlan header, then feeds the packet
> to ip(6)tables.
> 
> This changes the in/out interface to the vlan interface; if such
> an interface has been configured, to allow iptables rules to
> determine the original vlan the packet arrived on (e.g.
> -i br0.1 will now work if a br0.1 vlan exists on top of br0 bridge
> interface).

Bart, can you see any problem with this approach?
