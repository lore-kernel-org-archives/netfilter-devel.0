From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 1/2] netfilter: use sysctl to choose icmpv6 autoconf behaviour.
Date: Thu, 22 Jan 2009 00:43:50 +0100
Message-ID: <1232581431-15130-1-git-send-email-eric@inl.fr>
References: <1232581287.16003.47.camel@ice-age>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: yasuyuki.kozakai@toshiba.co.jp, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:53959 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754558AbZAUXoB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:44:01 -0500
In-Reply-To: <1232581287.16003.47.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patches adds a sysctl flag to decide wheither or not detect icmpv6
autoconfiguration packet as INVALID.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 0dbac72..4aa80ba 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -27,6 +27,7 @@
 #include <net/netfilter/nf_log.h>
 
 static unsigned long nf_ct_icmpv6_timeout __read_mostly = 30*HZ;
+static unsigned long nf_ct_icmpv6_autoconf __read_mostly = 0;
 
 static bool icmpv6_pkt_to_tuple(const struct sk_buff *skb,
 				unsigned int dataoff,
@@ -259,6 +260,13 @@ static struct ctl_table icmpv6_sysctl_table[] = {
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
+		.procname	= "nf_conntrack_icmpv6_autoconf",
+		.data		= &nf_ct_icmpv6_autoconf,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
 		.ctl_name	= 0
 	}
 };
-- 
1.5.6.3

