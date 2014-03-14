From: Yuxuan Shui <yshuiv7@gmail.com>
Subject: [nft RFC PATCH] mnl: Fix a potential buffer overflow
Date: Fri, 14 Mar 2014 13:47:05 +0000
Message-ID: <1394804825-6617-1-git-send-email-yshuiv7@gmail.com>
Cc: Yuxuan Shui <yshuiv7@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48445 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbaCNNrS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:47:18 -0400
Received: by mail-pb0-f51.google.com with SMTP id uo5so2641922pbc.10
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Mar 2014 06:47:18 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use nft_set_elems_nlmsg_build_payload_check to prevent the buffer from
being overflowed.
---
 src/mnl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index e825fb0..1dea2ed 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -709,7 +709,8 @@ int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 	nlh = nft_set_elem_nlmsg_build_hdr(buf, NFT_MSG_NEWSETELEM,
 			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
 			NLM_F_CREATE | NLM_F_ACK | flags, seq);
-	nft_set_elems_nlmsg_build_payload(nlh, nls);
+	if (!nft_set_elems_nlmsg_build_payload_check(nlh, MNL_SOCKET_BUFFER_SIZE, nls))
+		BUG("Too many elements in set.\n");
 
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
-- 
1.9.0

