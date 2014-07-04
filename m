From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [linux PATCH v3 2/5] netfilter: nf_nat_masquerade_ipv4: code
 factorization
Date: Fri, 4 Jul 2014 12:41:44 +0200
Message-ID: <20140704104144.GA6296@localhost>
References: <20140701162801.2847.14389.stgit@nfdev.cica.es>
 <20140701163034.2847.53931.stgit@nfdev.cica.es>
 <698ea380-0754-47de-a4a1-9023ebf8388c@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58874 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737AbaGDKlt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:41:49 -0400
Content-Disposition: inline
In-Reply-To: <698ea380-0754-47de-a4a1-9023ebf8388c@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Thu, Jul 03, 2014 at 02:23:20PM +0200, Patrick McHardy wrote:
> On 1. Juli 2014 18:30:54 MESZ, Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
> >Let's refactor the code so we can reach the masquerade functionality
> >from
> >outside the xt context (ie, nftables).
> >
> >The patch includes adding an atomic counter to the masquerade notifier:
> >the
> >stuff to be done by the notifier is the same in any case, and agnostic
> >about who called it. Only one notification handler is needed.
> >
> >This factorization only involves IPv4; a similar patch will follow to
> >handle
> >IPv6.
> 
> Just a suggestion, the NAT support is parameterizable at  runtime.
> An alternative would be an expression to load the local address.

That seems quite natural way to make it without requiring kernel
changes, I like it. The only problem that I see is that I don't come
up with a way to handle the conntrack cleanup case that needs to
happen if the interface is brought down with this approach.
