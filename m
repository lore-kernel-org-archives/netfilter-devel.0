From: Kelvie Wong <kelvie@ieee.org>
Subject: [PATCH] netfilter: nf_ct_expect: partially implement ctnetlink_change_expect
Date: Wed,  2 May 2012 17:39:24 -0700
Message-ID: <1336005564-23171-3-git-send-email-kelvie@ieee.org>
References: <1336005564-23171-1-git-send-email-kelvie@ieee.org>
Cc: Kelvie Wong <kelvie@ieee.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57556 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab2ECAjm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 May 2012 20:39:42 -0400
Received: by mail-qc0-f174.google.com with SMTP id o28so807896qcr.19
        for <netfilter-devel@vger.kernel.org>; Wed, 02 May 2012 17:39:41 -0700 (PDT)
In-Reply-To: <1336005564-23171-1-git-send-email-kelvie@ieee.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This refreshes the "timeout" attribute in existing expectations if one is
given.

The use case for this would be for userspace helpers to extend the lifetime
of the expectation when requested, as this is not possible right now
without deleting/recreating the expectation.

I use this specifically for forwarding DCERPC traffic through:

DCERPC has a port mapper daemon that chooses a (seemingly) random port for
future traffic to go to. We expect this traffic (with a reasonable
timeout), but sometimes the port mapper will tell the client to continue
using the same port. This allows us to extend the expectation accordingly.

Signed-off-by: Kelvie Wong <kelvie@ieee.org>
---
 net/netfilter/nf_conntrack_netlink.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ca7e835..87a9682 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2065,6 +2065,16 @@ static int
 ctnetlink_change_expect(struct nf_conntrack_expect *x,
 			const struct nlattr * const cda[])
 {
+	/* Refresh the timeout */
+	if (cda[CTA_EXPECT_TIMEOUT]) {
+		if (!del_timer(&x->timeout))
+			return -ETIME;
+
+		x->timeout.expires = jiffies +
+			ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
+		add_timer(&x->timeout);
+		return 0;
+	}
 	return -EOPNOTSUPP;
 }
 
-- 
1.7.9.5

