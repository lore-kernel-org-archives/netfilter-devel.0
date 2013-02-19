From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH] netfilter: ipset: timeout values corrupted on set resize
Date: Tue, 19 Feb 2013 11:35:59 -0800
Message-ID: <1361302559-8657-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:57994 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932947Ab3BSTgJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:36:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If a resize is triggered on a set with timeouts enabled, the timeout
values will get corrupted when copying them to the new set. This occured
b/c the wrong timeout value is supplied to type_pf_elem_tadd().

This also adds simple debug statement similar to the one in type_pf_resize().

Signed-off-by: Josh Hunt <johunt@akamai.com>
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

