From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables-dev Source Example
Date: Mon, 8 Oct 2012 17:22:37 +0200
Message-ID: <20121008152237.GA8350@1984>
References: <5072D6F8.2010707@iit.demokritos.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Katia Sarsempagieva <katias@iit.demokritos.gr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50873 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab2JHPWl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:22:41 -0400
Content-Disposition: inline
In-Reply-To: <5072D6F8.2010707@iit.demokritos.gr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 08, 2012 at 04:36:56PM +0300, Katia Sarsempagieva wrote:
> Hello everyone!
> 
> I'm totally new to the iptables development sphere, so I would like
> to kindly request for a favor...
> 
> I have installed the iptables-dev package on my Debian Linux machine.
> What I want to do is to write my very own program using the iptables
> library to query the interface information
> of various machines (queues, lost packets, total packets etc).
> 
> But no matter how much I've tried to find a single tutorial or a
> source code sample (with the compiler command, of cource)
> I failed.
> So, can any of you please help me out? Maybe give me a tip on where
> to search or pass me a link to a tutorial page
> or anything that could contain a program sample and compilation
> instructions..?

I don't think you'll find much information. The library that iptables
provides is mostly internal. We know of people that has been tinkering
with it in their projects, but the API has not been stable along years
and it is not documented. I expect to solve this situation soon.

I'm afraid that the only reference you have is the source code by now.
Good luck.
