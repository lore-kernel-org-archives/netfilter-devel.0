From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] [POM] ipp2p/ipv4options patches
Date: Fri, 07 Jul 2006 05:56:24 +0200
Message-ID: <44ADDB68.2010502@trash.net>
References: <44ACD6E2.5010101@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <44ACD6E2.5010101@anduras.de>
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

Sven Anders wrote:
> Hello!
>=20
> Here are some patches for the latest Patch-O-Matic, which I needed for =
using
> them with the latest stable kernel.
>=20
> These are only corrections for the new function parameters and the miss=
ing
> matchsize.

Thanks. The ipp2p match is not part of official pomng anymore, but
I've applied the ipv4options patch with one small change.
Krzysztof Ol=C4=99dzki just sent me the new URL for the ipp2p match,
I'll add it now.

>  static struct ipt_match ipv4options_match =3D {=20
>  	.name =3D "ipv4options",
> -	.match =3D match,
> -	.checkentry =3D checkentry,
> +	.match =3D &match,
> +	.matchsize =3D sizeof(struct ipt_ipv4options_info),
> +	.checkentry =3D &checkentry,
>  	.me =3D THIS_MODULE
>  };
> =20

I removed the & for the function pointers, they're not needed.
