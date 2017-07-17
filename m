From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1] netfilter: nf_ct_expect: fix expect removal
Date: Mon, 17 Jul 2017 17:06:48 +0200
Message-ID: <20170717150648.10058-1-jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Gao Feng <fgao@ikuai8.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Commit ec0e3f01114a ("netfilter: nf_ct_expect: Add
nf_ct_remove_expect()") introduced a helper nf_ct_remove_expect. It was
used over the code, but one location used a wrong variable and it
resulted in a crash in this call stack:
  -> nf_ct_expect_related_report
  -> nf_ct_remove_expect
  -> del_timer
  -> detach_if_pending

Switch to the proper variable.

Fixes: ec0e3f01114a
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Gao Feng <fgao@ikuai8.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Cc: <coreteam@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index e03d16ed550d..899c2c36da13 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -422,7 +422,7 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 	h = nf_ct_expect_dst_hash(net, &expect->tuple);
 	hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
 		if (expect_matches(i, expect)) {
-			if (nf_ct_remove_expect(expect))
+			if (nf_ct_remove_expect(i))
 				break;
 		} else if (expect_clash(i, expect)) {
 			ret = -EBUSY;
-- 
2.13.3
