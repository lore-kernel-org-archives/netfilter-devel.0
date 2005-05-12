From: Stephen Frost <sfrost@snowman.net>
Subject: Re: [PATCH] ipt_recent fixes
Date: Thu, 12 May 2005 08:18:05 -0400
Message-ID: <20050512121805.GX30011@ns.snowman.net>
References: <87ll6o1pbi.fsf@blackdown.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CpBQqYjq/d0HQTAP"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew Morton <akpm@osdl.org>, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <87ll6o1pbi.fsf@blackdown.de>
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


--CpBQqYjq/d0HQTAP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Juergen Kreileder (jk@blackdown.de) wrote:
> This patch fixes the problem by using get_seconds() instead of
> jiffies.  It also fixes some 64-bit issues.

This looks alright to me, provided get_seconds() doesn't mind being
called under the locks being held by ipt_recent at that time.  Of
course, it also needs to be fast.

	Thanks,

		Stephen

--CpBQqYjq/d0HQTAP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCg0l8rzgMPqB3kigRAizAAKCTRFixgFj1no/GclFQnnMYbdSmBACfeyVA
i1cei7MtFKY8GaqgKoeHzoA=
=2jUz
-----END PGP SIGNATURE-----

--CpBQqYjq/d0HQTAP--
