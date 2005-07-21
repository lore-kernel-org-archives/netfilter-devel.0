From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: SACK out of window segments?
Date: Thu, 21 Jul 2005 08:45:38 +0200
Message-ID: <1121928338.15942.3.camel@nienna.balabit>
References: <Pine.LNX.4.58.0507201213110.25054@blackhole.kfki.hu>
	<20050720.122652.28782810.davem@davemloft.net>
	<Pine.LNX.4.58.0507202219360.26391@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0507202219360.26391@blackhole.kfki.hu>
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

2005-07-20, sze keltez=E9ssel 22.24-kor Jozsef Kadlecsik ezt =EDrta:
> So I believe the trace was produced on the client itself, running Linux
> 2.4.25.
>=20
> Krisztian, is that assumption correct? Or did you run tcpdump on the
> perimeter somewhere?

  Actually the "client" in our case was a proxy firewall, and tcpdump
was run on that box.

--=20
 Regards,
  Krisztian Kovacs
