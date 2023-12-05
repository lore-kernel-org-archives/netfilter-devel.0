Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89DCC196
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 09:40:26 -0800 (PST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] monitor: add support for concatenated set ranges
Date: Tue,  5 Dec 2023 18:40:18 +0100
Message-Id: <20231205174018.406425-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

monitor is missing concatenated set ranges support.

Fixes: 8ac2f3b2fca3 ("src: Add support for concatenated set ranges")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/monitor.c                                 | 11 +++++++++--
 tests/monitor/testcases/set-concat-interval.t | 12 ++++++++++++
 2 files changed, 21 insertions(+), 2 deletions(-)
 create mode 100644 tests/monitor/testcases/set-concat-interval.t

diff --git a/src/monitor.c b/src/monitor.c
index 82762a0fe47b..2fc16d6776a2 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -390,13 +390,19 @@ static bool netlink_event_range_cache(struct set *cached_set,
 
 	/* don't cache half-open range elements */
 	elem = list_entry(dummyset->init->expressions.prev, struct expr, list);
-	if (!set_elem_is_open_interval(elem)) {
+	if (!set_elem_is_open_interval(elem) &&
+	    dummyset->desc.field_count <= 1) {
 		cached_set->rg_cache = expr_clone(elem);
 		return true;
 	}
 
 out_decompose:
-	interval_map_decompose(dummyset->init);
+	if (dummyset->flags & NFT_SET_INTERVAL &&
+	    dummyset->desc.field_count > 1)
+		concat_range_aggregate(dummyset->init);
+	else
+		interval_map_decompose(dummyset->init);
+
 	return false;
 }
 
@@ -437,6 +443,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		dummyset->data = expr_clone(set->data);
 	dummyset->flags = set->flags;
 	dummyset->init = set_expr_alloc(monh->loc, set);
+	dummyset->desc.field_count = set->desc.field_count;
 
 	nlsei = nftnl_set_elems_iter_create(nls);
 	if (nlsei == NULL)
diff --git a/tests/monitor/testcases/set-concat-interval.t b/tests/monitor/testcases/set-concat-interval.t
new file mode 100644
index 000000000000..763dc319f0d1
--- /dev/null
+++ b/tests/monitor/testcases/set-concat-interval.t
@@ -0,0 +1,12 @@
+# setup first
+I add table ip t
+I add chain ip t c
+O -
+J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
+J {"add": {"chain": {"family": "ip", "table": "t", "name": "c", "handle": 0}}}
+
+# add set with elements, monitor output expectedly differs
+I add map ip t s { typeof udp length . @ih,32,32 : verdict; flags interval; elements = { 20-80 . 0x14 : accept, 1-10 . 0xa : drop }; }
+O add map ip t s { typeof udp length . @ih,32,32 : verdict; flags interval; }
+O add element ip t s { 20-80 . 0x14 : accept }
+O add element ip t s { 1-10 . 0xa : drop }
-- 
2.30.2

