From: Harald Welte <laforge@netfilter.org>
Subject: Re: why not  __MOD_DEC_USE_COUNT when we register match failer?
Date: Wed, 21 Jan 2004 08:47:19 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040121134719.GP8642@obroa-skai.de.gnumonks.org>
References: <20040113041248.GA24062@lepton.goldenhope.com.cn>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aZoGpuMECXJckB41"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: lepton <lepton@sina.com>
Content-Disposition: inline
In-Reply-To: <20040113041248.GA24062@lepton.goldenhope.com.cn>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--aZoGpuMECXJckB41
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2004 at 12:12:48PM +0800, lepton wrote:
> in ipt_state.c (and ipt_helper.c)
>=20
> There is such code in init funciton
> -------------------------------------------
> /* NULL if ip_conntrack not a module */
> if (ip_conntrack_module)
> __MOD_INC_USE_COUNT(ip_conntrack_module);
> return
> 	ipt_register_match(&state_match);
> -------------------------------------------=09
>=20
> I think if ipt_register_match failed for some reason, the use count of
> ip_conntrack_module will increase. Is it not a bug?

yes, I agree.

> I thinks perhaps we should use such code:

Would you mind preparing a patch for those fixes?

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--aZoGpuMECXJckB41
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFADoLnXaXGVTD0i/8RApgFAJ4wrQrfTwJ/CCtpqSvv5AjlHQyH8gCdHwA1
hGIBrG/K5eMyHv7koBKu2Jk=
=Hn6t
-----END PGP SIGNATURE-----

--aZoGpuMECXJckB41--
