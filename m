From: Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH 1/3] Netfilter: Remove ip_conntrack_tuple_hash "ctrack"
Date: Sat, 22 Jan 2005 19:26:59 +0100
Message-ID: <m3k6q52ubw.fsf@igel.m5r.de>
References: <1105444254.19331.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1105444254.19331.43.camel@localhost.localdomain> (Rusty
	Russell's message of "Tue, 15 Jun 2004 12:54:07 +0200")
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

Rusty Russell <rusty@rustcorp.com.au> writes:

> Index: linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_conntr=
ack_tuple.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.10-bk13-Netfilter.orig/include/linux/netfilter_ipv4/ip_conn=
track_tuple.h	2005-01-11 21:04:11.743513264 +1100
> +++ linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_conntrack=
_tuple.h	2005-01-11 21:05:20.015134400 +1100
> @@ -64,7 +64,10 @@
>  		} u;
>=20=20
>  		/* The protocol. */
> -		u_int16_t protonum;
> +		u8 protonum;
> +
> +		/* The direction (for tuplehash) */
> +		u8 dir;
>  	} dst;
>  };
>=20=20

Doesn't this break the iptables conntrack module on big-endian systems?

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
Key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
