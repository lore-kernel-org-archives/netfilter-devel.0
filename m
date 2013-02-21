From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/2] netfilter: ipset: timeout values corrupted on set resize
Date: Thu, 21 Feb 2013 17:45:45 +0100
Message-ID: <1361465146-11861-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1361465146-11861-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:49966 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab3BUQps (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:45:48 -0500
In-Reply-To: <1361465146-11861-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Josh Hunt <johunt@akamai.com>

If a resize is triggered on a set with timeouts enabled, the timeout
values will get corrupted when copying them to the new set. This occured
b/c the wrong timeout value is supplied to type_pf_elem_tadd().

This also adds simple debug statement similar to the one in type_pf_resize().

Signed-off-by: Josh Hunt <johunt@akamai.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set_ahash.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_ahash.h b/include/linux/netfilter/ipset/ip_set_ahash.h
index ef9acd3..01d25e6 100644
--- a/include/linux/netfilter/ipset/ip_set_ahash.h
+++ b/include/linux/netfilter/ipset/ip_set_ahash.h
@@ -854,6 +854,8 @@ type_pf_tresize(struct ip_set *set, bool retried)
 retry:
 	ret = 0;
 	htable_bits++;
+	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
+		 set->name, orig->htable_bits, htable_bits, orig);
 	if (!htable_bits) {
 		/* In case we have plenty of memory :-) */
 		pr_warning("Cannot increase the hashsize of set %s further\n",
@@ -873,7 +875,7 @@ retry:
 			data = ahash_tdata(n, j);
 			m = hbucket(t, HKEY(data, h->initval, htable_bits));
 			ret = type_pf_elem_tadd(m, data, AHASH_MAX(h), 0,
-						type_pf_data_timeout(data));
+						ip_set_timeout_get(type_pf_data_timeout(data)));
 			if (ret < 0) {
 				read_unlock_bh(&set->lock);
 				ahash_destroy(t);
-- 
1.7.0.4

