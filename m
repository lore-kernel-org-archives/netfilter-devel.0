From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: faster way to read conntrack state than /proc ?
Date: Sat, 18 Oct 2003 10:55:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1066467318.12167.80.camel@tux.rsn.bth.se>
References: <20031018074256.GA29942@alpha.home.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8bKQCpnb6lCqfR9g7Q5I"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	davem@redhat.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20031018074256.GA29942@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-8bKQCpnb6lCqfR9g7Q5I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2003-10-18 at 09:42, Willy Tarreau wrote:
> Hello,
>=20
> On LKML, to someone complaining about the slowness of /proc/net/tcp, Dave=
m
> suggested to use the netlink interface instead which was really faster. B=
TW,
> the guy confirmed that 'ss' took 6 seconds where 'netstat' took 15 min. S=
o
> I was wondering if there is such an equivalent for /proc/net/ip_conntrack=
,
> and if not, what would be needed to implement it, because it's sometimes
> annoying to eat 100% system on production machines during several minutes
> just to get some statistics about connections status.
>=20
> Anyone has a clue on this ?

We have something called nfnetlink and ctnetlink. ctnetlink has the
ability to dump all connections via netlink (unless someone, possibly
me, broke it).

see extra/nfnetlink-ctnetlink-0.11.patch in patch-o-matic

This patch is very experimental and it may crash your machine.
I have a few quick fixes at
http://kashyyyk.netfilter.org/~gandalf/patches/nfnetlink_conntrack-fix.diff
Some of them has been applied to cvs so you'll have to hand-merge.

This only gives very limited functionality (lookup, dump table, delete).
If you want more there's a patch in the netfilter-ha repository that
adds a lot of things.

To be able to use ctnetlink you'll probably want to use libctnetlink
which you can find in netfilter/iptables2 in cvs. And possibly apply
http://kashyyyk.netfilter.org/~gandalf/patches/libctnetlink-020809-2.diff

That's just a small patch I made to be able to perform lookups in a
reasonable manner. I use that in my patch to oidentd (availiable at the
same place) to make it use ctnetlink for connection-lookups instead of
using /proc/net/ip_conntrack. Using /p/n/ip_conntrack can bring the
machine to it's knees with just one ident request every few seconds if
you have enough connections for it to go through.
With ctnetlink I can perform over 100k lookups per cpu per second on a
2xpIII 800 (it has a bug where lookups can stall until one of the
programs performing the lookups is restarted, only seen in
stresstesting).

nfnetlink and ctnetlink will be part of pkttables which Harald is
working on.

As you may nave noticed, this is code that's not widely used (mainly
because noone's finished it, but the patch in netfilter-ha by Patrick
McHardy adds a great deal of the missing stuff), so don't expect too
much :)

--=20
/Martin

--=-8bKQCpnb6lCqfR9g7Q5I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/kP/2Wm2vlfa207ERAnw0AJ0TYDKEEf3S2xphDsqx2K45sjv/GgCfeoqb
HfGxLILyAHCWqW54m0fZ4HM=
=ZSu7
-----END PGP SIGNATURE-----

--=-8bKQCpnb6lCqfR9g7Q5I--
