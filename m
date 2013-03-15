From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Unable to get NPTv6 to work with kernel 3.8.2
Date: Fri, 15 Mar 2013 13:02:06 +0100
Message-ID: <20130315120206.GA9625@localhost>
References: <513DE42B.5070702@universe-factory.net>
 <20130312061101.GB7938@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthias Schiffer <mschiffer@universe-factory.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38282 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab3COMCM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:02:12 -0400
Content-Disposition: inline
In-Reply-To: <20130312061101.GB7938@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 12, 2013 at 07:11:01AM +0100, Florian Westphal wrote:
> Matthias Schiffer <mschiffer@universe-factory.net> wrote:
> > ip6tables -t nat -A OUTPUT -d fd00:0:0:3::/64 -j DNPT --src-pfx
> > fd00:0:0:3::/64 --dst-pfx fd00:0:0:1::/64
> [..]
> 
> This won't work, DNPT is stateless, the nat table is only consulted
> for the first packet of a connection.
> 
> Use mangle instead, this should also take care of possible new
> route due to changed dst address.
> 
> Any objections wrt. restricting NPT to mangle?

No. People are getting confused with this, so let's get this into the
nf tree to hit mainstream as soon as possible.

Applied, thanks Florian.
