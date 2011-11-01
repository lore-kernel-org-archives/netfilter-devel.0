From: pablo@netfilter.org
Subject: [PATCH 06/14] ipvs: secure_tcp does provide alternate state timeouts
Date: Tue,  1 Nov 2011 10:11:28 +0100
Message-ID: <1320138696-28048-7-git-send-email-pablo@netfilter.org>
References: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Simon Horman <horms@verge.net.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37241 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab1KAJMG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:12:06 -0400
In-Reply-To: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Simon Horman <horms@verge.net.au>

Also reword the test to make it read more easily (to me)

Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/ipvs-sysctl.txt |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/ipvs-sysctl.txt b/Documentation/networking/ipvs-sysctl.txt
index 1dcdd49..13610e3 100644
--- a/Documentation/networking/ipvs-sysctl.txt
+++ b/Documentation/networking/ipvs-sysctl.txt
@@ -140,13 +140,11 @@ nat_icmp_send - BOOLEAN
 secure_tcp - INTEGER
         0  - disabled (default)
 
-        The secure_tcp defense is to use a more complicated state
-        transition table and some possible short timeouts of each
-        state. In the VS/NAT, it delays the entering the ESTABLISHED
-        until the real server starts to send data and ACK packet
-        (after 3-way handshake).
+	The secure_tcp defense is to use a more complicated TCP state
+	transition table. For VS/NAT, it also delays entering the
+	TCP ESTABLISHED state until the three way handshake is completed.
 
-        The value definition is the same as that of drop_entry or
+        The value definition is the same as that of drop_entry and
         drop_packet.
 
 sync_threshold - INTEGER
-- 
1.7.2.5

