From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/4] doc: add libnetfilter_queue pointer to libxt_NFQUEUE.man
Date: Mon, 15 Jul 2013 00:30:01 +0200
Message-ID: <1373841002-19071-3-git-send-email-fw@strlen.de>
References: <1373841002-19071-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50936 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab3GNWaQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Jul 2013 18:30:16 -0400
In-Reply-To: <1373841002-19071-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... and remove the QUEUE snippets from iptables man page,
the queue target was replaced by nfqueue years ago.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 ip6tables man page isn't changed since it will be removed by next patch.

 extensions/libxt_NFQUEUE.man | 13 +++++++------
 iptables/iptables.8.in       | 18 +++++-------------
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/extensions/libxt_NFQUEUE.man b/extensions/libxt_NFQUEUE.man
index f11e0c8..956edbe 100644
--- a/extensions/libxt_NFQUEUE.man
+++ b/extensions/libxt_NFQUEUE.man
@@ -1,11 +1,12 @@
-This target is an extension of the QUEUE target. As opposed to QUEUE, it allows
-you to put a packet into any specific queue, identified by its 16-bit queue
-number.
-It can only be used with Kernel versions 2.6.14 or later, since it requires
-the
+This target passes the packet to userspace using the
+\fBnfnetlink_queue\fP handler.  The packet is put into the queue
+identified by its 16-bit queue number.  Userspace can inspect
+and modify the packet if desired. Userspace must then drop or
+reinject the packet into the kernel.  Please see libnetfilter_queue
+for details.
 .B
 nfnetlink_queue
-kernel support. The \fBqueue-balance\fP option was added in Linux 2.6.31,
+was added in Linux 2.6.14. The \fBqueue-balance\fP option was added in Linux 2.6.31,
 \fBqueue-bypass\fP in 2.6.39.
 .TP
 \fB\-\-queue\-num\fP \fIvalue\fP
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 9643705..4279299 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -64,21 +64,14 @@ a `target', which may be a jump to a user-defined chain in the same
 table.
 .SH TARGETS
 A firewall rule specifies criteria for a packet and a target.  If the
-packet does not match, the next rule in the chain is the examined; if
+packet does not match, the next rule in the chain is examined; if
 it does match, then the next rule is specified by the value of the
-target, which can be the name of a user-defined chain or one of the
-special values \fBACCEPT\fP, \fBDROP\fP, \fBQUEUE\fP or \fBRETURN\fP.
+target, which can be the name of a user-defined chain, one of the targets
+described in \fBiptables\-extensions\fP(8), or one of the
+special values \fBACCEPT\fP, \fBDROP\fP or \fBRETURN\fP.
 .PP
 \fBACCEPT\fP means to let the packet through.
 \fBDROP\fP means to drop the packet on the floor.
-\fBQUEUE\fP means to pass the packet to userspace.
-(How the packet can be received
-by a userspace process differs by the particular queue handler.  2.4.x
-and 2.6.x kernels up to 2.6.13 include the \fBip_queue\fP
-queue handler.  Kernels 2.6.14 and later additionally include the
-\fBnfnetlink_queue\fP queue handler.  Packets with a target of QUEUE will be
-sent to queue number '0' in this case. Please also see the \fBNFQUEUE\fP
-target as described later in this man page.)
 \fBRETURN\fP means stop traversing this chain and resume at the next
 rule in the
 previous (calling) chain.  If the end of a built-in chain is reached
@@ -415,8 +408,7 @@ There are several other changes in iptables.
 \fBiptables\-extensions\fP(8),
 \fBip6tables\fP(8),
 \fBip6tables\-save\fP(8),
-\fBip6tables\-restore\fP(8),
-\fBlibipq\fP(3).
+\fBip6tables\-restore\fP(8).
 .PP
 The packet-filtering-HOWTO details iptables usage for
 packet filtering, the NAT-HOWTO details NAT,
-- 
1.8.1.5

