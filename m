From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: promiscuous mode
Date: Mon, 06 Jun 2005 12:08:52 +0200
Message-ID: <1118052532.2524.7.camel@nienna.balabit>
References: <32849.62.231.54.154.1117789778.squirrel@webmail.cs.tcd.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <32849.62.231.54.154.1117789778.squirrel@webmail.cs.tcd.ie>
To: knash@cs.tcd.ie
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2005-06-03, p keltez=E9ssel 10.09-kor knash@cs.tcd.ie ezt =EDrta:
> I set up my wireless card in promiscuous mode. I want to capture al=
l
> unicast packets using the hook NF_IP_PRE_ROUTING but packets other =
then
> the ones destined for my machine are been dropped.
> I found this link, which talks about a NF_IP_PROMISC hook
> This seems to be exactly what I want
>=20
> https://lists.netfilter.org/pipermail/netfilter-devel/2001-November=
.txt
>=20
> The only think is it refers to modifying
> netfilter/userspace/libiptc/libip4tc.c which doesn't seem to exist =
on the
> version of linux I'm running.

  The patch is a combined one containing userspace and kernelspace
modifications as well (patches files in iptables and adds files to th=
e
old patch-o-matic). You probably won't be able to apply it easily,
hand-editing files seems to be necessary.

  BTW, Neither of the Netfilter hooks sees promisc packets, they are
dropped very early in the IP stack. If you take a look at that patch,
you can even see the comment describing this:

+-=09/* When the interface is in promisc. mode, drop all the crap
+-=09 * that it receives, do not try to analyse it.
+-=09 */
+-=09if (skb->pkt_type =3D=3D PACKET_OTHERHOST)
+-=09=09goto drop;

  Gianni's patch seems to create a new NF_IP_PROMISC hook which recei=
ves
exactly these packets.

--=20
KOVACS Krisztian <hidden@sch.bme.hu>
