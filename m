From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nftables PATCH] rule: display rule handle as comment
Date: Wed, 22 May 2013 17:35:41 +0200
Message-ID: <20130522153538.GD8434@macbook.localnet>
References: <1369091340-29211-1-git-send-email-eric@regit.org>
 <Pine.LNX.4.64.1305221512110.26402@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>,
	Jesper Brouer <brouer@redhat.com>
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45129 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab3EVPfr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 May 2013 11:35:47 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1305221512110.26402@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 22, 2013 at 03:53:26PM +0200, Jesper Dangaard Brouer wrote:
> 
> On Tue, 21 May 2013, Eric Leblond wrote:
> 
> >Knowing the rule handle is necessary to be able to delete a single
> >rule. It was not displayed till now in the output and it was thus
> >impossible to remove a single rule.
> 
> The current iptables system supports deleting a specific rule by
> simply specifying iptables -D [...] instead of equivilant iptables
> -A [...]
> 
> Would it be possible to keep this semantics in nftables?

Yes, I wanted to add that feature myself. Implementation would be similar
to what we do in iptables, IOW we'd compare either the netlink commands
constructed from the rule specification or the internal expression
representation, whatever seems better suited.
