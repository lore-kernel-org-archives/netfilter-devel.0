From: Michael Bellion <mbellion@hipac.org>
Subject: Re: [PATCH] x_tables, take 4
Date: Mon, 7 Nov 2005 17:10:56 +0100
Message-ID: <200511071710.56991.mbellion@hipac.org>
References: <20051103191110.GO905@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6294281.3mSrDYULNN";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20051103191110.GO905@sunbeam.de.gnumonks.org>
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

--nextPart6294281.3mSrDYULNN
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

> This is the fourth incarnation of the x_tables patch.  It is now
> compiling clean, and at least those parts that I use in my systems seem
> to work fine.
>
> I want to run this trough nfsim before submitting it mainline.
>
> I dislike the 'void *' pointers we cast for match/targetinfo, but I
> think the advantage of code unification is bigger than some typecasts.
>
> Also, we should think about putting all those match/checkentry/target
> parameters into a structure (which could contain unions to avoid the
> typeasting).  But I think this can happen in a next patch, x_tables
> changes are already large enough.
>
> Please review and comment,

Nice work!

But could you rename it to something without "tables"?
It is not related to tables in any way. It is about function based matches =
and=20
targets, that's why the name "x_tables" is IMHO a bit irritating.

What about the name "x_functions" or something similar?

Best regards
	Michael Bellion

--nextPart6294281.3mSrDYULNN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBDb3yQqKCdDrsF/xIRAll8AJ9H/uPNt0CzPbAhqFoJ9Y0bkBtNWACeI3n2
xUAPtoS8avJQMVK513Kgo60=
=KbYQ
-----END PGP SIGNATURE-----

--nextPart6294281.3mSrDYULNN--
