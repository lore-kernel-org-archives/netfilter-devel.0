From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Merging iptables-nftables into iptables
Date: Tue, 31 Dec 2013 00:07:31 +0100
Message-ID: <20131230230731.GA4849@localhost>
References: <20131204114834.GA13280@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36002 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab3L3XHg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Dec 2013 18:07:36 -0500
Content-Disposition: inline
In-Reply-To: <20131204114834.GA13280@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 04, 2013 at 12:48:34PM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> The iptables-nftables tree [1] currently stores the iptables over
> nftables compatibility support. This allows you to run iptables
> commands using the nftables kernel infrastructure.
> 
> JFYI, my plan is to merge the iptables-nftables into iptables at some
> point of this week given that it contains stuff that is scheduled for
> 3.13.  After that merge, the iptables-nftables will be disabled.

With some delay, I found some time to rebase iptables-nftables upon
the current head and to push into the iptables.git's nft-compat branch [1].
I plan to give it another review tomorrow to see if I left something
behind in the rebase, if no troubles I'll merge it into master.

[1] http://git.netfilter.org/iptables/log/?h=nft-compat
