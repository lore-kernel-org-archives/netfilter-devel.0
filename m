From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: REDIRECT changes DST address of the packet
Date: Tue, 26 Jul 2005 11:31:35 +0200
Message-ID: <1122370295.24626.10.camel@nienna.balabit>
References: <20050725045409.35744.qmail@web60823.mail.yahoo.com>
	<42E57CE5.4070202@trash.net>  <42E581D4.10402@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42E581D4.10402@trash.net>
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

2005-07-26, k keltez=E9ssel 02.20-kor Patrick McHardy ezt =EDrta:
> >> I am able to get the original dst address when I am
> >> using tcp connection.
> >> How can I get with UDP???
> >=20
> > Does this patch help? It should make SO_ORIGINAL_DST usable
> > with UDP as well.
> >=20
> > diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfil=
ter/ip_conntrack_core.c
> > --- a/net/ipv4/netfilter/ip_conntrack_core.c
> > +++ b/net/ipv4/netfilter/ip_conntrack_core.c
> > @@ -1310,9 +1310,8 @@ getorigdst(struct sock *sk, int optval,=20
> >  	tuple.dst.u.tcp.port =3D inet->dport;
> >  	tuple.dst.protonum =3D IPPROTO_TCP;

  Patrick, I'm afraid this is not enough for a full-featured UDP
solution. If you're using a single socket to receive UDP packets sent to
multiple original addresses this approach simply fails. A better
solution would require receiving the original destination address in a
per-packet manner.

  We're using something similar as part of the transparent proxying
patchset, but unfortunately this requires enlarging the skb and is a
little hackish. The patch introduces an IP_RECVORIGADDRS socket option.
If you enable this sockopt on a UDP socket, then recvmsg() will return
the original addresses as a control message.

--=20
 Regards,
  Krisztian Kovacs
