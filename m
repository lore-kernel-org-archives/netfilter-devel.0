From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: INVALID state incorrectly explained in iptables.8 manpage
Date: 28 Jun 2003 12:41:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056796902.1233.25.camel@elendil.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: gkweb <gkweb@wanadoo.fr>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all !

INVALID state is described as follow in iptables.8 manpage (from
iptables 1.2.8 tarball) :

   state
	This module, when combined with connection tracking, allows
	access  to the connection tracking state for this packet.
                                                                         =
      =20
	--state state
		Where  state  is a comma separated list of the
		connection states to match. Possible states are INVALID
		meaning that the packet is associated with no known
		connection, ESTABLISHED meaning that the packet is
		associated with a connection which has seen packets in
		both directions, NEW meaning that the packet has started
		a new connection, or otherwise associated with a
		connection which has not seen packets in both
		directions, and RELATED meaning that the packet is
		starting a new connection, but is associated  with an
		existing connection, such as an FTP data transfer, or an
		ICMP error.

Describing INVALID state as "associated with no known connection" can
fool people as it does not seem the same to me than the Filtering HOWTO
description, which I know is good ;)

     INVALID
        A packet which could not be identified for some reason: this
        includes running out of memory and ICMP errors which don't
        correspond to any known connection.  Generally these packets
        should be dropped.

What do you think of including this definition into man page ?

   state
	This module, when combined with connection tracking, allows
	access  to the connection tracking state for this packet.
                                                                         =
      =20
	--state state
		Where  state  is a comma separated list of the
		connection states to match. Possible states are INVALID
		meaning that the packet could not be identified for some
		reason which includes running out of memory and ICMP
		errors which don't correspond to any known connection
		ESTABLISHED meaning that the packet is associated with a
		connection which has seen packets in both directions,
		NEW meaning that the packet has started	a new
		connection, or otherwise associated with a connection
		which has not seen packets in both directions, and
		RELATED meaning that the packet is starting a new
		connection, but is associated  with an existing
		connection, such as an FTP data transfer, or an	ICMP
		error.

--=20
C=E9dric Blancher  <blancher@cartel-securite.fr>
IT systems and networks security - Cartel S=E9curit=E9
Phone : +33 (0)1 44 06 97 87 - Fax: +33 (0)1 44 06 97 99
PGP KeyID:157E98EE  FingerPrint:FA62226DA9E72FA8AECAA240008B480E157E98EE
