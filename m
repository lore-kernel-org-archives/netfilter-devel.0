From: Sven Schnelle <svens@gmx.de>
Subject: ip_conntrack_standalone / sprintf to buffer
Date: Mon, 23 May 2005 22:50:54 -0700
Message-ID: <87oeb1b29t.fsf@deprecated.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

--=-=-=
Content-Transfer-Encoding: quoted-printable

Hi,

found the following code snippet in ip_conntrack_standalone.c:145
in function conntrack_iterate():
=2D------------------000000------8<-----------------------------
	newlen =3D print_conntrack(buffer + *len, hash->ctrack);
	printk("len + newlen: %d maxlen: %d\n", *len + newlen, maxlen);
	if (*len + newlen > maxlen)
		return 1;
	else *len +=3D newlen;
=2D------------000000------------8<-----------------------------

print_conntrack() uses sprintf without length checking. And now i'm
wondering what happens if for example, maxlen=3D3072 and
len=3D3071. print_conntrack uses sprintf, writes beyond the end the buffer,=
 and
after this the check (*len + newlen > maxlen) is done. Looks to me like
a bug.

Did i missed something?

Bye,

Sven.
=2D-=20
"If you can't make it good, at least make it look good." Bill Gates on
 the solid code base of Win9X


--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBCksDB86MdxiXaIbERAql2AKCOZOysHVWeN4GmPer0dlPK7cTOZACdE8JM
x3aOC2JDuEVx3GH+nSq7LiI=
=57aR
-----END PGP SIGNATURE-----
--=-=-=--
