From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables (nft-compat) PATCH 8/8] nft: Initialize according to
 requested table, if any
Date: Tue, 11 Feb 2014 15:44:10 +0100
Message-ID: <20140211144410.GA12972@localhost>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1392115608-6733-9-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20140211130701.GA24450@localhost>
 <52FA2791.3050009@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50751 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbaBKOoW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:44:22 -0500
Content-Disposition: inline
In-Reply-To: <52FA2791.3050009@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 11, 2014 at 03:37:21PM +0200, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> >Does it work the autochain load if you reload with rules in different
> >tables? eg. filter and raw.
> 
> Indeed, no... While chasing a bug (patch 7 is the result) I forgot
> to do this simple test.
> 
> I could overload struct builtin_table {} for that.
> But I just figured out another issue here, it will work if only we
> don't have /etc/xtables.conf file.

This is the way it should work with the file. That file provides a way
to enforce a chain configuration that will bypass the default chain
configuration.

> If you have such file, when xtables-restore will insert rules, it
> will always call nft_xtables_config_load() thus always trying to
> initialize tables that might be already there.

For xtables-restore, I think we should just initialize the chains once
when handling the ':' marker that we get from the standard input that
refers to the chain. With patch 7/8, we know if we're in the context
of a restore or not, thus you can use that to skip any sort of
chain initialization from the functions defined in nft.c.

> So there is a bigger fix here: I will add necessary stuff in handle
> to keep track of parsed file like tables and store which one has
> been initialized and not.

I think with the approach I'm describing above the patch should be
relatively small.
