Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B319CC74A5B
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Mar 2023 23:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCVXdn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Mar 2023 19:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjCVXdm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2023 19:33:42 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Mar 2023 16:33:41 PDT
Received: from ma-mailsvcp-mx-lapp03.apple.com (ma-mailsvcp-mx-lapp03.apple.com [17.32.222.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B8F2194E
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2023 16:33:41 -0700 (PDT)
Received: from ma-mailsvcp-mta-lapp02.corp.apple.com
 (ma-mailsvcp-mta-lapp02.corp.apple.com [10.226.18.134])
 by ma-mailsvcp-mx-lapp03.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) with ESMTPS id <0RRY005WV1C4Y000@ma-mailsvcp-mx-lapp03.apple.com> for
 netfilter-devel@vger.kernel.org; Wed, 22 Mar 2023 15:33:40 -0700 (PDT)
X-Proofpoint-GUID: MPxMfiAc5XgMrldIlTppvRJZcoFob78t
X-Proofpoint-ORIG-GUID: MPxMfiAc5XgMrldIlTppvRJZcoFob78t
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.573,18.0.942
 definitions=2023-03-22_18:2023-03-22,2023-03-22 signatures=0
X-Proofpoint-Spam-Details: rule=interactive_user_notspam
 policy=interactive_user score=0 spamscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303220162
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=from : to
 : cc : subject : date : message-id : mime-version : content-transfer-encoding;
 s=20180706; bh=jMPRlDUGWS+zjQ1lP8VqjeyJ5mGrCYg7h1zOEAozM8w=;
 b=YBXO5skeEC36mzC2Z9GyIZ5QGOPxFVIjuCoe+gu1yML72zgRI2kFR+BrwRixVCQ6XWRN
 UWEKgUZqVtb747NLLFseaMcsSxfCuMfZuzktYzzzhDtociepEJfgZneHmWlrgU6i+S2m
 zJqCmk4jMXCpeOTamsTNB32+3ZwLMhh9U3tghVzhvnBRKbEHodyVl0/fpDFKXkuXh1Hj
 qT9aIIo1vMsZIvjMErKwS3j6n19lQN8qUch5Yn9eAYFO6KwGonKWwMMo9CRRPM0wVCk+
 dlMFECo9DiX6/JpZlgosMq0H9nca/LPMebjg7z6OqjSsA2xTNz9HlCXTRB7LS4joCR6p vw==
Received: from ma-mailsvcp-mmp-lapp01.apple.com
 (ma-mailsvcp-mmp-lapp01.apple.com [17.32.222.14])
 by ma-mailsvcp-mta-lapp02.corp.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023))
 with ESMTPS id <0RRY00O3P1C4PM40@ma-mailsvcp-mta-lapp02.corp.apple.com>; Wed,
 22 Mar 2023 15:33:40 -0700 (PDT)
Received: from process_milters-daemon.ma-mailsvcp-mmp-lapp01.apple.com by
 ma-mailsvcp-mmp-lapp01.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) id <0RRY009000OG4Q00@ma-mailsvcp-mmp-lapp01.apple.com>; Wed,
 22 Mar 2023 15:33:40 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: ee775fe296fae01696e403bd65ae1163
X-Va-E-CD: 9ee6584fe98d86454e9294ebfdb90501
X-Va-R-CD: 9ee6584fe98d86454e9294ebfdb90501
X-Va-ID: 026a1724-ba98-449a-90dc-7691644e4e9a
X-Va-CD: 0
X-V-A:  
X-V-T-CD: ee775fe296fae01696e403bd65ae1163
X-V-E-CD: 9ee6584fe98d86454e9294ebfdb90501
X-V-R-CD: 9ee6584fe98d86454e9294ebfdb90501
X-V-ID: 2f79a8ab-742f-4317-876f-464a9b2c1826
X-V-CD: 0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.573,18.0.942
 definitions=2023-03-22_18:2023-03-22,2023-03-22 signatures=0
Received: from st57p01nt-relayp04.apple.com (unknown [17.233.35.102])
 by ma-mailsvcp-mmp-lapp01.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) with ESMTPSA id <0RRY00Z7I1C2BE00@ma-mailsvcp-mmp-lapp01.apple.com>;
 Wed, 22 Mar 2023 15:33:39 -0700 (PDT)
From:   eric_sage@apple.com
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, kadlec@netfilter.org, pablo@netfilter.org,
        Eric Sage <eric_sage@apple.com>
Subject: [PATCH] netfilter: nfnetlink_queue: enable classid socket info
 retrieval
Date:   Wed, 22 Mar 2023 18:33:29 -0400
Message-id: <20230322223329.48949-1-eric_sage@apple.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-version: 1.0
Content-transfer-encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Eric Sage <eric_sage@apple.com>

This enables associating a socket with a v1 net_cls cgroup. Useful for
applying a per-cgroup policy when processing packets in userspace.

Signed-off-by: Eric Sage <eric_sage@apple.com>
---
 .../uapi/linux/netfilter/nfnetlink_queue.h    |  4 ++-
 net/netfilter/nfnetlink_queue.c               | 27 +++++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index ef7c97f21a15..9fbc8c49bd6d 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -62,6 +62,7 @@ enum nfqnl_attr_type {
 	NFQA_VLAN,			/* nested attribute: packet vlan info */
 	NFQA_L2HDR,			/* full L2 header */
 	NFQA_PRIORITY,			/* skb->priority */
+	NFQA_CLASSID,			/* __u32 cgroup classid */
 
 	__NFQA_MAX
 };
@@ -116,7 +117,8 @@ enum nfqnl_attr_config {
 #define NFQA_CFG_F_GSO				(1 << 2)
 #define NFQA_CFG_F_UID_GID			(1 << 3)
 #define NFQA_CFG_F_SECCTX			(1 << 4)
-#define NFQA_CFG_F_MAX				(1 << 5)
+#define NFQA_CFG_F_CLASSID			(1 << 5)
+#define NFQA_CFG_F_MAX				(1 << 6)
 
 /* flags for NFQA_SKB_INFO */
 /* packet appears to have wrong checksums, but they are ok */
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 87a9009d5234..8c513a2e0e30 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -301,6 +301,25 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
 	return -1;
 }
 
+static int nfqnl_put_sk_classid(struct sk_buff *skb, struct sock *sk)
+{
+	u32 classid;
+
+	if (!sk_fullsock(sk))
+		return 0;
+
+	read_lock_bh(sk->sk_callback_lock);
+	sock_cgroup_classid(&entskb->sk->sk_cgrp_data);
+	if (nla_put_be32(skb, NFQA_CLASSID, htonl(classid)))
+		goto nla_put_failure;
+	read_unlock_bh(sk->sk_callback_lock);
+	return 0;
+
+nla_put_failure:
+	read_unlock_bh(sk->sk_callback_lock);
+	return -1;
+}
+
 static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 {
 	u32 seclen = 0;
@@ -461,6 +480,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			+ nla_total_size(sizeof(u_int32_t)));	/* gid */
 	}
 
+	if (queue->flags & NFQA_CFG_F_CLASSID) {
+		size += nla_total_size(sizeof(u_int32_t));	/* classid */
+	}
+
 	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
 		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
 		if (seclen)
@@ -599,6 +622,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
+	if ((queue->flags & NFQA_CFG_F_CLASSID) && entskb->sk &&
+	    nfqnl_put_sk_classid(skb, entskb->sk) < 0)
+		goto nla_put_failure;
+
 	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
 		goto nla_put_failure;
 
-- 
2.37.1

