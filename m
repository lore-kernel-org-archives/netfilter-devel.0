From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/4] netfilter: ctnetlink: missing validation of
	CTA_EXPECT_ZONE attribute
Date: Tue, 21 Sep 2010 11:34:47 +0200
Message-ID: <20100921093447.3279.83375.stgit@decadence>
References: <20100921092843.3279.6914.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33794 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051Ab0IUJeu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Sep 2010 05:34:50 -0400
In-Reply-To: <20100921092843.3279.6914.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the missing validation of the CTA_EXPECT_ZONE
attribute in the ctnetlink code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5bae1cd..37533a3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1733,6 +1733,7 @@ static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
 	[CTA_EXPECT_TIMEOUT]	= { .type = NLA_U32 },
 	[CTA_EXPECT_ID]		= { .type = NLA_U32 },
 	[CTA_EXPECT_HELP_NAME]	= { .type = NLA_NUL_STRING },
+	[CTA_EXPECT_ZONE]	= { .type = NLA_U16 },
 };
 
 static int

