From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] snort hex strings and libipt_string.c
Date: Wed, 26 Feb 2003 18:24:33 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226172433.GH8883@sunbeam.de.gnumonks.org>
References: <20030218101418.A11762@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FwyhczKCDPOVeYh6"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Rash <mbr@cipherdyne.com>
Content-Disposition: inline
In-Reply-To: <20030218101418.A11762@orthanc.gambrl01.md.comcast.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--FwyhczKCDPOVeYh6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2003 at 10:14:18AM -0500, Michael Rash wrote:
> (Reposting since I was not subscribed to the list at the time.)

This is not a problem, all mail from non-subscribes goes through manual
moderation (by me).

> The attached patch adds an option "--hex-string" to the string match
> module to allow snort-style hex strings to be specified on the
> command line.  This is useful because there are many signatures that
> consist of non-printable characters and without this patch there is
> no way to easily tell iptables to search for them.

please follow the coding style (8char wide tabs, ...) when creating
patches.  It looks awful if parts of the code in the same file follow
different coding style.

Can you plese fix this cosmetic issue and resubmit?

> --Mike
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FwyhczKCDPOVeYh6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+XPhRXaXGVTD0i/8RAnwHAJ9nHypSaELi+2UItQiSKnWVqGzDNwCeLPbk
WMsZ8cZmW1NAeYdFOlui1L0=
=i5PT
-----END PGP SIGNATURE-----

--FwyhczKCDPOVeYh6--
