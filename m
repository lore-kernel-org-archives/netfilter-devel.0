From: Harald Welte <laforge@gnumonks.org>
Subject: Re: netfilter on solaris?
Date: Sat, 15 Jun 2002 14:52:12 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020615145212.S2543@sunbeam.de.gnumonks.org>
References: <20020614100540.GA6399@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+maYzbBNDhZdX/s8"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20020614100540.GA6399@balabit.hu>; from bazsi@balabit.hu on Fri, Jun 14, 2002 at 12:05:40PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--+maYzbBNDhZdX/s8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 14, 2002 at 12:05:40PM +0200, Balazs Scheidler wrote:
> Hi,
>=20
> It is a strange idea I know, but I'd be interested in what the opinion of
> the core netfilter developers is on porting the whole netfilter subsystem=
 to
> Solaris?

After my netfilter presentation at linuxtag, somebody was asking me exactly
this question.

> Apart from the technical issues, would there be any problems? Does the GPL
> allow this kind of usage? (it would be implemented as a module)

This is basically the same question like binary-only kernel modules.=20

The GPL just talks about linking with libraries, since it was written
at the time people were working on userspace programs.

Linus has generally given his permission, that his code might be called
from binary-only kernel modules

Rusty has always made it very clear, that he doesn't share this view and
he has never given permission for people using any of his code from binary-
only modules.

Having netfilter within a different kernel, is technically the same:=20
GPL'd netfilter/iptables code is called from a binary-only kernel. =20

Thus, my conclusion would be: Without the explicit permission of the author=
s,
it is legally not possible to use netfilter/iptables within a proprietary
OS kernel.  But of coursel, I am not a lawyer.

I for myself are somewhat undecided, but I tend to share Rusty's view:
I haven't ever given permission for using my code by binary only kernel
modules.  All new code I'm working on wil export GPLONLY to make sure
about that.

> ps: don't tell me to use ipfilter (which works on Solaris), it's awful

I don't share this opinion, but this doesn't matter - it's off-topic.

> Bazsi

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

--+maYzbBNDhZdX/s8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9Czh8XaXGVTD0i/8RAvh0AJ4sPxrTC6EZRUQJA5h0CHqXFTRsWACgnCn/
VU5esWOfn5dSS5Oa9ddKub0=
=sGYL
-----END PGP SIGNATURE-----

--+maYzbBNDhZdX/s8--
