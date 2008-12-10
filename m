From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: ctnetlink: fix missing CTA_NAT_SEQ_UNSPEC
Date: Wed, 10 Dec 2008 21:06:50 +0100
Message-ID: <20081210200649.23169.33618.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40900 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753993AbYLJUG6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:06:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes an inconsistency in nfnetlink_conntrack.h that
I introduced myself. The problem is that CTA_NAT_SEQ_UNSPEC is
missing from enum ctattr_natseq. This inconsistency may lead to
problems in the message parsing in userspace (if the message
contains the CTA_NAT_SEQ_* attributes, of course).

This patch breaks backward compatibility, however, the only known
client of this code is libnetfilter_conntrack which indeed crashes
because it assumes the existence of CTA_NAT_SEQ_UNSPEC to do
the parsing.

The CTA_NAT_SEQ_* attributes were introduced in 2.6.25.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/linux/netfilter/nfnetlink_conntrack.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index c19595c..29fe9ea 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -141,6 +141,7 @@ enum ctattr_protonat {
 #define CTA_PROTONAT_MAX (__CTA_PROTONAT_MAX - 1)
 
 enum ctattr_natseq {
+	CTA_NAT_SEQ_UNSPEC,
 	CTA_NAT_SEQ_CORRECTION_POS,
 	CTA_NAT_SEQ_OFFSET_BEFORE,
 	CTA_NAT_SEQ_OFFSET_AFTER,

