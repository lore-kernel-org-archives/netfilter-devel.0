From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables: parser conflict between tokens & symbols
Date: Mon, 29 Jun 2015 20:03:13 +0200
Message-ID: <20150629180313.GA22518@salvia>
References: <20150626124423.GB5835@bzorp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Balazs Scheidler <balazs.scheidler@balabit.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59794 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbbF2R6X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2015 13:58:23 -0400
Content-Disposition: inline
In-Reply-To: <20150626124423.GB5835@bzorp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 26, 2015 at 02:44:23PM +0200, Balazs Scheidler wrote:
> Hi,
> 
> I've noticed that our set of keywords in nftables is pretty rich and
> this can cause conflicts in the grammar when a keyword is also used
> as a symbol.
> 
> For instance, we do have a "redirect" expression and "redirect" as
> a word is also used as an ICMP message type.
> 
> # here is the redirect expression in action, which works:
> $ nft add rule tcp dport 80 redirect to 8080
> 
> # here's an ICMP rule that works
> $ nft add rule filter input icmp type echo-request accept
> 
> # here's an ICMP rule that should work, but it doesn't
> $ nft add rule filter input icmp type redirect accept
> 
> The root cause is that "redirect" is now recognized as a token, whereas the
> icmp type is expecting a STRING token.
> 
> I have tried to solve this but the idea I had didn't work out, and I don't
> really have more time now to fix it, but still thought this information
> would be useful.

The problem is known, the test infrastructure is catching this among
other existing problems. You can also file a bug to bugzilla if this
doesn't exist already so we can track this.
