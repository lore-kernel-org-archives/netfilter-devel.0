From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Very first try: ipt_connrate patch.
Date: Sat, 14 Feb 2004 21:14:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040214201444.GS7756@sunbeam.de.gnumonks.org>
References: <87bro9fiqq.fsf@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nSQp8DZZn7gZbDHt"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nuutti Kotivuori <naked@iki.fi>
Content-Disposition: inline
In-Reply-To: <87bro9fiqq.fsf@iki.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--nSQp8DZZn7gZbDHt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 08, 2004 at 09:56:13PM +0200, Nuutti Kotivuori wrote:
> Okay, this is my very first patch concerning anything netfilter
> related. I have no idea which versions I should build it against, how
> to deal with the patch-o-matic, let alone patch-o-matic-ng.

since it is 2.6.x, please put it in patch-o-matic-ng.

> So, I'd appreciate some hand-holding in getting this thing into a form
> where it can be easily used by other people.

all the wholefiles go in as files themselves.  i.e.=20
patch-o-matic-ng/connrate/linux/include/linux/netfilter_ipv4/ip_conntrack_r=
ate.h

The rest is a bit more tricky, and I have to admit that there is no way
but to look at the dozens of examples in order to figure it out.

> And the other one is against iptables 1.2.9. This is a rather hackish
> patch, 95% of it is copy-pasted from libipt_connbytes.c, which doesn't
> seem to be that perfect itself either. It is also built against the
> debian patched version of iptables 1.2.9, so I'm not sure how cleanly
> the Makefile part applies to others.

As long as you only add a libipt_connrate.c file (together with a
=2Elibipt_connrate-test), this will usually be applied without any
problems.

> +	/* jiffies of previous received packet */
> +	unsigned long prev;
> +	/* average rate of tokens per jiffy */
> +	u_int32_t avgrate;

be careful.  I didn't review your algorithms, but on 64bit
architectures, unsigned long tend to be 64bit and you forced 'avgrate'
to be 32 bits.

> +PF_EXT_SLIB:=3Dah connlimit connmark connrate conntrack dscp ecn esp
> helper icmp iprange length limit mac mark multiport owner physdev
> pkttype realm rpc standard state tcp tcpmss tos ttl udp unclean
> CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP
> NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
> PF6_EXT_SLIB:=3Deui64 hl icmpv6 length limit mac mark multiport owner
> standard tcp udp HL LOG MARK TRACE

instead of adding it here, please include a .connrate-test file

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nSQp8DZZn7gZbDHt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFALoG0XaXGVTD0i/8RAiU+AJ0SyUgkIiTv4BIJaps5scUoU3aXKgCeO9hX
mFprVunEMbnnsBSIpmVd7Z4=
=XRn1
-----END PGP SIGNATURE-----

--nSQp8DZZn7gZbDHt--
