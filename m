From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 1/3] netfilter: nft_dynset: fix panic if NFT_SET_HASH is not enabled
Date: Sat, 22 Oct 2016 18:51:24 +0800
Message-ID: <1477133486-60686-2-git-send-email-zlpnobody@163.com>
References: <1477133486-60686-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:33168 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937312AbcJVKwM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Oct 2016 06:52:12 -0400
In-Reply-To: <1477133486-60686-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

When CONFIG_NFT_SET_HASH is not enabled and I input the following rule:
"nft add rule filter output flow table test {ip daddr counter }", kernel
panic happened on my system:
 BUG: unable to handle kernel NULL pointer dereference at (null)
 IP: [<          (null)>]           (null)
 [...]
 Call Trace:
 [<ffffffffa0590466>] ? nft_dynset_eval+0x56/0x100 [nf_tables]
 [<ffffffffa05851bb>] nft_do_chain+0xfb/0x4e0 [nf_tables]
 [<ffffffffa0432f01>] ? nf_conntrack_tuple_taken+0x61/0x210 [nf_conntrack]
 [<ffffffffa0459ea6>] ? get_unique_tuple+0x136/0x560 [nf_nat]
 [<ffffffffa043bca1>] ? __nf_ct_ext_add_length+0x111/0x130 [nf_conntrack]
 [<ffffffffa045a357>] ? nf_nat_setup_info+0x87/0x3b0 [nf_nat]
 [<ffffffff81761e27>] ? ipt_do_table+0x327/0x610
 [<ffffffffa045a6d7>] ? __nf_nat_alloc_null_binding+0x57/0x80 [nf_nat]
 [<ffffffffa059f21f>] nft_ipv4_output+0xaf/0xd0 [nf_tables_ipv4]
 [<ffffffff81702515>] nf_iterate+0x55/0x60
 [<ffffffff81702593>] nf_hook_slow+0x73/0xd0

Because in rbtree type set, ops->update is not implemented. So just keep
it simple, in such case, report -EOPNOTSUPP to the user space.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nft_dynset.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index e3b83c3..6a631cb 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -139,6 +139,9 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			return PTR_ERR(set);
 	}
 
+	if (set->ops->update == NULL)
+		return -EOPNOTSUPP;
+
 	if (set->flags & NFT_SET_CONSTANT)
 		return -EBUSY;
 
-- 
2.5.5


