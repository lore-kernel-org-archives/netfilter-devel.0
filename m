From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: Patch for CONFIG_IP_NF_NAT_LOCAL in 2.6.11 ?
Date: Fri, 11 Mar 2005 13:48:16 +0100
Message-ID: <1110545296.3751.16.camel@nienna.balabit>
References: <019201c52592$e181a4b0$0a00a8c0@alexandre>
	<42307E2A.5060806@trash.net>	<019f01c52595$dd3a56b0$0a00a8c0@alexandre>
	<42308509.4040902@trash.net>	<01cd01c5259a$89ab8dc0$0a00a8c0@alexandre>
	<42308B4E.3030303@trash.net>	<1110483093.1100.9.camel@tux.rsn.bth.se>
	<42312929.7000102@trash.net>  <42312A33.3030603@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42312A33.3030603@trash.net>
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

2005-03-11, p keltez=E9ssel 06.18-kor Patrick McHardy ezt =EDrta:
> >> It simply does not route packets with loopback addresses out via non
> >> loopback interfaces, and SNAT occurs at POSTROUTING...
> >> Not sure what a good solution could be, we certainly don't want to t=
he
> >> possibility to send out packets with 127.0.0.1 as source (like some
> >> windows virus got the windows stack to do by synflooding a domain th=
at
> >> later got changed into 127.0.0.1)
> >=20
> >=20
> > Maybe we can use 0 as source if LOOPBACK(src). OTOH, I don't think we
> > want to route packet with loopback source, so we may instead declare
> > this as a bad testcase :)
>=20
> A different possibility would be retaining the old behaviour for
> loopback addresses and doing implicit source NAT.

  You can't do that easily anymore. 2.6.11 does not have a list of
manipulations, so you cannot do multiple source NATs at all. To make it
even more limited, nat_packet() does only one manipulation per hook, so
doing SNAT+DNAT on LOCAL_OUT is impossible.

  BTW, I think SNAT-ting pure local traffic so that it goes out on the
wire is a bad practice anyway.

--=20
 Regards,
  Krisztian Kovacs
