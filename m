From: Harald Welte <laforge@netfilter.org>
Subject: Re: linux packet forwarding rate
Date: Thu, 6 Mar 2003 12:27:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030306112749.GE25556@sunbeam.de.gnumonks.org>
References: <3E66F084.3F396F59@ie.cuhk.edu.hk> <20030306071336.GE2829@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZInfyf7laFu/Kiw7"
Cc: Philip Ho <cbho@ie.cuhk.edu.hk>,
	netfilter devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030306071336.GE2829@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ZInfyf7laFu/Kiw7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 06, 2003 at 08:13:36AM +0100, Patrick Schaaf wrote:
> Finally, the ONLY way to REALLY find out about these things, is to
> get some hardware, test software, UNDERSTAND WHAT IS TESTED, and
> the TEST!

Yet to be added:

- understand exactly what hardware can even do gbit linerate (not all
  NIC's can do this
- understand a lot about the linux network stack and know where you can
  tune it
- understand that without NAPI you don't have a very high chance

So unless you are a very experienced linux networking guy [or you hire
one], I think you will not be able to do a realistic test.  You will
just find out that in your configuration and the default setup it will
not work.

> best regards
>   Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ZInfyf7laFu/Kiw7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+ZzC1XaXGVTD0i/8RAuH8AJ9yGCPupFooaHI8iDHB2spG2H0nYwCgi7qK
GQMNUTXRCUsB2M9Q2vuFiwc=
=UJzr
-----END PGP SIGNATURE-----

--ZInfyf7laFu/Kiw7--
