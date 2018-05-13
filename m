From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/15] netfilter: x_tables: check name length in find_match/target, too
Date: Mon, 14 May 2018 00:36:43 +0200
Message-ID: <20180513223656.10077-3-pablo@netfilter.org>
References: <20180513223656.10077-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180513223656.10077-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

ebtables uses find_match() rather than find_request_match in one case
(see bcf4934288402be3464110109a4dae3bd6fb3e93,
 "netfilter: ebtables: Fix extension lookup with identical name"), so
 extend the check on name length to those functions too.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 71325fef647d..cb7cb300c3bc 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -183,6 +183,9 @@ struct xt_match *xt_find_match(u8 af, const char *name, u8 revision)
 	struct xt_match *m;
 	int err = -ENOENT;
 
+	if (strnlen(name, XT_EXTENSION_MAXNAMELEN) == XT_EXTENSION_MAXNAMELEN)
+		return ERR_PTR(-EINVAL);
+
 	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(m, &xt[af].match, list) {
 		if (strcmp(m->name, name) == 0) {
@@ -229,6 +232,9 @@ struct xt_target *xt_find_target(u8 af, const char *name, u8 revision)
 	struct xt_target *t;
 	int err = -ENOENT;
 
+	if (strnlen(name, XT_EXTENSION_MAXNAMELEN) == XT_EXTENSION_MAXNAMELEN)
+		return ERR_PTR(-EINVAL);
+
 	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(t, &xt[af].target, list) {
 		if (strcmp(t->name, name) == 0) {
-- 
2.11.0
