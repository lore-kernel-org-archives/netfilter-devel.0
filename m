From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
Date: Sun, 25 Feb 2007 19:38:13 +0100
Message-ID: <1172428694.4485.31.camel@localhost.localdomain>
References: <45DB9C1F.1080605@redhat.com> <45DCEA47.5080100@redhat.com>
	<45E04468.7020001@trash.net> <45E06546.504@redhat.com>
	<45E1C7E0.9070102@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-N1rREts8Rj+1DcGD7fDt"
Cc: netfilter-devel@lists.netfilter.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Chuck Ebbert <cebbert@redhat.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45E1C7E0.9070102@trash.net>
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


--=-N1rREts8Rj+1DcGD7fDt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-02-25 at 18:31 +0100, Patrick McHardy wrote:

> [NETFILTER]: conntrack: fix {nf,ip}_ct_iterate_cleanup endless loops
>=20
> {nf,ip}_ct_iterate_cleanup iterate over the unconfirmed list for cleaning
> up conntrack entries, which is wrong for multiple reasons:
>=20
> - unconfirmed entries can not be killed manually, which means we might
>   iterate forever without making forward progress.
>=20
>   This can happen in combination with the conntrack event cache, which
>   holds a reference to the conntrack entry, which is only released when
>   the packet makes it all the way through the stack or a different
>   packet is handled.
>
> - taking references to an unconfirmed entry and using it outside the
>   locked section doesn't work, the list entries are not refcounted and
>   another CPU might already be waiting to destroy the entry
>=20
> Split ip_ct_iterate_cleanup in ip_ct_iterate, which iterates over both
> confirmed and unconfirmed entries, but doesn't attempt to kill them,
> and ip_ct_cleanup, which makes sure no unconfirmed entries exist by
> calling synchronize_net() prior to walking the conntrack hash.

What about this case:

1. Conntrack entry is created and placed on the unconfirmed list
2. The event cache bumps the refcount of the conntrack entry
3. module removal of ip_conntrack unregisters all hooks
4. packet is dropped by an iptables rule
5. packet is freed but we still have a refcount on the conntrack entry

Now there's no way to get that refcount to decrease as that only happens
when the event cache receives another packet or the current packet makes
it through the stack as you wrote above. And neither of this will happen
since we unregistered the hooks providing the packets and dropped the
packet.

I ran into this case a while ago during stresstesting and rewrote the
event cache to not increase the refcount, but this has the drawback that
events caused by dropped packets won't be reported. This may not be a
good thing...

Old patch can be found here:
http://performance.netfilter.org/patches/nf_conntrack_ecache-fix

--=20
/Martin

--=-N1rREts8Rj+1DcGD7fDt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF4deVWm2vlfa207ERAhZOAJ4wwLtE4BJ7He5HfPoDYWuhO4xEBACfTa0v
koSHK6ziYbPehHuf6mJG65Q=
=yYBJ
-----END PGP SIGNATURE-----

--=-N1rREts8Rj+1DcGD7fDt--
