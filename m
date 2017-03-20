From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/22] ipvs: Document sysctl pmtu_disc
Date: Mon, 20 Mar 2017 11:08:48 +0100
Message-ID: <1490004530-9128-21-git-send-email-pablo@netfilter.org>
References: <1490004530-9128-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52112 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754074AbdCTKJq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2017 06:09:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ADC2F5233F
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:09:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E7BDDA7E9
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:09:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 608A1DA86F
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 11:09:16 +0100 (CET)
In-Reply-To: <1490004530-9128-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Hangbin Liu <liuhangbin@gmail.com>

Document sysctl pmtu_disc based on commit 3654e61137db ("ipvs: add
pmtu_disc option to disable IP DF for TUN packets").

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 Documentation/networking/ipvs-sysctl.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/networking/ipvs-sysctl.txt b/Documentation/networking/ipvs-sysctl.txt
index a6feecd467cd..056898685d40 100644
--- a/Documentation/networking/ipvs-sysctl.txt
+++ b/Documentation/networking/ipvs-sysctl.txt
@@ -175,6 +175,14 @@ nat_icmp_send - BOOLEAN
         for VS/NAT when the load balancer receives packets from real
         servers but the connection entries don't exist.
 
+pmtu_disc - BOOLEAN
+	0 - disabled
+	not 0 - enabled (default)
+
+	By default, reject with FRAG_NEEDED all DF packets that exceed
+	the PMTU, irrespective of the forwarding method. For TUN method
+	the flag can be disabled to fragment such packets.
+
 secure_tcp - INTEGER
         0  - disabled (default)
 
-- 
2.1.4

