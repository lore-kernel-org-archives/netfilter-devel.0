From: Harald Welte <laforge@netfilter.org>
Subject: Re: Accept and remove
Date: Wed, 26 Mar 2003 16:01:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030326150110.GX21953@sunbeam.de.gnumonks.org>
References: <20030319140857.GB21417@ra.is>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tgGnixv3tJWXBxdL"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Richard Allen <ra@ra.is>
Content-Disposition: inline
In-Reply-To: <20030319140857.GB21417@ra.is>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tgGnixv3tJWXBxdL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2003 at 02:08:57PM +0000, Richard Allen wrote:
> Hi all.
>=20
> I was wondering if there is a feature in iptables where I can add a rule
> that matches for example a SYN packet and jump to a target that lets it
> through and then removes the rule.

rule changes (removal, ..) are not possible from within the kernel,
sorry.  The kernel just has code to iterate over a ruleset, not to
create/modify it.

> If not, I was considering to take the ACCEPT target and copy it to someth=
ing
> else (ACCEPTONCE) and making the necessary changes.  Is there any way for
> targets to know which rule called them ?

no.  but you have a per-rule private data (targinfo) for your target.
So you can just write a '1' to this data area when your rule was
matched, and then don't match for all further packets if there is this
magic '1'.

> Rikki.         --  RHCE, RHCX, HP-UX Certified Administrator.
=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tgGnixv3tJWXBxdL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gcC2XaXGVTD0i/8RAsSPAKCwpfqqGnITWDMCXbRpBhSVMLG7eACfbxnA
BBAaunpI89fqreqHUF1Ft9Y=
=/lK9
-----END PGP SIGNATURE-----

--tgGnixv3tJWXBxdL--
