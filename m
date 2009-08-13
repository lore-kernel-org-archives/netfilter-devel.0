From: Simon Horman <horms@verge.net.au>
Subject: Re: [bug?] netfilter/ipvs : suspected race bugs related to atomic
	operations
Date: Fri, 14 Aug 2009 08:56:03 +1000
Message-ID: <20090813225603.GG3873@verge.net.au>
References: <2014bcab0908120743w2d96c359t818729b64c9da62b@mail.gmail.com> <4A8418BB.4060100@trash.net> <20090813224316.GF3873@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?7ZmN7Iug?= shin hong <hongshin@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Wensong Zhang <wensong@linux-vs.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:40402 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZHMW4E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2009 18:56:04 -0400
Content-Disposition: inline
In-Reply-To: <20090813224316.GF3873@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 14, 2009 at 08:43:18AM +1000, Simon Horman wrote:
> On Thu, Aug 13, 2009 at 03:44:27PM +0200, Patrick McHardy wrote:
> > =ED=99=8D=EC=8B=A0 shin hong wrote:
> > > Hi. I am reporting two suspected race bug related to atomic opera=
tions
> > > while I read net/netfilter/ipvs of Linux 2.6.30.4.
> > >=20
> > > (1) In net/netfilter/ipvs/ip_vs_core.c, ip_vs_in() first incremen=
ts &cp->in_pkts
> > >      and then reads variable for condition checking at line 1346-=
1351.
> > >=20
> > >      However, these two atomic operations may not be executed ato=
mically.
> > >      For this reason, it may result race with other concurrent ex=
ecutions
> > >      which manipulates &cp->in_pkts.
> > >=20
> > > (2) In net/netfilter/ipvs/ip_vs_wrr.c, ip_vs_wrr_max_weight() fir=
st
> > > checks &dest->weight
> > >      and then reads the variable again to assign its value to a l=
ocal variable.
> > >      For the similar reason above, it seems that two atomic_read(=
) operations
> > >      may result different values so that it may result race condi=
tion.
> > >=20
> > > Please examine the code and let me know your opinion. Thanks.
> >=20
> > I'm not sure whether the IPVS guys are following the netfilter-deve=
l
> > list, so I've CCed Wensong and Simon.
>=20
> Hi,
>=20
> my feeling is that with both of these is that while there are certain=
ly
> correctness problems they shouldn't manifest in anything terribly bad
> happening. In both cases I feel that we are essentially dealing with
> inputs to a heuristic, and thus some noise in the input really
> ought not make much difference in the long run, although and individu=
al packet
> or connection may be miss-classified.

However, having said that, it seems worthwhile to fix these problems.

[IPVS] Use atomic operations atomicly

A pointed out by Shin Hong, IPVS doesn't always use atomic operations
in an atomic manner. While this seems unlikely to be manifest in
strange behaviour, it seems appropriate to clean this up.

Cc: =ED=99=8D=EC=8B=A0 shin hong <hongshin@gmail.com>
Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/net/netfilter/ipvs/ip_vs_core.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/net/netfilter/ipvs/ip_vs_core.c	2009-08-14 08:31:48.=
000000000 +1000
+++ linux-2.6/net/netfilter/ipvs/ip_vs_core.c	2009-08-14 08:51:56.00000=
0000 +1000
@@ -1256,7 +1256,7 @@ ip_vs_in(unsigned int hooknum, struct sk
 	struct ip_vs_iphdr iph;
 	struct ip_vs_protocol *pp;
 	struct ip_vs_conn *cp;
-	int ret, restart, af;
+	int ret, restart, af, pkts;
=20
 	af =3D (skb->protocol =3D=3D htons(ETH_P_IP)) ? AF_INET : AF_INET6;
=20
@@ -1343,12 +1343,12 @@ ip_vs_in(unsigned int hooknum, struct sk
 	 * Sync connection if it is about to close to
 	 * encorage the standby servers to update the connections timeout
 	 */
-	atomic_inc(&cp->in_pkts);
+	pkts =3D atomic_add_return(1, &cp->in_pkts);
 	if (af =3D=3D AF_INET &&
 	    (ip_vs_sync_state & IP_VS_STATE_MASTER) &&
 	    (((cp->protocol !=3D IPPROTO_TCP ||
 	       cp->state =3D=3D IP_VS_TCP_S_ESTABLISHED) &&
-	      (atomic_read(&cp->in_pkts) % sysctl_ip_vs_sync_threshold[1]
+	      (pkts % sysctl_ip_vs_sync_threshold[1]
 	       =3D=3D sysctl_ip_vs_sync_threshold[0])) ||
 	     ((cp->protocol =3D=3D IPPROTO_TCP) && (cp->old_state !=3D cp->st=
ate) &&
 	      ((cp->state =3D=3D IP_VS_TCP_S_FIN_WAIT) ||
Index: linux-2.6/net/netfilter/ipvs/ip_vs_wrr.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/net/netfilter/ipvs/ip_vs_wrr.c	2009-08-14 08:31:48.0=
00000000 +1000
+++ linux-2.6/net/netfilter/ipvs/ip_vs_wrr.c	2009-08-14 08:31:50.000000=
000 +1000
@@ -74,11 +74,12 @@ static int ip_vs_wrr_gcd_weight(struct i
 static int ip_vs_wrr_max_weight(struct ip_vs_service *svc)
 {
 	struct ip_vs_dest *dest;
-	int weight =3D 0;
+	int new_weight, weight =3D 0;
=20
 	list_for_each_entry(dest, &svc->destinations, n_list) {
-		if (atomic_read(&dest->weight) > weight)
-			weight =3D atomic_read(&dest->weight);
+		new_weight =3D atomic_read(&dest->weight);
+		if (new_weight > weight)
+			weight =3D new_weight;
 	}
=20
 	return weight;
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
