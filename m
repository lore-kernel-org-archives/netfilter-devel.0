From: netfilter@interlinx.bc.ca
Subject: Re: testing checksum in helpers is redundant with tcp_window_tracking
Date: Fri, 28 Feb 2003 07:13:40 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030228121336.GB9692@pc.ilinx>
References: <20030227222154.GA9692@pc.ilinx> <Pine.LNX.4.33.0302281127290.27528-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0302281127290.27528-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2003 at 11:33:15AM +0100, Jozsef Kadlecsik wrote:
>=20
> No, I think that is a bad idea. The tcp-window-tracking patch patches the
> default helpers (ftp, irc) and remove the redundant checkings.

Right.  I have noticed this.  But based on that idea, it should patch
all of the helpers, but that becomes a maintenance nightmare.

> However the
> current status of the patch is 'extra'.

Right.  I understand that.

> No other
> subsystem/patch should be made dependent of it.

If it were a requirement type of dependancy, I would completely agree
with you, but I am talking about an optional "take advantage of it if
it's there and business as usual if it's not" type dependency.

Adding a macro to tcp-window-tracking (simply signifying it's in the
kernel) and wrapping the tcp checks in helpers with a test for the
macro does not introduce any loss of functionality at all.  A module
writer doesn't even have to use it if he doesn't want to, but if he
wants his module to be as efficient as possible in the presence of
tcp-window-tracking, he can use the macro.

b.

--=20
Brian J. Murrell

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+X1Jwl3EQlGLyuXARAp//AJ0d5E669HEj4FYrCSW2jq8M3iyMEwCg4ozk
xW/WwBrpaqKJr+PmRNtfvpk=
=MkGn
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
