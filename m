From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 0/3]  [RFC] fixed duration connection
Date: Tue, 04 Apr 2006 10:33:39 +0200
Message-ID: <1144139619.5186.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-22sPSOySZF3/Gisn7KQ7"
Cc: nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--=-22sPSOySZF3/Gisn7KQ7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

While working on NuFW development branch, we have had to
implement policy just as :
      * connection to server is authorised from 08h to 18h and
        connection must be switched off at 18h.

Such features are frequently asked by customers or netfilter addicts but
even with current conntrack related code, it can not be done cleanly.

Thus, we've added the notion of fixed duration before expiration to
connection in the conntrack. (See extended information on bottom for
details)

The following set of patches is against kernel (linus git tree),
libnetfilter_conntrack, and conntrack tool.

-- Extended --

When trying to implement this feature with current connection tracking
code, we have faced some issues :
     1. userspace code has to duplicate conntrack entries, thus it's
        complex and uses memory
     2. there is no hope to have it done by a simple command line
        (because of 1.)
     3. if replication of conntrack in userspace is needed there will be
        many synchronisation problems : stop and start of an
        hypothetical "expiration" daemon would cause conntrack
        duplication and/or loss of information ...

For this reason, we've worked on a simple kernel level implementation.
This is done via a second "struct timer" that is added in connection
structure. Activation of the timer, is for now done via userspace by
using libnetfilter_conntrack or by using new option -T of the conntrack
tool.

This kernel implementation could easily lead to a new iptables target in
the future.

This is a resend of patch :
http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3289
It adds support for nf_conntrack.

Best regards,
--
Eric Leblond <regit@inl.fr> for the NuFW Core Team
NuFW : http://www.nufw.org/

--=-22sPSOySZF3/Gisn7KQ7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBEMi9jnxA7CdMWjzIRAlc9AJsFULFPgPYzWmOW5Jnylf0Eh1SU7wCfan07
TMStuoZnVZPCPWv34KgJrjY=
=Napl
-----END PGP SIGNATURE-----

--=-22sPSOySZF3/Gisn7KQ7--
