From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] [PATCH] clean up nf_log API
Date: Thu, 11 May 2006 10:25:55 +0200
Message-ID: <20060511082555.GB10324@sunbeam.de.gnumonks.org>
References: <20060510191034.GA29531@sunbeam.de.gnumonks.org>
	<4462E031.4090206@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4462E031.4090206@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 11, 2006 at 08:56:49AM +0200, Patrick McHardy wrote:

> That all sounds very reasonable. How is the priority of a backend
> determined?

statically.  nfnetlink_log overrules ULOG, which overrules LOG.

We could make that configurable, but I think that's too much
flexibility.  If a user _wants_ a specific backend, he can chose it. if
not, we'll fallback on something.

> > a) we only search for 'fallback' backends during unregistration/unbind.
> >    Should we also do this during registration?  Or whenever we receive
> >    a packet and don't have a backend?  Early registration might become
> >    problematic, since we don't really know what the user wants...
>=20
> I think after each change we should just search for the highest priority
> backend and use that.

ok, that's what the code does now.

> > b) reference counting.  We could actually get_module / put_module the
> >    module that implements a specific backend rather than using our own
> >    use counter.
>=20
> I guess it depends on whether we want to block unloading while it is
> in use or do automatic fallback. I tend to prefer the later.

I agree, I prefer automatic fallback while giving the user the ability
to unload.  However, if people automatically unload 'unused' modules,
then there might be a problem (however, for both ULOG and nfnetlink_log,
userspace listeners would increment the refcount, I think).

Also, there is another unresolved problem:  What if we actually have
e.g. nfnetlink_log loaded, but it is unable to send a specific packet to
userspace because there is no listener for this Address family or log
group?   Should we then also fall back on some other backend?

At the moment we only fall back if a backend is unbound, but not if it
e.g. returns an error code because it was unable to log a specific
packet.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEYvUTXaXGVTD0i/8RAsVzAKCVSXCcB79m0XfaYCfXNtbq3Y0WeACdFPBL
WOIpbNjVCKg9jju4X+QEPoQ=
=MQB4
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
