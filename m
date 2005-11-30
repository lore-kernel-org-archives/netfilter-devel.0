From: Stephen Frost <sfrost@snowman.net>
Subject: Re: [RESEND][PATCH] Recent match jiffies wrap mismatches
Date: Wed, 30 Nov 2005 14:13:22 -0500
Message-ID: <20051130191321.GS6026@ns.snowman.net>
References: <20051129050813.GA30630@linuxace.com> <438CDE4E.8070006@trash.net>
	<20051129235159.GA3680@linuxace.com> <438D5825.2070304@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xouvI93GL9moT7Vn"
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <438D5825.2070304@trash.net>
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


--xouvI93GL9moT7Vn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Patrick McHardy (kaber@trash.net) wrote:
> Or better some serious rewriting .. its a pile of junk.

Feel free, it's really not all that complicated.  It should be made part
of the ipset stuff though, really.  I kept hearing ipset was going to be
built in such a way so it'd be easy to incorporate things like
ipt_recent but I havn't had a chance to really look at it lately.  Last
time I looked, the new ipset was still very much 'under construction'
but I gather the new version has been incorporated now.

Sorry for the assumptions about jiffies but that's certainly an area
that likes to change every other month in the kernel and I expect the
API for them will change yet again (along with what assumptions can be
made about them).

	Enjoy,

		Stephen

--xouvI93GL9moT7Vn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDjfnRrzgMPqB3kigRAncgAJ9PWtlGi2mFpvVASPFGjpuUOQUTqgCdHXf6
KQas+C7/Eq9oqKXnxWp+fI8=
=SV+k
-----END PGP SIGNATURE-----

--xouvI93GL9moT7Vn--
