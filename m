From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] snort hex strings and libipt_string.c (revisited)
Date: Wed, 26 Feb 2003 18:27:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226172713.GI8883@sunbeam.de.gnumonks.org>
References: <20030218180344.B23930@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nOM8ykUjac0mNN89"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Rash <mbr@cipherdyne.com>
Content-Disposition: inline
In-Reply-To: <20030218180344.B23930@orthanc.gambrl01.md.comcast.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--nOM8ykUjac0mNN89
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2003 at 06:03:44PM -0500, Michael Rash wrote:

Ok, just forget about my last mail.  I should read netfilter-devel more
often ;)

> Ok, after thinking about it a bit more I removed the --hex-string
> option in favor of a more flexible strategy.  Snort signatures can
> have content fields that mix both ascii and hex strings like so:

great. I'll apply your patch to cvs right now.
=20
> BTW, snort2iptables was the inspiration for this patch.  Thanks
> for the great original idea!

Of course this all is a big hack.  What you should be doing if you
really want to do massive string/pattern searching in the kernel is
something like libqsearch for the kernel

(http://www.cartel-securite.fr/pbiondi/libqsearch.html)

> Michael Rash

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nOM8ykUjac0mNN89
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+XPjxXaXGVTD0i/8RAghKAJ9w/oI56XJk0uVenmphzAWtICE1KgCfTNdc
w9oRr9iHdX+nv46JiVWRmm4=
=kiLv
-----END PGP SIGNATURE-----

--nOM8ykUjac0mNN89--
