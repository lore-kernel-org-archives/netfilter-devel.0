From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/25] netfilter: constify arg to is_dying/confirmed
Date: Sat, 23 Jul 2016 13:02:10 +0200
Message-ID: <1469271745-14523-11-git-send-email-pablo@netfilter.org>
References: <1469271745-14523-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35278 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbcGWLDL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 07:03:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 57407E7DAC
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 48EAFFF154
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3D3269D6B7
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:08 +0200 (CEST)
In-Reply-To: <1469271745-14523-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a08825b..1e04911 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -270,12 +270,12 @@ static inline int nf_ct_is_template(const struct nf_conn *ct)
 }
 
 /* It's confirmed if it is, or has been in the hash table. */
-static inline int nf_ct_is_confirmed(struct nf_conn *ct)
+static inline int nf_ct_is_confirmed(const struct nf_conn *ct)
 {
 	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
 }
 
-static inline int nf_ct_is_dying(struct nf_conn *ct)
+static inline int nf_ct_is_dying(const struct nf_conn *ct)
 {
 	return test_bit(IPS_DYING_BIT, &ct->status);
 }
-- 
2.1.4

