From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: RFC: Probably wrong code in nf_nat_snmp_basic.c
Date: Fri, 18 Nov 2011 01:34:29 +0100
Message-ID: <20111118003429.GA30271@1984>
References: <4EC5791A.1040005@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44374 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab1KRAei (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Nov 2011 19:34:38 -0500
Content-Disposition: inline
In-Reply-To: <4EC5791A.1040005@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 17, 2011 at 10:14:02PM +0100, Thomas Jarosch wrote:
> Hi,
> 
> consider this piece of code from
> net/ipv4/netfilter/nf_nat_snmp_basic.c:1198
> 
> ---------------------------------------------
> /*
>     * Determine mappping for application layer addresses based
>     * on NAT manipulations for the packet.
>     */
> if (dir == IP_CT_DIR_ORIGINAL) {
>     /* SNAT traps */
>     map.from = NOCT1(&ct->tuplehash[dir].tuple.src.u3.ip);
>     map.to = NOCT1(&ct->tuplehash[!dir].tuple.dst.u3.ip);
> } else {
>     /* DNAT replies */
>     map.from = NOCT1(&ct->tuplehash[dir].tuple.src.u3.ip);
>     map.to = NOCT1(&ct->tuplehash[!dir].tuple.dst.u3.ip);
> }
> ---------------------------------------------
> 
> cppcheck reported: (style) Found duplicate branches for if and else.
> 
> 
> Either I need glasses or the code is exactly the same :)

Indeed. I'll be happy to take a patch for this. If you don't make it
in the following days, no problem, I'll take of this myself. Thanks
for the report.
