From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 0/2] IPv6 conntrack support for neighbour discovery
Date: Tue, 27 Jan 2009 19:09:38 +0900 (JST)
Message-ID: <200901271009.n0RA9dqv000882@toshiba.co.jp>
References: <1232707890.32071.41.camel@khasse.inl.fr>
	<200901231110.n0NBAR7Z000645@toshiba.co.jp>
	<497DB689.3020109@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, eric@inl.fr,
	Marek.Szuba@if.pw.edu.pl, netfilter-devel@vger.kernel.org,
	vstinner@inl.fr, pablo@netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx12.toshiba.co.jp ([61.202.160.132]:36125 "EHLO
	imx12.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZA0KJm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jan 2009 05:09:42 -0500
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by imx12.toshiba.co.jp  with ESMTP id n0RA9eWL008089
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2009 19:09:40 +0900 (JST)
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id n0RA9ePA010231
	for netfilter-devel@vger.kernel.org; Tue, 27 Jan 2009 19:09:40 +0900 (JST)
Received: from mx.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id n0RA9d9U008335
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2009 19:09:40 +0900 (JST)
In-Reply-To: <497DB689.3020109@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


From: Patrick McHardy <kaber@trash.net>
Date: Mon, 26 Jan 2009 14:11:37 +0100

> Yasuyuki KOZAKAI wrote:
> > From: Eric Leblond <eric@inl.fr>
> > Date: Fri, 23 Jan 2009 11:51:30 +0100
> > 
> >>> I prefer 'NEW' rather than 'UNTRACKED' as other protocols which
> >>> validation is unclear. So another solution is to let the connection
> >>> tracking subsystem to create a new conntrack and to make
> >>> nf_contrack_proto_icmpv6 assign 0 as timeout. How do you think ?
> >> If we do that, we can have nfnetlink messages (NEW, DESTROY) send to
> >> userspace. Personnaly, I don't think they are necessary. But there is an
> >> other issue: as we can't invert the tuple, the information provided to
> >> userspace will be false.
> >>
> >> Once we agree on this last point, I will send a reworked patchset (with
> >> at least the removal of sysctl stuff).
> > 
> > Thank you. I understand why ICMPv6 packets are special here and
> > I agree to assign UNTRACKED to them. Indeed non-invertible tuple might
> > bring issues.
> 
> How about adding a flag to indicate that only one direction of
> the tuple exists? It makes sense to support this for other kinds
> of simplex flows as well in my opinion and it somewhat goes in the
> same direction as the patch I talked about during the workshop
> to have only a single tuple within the conntrack and have reply
> tuples or potentially other tuples that relate to a connection
> within the ct_extend area. And using NEW and having netlink
> events seems more consistent to me.

It sounds good for long term solution. For now Eric's patch is enough,
I think.

And sorry, I don't remember your patch in detail since maybe nftables talk
was impressive to me ;) but it sounds that it will make easier to implement
a module to track protocols using broadcast. 

-- Yasuyuki Kozakai
