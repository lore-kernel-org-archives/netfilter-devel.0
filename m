From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables branch management
Date: Mon, 5 Sep 2011 19:54:25 +0200
Message-ID: <20110905175425.GC32733@1984>
References: <alpine.LNX.2.01.1109021604260.4532@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55026 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab1IERy3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:54:29 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1109021604260.4532@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Fri, Sep 02, 2011 at 04:20:13PM +0200, Jan Engelhardt wrote:
> Hei
> 
> I would like to propose a "stable" branch that would be rooted 
> in the most recent tag and only receive fixes. Furtheremore, 
> the branch is merged time and again into master, so that the 
> fix is available in both without cherry-pick. 1.4.12.x releases be made 
> from stable, and 1.4.y from master.
> How about it?

Hm, I remember that we had this discussion before.

I think it's probably too much overhead for it, looking at how other
similar net-tools are maintained, the amount of contributions that
er receive and amount of changes that get into every version.
