From: Simon Horman <horms@verge.net.au>
Subject: Re: [bug?] netfilter/ipvs : suspected race bugs related to atomic
	operations
Date: Fri, 14 Aug 2009 08:43:18 +1000
Message-ID: <20090813224316.GF3873@verge.net.au>
References: <2014bcab0908120743w2d96c359t818729b64c9da62b@mail.gmail.com> <4A8418BB.4060100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?7ZmN7Iug?= shin hong <hongshin@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Wensong Zhang <wensong@linux-vs.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:54290 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZHMWnT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2009 18:43:19 -0400
Content-Disposition: inline
In-Reply-To: <4A8418BB.4060100@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 13, 2009 at 03:44:27PM +0200, Patrick McHardy wrote:
> =ED=99=8D=EC=8B=A0 shin hong wrote:
> > Hi. I am reporting two suspected race bug related to atomic operati=
ons
> > while I read net/netfilter/ipvs of Linux 2.6.30.4.
> >=20
> > (1) In net/netfilter/ipvs/ip_vs_core.c, ip_vs_in() first increments=
 &cp->in_pkts
> >      and then reads variable for condition checking at line 1346-13=
51.
> >=20
> >      However, these two atomic operations may not be executed atomi=
cally.
> >      For this reason, it may result race with other concurrent exec=
utions
> >      which manipulates &cp->in_pkts.
> >=20
> > (2) In net/netfilter/ipvs/ip_vs_wrr.c, ip_vs_wrr_max_weight() first
> > checks &dest->weight
> >      and then reads the variable again to assign its value to a loc=
al variable.
> >      For the similar reason above, it seems that two atomic_read() =
operations
> >      may result different values so that it may result race conditi=
on.
> >=20
> > Please examine the code and let me know your opinion. Thanks.
>=20
> I'm not sure whether the IPVS guys are following the netfilter-devel
> list, so I've CCed Wensong and Simon.

Hi,

my feeling is that with both of these is that while there are certainly
correctness problems they shouldn't manifest in anything terribly bad
happening. In both cases I feel that we are essentially dealing with
inputs to a heuristic, and thus some noise in the input really
ought not make much difference in the long run, although and individual=
 packet
or connection may be miss-classified.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
