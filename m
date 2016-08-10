From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/9] netfilter: nf_ct_expect: remove the redundant slash when policy name is empty
Date: Wed, 10 Aug 2016 21:16:41 +0200
Message-ID: <1470856605-7903-6-git-send-email-pablo@netfilter.org>
References: <1470856605-7903-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1470856605-7903-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Liping Zhang <liping.zhang@spreadtrum.com>

The 'name' filed in struct nf_conntrack_expect_policy{} is not a
pointer, so check it is NULL or not will always return true. Even if the
name is empty, slash will always be displayed like follows:
  # cat /proc/net/nf_conntrack_expect
  297 l3proto = 2 proto=6 src=1.1.1.1 dst=2.2.2.2 sport=1 dport=1025 ftp/
                                                                        ^

Fixes: 3a8fc53a45c4 ("netfilter: nf_ct_helper: allocate 16 bytes for the helper and policy names")
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 9e36931..f8dbacf 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -574,7 +574,7 @@ static int exp_seq_show(struct seq_file *s, void *v)
 	helper = rcu_dereference(nfct_help(expect->master)->helper);
 	if (helper) {
 		seq_printf(s, "%s%s", expect->flags ? " " : "", helper->name);
-		if (helper->expect_policy[expect->class].name)
+		if (helper->expect_policy[expect->class].name[0])
 			seq_printf(s, "/%s",
 				   helper->expect_policy[expect->class].name);
 	}
-- 
2.1.4
