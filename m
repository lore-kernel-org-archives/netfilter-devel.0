From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables: parser conflict between tokens & symbols
Date: Mon, 29 Jun 2015 16:57:25 +0200
Message-ID: <20150629145725.GD2324@breakpoint.cc>
References: <20150626124423.GB5835@bzorp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Balazs Scheidler <balazs.scheidler@balabit.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47724 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014AbbF2O51 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2015 10:57:27 -0400
Content-Disposition: inline
In-Reply-To: <20150626124423.GB5835@bzorp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Balazs Scheidler <balazs.scheidler@balabit.com> wrote:
> I've noticed that our set of keywords in nftables is pretty rich and
> this can cause conflicts in the grammar when a keyword is also used
> as a symbol.
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

While we're at it, there are other issues, f.e.:

ct label saddr
ct label == saddr

won't work since saddr is considered to be the SADDR token.
Similar issues for other places where we accept arbitrary symbol names.

I think the above might be fixable via

|       CT      ct_key  error
{
	yychar = STRING;
...

But of course that won't fix up all cases, e.g.
ct label == saddr would still not work since we encounter
the error (unexpected token) after a relational expression.

Does anyone have better ideas other than plastering parser with error
handlers...?
