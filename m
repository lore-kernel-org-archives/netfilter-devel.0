From: Harald Welte <laforge@netfilter.org>
Subject: Re: Per site de-window-scaling
Date: Thu, 2 Sep 2004 23:09:52 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040902210952.GK26263@sunbeam.de.gnumonks.org>
References: <20040902120144.0b811b73@dell_ss3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cqq5NadOW2RfLMJ/"
Cc: "David S. Miller" <davem@redhat.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Hemminger <shemminger@osdl.org>
Content-Disposition: inline
In-Reply-To: <20040902120144.0b811b73@dell_ss3.pdx.osdl.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--Cqq5NadOW2RfLMJ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 02, 2004 at 12:01:44PM -0700, Stephen Hemminger wrote:
> Is there a simple way with netfilter to do per-site TCP SYN mangling
> to remove the window scale option?  That way sites that have window-scale
> corrupting firewalls could be blacklisted.

Yes, this is possible with a quite simple piece of code similar to what
I did with the 'ECN' target for known ECN blackholes.=20

All you do is to iterate over the tcp options and NOP out the window
scaling options.=20

Please don't copy any of the mistakes we did before, like the option
parsing signedness bug, or overwriting with '0' (end of options) instead
of NOP ;)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Cqq5NadOW2RfLMJ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBN4wgXaXGVTD0i/8RAs6lAJ9GBcyv39Amn0CtEVlbVwXf5juUeQCfT7TA
T7iz4Ztfn6IJtCIUHik46FY=
=QqxO
-----END PGP SIGNATURE-----

--Cqq5NadOW2RfLMJ/--
