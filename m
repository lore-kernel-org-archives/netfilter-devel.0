From: Harald Welte <laforge@gnumonks.org>
Subject: Re: remove usage of __MOD_XXX_USAGE_COUNT and derivatives
Date: Sun, 12 Jan 2003 17:36:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030112163616.GA426@naboo.de.gnumonks.org>
References: <3E1DEF2D.4080703@fugmann.dhs.org> <20030110131315.GS1353@sunbeam.de.gnumonks.org> <3E1ECF6B.5080109@fugmann.dhs.org> <20030110134959.GE9467@sunbeam.de.gnumonks.org> <3E1EE4EC.7010703@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
Content-Disposition: inline
In-Reply-To: <3E1EE4EC.7010703@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2003 at 04:21:16PM +0100, Anders Fugmann wrote:
> Harald Welte wrote:
> >On Fri, Jan 10, 2003 at 02:49:31PM +0100, Anders Fugmann wrote:
> >
> >I don't think that this is necessarry.  What is in fact necessarry, is
> >increasing the module use count for every rule created.  Otherwise it
> >would state 'iptable_filter:unused' in case you had 10 dropping rules.
> >This used to be the old behaviour, but confused a couple of users... so
> >we decided to change it.
> Ok - I will split my answer up into two parts.
> 1. It seems that we agree upon modules should not have their module=20
> count increased because a new module is loaded. This is the current case.

Well, I don't consider it important, if there is 'just' a module
dependency, or an increased module usage count (or both, like now).  As
long as it is assured that the system is in a consistent state.

It's a minor (cosmetic) issue, that we do both right now... it doesn't
even affect runtime performance in any noticeable way - how often are
new matches/targets loaded?=20

> 2. If the general design goal is to have modules reflect all rules, I=20
> guess that the sum of all module counts should be equal or greater than=
=20
> the total number of rules. If this is the case, then where which module=
=20
> should be increased when inserting the rule "iptables -A INPUT". In=20
> general - Should not iptables_filter's module count be incremented for=20
> every inserted rule in the filter tabel (Same goes for NAT and MANGLE).

iptable_filter usage count needs to be incremented.  Either per rule, or
increased to one as soon as there is >0 rules, and decreased to zero as
soon as there is <1 rules.

> I'm asking, as I'm willing to spend some time understanding the system,=
=20
> and make patches for Netfilter.

great, although I don't really see the need (see above).

> Regards
> Anders Fugmann

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+IZl/XaXGVTD0i/8RAt3HAKCKwaN5j+ugWHCEu8p2o8DjqsORcACglKbX
6YoPX7CRq0Ey0O7QfJ+0PT0=
=e5VY
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
