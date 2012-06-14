From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] netfilter: xt_TEE:  IPv4 Don't Fragmet options
Date: Thu, 14 Jun 2012 20:59:40 +0200
Message-ID: <20120614185940.GA10978@1984>
References: <rvd97lb.cb16bfe930b2100854041c0a3d714500@obelix.schillstrom.com>
 <20120614175223.GA10633@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Hans Schillstrom <hans@schillstrom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48024 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab2FNS7s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:59:48 -0400
Content-Disposition: inline
In-Reply-To: <20120614175223.GA10633@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 14, 2012 at 07:52:23PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 14, 2012 at 08:17:35AM +0200, Hans Schillstrom wrote:
> > Hello,
> > 
> > I  think it is wrong to always force the DF bit in IPv4, it's better
> > to have an option If an application don't set the DF bit, usually it
> > doesn't expect to get an icmp back either.  The result is that the
> > packet will be dropped...

I don't understand what effect you're observing to propose this
change. Could you clarify this?
