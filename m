From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: [PATCH 2/2] segtree: allocate memory for arrays on heap
Date: Mon,  2 Jan 2017 18:38:51 +0100
Message-ID: <20170102173851.2542-3-oleksandr@natalenko.name>
References: <20170102173851.2542-1-oleksandr@natalenko.name>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vulcan.natalenko.name ([104.207.131.136]:41742 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756226AbdABRjA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2017 12:39:00 -0500
Received: from localhost.localdomain (unknown [IPv6:2001:470:5b39:29:c99:116f:61fe:9756])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id A6EF616AA55
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Jan 2017 18:38:58 +0100 (CET)
In-Reply-To: <20170102173851.2542-1-oleksandr@natalenko.name>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Huge sets may cause stack to be exhausted.
So, put allocate memory for arrays in
interval_map_decompose() function on heap.

Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
---
 src/segtree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index 5b6cdd1..d3873d9 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -608,12 +608,15 @@ static int expr_value_cmp(const void *p1, const void *p2)
 
 void interval_map_decompose(struct expr *set)
 {
-	struct expr *elements[set->size], *ranges[set->size * 2];
+	struct expr **elements, **ranges;
 	struct expr *i, *next, *low = NULL, *end;
 	unsigned int n, m, size;
 	mpz_t range, p;
 	bool interval;
 
+	elements = xmalloc_array(set->size, sizeof(struct expr *));
+	ranges = xmalloc_array(set->size * 2, sizeof(struct expr *));
+
 	mpz_init(range);
 	mpz_init(p);
 
@@ -728,4 +731,7 @@ void interval_map_decompose(struct expr *set)
 
 		compound_expr_add(set, i);
 	}
+
+	xfree(ranges);
+	xfree(elements);
 }
-- 
2.11.0

