Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CA6C74A5B
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Mar 2023 17:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbjCWRYH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Mar 2023 13:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjCWRYD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2023 13:24:03 -0400
Received: from ma-mailsvcp-mx-lapp01.apple.com (ma-mailsvcp-mx-lapp01.apple.com [17.32.222.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D92D23874
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Mar 2023 10:23:48 -0700 (PDT)
Received: from ma-mailsvcp-mta-lapp03.corp.apple.com
 (ma-mailsvcp-mta-lapp03.corp.apple.com [10.226.18.135])
 by ma-mailsvcp-mx-lapp01.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) with ESMTPS id <0RRZ002Y7HNNZM00@ma-mailsvcp-mx-lapp01.apple.com> for
 netfilter-devel@vger.kernel.org; Thu, 23 Mar 2023 10:23:47 -0700 (PDT)
X-Proofpoint-GUID: _F-r1l_XlrtQPVDDiZh-IoUUKS1fUGWi
X-Proofpoint-ORIG-GUID: _F-r1l_XlrtQPVDDiZh-IoUUKS1fUGWi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.573,18.0.942
 definitions=2023-03-21_11:2023-03-21,2023-03-21 signatures=0
X-Proofpoint-Spam-Details: rule=interactive_user_notspam
 policy=interactive_user score=0 phishscore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303210127
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=from : to
 : cc : subject : date : message-id : mime-version : content-transfer-encoding;
 s=20180706; bh=PWyYlAggYBzcJYO8PraeDpHjAEn9+hHFtG2R0Rplilo=;
 b=OpD45d7/ml6uBMRgqDepR/AU0rzQLele5cs4ePW7r543mJWj9ubNdTznCX/ojqaMrkMk
 5xur23mxh6Y1DLvGcE99M5bDX9gjibpdX9glJrlmvOHY7YNSrId4PQjkoY0NzLJeKRC5
 1mZAlTJ+K2ouDfyQjFv0LMs3hH56AvIaLW1lskLLZx62RkJVUOhmiiZiXk5GHlby5Xi7
 2WfJS+qf4/JJwUe02wiXFhtDdzRy34k2tkzc44UswgzbWEmDKSZKfPijrLxf9gYw8N93
 A+pXZBN9dVvQTDotmae1pocB4Gq1sw+n6KfrJlxUQGdKpvCT6SvL4ovadZbq112Wh9VV 9A==
Received: from ma-mailsvcp-mmp-lapp01.apple.com
 (ma-mailsvcp-mmp-lapp01.apple.com [17.32.222.14])
 by ma-mailsvcp-mta-lapp03.corp.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023))
 with ESMTPS id <0RRZ010DUHNNCQ10@ma-mailsvcp-mta-lapp03.corp.apple.com>; Thu,
 23 Mar 2023 10:23:47 -0700 (PDT)
Received: from process_milters-daemon.ma-mailsvcp-mmp-lapp01.apple.com by
 ma-mailsvcp-mmp-lapp01.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) id <0RRZ00A00HLN7N00@ma-mailsvcp-mmp-lapp01.apple.com>; Thu,
 23 Mar 2023 10:23:47 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: ee775fe296fae01696e403bd65ae1163
X-Va-E-CD: e4cec93d3c7fa649de388baf7e4d24ac
X-Va-R-CD: cc7b31680bc1288be87a90c50b90193f
X-Va-ID: 42e53bf3-6023-4a88-8513-aad7ccb5a655
X-Va-CD: 0
X-V-A:  
X-V-T-CD: ee775fe296fae01696e403bd65ae1163
X-V-E-CD: e4cec93d3c7fa649de388baf7e4d24ac
X-V-R-CD: cc7b31680bc1288be87a90c50b90193f
X-V-ID: 6bfebf05-f4d9-4cf9-8814-98f83625ce9e
X-V-CD: 0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.573,18.0.942
 definitions=2023-03-23_02:2023-03-23,2023-03-22 signatures=0
Received: from st57p01nt-relayp02.apple.com (unknown [17.233.46.8])
 by ma-mailsvcp-mmp-lapp01.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) with ESMTPSA id <0RRZ00KIKHNMFB00@ma-mailsvcp-mmp-lapp01.apple.com>;
 Thu, 23 Mar 2023 10:23:47 -0700 (PDT)
From:   Eric Sage <eric_sage@apple.com>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, kadlec@netfilter.org, pablo@netfilter.org,
        Eric Sage <eric_sage@apple.com>
Subject: [PATCH v2] netfilter: nfnetlink_queue: enable classid socket info
 retrieval
Date:   Thu, 23 Mar 2023 13:23:22 -0400
Message-id: <20230323172321.33955-1-eric_sage@apple.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-version: 1.0
Content-transfer-encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This enables associating a socket with a v1 net_cls cgroup. Useful for
applying a per-cgroup policy when processing packets in userspace.

Signed-off-by: Eric Sage <eric_sage@apple.com>
---
v2
- Remove classid flag, always include with NET_CLASSID.
- Include cgroup-defs header.
- Remove lock.

 .../uapi/linux/netfilter/nfnetlink_queue.h    |  1 +
 net/netfilter/nfnetlink_queue.c               | 20 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index ef7c97f21a15..12f4eda93758 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -62,6 +62,7 @@ enum nfqnl_attr_type {
 	NFQA_VLAN,			/* nested attribute: packet vlan info */
 	NFQA_L2HDR,			/* full L2 header */
 	NFQA_PRIORITY,			/* skb->priority */
+	NFQA_CLASSID,			/* __u32 cgroup classid */
 
 	__NFQA_MAX
 };
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 87a9009d5234..b0c12aa3e9b0 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -29,6 +29,7 @@
 #include <linux/netfilter/nfnetlink_queue.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/list.h>
+#include <linux/cgroup-defs.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/netfilter/nf_queue.h>
@@ -301,6 +302,19 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
 	return -1;
 }
 
+static int nfqnl_put_sk_classid(struct sk_buff *skb, struct sock *sk)
+{
+#if IS_BUILTIN(CONFIG_CGROUP_NET_CLASSID)
+	if (sk && sk_fullsock(sk)) {
+		u32 classid = sock_cgroup_classid(&sk->sk_cgrp_data);
+
+		if (classid && nla_put_be32(skb, NFQA_CLASSID, htonl(classid)))
+			return -1;
+	}
+#endif
+	return 0;
+}
+
 static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 {
 	u32 seclen = 0;
@@ -407,6 +421,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hw))
 		+ nla_total_size(sizeof(u_int32_t))	/* skbinfo */
 		+ nla_total_size(sizeof(u_int32_t));	/* cap_len */
+#if IS_BUILTIN(CONFIG_CGROUP_NET_CLASSID)
+		+ nla_total_size(sizeof(u_int32_t));	/* classid */
+#endif
 
 	tstamp = skb_tstamp_cond(entskb, false);
 	if (tstamp)
@@ -599,6 +616,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
+	if (nfqnl_put_sk_classid(skb, entskb->sk) < 0)
+		goto nla_put_failure;
+
 	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
 		goto nla_put_failure;
 
-- 
2.37.1

