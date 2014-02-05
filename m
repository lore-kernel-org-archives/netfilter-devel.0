From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netfilter: REJECT: separate reusable code
Date: Wed, 5 Feb 2014 11:42:47 +0100
Message-ID: <20140205104247.GA4458@localhost>
References: <20140205102547.GA20930@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42378 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaBEKmx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:42:53 -0500
Content-Disposition: inline
In-Reply-To: <20140205102547.GA20930@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 05, 2014 at 10:25:48AM +0000, Patrick McHardy wrote:
> Just noticed commit cc70d069 (netfilter: REJECT: separate reusable code).
> That doesn't look like a good idea to me at all.
> 
> First of all, it introduces static non-inline functions into a header file,
> which is obviously wrong. But more importantly, it adds a symbol dependency
> of the reject module on IPv6. We've tried hard to get rid of all these in
> x_tables, lets please not re-add them in nftables.

Well, I think this is working at this moment, we can improve it of
course.

> I think we should instead use AF-specific modules for things like that.
> We share basically no code except the boiler plate. I'd suggest to add
> an AF-specific expression type lookup mechanism that takes precedence
> over generic types.

Yes, this looks like the way to go to me.

How do you plan to handle this with the inet table? We don't have
family context there.
