From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nf_expect_proc: remove the redundant slash when policy name is empty
Date: Mon,  8 Aug 2016 21:57:58 +0800
Message-ID: <1470664678-19155-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:35812 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbcHHN6f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 09:58:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

The 'name' filed in struct nf_conntrack_expect_policy{} is not a
pointer, so check it is NULL or not will always return true. Even if the
name is empty, slash will always be displayed like follows:
  # cat /proc/net/nf_conntrack_expect
  297 l3proto = 2 proto=6 src=1.1.1.1 dst=2.2.2.2 sport=1 dport=1025 ftp/
                                                                        ^

Fixes: 3a8fc53a45c4 ("netfilter: nf_ct_helper: allocate 16 bytes for the helper and policy names")
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nf_conntrack_expect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 9e36931..a4f3cc8 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -574,7 +574,7 @@ static int exp_seq_show(struct seq_file *s, void *v)
 	helper = rcu_dereference(nfct_help(expect->master)->helper);
 	if (helper) {
 		seq_printf(s, "%s%s", expect->flags ? " " : "", helper->name);
-		if (helper->expect_policy[expect->class].name)
+		if (helper->expect_policy[expect->class].name[0] != '\0')
 			seq_printf(s, "/%s",
 				   helper->expect_policy[expect->class].name);
 	}
-- 
2.5.5


