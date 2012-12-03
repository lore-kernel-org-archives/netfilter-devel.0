From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Handle routing changes in MASQUERADE target, v4
Date: Mon, 3 Dec 2012 19:28:05 +0100
Message-ID: <20121203182805.GA22736@1984>
References: <alpine.DEB.2.00.1211302149050.16257@blackhole.kfki.hu>
 <alpine.DEB.2.00.1211302336170.16789@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43944 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab2LCS2M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:28:12 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211302336170.16789@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 30, 2012 at 11:37:26PM +0100, Jozsef Kadlecsik wrote:
> When the route changes (backup default route, VPNs) which affect a
> masqueraded target, the packets were sent out with the outdated source
> address. The patch addresses the issue by comparing the outgoing interface
> directly with the masqueraded interface in the nat table.
> 
> Events are inefficient in this case, because it'd require adding route
> events to the network core and then scanning the whole conntrack table
> and re-checking the route for all entry.

Applied, thanks.
