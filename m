From: "Brian J. Murrell" <80b664d7b3eb11641a57346257febc3d@interlinx.bc.ca>
Subject: Re: MSN Messenger ALG
Date: Fri, 28 Jun 2002 13:04:03 -0400
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020628170403.GB11348@pc.ilinx>
References: <20020627181256.GN9003@naboo.rchrd.phub.net.cable.rogers.com> <000901c21eaa$4826ef60$7200a8c0@blue>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <000901c21eaa$4826ef60$7200a8c0@blue>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2002 at 08:46:57AM -0500, Glover George wrote:
>=20
> UPnP is finishing up a security mechanism to add on to the UPnP spec for
> version 1.0,

Any pointers to these mechanisms?  I can't think of anything that
would work, in real life.  The issue is who can a UPnP gateway trust?
In the definition of "who" is "who is running the app?", as well as
"what is the app?" among other quesitons.

It seems that everybody wants this UPnP gateway for MSN Messenger, but
in my security policy, MS applications are automaticlly excluded from
using the UPnP gateway due to MS's constant obvious disregard for
security in favour of doing whatever they need to to make things work.

> and version 2.0 of UPnP is not far off, so security
> mechanisms are being put in place.

Again, anything I can read?

> But for the moment, AS WITH
> ANYTHING, if you take proper precautions to ensure that your rules in
> iptables will prevent any untrusted machines

Machines is not so much the issue as apps on those machines.  I am not
giving an MS machine access to the gateway because there is a trusted
app on it that wants to use the gateway when there are also untrusted
apps on the same machine or easily installable on the same machine.

Security for a UPnP gateway needs to be more fine grained than just
trusting machines.

> from access UPnP gateway in
> the first place, then you don't have these problems.  Sure an app could
> request it, but so what?  An app could fake itself into being h.323 as
> well. =20

Right.  It is this faking that needs to be addressed.  How do I
know that an app that is claiming to be "trusted app foo" really is
foo.

b.

--=20
Brian J. Murrell

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9HJcDl3EQlGLyuXARAq13AJoDm2MqzvntDzpGIScgOIZUEo7K+wCeMYtr
L98Ch2ow+zBDzowAp4wszcs=
=T4vP
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
