From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/47] netfilter: x_tables: check error target size too
Date: Fri, 30 Mar 2018 13:36:50 +0200
Message-ID: <20180330113729.18335-9-pablo@netfilter.org>
References: <20180330113729.18335-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330113729.18335-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Check that userspace ERROR target (custom user-defined chains) match
expected format, and the chain name is null terminated.

This is irrelevant for kernel, but iptables itself relies on sane input
when it dumps rules from kernel.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/x_tables.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 2e4d423e58e6..f045bb4f7063 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -654,6 +654,11 @@ struct compat_xt_standard_target {
 	compat_uint_t verdict;
 };
 
+struct compat_xt_error_target {
+	struct compat_xt_entry_target t;
+	char errorname[XT_FUNCTION_MAXNAMELEN];
+};
+
 static bool verdict_ok(int verdict)
 {
 	if (verdict > 0)
@@ -679,6 +684,12 @@ static bool verdict_ok(int verdict)
 	return false;
 }
 
+static bool error_tg_ok(unsigned int usersize, unsigned int kernsize,
+			const char *msg, unsigned int msglen)
+{
+	return usersize == kernsize && strnlen(msg, msglen) < msglen;
+}
+
 int xt_compat_check_entry_offsets(const void *base, const char *elems,
 				  unsigned int target_offset,
 				  unsigned int next_offset)
@@ -708,6 +719,12 @@ int xt_compat_check_entry_offsets(const void *base, const char *elems,
 
 		if (!verdict_ok(st->verdict))
 			return -EINVAL;
+	} else if (strcmp(t->u.user.name, XT_ERROR_TARGET) == 0) {
+		const struct compat_xt_error_target *et = (const void *)t;
+
+		if (!error_tg_ok(t->u.target_size, sizeof(*et),
+				 et->errorname, sizeof(et->errorname)))
+			return -EINVAL;
 	}
 
 	/* compat_xt_entry match has less strict alignment requirements,
@@ -796,6 +813,12 @@ int xt_check_entry_offsets(const void *base,
 
 		if (!verdict_ok(st->verdict))
 			return -EINVAL;
+	} else if (strcmp(t->u.user.name, XT_ERROR_TARGET) == 0) {
+		const struct xt_error_target *et = (const void *)t;
+
+		if (!error_tg_ok(t->u.target_size, sizeof(*et),
+				 et->errorname, sizeof(et->errorname)))
+			return -EINVAL;
 	}
 
 	return xt_check_entry_match(elems, base + target_offset,
-- 
2.11.0
