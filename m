From: Patrick McHardy <kaber@trash.net>
Subject: netfilter -stable: nf_conntrack_tcp: fix endless loop
Date: Thu, 17 Jul 2008 14:07:47 +0200
Message-ID: <487F3613.6040708@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070607070706090102090103"
Cc: "David S. Miller" <davem@davemloft.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54226 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbYGQMH4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2008 08:07:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070607070706090102090103
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch for 2.6.25.x fixes a race condition between TCP conntrack
and ctnetlink that can lead to an endless loop.

Please apply, thanks.


--------------070607070706090102090103
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit e85c8c076640e9cd42fb52f27fea16f74b236626
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Jul 17 14:06:16 2008 +0200

    netfilter: nf_conntrack_tcp: fix endless loop
    
    Upstream commit 6b69fe0:
    
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
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 6256795..73cef18 100644
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

--------------070607070706090102090103--
