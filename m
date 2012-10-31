From: Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH V2 2/3] Remove VLAIS usage from gadget code
Date: Wed, 31 Oct 2012 15:28:38 +0200
Message-ID: <20121031132838.GQ10998@arwen.pp.htv.fi>
References: <1351631937-21455-1-git-send-email-behanw@converseincode.com>
 <1351631937-21455-3-git-send-email-behanw@converseincode.com>
Reply-To: <balbi-l0cyMroinI0@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gV1yUYniiDLxW66s"
Cc: <balbi-l0cyMroinI0@public.gmane.org>, <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Behan Webster <behanw-k/hB3zQhLwledRVtV/plodBPR1lH4CV8@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1351631937-21455-3-git-send-email-behanw-k/hB3zQhLwledRVtV/plodBPR1lH4CV8@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

--gV1yUYniiDLxW66s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Tue, Oct 30, 2012 at 05:18:56PM -0400, Behan Webster wrote:
> The use of variable length arrays in structs (VLAIS) in the Linux Kernel =
code
> precludes the use of compilers which don't implement VLAIS (for instance =
the
> Clang compiler). This patch instead calculates offsets into the kmalloc-ed
> memory buffer using macros from valign.h.
>=20
> Signed-off-by: Behan Webster <behanw-k/hB3zQhLwledRVtV/plodBPR1lH4CV8@public.gmane.org>

this won't apply after the current cleanups I applied to gadget code
=66rom Sebastian.

If someone takes this patch, it will generate a series of annoying,
hard-to-figure-out conflicts (at least judging by the looks of
$SUBJECT).

--=20
balbi

--gV1yUYniiDLxW66s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkSeGAAoJEIaOsuA1yqREkmkP/0p2f4qdD0jfl3t5fmKjbEbs
xMWmFQw/lE0VH8EVzgYVLqOD63TeBnztKlNXZ4Riwl9ntk2pMx72+9HihYYE36OI
wXppqGbAcFfMtUFlu3jBGPlh4CcSYLI2tG2OCukkqOfK2tjE1tUnTZf7lPVC3SYA
kCy5P4WCGDwUXIaOh47k+ocPtS/JlM33oDc68lPsIFQwKf1JurUASOSbr3+cdr6J
rLt1aoeofuKfngzG8YQQPKgIrsRVqhaHP1uQawLW8zUOFr1UYQKf5oImXAYd3zCD
Z8Dy8fzmwboFt41RkFfV7e95XWYlsgXIuXjV8vcO7/vPDQygpHti/bSKUcMPgyf2
/Ks1bIfNuFBqCPGV5YGyWNst4LuFxG1vWgr0AdzSw0COG6MjrV4axuoL9o/RyPPq
Sg88NT3n8LLOG8u71e2ETRC5IaTWtuD3kUsPXkCpw/MP2A4UOxqcwEcrhZvYHtph
yRvKAHb3aUCsSXMW1na/AWnJzWK9l1qiiDAHK9UP72Net+UGFiPxSKj3w2ixONcp
05oxmKLB/DIb90F2oSfqIWNMlXgxTpykhaOCzWcKdMA8GY6Dhw7xuboprhgwzC3n
AjfF1Pfqds7MkbeGo2YxvyO9WNjwqhb/znsZTishd95Nvr4PIdKK3EeIs+E40cVp
y5HOH7YV0wUxl8ja6UV1
=lsOs
-----END PGP SIGNATURE-----

--gV1yUYniiDLxW66s--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
