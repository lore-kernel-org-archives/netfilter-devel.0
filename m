From: Daniel Wagner <wagi@monom.org>
Subject: [PATCH] examples: load modules when adding chains or tables
Date: Fri, 29 Apr 2016 12:07:34 +0200
Message-ID: <1461924454-19498-1-git-send-email-wagi@monom.org>
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:40880 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbcD2KQj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 06:16:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Tell the kernel to load the necessary modules by adding
the NLM_F_CREATE flag.

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---

This is for libnftnl.

examples/nft-chain-add.c | 2 +-
 examples/nft-table-add.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
index 3afc06e..ca1edf9 100644
--- a/examples/nft-chain-add.c
+++ b/examples/nft-chain-add.c
@@ -110,7 +110,7 @@ int main(int argc, char *argv[])
 	chain_seq = seq;
 	nlh = nftnl_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 					NFT_MSG_NEWCHAIN, family,
-					NLM_F_ACK, seq++);
+					NLM_F_CREATE|NLM_F_ACK, seq++);
 	nftnl_chain_nlmsg_build_payload(nlh, t);
 	nftnl_chain_free(t);
 	mnl_nlmsg_batch_next(batch);
diff --git a/examples/nft-table-add.c b/examples/nft-table-add.c
index db6e39e..aa6e268 100644
--- a/examples/nft-table-add.c
+++ b/examples/nft-table-add.c
@@ -87,7 +87,7 @@ int main(int argc, char *argv[])
 	family = nftnl_table_get_u32(t, NFTNL_TABLE_FAMILY);
 	nlh = nftnl_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 					NFT_MSG_NEWTABLE, family,
-					NLM_F_ACK, seq++);
+					NLM_F_CREATE|NLM_F_ACK, seq++);
 	nftnl_table_nlmsg_build_payload(nlh, t);
 	nftnl_table_free(t);
 	mnl_nlmsg_batch_next(batch);
-- 
2.5.5
