From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunoi@info.ucl.ac.be>
Subject: Re: about ROUTE target
Date: 18 Sep 2002 12:57:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032346636.2377.4.camel@descartes>
References: <002f01c25e5e$46745100$ecf8a8c0@monday>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Toshihiro Sonoda <toshihiro@jp.fujitsu.com>
In-Reply-To: <002f01c25e5e$46745100$ecf8a8c0@monday>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I confirmed that ipt_route_target(), which is in "ipt_ROUTE.c", hook func=
tion=20
> in the ROUTE target was called in the router's linux kernel,
> and ipgre_tunnel_xmit() in gre's tunneling device(ip_gre.c) was called.
>=20
> But, the at the IPTUNNLE_XMIT() called in the ipgre_tunnel_xmit(), linux=20
> was freezed.
>=20
> Do I mistake how to use the ROUTE target ?

It seems you found a bug. I'll take a look to this problem as soon as
possible. Thanks for having reported this bug.

C=E9dric de Launois
