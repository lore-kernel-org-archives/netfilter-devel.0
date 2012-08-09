From: pablo@netfilter.org
Subject: [PATCH 1/2] netfilter: nf_ct_expect: fix re-insertion in expect list if timer refresh fails
Date: Fri, 10 Aug 2012 01:02:11 +0200
Message-ID: <1344553332-8536-2-git-send-email-pablo@netfilter.org>
References: <1344553332-8536-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56224 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759719Ab2HIXDY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 19:03:24 -0400
In-Reply-To: <1344553332-8536-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch fixes __nf_ct_expect_check to return 0 in case that the
expectation timer refresh fails. If the expectation is dying, we have
to make sure that we don't re-insert it again in the list.

This problem becomes more noticeable with permanent expectations, used
by the conntrack SIP helper.

RIP: 0010:[<ffffffffa00b6ce2>]  [<ffffffffa00b6ce2>] flush_expectations.clone.15+0x72/0x9b
 [nf_conntrack_sip]
RSP: 0018:ffff88013fc03970  EFLAGS: 00010246
RAX: 0000000000000000 RBX: dead000000100100 RCX: ffff88011aaced68
RDX: 0000000000000000 RSI: ffff88013fc03950 RDI: ffff88009a411f78
RBP: ffff88013fc03990 R08: dead000000200200 R09: dead000000100100
R10: dead000000200200 R11: ffff88013fc03950 R12: ffff88013fc03a01
R13: 0000000000000001 R14: dead000000100100 R15: 0000000000000157
[...]
[<ffffffffa00b6e6a>] process_invite_response+0x66/0x6b [nf_conntrack_sip]
[<ffffffffa00b65a1>] process_sip_msg.clone.11+0x1db/0x236 [nf_conntrack_sip]
[<ffffffffa00b6e04>] ? process_update_response+0x6b/0x6b [nf_conntrack_sip]
[<ffffffffa00b68a6>] sip_help_udp+0x8c/0x97 [nf_conntrack_sip]
[<ffffffffa007aa15>] ipv4_confirm+0xab/0x19f [nf_conntrack_ipv4]
[<ffffffff812e54bc>] nf_iterate+0x43/0x78

Reported-by: Rafal Fitt <rafalf@aplusc.com.pl>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 45cf602..ec8bb0d 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -398,7 +398,7 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 	hlist_for_each_entry(i, n, &net->ct.expect_hash[h], hnode) {
 		if (expect_matches(i, expect)) {
 			/* Refresh timer: if it's dying, ignore.. */
-			if (refresh_timer(i)) {
+			if (!refresh_timer(i)) {
 				ret = 0;
 				goto out;
 			}
-- 
1.7.10.4

