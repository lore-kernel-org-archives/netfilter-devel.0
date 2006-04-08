From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] [libnetfilter_conntrack] fixed duration connection
Date: Sat, 08 Apr 2006 21:58:58 +0200
Message-ID: <44381602.5090105@trash.net>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net> <4436DF6B.4060208@inl.fr>
	<4436E0B6.9040602@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <4436E0B6.9040602@inl.fr>
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

Eric Leblond wrote:
> Hi,
>=20
> This patch add support for the IPS_FIXED_TIMEOUT state.
>=20
> BR,
> --
> Regit
>=20
>=20
> -----------------------------------------------------------------------=
-
>=20
> Index: include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h	(r=C3=A9=
vision 6576)
> +++ include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h	(copie d=
e travail)
> @@ -29,6 +29,7 @@
>  	CTA_HELP,
>  	CTA_NAT,
>  	CTA_TIMEOUT,
> +	CTA_FIXED_TIMEOUT,
>  	CTA_MARK,
>  	CTA_COUNTERS_ORIG,
>  	CTA_COUNTERS_REPLY,

I didn't see the patch adding support for this in the kernel. Since
there is no seperate fixed timeout anymore, this also looks obsolete.
The way I understood the kernel patch, you would just do two netlink
operations:

- set flag FIXED_TIMEOUT
- change timeout using CTA_TIMEOUT

Am I missing something?
