From: Stephen Frost <sfrost@snowman.net>
Subject: Re: [testsuite] ipt_recent
Date: Thu, 30 Dec 2004 09:18:57 -0500
Message-ID: <20041230141857.GH10437@ns.snowman.net>
References: <41D39D3A.8050308@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x5Jc+KxZ0sNxpb2X"
Cc: Rusty Russell <rusty@rustcorp.com.au>, netfilter-devel@lists.netfilter.org,
        Nicolas Bouliane <nib@cookinglinux.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samuel <sj-netfilter@cookinglinux.org>
Content-Disposition: inline
In-Reply-To: <41D39D3A.8050308@cookinglinux.org>
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


--x5Jc+KxZ0sNxpb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Samuel (sj-netfilter@cookinglinux.org) wrote:
> Here's the testcase for the ipt_recent module.

Hey, that's kinda neat (that you can write a testcase like that :).

> Note that it really doesn't behave like I think it should.

I'm guessing you're referring to the 'FIXME'/'BUG' things below?

> # Test #4: Using --hitcount in solo limiting 5 packets & more.
> # We expect to NF_DROP 5th and 6th packet. IMO
> #
> # FIXME: Actually it only drops 6th packet. Shouldn't this
> #			acts the same on 5th packet ?
> echo iptables -I INPUT -m recent --name testcase --rsource \
> 	--hitcount 5 --rcheck -j DROP
> echo iptables -A INPUT -m recent --name testcase --set --rsource -j ACCEPT
>=20
> for pkt in 1 2 3 4 5; do # The 4 packets we send + an unexpected 5th
> 	echo expect gen_ip hook:NF_IP_LOCAL_IN iptable_filter NF_ACCEPT '*'
> 	echo gen_ip IF=3Deth0 192.168.0.2 192.168.0.1 0 17 1 2
> done

Well, you're using --rcheck and --set, and the --set is coming *after*
the --rcheck.  --rcheck doesn't change anything, so when packet #5 comes
through the '--set' has been done *4* times.  It isn't until packet #5
passes --set that the hitcount for that packet becomes 5.  It's an
interesting thing to think about as to if --update should behave the
same way or not.  At the moment it does because the
--update/modification logic is after the --update/check logic.  That
wouldn't be too hard to change, but then that'd end up producing
different results than the --rcheck/--set above, which I'm not sure I
like.

Hope that helps.  Were there any other issues?  Looked like everything
else was correct, but I might have missed something.

	Stephen

--x5Jc+KxZ0sNxpb2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB1A5RrzgMPqB3kigRAi3sAJ9XSU8hWcIK2OdGkQ7mCNiZL3MtCwCgl6LN
sjESqtUlGt7y+QEgd4wxuSI=
=hoa6
-----END PGP SIGNATURE-----

--x5Jc+KxZ0sNxpb2X--
