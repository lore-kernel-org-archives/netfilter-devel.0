From: Harald Welte <laforge@netfilter.org>
Subject: Re: netlink and iptables
Date: Thu, 26 Jun 2003 09:25:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030626072548.GL2645@sunbeam.de.gnumonks.org>
References: <3EFA0B56.1030006@linux.org.ar>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I7xMaAXwyt9AGI17"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Diego Woitasen <diegows@linux.org.ar>
Content-Disposition: inline
In-Reply-To: <3EFA0B56.1030006@linux.org.ar>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--I7xMaAXwyt9AGI17
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2003 at 05:51:34PM -0300, Diego Woitasen wrote:
> Where is the code of iptables2 updated? I saw some code in CVS but is=20
> really old. I want to contribute to the project but i can 't find=20
> anything about it.

the problem is that I don't have as much time as I'd like to have to
spend on iptables2 (which should be renamed to pkttables anyway).

Before the development of the userspace program can start, libiptables
(which should be renamed to libpkttables) has to be at some more mature
state.

> Thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--I7xMaAXwyt9AGI17
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++p/8XaXGVTD0i/8RAqEQAJ0do3lER0cRU+bICoYstUIlLFS3CACgkVGF
sSbyLCoVBorzPdR9bEDWB0c=
=i0xB
-----END PGP SIGNATURE-----

--I7xMaAXwyt9AGI17--
