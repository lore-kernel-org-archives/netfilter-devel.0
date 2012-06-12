From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Having expectations live past the master connection's lifetime
Date: Tue, 12 Jun 2012 19:56:56 +0200
Message-ID: <20120612175656.GA32542@1984>
References: <CAK2bC5qkHXMzSQg6v6DNb0ou7KWj+sTXibyLv=53zxe236M9pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kelvie Wong <kelvie@ieee.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52125 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab2FLR47 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:56:59 -0400
Content-Disposition: inline
In-Reply-To: <CAK2bC5qkHXMzSQg6v6DNb0ou7KWj+sTXibyLv=53zxe236M9pw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 07, 2012 at 10:34:13AM -0700, Kelvie Wong wrote:
> Hello all,
> 
> I have noticed that expectations seem to get deleted as soon as their
> master connection finishes their TIME_WAIT. Is there any way to have
> expectations outlive their masters?

Not yet.

> I need to have a dynamic port open (for DCERPC), and the initial
> connection to the endpoint mapper is typically short-lived.
> 
> The way I was going to do this was to just add a rule with iptables
> using a userspace helper; is there a better way to do this?

We can skip removing these expectations by setting some flag in the
expectation. Still, we'll have to insert those expectations in some
list so we make sure that they are removed on module removal.

Another problem is that I cannot take that kernel patch if there's no
publicitly available Netfilter code using it.
