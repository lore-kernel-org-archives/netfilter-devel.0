From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] big endian patch against netfilter after PPTP NAT pat ch
Date: Sun, 9 Feb 2003 10:29:11 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030209092911.GO13269@naboo.fugue.com>
References: <771F217D7A4AF84494632457889470A412D77E@bcmsg011.corp.ads> <3E41A7BC.20209@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OGLMwEELQbPC02lM"
Cc: Chris Poon <Chris.Poon@TELUS.COM>,
	"'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Content-Disposition: inline
In-Reply-To: <3E41A7BC.20209@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--OGLMwEELQbPC02lM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 06, 2003 at 10:09:32AM +1000, Philip Craig wrote:
> No, the masks the helpers currently use are the correct mask
> for what they need.  For example, the ftp helper wants the
> mask to cover the IP address and the TCP port.  The TCP port
> is still only 16 bits regardless of what changes are made to
> the structure, so the mask must still be 0xffff.
>=20
> The problem is that they are storing the mask in the u.all
> member of the union, rather than the specific member that
> they are interested in.  So if the total size of union
> changes, the mask getting stored will no longer match up
> with the appropriate member, depending on endianness and
> padding.
>=20
> The proper fix is what Harald said: zero out the structure, and
> store the mask in the specific member, rather than u.all.
> Once they are fixed properly, they will also work for any
> future changes to the tuple structure.

yes.  David Miller has indicated that he wants us to use
individual-member initialization instead of our '{{{{ }}, }}' stuff.
So maybe this is the time to do the change - or at least use named
initializers like '{ asdf: 0xffff, }'

> Paul Mielke posted a patch a few weeks ago that fixed the ftp
> helper and the SO_ORIGINAL_DST ioctl.

I'll try to find it in the folder, I seem to have overlooked it, thanks.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--OGLMwEELQbPC02lM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Rh9nXaXGVTD0i/8RAgmaAJ9CSY+p1SMpfgT92MWYTX+Nrya9CQCeM37p
9fKH88rVvrXlXc68jBNl6rc=
=zA/b
-----END PGP SIGNATURE-----

--OGLMwEELQbPC02lM--
