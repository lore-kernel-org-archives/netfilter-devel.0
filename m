From: <gregkh@suse.de>
Subject: patch netfilter-stable-nf_conntrack_tcp-fix-endless-loop.patch added to 2.6.25-stable tree
Date: Wed, 30 Jul 2008 15:09:42 -0700
Message-ID: <20080730221309.8AC931454459@imap.suse.de>
References: <487F3613.6040708@trash.net>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: kaber@trash.net, davem@davemloft.net, gregkh@suse.de,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:58447 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbYG3WNL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:13:11 -0400
In-Reply-To: <487F3613.6040708@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: netfilter -stable: nf_conntrack_tcp: fix endless loop

to the 2.6.25-stable tree.  Its filename is

    netfilter-stable-nf_conntrack_tcp-fix-endless-loop.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Thu Jul 17 05:08:03 2008
From: Patrick McHardy <kaber@trash.net>
Date: Thu, 17 Jul 2008 14:07:47 +0200
Subject: netfilter -stable: nf_conntrack_tcp: fix endless loop
To: stable@kernel.org
Cc: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
Message-ID: <487F3613.6040708@trash.net>


From: Patrick McHardy <kaber@trash.net>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nf_conntrack_proto_tcp.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -845,9 +845,15 @@ static int tcp_packet(struct nf_conn *ct
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


Patches currently in stable-queue which might be from kaber@trash.net are

queue-2.6.25/netfilter-stable-nf_conntrack_tcp-fix-endless-loop.patch
