From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/2] netfilter: ipset: remove duplicate define
Date: Sun, 27 Oct 2013 19:31:59 +0100
Message-ID: <1382898719-7003-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1382898719-7003-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:40647 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab3J0ScB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 14:32:01 -0400
In-Reply-To: <1382898719-7003-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>

This patch removes a duplicate define from
net/netfilter/ipset/ip_set_hash_gen.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 2f80c74..be6932a 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -234,7 +234,6 @@ hbucket_elem_add(struct hbucket *n, u8 ahash_max, size_t dsize)
 #define mtype_uadt		IPSET_TOKEN(MTYPE, _uadt)
 #define mtype			MTYPE
 
-#define mtype_elem		IPSET_TOKEN(MTYPE, _elem)
 #define mtype_add		IPSET_TOKEN(MTYPE, _add)
 #define mtype_del		IPSET_TOKEN(MTYPE, _del)
 #define mtype_test_cidrs	IPSET_TOKEN(MTYPE, _test_cidrs)
-- 
1.7.10.4

