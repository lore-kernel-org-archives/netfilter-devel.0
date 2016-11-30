From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/11] netfilter: fix nf_conntrack_helper documentation
Date: Wed, 30 Nov 2016 22:57:17 +0100
Message-ID: <1480543045-3389-4-git-send-email-pablo@netfilter.org>
References: <1480543045-3389-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42128 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753276AbcK3V5m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2016 16:57:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 352BA13C0E3
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 22:57:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28253DA862
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 22:57:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2282DDA80B
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 22:57:39 +0100 (CET)
In-Reply-To: <1480543045-3389-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

Since kernel 4.7 this defaults to off.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/nf_conntrack-sysctl.txt | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.txt b/Documentation/networking/nf_conntrack-sysctl.txt
index 399e4e866a9c..433b6724797a 100644
--- a/Documentation/networking/nf_conntrack-sysctl.txt
+++ b/Documentation/networking/nf_conntrack-sysctl.txt
@@ -62,10 +62,13 @@ nf_conntrack_generic_timeout - INTEGER (seconds)
 	protocols.
 
 nf_conntrack_helper - BOOLEAN
-	0 - disabled
-	not 0 - enabled (default)
+	0 - disabled (default)
+	not 0 - enabled
 
 	Enable automatic conntrack helper assignment.
+	If disabled it is required to set up iptables rules to assign
+	helpers to connections.  See the CT target description in the
+	iptables-extensions(8) man page for further information.
 
 nf_conntrack_icmp_timeout - INTEGER (seconds)
 	default 30
-- 
2.1.4

