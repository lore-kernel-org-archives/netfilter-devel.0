From: netfilter@interlinx.bc.ca
Subject: Re: ip_nat_amanda unresolved symbol
Date: Thu, 17 Oct 2002 12:35:35 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021017163535.GN344@pc.ilinx>
References: <E131E9F1848D0148813EAF06A846608F615F97@w2ks-e2k.iconos.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MsEL38XAg4rx1uDx"
Cc: Filip.Sneppe@cronos.be
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <E131E9F1848D0148813EAF06A846608F615F97@w2ks-e2k.iconos.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MsEL38XAg4rx1uDx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2002 at 01:37:02AM +0200, Sneppe Filip wrote:
>    It seems like the amanda conntracker/nat module depends on some
>    earlier code written by the same author to mangle udp packets.
>    However, that earlier code did not get accepted; see the following
>    mails on netfilter-devel:
>    [2]http://lists.netfilter.org/pipermail/netfilter-devel/2002-August/00
>    9012.html
>    [3]http://lists.netfilter.org/pipermail/netfilter-devel/2002-September
>    /009371.html
>    [4]http://lists.netfilter.org/pipermail/netfilter-devel/2002-August/00
>    8916.html

This is correct.  Harald did not like my implementation, and we came
to an agreement on how to correct it.  Unfortunately, making the
correction has not bubbled to the top of my TODO list (as much as
getting a job has!  :-)

[ Harald, please feel free to correct anything I get wrong here ]

There were two issues.  First, Harald did not like the "multi-mangle"
function that I wrote for UDP.  It was/is at this point an unused
function and a) Harald did not want to bloat the code with an unused
function and b) it would only be used in the rarer of cases and
mulitple calls to the single mangle function would be sufficient.  I
don't necessarily disagree.

The other issue was that my UDP mangle function _always_ calculated a
checksum on the mangled packet, even when it did not have a checksum
prior to mangling.  I have corrected the function to only re-calculate
the checksum when the checksum is 0 (indicated no UDP checksum on the
packet).

>    - get in touch with the author of the amanda conntracker/nat module,
>       because  obviously the patch in p-o-m is of little use to anyone in
>    its
>      current state.

Right.  Stay tuned for a patch to directly follow this e-mail with an
updated patch in it.

b.

--=20
Brian J. Murrell

--MsEL38XAg4rx1uDx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9rubXl3EQlGLyuXARAnToAJ9BbQzxayeB28/BuX100RUW0TXCwgCg5YnF
LK/to9jEo1/X2PNDu5DpXaY=
=PzBW
-----END PGP SIGNATURE-----

--MsEL38XAg4rx1uDx--
