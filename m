From: Harald Welte <laforge@gnumonks.org>
Subject: [RFC]: ip_conntrack breaks UDP PMTU
Date: Fri, 14 Feb 2003 09:06:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030214080612.GN14794@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6iqOn7HZPWKXx18"
Cc: coreteam@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--d6iqOn7HZPWKXx18
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=3D48

> ip_conntrack defrags packets at PRE_ROUTING and LOCAL_OUT and
> refragments them at POST_ROUTING without careing about IP_DF. packets
> with IP_DF|IP_MF can be refragmented with a different size, so path
> mtu discovery is broken.  Linux nfs itself sends out packets with
> IP_DF|IP_MF.
>
> ------- Additional Comments From Harald Welte 2003-02-14 09:02 -------
>
> This is a really hard issue.=20
>
> The problem is that we _need_ to defragment at NF_IP_PRE_ROUTING in
> order to have the be able to do connection tracking.  So at this point
> we would need to save the sizes of all individual fragments.  This
> would enable us to re-fragment to exactly the same size at
> POST_ROUTING.=20
>
> Another obvious approach was to check for IP_DF and see if it is
> bigger than the MTU of the outgoing interface.  The problem is: before
> we do conntrack at NF_IP_PRE_ROUTING we don't know what potential NAT
> bindings apply to this connection/packet - and thus don't know the
> outgoing interface [that's why it's called PRE_ROUTING].
>
> And then, what happens if NAT has to resize (enlarge/shrink) a packet.
> How should we deal with this while re-fragmenting?=20
>
> I think this needs some good discussion at netfilter-devel...

So what are we going to do?  Does anybody have an alternative (viable?)
approach? =20

And if we go for my first propsal, how/where would we store the
list-of-fragment-sizes?  We certainly don't want it to be dynamically
allocated... but according to RFC791 there kan be 8192 fragments of 8
octets each...

:((

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--d6iqOn7HZPWKXx18
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+TKN0XaXGVTD0i/8RAmv6AJ0f09wAook0+T9ZqghpamMKyymTYACdHFWG
gXx1u85ykOz3KKUYBTCqVGE=
=MSXZ
-----END PGP SIGNATURE-----

--d6iqOn7HZPWKXx18--
