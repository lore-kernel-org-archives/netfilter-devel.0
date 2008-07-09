From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 01/02: nf_conntrack_tcp: fix endless loop
Date: Wed, 09 Jul 2008 18:46:27 +0200
Message-ID: <4874EB63.6090304@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040308020109040600040008"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33213 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbYGIQq3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:46:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040308020109040600040008
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

following is a bugfix for an endless loop in TCP conntrack triggered
by a rare race condition, as well as a fix for a warning introduced
by the SNMP ASN.1 parser fixes. The first one is of course also a
-stable candidate.

Please apply, thanks.


  net/ipv4/netfilter/nf_nat_snmp_basic.c |    2 +-
  net/netfilter/nf_conntrack_proto_tcp.c |   10 ++++++++--
  2 files changed, 9 insertions(+), 3 deletions(-)

David Howells (1):
       netfilter: nf_nat_snmp_basic: fix a range check in NAT for SNMP

Patrick McHardy (1):
       netfilter: nf_conntrack_tcp: fix endless loop

--------------040308020109040600040008
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

netfilter: nf_conntrack_tcp: fix endless loop

When a conntrack entry is destroyed in process context and destruction
is interrupted by packet processing and the packet is an attempt to
reopen a closed connection, TCP conntrack tries to kill the old entry
itself and returns NF_REPEAT to pass the packet through the hook
again. This may lead to an endless loop: TCP conntrack repeatedly
finds the old entry, but can not kill it itself since destruction
is already in progress, but destruction in process context can not
complete since TCP conntrack is keeping the CPU busy.

Drop the packet in TCP conntrack if we can't kill the connection
ourselves to avoid this.

Reported by: hemao77@gmail.com [ Kernel bugzilla #11058 ]
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit baa04a1fb3dbef550ed1dc5acd15e21e7dde3b85
tree 94334a28c9db60981a72478b18d54fccd353f7ff
parent 32e8d4948bb0b5f3f0ac5cdb71d0ac8e305b29a5
author Patrick McHardy <kaber@trash.net> Wed, 09 Jul 2008 18:32:29 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 09 Jul 2008 18:32:29 +0200

 net/netfilter/nf_conntrack_proto_tcp.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 271cd01..dd28fb2 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -844,9 +844,15 @@ static int tcp_packet(struct nf_conn *ct,
 			/* Attempt to reopen a closed/aborted connection.
 			 * Delete this connection and look up again. */
 			write_unlock_bh(&tcp_lock);
-			if (del_timer(&ct->timeout))
+			/* Only repeat if we can actually remove the timer.
+			 * Destruction may already be in progress in process
+			 * context and we must give it a chance to terminate.
+			 */
+			if (del_timer(&ct->timeout)) {
 				ct->timeout.function((unsigned long)ct);
-			return -NF_REPEAT;
+				return -NF_REPEAT;
+			}
+			return -NF_DROP;
 		}
 		/* Fall through */
 	case TCP_CONNTRACK_IGNORE:

--------------040308020109040600040008--
