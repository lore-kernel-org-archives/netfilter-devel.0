From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: RFC: Probably wrong code in nf_nat_snmp_basic.c
Date: Fri, 18 Nov 2011 09:43:29 +0100
Message-ID: <201111180943.29443.thomas.jarosch@intra2net.com>
References: <4EC5791A.1040005@intra2net.com> <20111118003429.GA30271@1984>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, James Morris <jmorris@namei.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:51997 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab1KRInb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Nov 2011 03:43:31 -0500
In-Reply-To: <20111118003429.GA30271@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday, 18. November 2011 01:34:29 Pablo Neira Ayuso wrote:
> > if (dir == IP_CT_DIR_ORIGINAL) {
> > 
> >     /* SNAT traps */
> >     map.from = NOCT1(&ct->tuplehash[dir].tuple.src.u3.ip);
> >     map.to = NOCT1(&ct->tuplehash[!dir].tuple.dst.u3.ip);
> > 
> > } else {
> > 
> >     /* DNAT replies */
> >     map.from = NOCT1(&ct->tuplehash[dir].tuple.src.u3.ip);
> >     map.to = NOCT1(&ct->tuplehash[!dir].tuple.dst.u3.ip);
> > 
> > }
> > ---------------------------------------------
> > 
> > cppcheck reported: (style) Found duplicate branches for if and else.
> > 
> > 
> > Either I need glasses or the code is exactly the same :)
> 
> Indeed. I'll be happy to take a patch for this. If you don't make it
> in the following days, no problem, I'll take of this myself. Thanks
> for the report.

The if() statement is probably in there for a reason. I'm not familiar with 
the internal details of the ct stuff, perhaps map.from/map.to
should be swapped or something like that.

James, any idea what's going on?

Cheers,
Thomas
