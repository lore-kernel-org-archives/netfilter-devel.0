From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] Re: INVALID state incorrectly explained in iptables.8 manpage
Date: Sat, 28 Jun 2003 13:00:51 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0306281258150.11999@dns.toxicfilms.tv>
References: <1056796902.1233.25.camel@elendil.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@lists.netfilter.org, gkweb <gkweb@wanadoo.fr>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric Blancher <blancher@cartel-securite.fr>
In-Reply-To: <1056796902.1233.25.camel@elendil.intranet.cartel-securite.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

> What do you think of including this definition into man page ?
I would agree, it sounds better, here is a patch.

> Cédric Blancher  <blancher@cartel-securite.fr>
Maciej


diff -u netfilter.orig/userspace/iptables.8 netfilter/userspace/iptables.8
--- netfilter.orig/userspace/iptables.8	2003-05-24 13:44:18.000000000 +0200
+++ netfilter/userspace/iptables.8	2003-06-28 12:56:42.000000000 +0200
@@ -610,7 +610,9 @@
 Where state is a comma separated list of the connection states to
 match.  Possible states are
 .B INVALID
-meaning that the packet is associated with no known connection,
+meaning that the packet could not be identified for some reason which
+includes running out of memory and ICMP errors which don't correspond to any
+known connection,
 .B ESTABLISHED
 meaning that the packet is associated with a connection which has seen
 packets in both directions,
