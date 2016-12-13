From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] mnl: don't send empty set elements netlink message to kernel
Date: Wed, 14 Dec 2016 00:27:46 +0100
Message-ID: <1481671666-12716-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55636 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750850AbcLMX16 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Dec 2016 18:27:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B30A9C2B00
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2016 00:27:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A42FDDA388
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2016 00:27:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C7DEDA388
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2016 00:27:50 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following command:

 # nft --debug=mnl add rule x y flow table xyz { ip saddr timeout 30s counter }

breaks with EINVAL. The following netlink message is causing the
problem:

...
----------------        ------------------
|  0000000044  |        | message length |
| 02572 | R--- |        |  type | flags  |
|  0000000004  |        | sequence number|
|  0000000000  |        |     port ID    |
----------------        ------------------
| 02 00 00 00  |        |  extra header  |
|00008|--|00002|        |len |flags| type|
| 78 79 7a 00  |        |      data      |       x y z
|00008|--|00004|        |len |flags| type|
| 00 00 00 01  |        |      data      |
|00006|--|00001|        |len |flags| type|
| 78 00 00 00  |        |      data      |       x
----------------        ------------------
...

This is incorrect since this describes no elements at all, so it is
useless.  Add upfront check before iterating over the list of set
elements so the netlink message is not placed in the batch.

This patch also adds a set so flow tables are minimally covered.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c                       | 14 +++++++++-----
 tests/py/ip/flowtable.t         |  5 +++++
 tests/py/ip/flowtable.t.payload |  7 +++++++
 3 files changed, 21 insertions(+), 5 deletions(-)
 create mode 100644 tests/py/ip/flowtable.t
 create mode 100644 tests/py/ip/flowtable.t.payload

diff --git a/src/mnl.c b/src/mnl.c
index 137ecf0d1e01..d107015c2743 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -825,19 +825,21 @@ int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 	char buf[NFT_NLMSG_MAXSIZE];
 	struct nlmsghdr *nlh;
 	struct nftnl_set_elems_iter *iter;
-	int ret, err;
+	int ret, err = 0;
 
 	iter = nftnl_set_elems_iter_create(nls);
 	if (iter == NULL)
 		memory_allocation_error();
 
-	do {
+	while (nftnl_set_elems_iter_cur(iter)) {
 		nlh = nftnl_set_elem_nlmsg_build_hdr(buf, NFT_MSG_NEWSETELEM,
 				nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
 				NLM_F_CREATE | NLM_F_ACK | flags, seq);
 		ret = nftnl_set_elems_nlmsg_build_payload_iter(nlh, iter);
 		err = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
-	} while (ret > 0 && err >= 0);
+		if (ret <= 0 || err < 0)
+			break;
+	}
 
 	nftnl_set_elems_iter_destroy(iter);
 
@@ -879,13 +881,15 @@ static int mnl_nft_setelem_batch(struct nftnl_set *nls,
 	if (iter == NULL)
 		memory_allocation_error();
 
-	do {
+	while (nftnl_set_elems_iter_cur(iter)) {
 		nlh = nftnl_set_elem_nlmsg_build_hdr(nftnl_batch_buffer(batch),
 				cmd, nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
 				NLM_F_CREATE | flags, seqnum);
 		ret = nftnl_set_elems_nlmsg_build_payload_iter(nlh, iter);
 		mnl_nft_batch_continue();
-	} while (ret > 0);
+		if (ret <= 0)
+			break;
+	}
 
 	nftnl_set_elems_iter_destroy(iter);
 
diff --git a/tests/py/ip/flowtable.t b/tests/py/ip/flowtable.t
new file mode 100644
index 000000000000..aea57c32fec2
--- /dev/null
+++ b/tests/py/ip/flowtable.t
@@ -0,0 +1,5 @@
+:input;type filter hook input priority 0
+
+*ip;test-ip;input
+
+flow table xyz { ip saddr timeout 30s counter packets 0 bytes 0};ok
diff --git a/tests/py/ip/flowtable.t.payload b/tests/py/ip/flowtable.t.payload
new file mode 100644
index 000000000000..ffadfd2555c3
--- /dev/null
+++ b/tests/py/ip/flowtable.t.payload
@@ -0,0 +1,7 @@
+# flow table xyz { ip saddr timeout 30s counter packets 0 bytes 0}
+xyz test-ip 31
+xyz test-ip 0
+ip test-ip input 
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ dynset update reg_key 1 set xyz timeout 30000ms expr [ counter pkts 0 bytes 0 ] ]
+
-- 
2.1.4

