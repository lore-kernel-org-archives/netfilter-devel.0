From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: fix nf_conntrack_helper documentation
Date: Thu, 10 Nov 2016 14:24:40 +0100
Message-ID: <1478784280-17103-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51494 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932336AbcKJNYV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 08:24:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since kernel 4.7 this defaults to off.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Documentation/networking/nf_conntrack-sysctl.txt | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.txt b/Documentation/networking/nf_conntrack-sysctl.txt
index cdeb9d6a44c7..497d668288f9 100644
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
2.7.3

