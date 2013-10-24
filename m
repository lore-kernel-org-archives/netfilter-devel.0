From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter: xt_socket: add XT_SOCKET_NOWILDCARD flag causes
 behavioural change in userspace?
Date: Thu, 24 Oct 2013 05:05:07 -0700
Message-ID: <1382616307.7572.56.camel@edumazet-glaptop.roam.corp.google.com>
References: <52667EBC.5010709@ee.oulu.fi> <20131024095212.GA4422@localhost>
	 <1382609706.7572.48.camel@edumazet-glaptop.roam.corp.google.com>
	 <526902D1.50803@ee.oulu.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, edumazet@google.com,
	netfilter-devel@vger.kernel.org
To: Pekka =?ISO-8859-1?Q?Pietik=E4inen?= <pp@ee.oulu.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:44456 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3JXMFL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:05:11 -0400
Received: by mail-wg0-f48.google.com with SMTP id b13so2167400wgh.3
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2013 05:05:10 -0700 (PDT)
In-Reply-To: <526902D1.50803@ee.oulu.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2013-10-24 at 14:21 +0300, Pekka Pietik=C3=A4inen wrote:
> On 24/10/13 13:15, Eric Dumazet wrote:
> > On Thu, 2013-10-24 at 11:52 +0200, Pablo Neira Ayuso wrote:
> >> Hi Pekka,
> >>
> >> On Tue, Oct 22, 2013 at 04:33:48PM +0300, Pekka Pietik=C3=A4inen w=
rote:
> >>> After a kernel update to 3.11 (feat. commit
> >>> 681f130f39e10087475383e6771b9366e26bab0c) my "generate fake tcp
> >>> connections from random ip addresses" app broke.
> >> Did you give a try to revert it and things were working back fine?=
 I
> >> think the root cause for this behaviour change is not in that patc=
h.
> > Yes, given that the option is off by default, I do not really under=
stand
> > the issue.
> >
> > Its true that the option is currently a bit flawed, but my refactor=
ing
> > of TCP listener should solve the problem soon. I do not feel necess=
ary
> > to 'fix' xt_socket --nowildcard right now.
> >
> Okie, did some poking,  Going to before "use IP early demux" seems to=
=20
> have found the real cause:
>=20
> Old:
>=20
> [ 1700.684685] sk->sk_state: 2
> [ 1700.684688] wildcard: 0 transparent: 1, sk !=3D skb->sk 1
> [ 1700.684691] proto 6 192.168.122.93:22 -> 5.5.5.5:45856 (orig=20
> 5.5.5.5:45856) sock ffff8803fb7b1500
> [ 1700.685583] sk->sk_state: 4
> [ 1700.685585] wildcard: 0 transparent: 1, sk !=3D skb->sk 1
> [ 1700.685587] proto 6 192.168.122.93:22 -> 5.5.5.5:45856 (orig=20
> 5.5.5.5:45856) sock ffff8803fb7b1500
> [ 1700.688443] sk->sk_state: 6
> [ 1700.688445] wildcard: 0 transparent: 1, sk !=3D skb->sk 1
>=20
> New:
>=20
> [ 1613.960054] sk->sk_state: 7
> [ 1613.960057] wildcard: 1 transparent: 1, sk !=3D skb->sk 0
> [ 1613.960060] proto 6 192.168.122.93:22 -> 5.5.5.5:43540 (orig=20
> 5.5.5.5:43540) sock           (null)
> [ 1615.511751] sk->sk_state: 7
> [ 1615.511754] wildcard: 1 transparent: 1, sk !=3D skb->sk 0
> [ 1615.511756] proto 6 192.168.122.93:22 -> 5.5.5.5:43540 (orig=20
> 5.5.5.5:43540) sock           (null)
> [ 1615.963020] sk->sk_state: 7
> [ 1615.963022] wildcard: 1 transparent: 1, sk !=3D skb->sk 0
> [ 1615.963024] proto 6 192.168.122.93:22 -> 5.5.5.5:34950 (orig=20
> 5.5.5.5:34950) sock           (null)
> [ 1615.963036] sk->sk_state: 7
> [ 1615.963037] wildcard: 1 transparent: 1, sk !=3D skb->sk 0
> [ 1615.963038] proto 6 192.168.122.93:22 -> 5.5.5.5:43540 (orig=20
> 5.5.5.5:43540) sock           (null)
>=20

sk_state 7 means TCP_CLOSE

I do not see how a TCP_CLOSE socket can be matched...



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
