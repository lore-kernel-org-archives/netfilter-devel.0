From: Harald Welte <laforge@gnumonks.org>
Subject: Re: limit rule on sparc-linux
Date: Thu, 9 Jan 2003 21:00:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030109200050.GO1353@sunbeam.de.gnumonks.org>
References: <20030109085840.GA1086@netswarm.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L5nTHegdhbHhzmSD"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Christian Birchinger <joker@netswarm.net>
Content-Disposition: inline
In-Reply-To: <20030109085840.GA1086@netswarm.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--L5nTHegdhbHhzmSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09, 2003 at 09:58:40AM +0100, Christian Birchinger wrote:
> Hello
> Is there a known patch for the non-working limit rule on
> sparc/linux? The last version Kernel i've tested is 2.4.20
> and it still refuses limit rules.

yes, patch has been posted very recently on this list.  However, I'm
still not sure that this is the solution we will finally implement.

btw: please always indicate that you are talking about sparc64 linux.
sparc32 should work straight ahead.

> --=20
> Christian Birchinger

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--L5nTHegdhbHhzmSD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HdTyXaXGVTD0i/8RAj9zAKCi1SSDTekEeFkXTNV1IaOn59bRbwCfeauY
HzKYo2hemLYcFRvytUPyRik=
=bJuV
-----END PGP SIGNATURE-----

--L5nTHegdhbHhzmSD--
