From: Harald Welte <laforge@netfilter.org>
Subject: Re: IP Options with libipq
Date: Wed, 21 Jan 2004 08:44:11 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040121134410.GO8642@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.44.0401171737300.10400-100000@filer.marasystems.com> <40093097.7010902@plobe.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2hMgfIw2X+zgXrFs"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: XiChimos <xichimos@plobe.com>
Content-Disposition: inline
In-Reply-To: <40093097.7010902@plobe.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--2hMgfIw2X+zgXrFs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 17, 2004 at 07:54:47AM -0500, XiChimos wrote:
> I hate to repost, but I still need help.  I need to use libipq to add=20
> and remove an IP option defined by me.  I am working from the sample in=
=20
> the man page and also samples from the CVS tools folder.  Does anyone=20
> have *any* idea how to do this?

where's the exact problem?  You get the packet via
ipq_read()/ipq_get_packet(), then modify it according to your needs, and
send it back via ipq_set_verdict(handle, id, NF_ACCEPT, new_len,
buffer).

> Chris

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--2hMgfIw2X+zgXrFs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFADoIqXaXGVTD0i/8RAlpoAJwLktCnP+Md6Z3/X2VmNBvTJuR+lgCgprvf
ET+iKbhXpeaLNIfCYCNZVh4=
=Al3K
-----END PGP SIGNATURE-----

--2hMgfIw2X+zgXrFs--
