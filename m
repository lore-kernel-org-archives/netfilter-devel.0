From: Harald Welte <laforge@gnumonks.org>
Subject: Re: sparc64 ipv6 ip6tables nogo
Date: Sun, 15 Sep 2002 13:12:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020915131217.F3810@sunbeam.de.gnumonks.org>
References: <20020912155314.GA20741@paradigm.rfc822.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DTbNwtYx2n+Gggn7"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Florian Lohoff <flo@rfc822.org>
Content-Disposition: inline
In-Reply-To: <20020912155314.GA20741@paradigm.rfc822.org>; from flo@rfc822.org on Thu, Sep 12, 2002 at 05:53:14PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--DTbNwtYx2n+Gggn7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2002 at 05:53:14PM +0200, Florian Lohoff wrote:
>=20
> Hi,
> i seem to have been hit by a ip6tables problem on sparc64 - It seems
> that there are some hidden 64bit kernel / 32 bit userspace problems
> somewhere in netfilter (Same happened with tunnel ioctls on sparc64)

There are known 64bit kernel/ 32bit userspace problems, which affect the
byte/packet counters in iptables/ip6tables.  I've tried to fix this,
but unfortunately didn't succeed.  See the mailinglist archives for this.

The ip6tables problem you have reported was unknown so far.  I can reproduce
this problem on my Ultra5 running 2.4.18.  But it certainly has no relation
to any 64/32 kernel/usrspace, since there is no userspace involved when
ip6table_filter registers with ip6_tables.

What really is surprising is the fact that ip_tables work and ip6_tables
doesn't - and ip6_tables is a copy+paste 'port'...

I've tried to debug the problem, and the EINVAL comes from=20
check_entry_size_and_hooks() in ip6_tables.c:

translate_table: size 856
Bad offset 000000014002e074

Unfortunately I don't have the time to dig further right now.  I will
put it on the TODO list.=20

> Flo
> PS: I am not subscribed to netfilter-devel

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--DTbNwtYx2n+Gggn7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9hGsMXaXGVTD0i/8RAraXAJ967+Q3pK7TcA7nVcmfvXixyw7WWgCglBH1
vNkwFLhsvJvkbqN/SX3bmmQ=
=PYZQ
-----END PGP SIGNATURE-----

--DTbNwtYx2n+Gggn7--
