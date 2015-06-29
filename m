From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables: parser conflict between tokens & symbols
Date: Mon, 29 Jun 2015 20:09:29 +0200
Message-ID: <20150629180929.GA22616@salvia>
References: <20150626124423.GB5835@bzorp>
 <20150629145725.GD2324@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Balazs Scheidler <balazs.scheidler@balabit.com>,
	netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32969 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbbF2SEA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2015 14:04:00 -0400
Content-Disposition: inline
In-Reply-To: <20150629145725.GD2324@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 29, 2015 at 04:57:25PM +0200, Florian Westphal wrote:
> While we're at it, there are other issues, f.e.:
> 
> ct label saddr
> ct label == saddr
> 
> won't work since saddr is considered to be the SADDR token.

I don't think we're searching for such a flexibility in the grammar at
this stage.
