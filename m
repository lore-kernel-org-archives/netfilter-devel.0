From: Harald Welte <laforge@gnumonks.org>
Subject: [BUG] yet another icmp reply transition bug
Date: Tue, 29 Oct 2002 21:15:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021029211506.A26147@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
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


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi !

While debugging the network problem of a friend of mine, I have discovered
yet another icmp reply transition bug, present in all kernel versions.

Imagine the following setup:

a NAT gateway is situated between two networks with different MTUs. Let's
say 1500 on one side, and 1300 on the other side.

Poor user on the 1300 network initiates a TCP connection to some other end
in the 1500 network.  The other end will start sending 1500-sized datagrams
with DONT_FRAG set.

The NAT gateway will generate an ICMP dest_unreach/frag_needed inside
ip_forward.c, which will hit conntrack and NAT on the NF_IP_LOCAL_OUT
hook.

ip_nat_core.c:icmp_reply_translation() will get called, and in line 916
[ if (info->manips[i].hooknum =3D=3D opposite_hook[hooknum])  ] is evaluate=
d.

If LOCAL_NAT is disabled, opposite_hook doesn't even have an entry for
LOCAL_OUT... yes, we are reading over the end of the array :((

If LOCAL_NAT is enabled, opposite_hook would return NF_IP_LOCAL_IN,
which is not what we want.  The inverse translation needed for the inner
icmp translation happened at NF_IP_PRE_ROUTING!

I'm now heading off to a party, leaving you to think about this *g*.

If there is no reasonable proposal on how to solve this problem, I'll
come up with a solution tomorrow.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9vuxIXaXGVTD0i/8RAoJUAJ0ZWB+6IGsrzHSg8yqVLaWGs9//nACfei6l
Y+jjMBMmdjyhTxP9lvbgv+g=
=UTE3
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
