From: Florian Westphal <fw@strlen.de>
Subject: Re: [ANNOUNCE] iptables 1.4.21 release
Date: Sat, 23 Nov 2013 23:57:23 +0100
Message-ID: <20131123225723.GB14401@breakpoint.cc>
References: <20131122121232.GA5698@localhost>
 <528FAAA6.2010607@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51393 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755935Ab3KWW51 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Nov 2013 17:57:27 -0500
Content-Disposition: inline
In-Reply-To: <528FAAA6.2010607@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gustavo Zacarias <gustavo@zacarias.com.ar> wrote:
> > The Netfilter project proudly presents:
> > 
> >         iptables 1.4.21
> 
> Commit 76e230e41947576efb96e86e605bb84015cdb287 was never merged into
> master so static builds are still broken for this release :-(

I am very sorry about this, i've merged stable-1.4.20 to master to fetch
this commit.
