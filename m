From: Harald Welte <laforge@netfilter.org>
Subject: Re: IPT_RETURN is not worked in the kernel 2.6.10
Date: Thu, 22 Sep 2005 14:59:57 +0200
Message-ID: <20050922125957.GK26520@sunbeam.de.gnumonks.org>
References: <007001c5bf37$55629e00$aa0ba8c0@l7.com.tw>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ed/6oDxOLijJh8b0"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Vincent <cs83152@csie.chu.edu.tw>
Content-Disposition: inline
In-Reply-To: <007001c5bf37$55629e00$aa0ba8c0@l7.com.tw>
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


--ed/6oDxOLijJh8b0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 22, 2005 at 01:34:37PM +0800, Vincent wrote:
> Sorry, after understanding the meaning of ipt_do_table function. I know
> currently the IPT_RETURN is only available in the standard target.=20
> But I wonder why don't we have the IPT_RETURN in the user defined
> target?=20

> Can we create a IPT_RETURN in the user defined target. So that we can
> use the IPT_RETURN in our target to return to the upper chain.

I don't see that much of a problem with it.  It should work if you copy
the "if (v !=3D IPT_RETURN)" block from the "if
(!t->u.kernel.target->target)" block to the "else" section.

Please test and submit a proposed patch. =20

And please don't repost your messages thrice to this list, thanks.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ed/6oDxOLijJh8b0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDMqrNXaXGVTD0i/8RArgOAKCPt0gc0dHLrBrxzI9YQgvxfvJNJACfRjeE
wdOr5BlJ8DBy6SW2MZGCGzc=
=QI4S
-----END PGP SIGNATURE-----

--ed/6oDxOLijJh8b0--
