From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] iptables/conntrack in enterprise environment.
Date: Fri, 30 May 2003 10:08:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030530080806.GB29312@sunbeam.de.gnumonks.org>
References: <200305290113.58552.prez@srealm.net.au> <20030529083953.GB2461@sunbeam.de.gnumonks.org> <200305290810.16531.prez@srealm.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org,
	coreteam@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Preston A. Elder" <prez@srealm.net.au>
Content-Disposition: inline
In-Reply-To: <200305290810.16531.prez@srealm.net.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2003 at 08:09:52AM -0400, Preston A. Elder wrote:
> 752_iptables-10_confirm_fix
>=20
> Please let me know if you think one is missing I should try.

no, the above one is what I was talking about.

> > With a non-broken kernel it is 2 minutes, that is TIME_WAIT of a TCP
> > socket.
> That was not my point.  My point was, for up to 5 days later, the
> system still has entries in the conntrack table (listed as
> 'ESTABLISHED'), which have been dead and gone for a long time,
> conntrack does not realise that connection is utterly closed, and it
> should drop its conntrack entry.  I'm not as worried about the
> lower-value timeouts, but as I said, I saw ALOT of established
> connections hanging around in the conntrack table (making the
> conntrack table about 200,000 entries long, give or take), most of
> which were entries for connections already closed.

This is exactly the behaviour shown by kernels that have not the above bug =
fix
applied.=20

Can you please verify that this is indeed a conntrack bug?  Can you do
some tcpdump capturing that actually shows that there was a connection
teardown (FIN handshake or RST) and after it, conntrack state of the
respective connection stays ESTABLISHED?

I just want to make sure that this is really some problem about a
possible conntrack bug - not some application that forgets to fully
close TCP connections..

> Systems Administrator
> Shadow Realm

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+1xFmXaXGVTD0i/8RAvE4AJ9LuWBvF8i15Ia7AMNRxX6IKj7AFwCggWSV
a8KWtoThKDsM5tUPpe4oorE=
=lmWB
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
