From: Eric Leblond <eric@inl.fr>
Subject: [feature request] Fixed timeout for conntrack entry
Date: Mon, 23 Jan 2006 10:24:25 +0100
Message-ID: <1138008265.11978.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-0QHeOUCxmNW/H7D8ffoz"
Cc: nufw-core-team@nufw.org
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


--=-0QHeOUCxmNW/H7D8ffoz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

The current libconntrack is for now able to set the standard conntrack
timeout. I think it should be useful to be able to set a fixed conntrack
timeout from userspace to be able to define an efficient connection
expiration policy.

What do you think of this idea ?

Expanded version :

When working on NuFW (http://www.nufw.org), we had to use libconntrack
to kill some entry at a given time. In fact, we use it to be able to
have connections that expire at a given time. At the same time we use
event handling system to be warned of connections that were closed
before their expiration by the users.

This works well but there is a synchronisation problem because when the
NuFW daemon restart you have to synchronise to handle events that have
occur during shutdown :
Let's have a connection and let it die when the daemon is off. When
daemon restart, it could ask kernel to close this connection but it
could then be another existing connection (with the same IPV4 or id
parameters). Arghh ...

Even if it can be done with current functionnalities of conntrack
(dumping conntrack table to daemon at start), it seems that this is not
the cleanest way to do.

In fact, connection expiration is often a user requested feature
(independantly of userspace system) and it could be great to have it
hard wired in the kernel. For example, an iptables match and target
could use it.

=46rom a developpement point of view it seems that this is a "small"
modification of code. It could be done by adding a test when refreshing
standard connection entry timeout (when receiving a packet) and testing
if the connection must be destroy and destroy it if needed ?

Here's some questions :
      * Is this a good idea ?
      * Is there anyone interested in coding it ? (If not I can try to
        do it myself)
      * Is there a chance to have into mainstream ?

BR,
--=20
Eric Leblond <eric@inl.fr>

--=-0QHeOUCxmNW/H7D8ffoz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBD1KDInxA7CdMWjzIRAiwhAKCKsTvcz25iDJlsilywdBKt//fznwCeN0fm
3nXKEc1oUVnPK8TjYU4bv+c=
=G6fy
-----END PGP SIGNATURE-----

--=-0QHeOUCxmNW/H7D8ffoz--
