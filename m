From: Tom Marshall <tommy@home.tig-grr.com>
Subject: Re: http&rtsp kernel 'proxy'
Date: Thu, 2 Oct 2003 11:05:26 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002180526.GA12113@home.tig-grr.com>
References: <200310021145.10243.fjcabello@visual-tools.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Francisco Javier Cabello Torres <fjcabello@visual-tools.com>
Content-Disposition: inline
In-Reply-To: <200310021145.10243.fjcabello@visual-tools.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 02, 2003 at 11:45:10AM +0200, Francisco Javier Cabello Torres w=
rote:
> Hello,
> I'm new with kernel development.=20
> I would like to implement a http&rtsp port as a kernel module.
> First, I will try to explain what I want to develop. I have two servers, =
one=20
> of then a HTTP server, listening on port 80, and the second one a RTSP=20
> server, listening on port 554. My system is besides a firewall which only=
=20
> allow traffic in port 80. Because of that I need a 'proxy' listen on port=
 80=20
> which redirect traffic to RTSP server (still listen on 554) or HTTP serve=
r=20
> (now listen on 8080). This 'proxy' should  analyze incoming packets and=
=20
> depending of contents redirect it to one of the servers.  If packet conte=
nts=20
> belongs to rtsp protocol, it will be redirect to port 554, however if it'=
s a=20
> http packet, it will be redirect to 8080.
>=20
> I have been reading some documentation, and it think it would be possible=
 to=20
> implement a iptables 'match' for rtsp and http packets, modify iptables t=
o=20
> accept new match and then, with my modified iptables, specify rules to se=
nd=20
> packets to correct servers.
> Any ideas? Am I going crazy?  ;)

Why is your firewall restricted to port 80?  If you require the use of RTSP,
your administrator should open the port for you.

You cannot do protocol multiplexing with iptables and remain standards
compliant.  This is a job for an application level proxy.  You could
probably make it work "most of the time" with some clever string matching.=
=20
But in the end, using iptables for this would be a hack.

--=20
The intelligence of any discussion diminishes with the square of the
number of participants.
        -- Adam Walinsky

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iEYEARECAAYFAj98aOYACgkQFMm9uvwPXW7tTACfexJE0uL3q3EfkoiKQHGwFRit
paMAn10c+xSHq4Vb1cVfgIr7zTgguPIu
=KZmb
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
