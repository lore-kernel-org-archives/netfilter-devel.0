From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables with ipset combined types
Date: Wed, 29 Jan 2014 10:30:11 +0100
Message-ID: <20140129093010.GA4332@localhost>
References: <52E8AD76.5050808@aim.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Brian Allen Vanderburg II <brianvanderburg2@aim.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33682 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaA2Jaa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:30:30 -0500
Content-Disposition: inline
In-Reply-To: <52E8AD76.5050808@aim.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 29, 2014 at 02:27:50AM -0500, Brian Allen Vanderburg II wrote:
> I use ipset for my setup to simplify certain iptables rules. I have
> rules to allow trusted networks and trusted services using two different
> sets.  The services set is a hash:net,port set, and the network set its
> a hash:net,iface set.  Is it planned to have sets that can contain
> multiple value entries in nftables?

Yes, some bits are missing in the kernel, we'll have support for
multi-dimensional keys in sets at some point.
