From: Harald Welte <laforge@gnumonks.org>
Subject: Re: iptables --syn and kernel behavior
Date: Wed, 30 Oct 2002 09:34:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021030093454.I8635@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0210201836020.17904-100000@roope.top.tkukoulu.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0k24IdCjZr+ZpLJG"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tero Pelander <tpeland@tkukoulu.fi>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0210201836020.17904-100000@roope.top.tkukoulu.fi>; from tpeland@tkukoulu.fi on Sun, Oct 20, 2002 at 06:51:38PM +0300
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0k24IdCjZr+ZpLJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 20, 2002 at 06:51:38PM +0300, Tero Pelander wrote:
> According to a message that appeared in bugtraq linux 2.4.19 allows=20
> opening new connections with SYN and RST set, ACK reset.=20

Well, according to my understanding of TCP, this is a bug in the TCP
stack then.

> Iptables has option "--syn" that tries to protect from new connections=20
> but unfortunately the described packet would get through such rule.

sure? (see below)

> --man iptables--
>   --syn
>     It is equivalent to --tcp-flags SYN,RST,ACK SYN.

Which means that RST and ACK have to be 0, and SYN has to be 1.

Where is your problem?  Have you actually tested what you are claiming?

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--0k24IdCjZr+ZpLJG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9v5muXaXGVTD0i/8RAkeeAKCh7IT9tE+L0C1edEDcGU07ZpOjigCcDPg8
o/PLoEkF99CA6PZiGglluvc=
=mg/0
-----END PGP SIGNATURE-----

--0k24IdCjZr+ZpLJG--
