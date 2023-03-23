Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF52C6FD1C
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Mar 2023 19:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjCWTop (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Mar 2023 15:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjCWToo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2023 15:44:44 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Mar 2023 12:44:43 PDT
Received: from rn-mailsvcp-mx-lapp01.apple.com (rn-mailsvcp-mx-lapp01.apple.com [17.179.253.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F994C0D
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Mar 2023 12:44:43 -0700 (PDT)
Received: from ma-mailsvcp-mta-lapp03.corp.apple.com
 (ma-mailsvcp-mta-lapp03.corp.apple.com [10.226.18.135])
 by rn-mailsvcp-mx-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) with ESMTPS id <0RRZ00SJLLEIOC20@rn-mailsvcp-mx-lapp01.rno.apple.com>
 for netfilter-devel@vger.kernel.org; Thu, 23 Mar 2023 11:44:43 -0700 (PDT)
X-Proofpoint-ORIG-GUID: FHXvV0SXFvqsJnqRM1bJtyhqVFzPAV1P
X-Proofpoint-GUID: FHXvV0SXFvqsJnqRM1bJtyhqVFzPAV1P
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.573,18.0.942
 definitions=2023-03-23_02:2023-03-23,2023-03-22 signatures=0
X-Proofpoint-Spam-Details: rule=interactive_user_notspam
 policy=interactive_user score=0 malwarescore=0 suspectscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303230136
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=from : to
 : cc : subject : date : message-id : mime-version : content-transfer-encoding;
 s=20180706; bh=+AndQ8MYsQRol2o5PlCKgTa1dx2t5ZmdaG2COuit10E=;
 b=FSqk03QDaA5buh0msTKSniz2QTNet3TImcW6sCX7mifiuYdnmpKOvfidWz06X7XMAW+u
 81yzPQ/KulP46v1Gty/izjapD1KmMTUmRnmn/4/SXlN+XnfC5xG0Cw8P66qUuNAD8Yhk
 knEB+XMO04cOYX2mXs4BPb4vjlAyLhx8b0kedjCGoWeVGarQvTGsaUC4noUF1aLMoXki
 uQmlQMLhBEmn8w1HU6u9aB5k3R44SHh7qETduFsYsAAb9PZZRyRAX52LTeloCWnuH6x6
 XPCQzWYkkpGFf8XRPPCoHsVG8sqZSb6q0pwpX3BIOW7Mk7elrRFJdYL1dJnm0YTZU1VJ 0Q==
Received: from ma-mailsvcp-mmp-lapp02.apple.com
 (ma-mailsvcp-mmp-lapp02.apple.com [17.32.222.15])
 by ma-mailsvcp-mta-lapp03.corp.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023))
 with ESMTPS id <0RRZ008G6LEIU740@ma-mailsvcp-mta-lapp03.corp.apple.com>; Thu,
 23 Mar 2023 11:44:42 -0700 (PDT)
Received: from process_milters-daemon.ma-mailsvcp-mmp-lapp02.apple.com by
 ma-mailsvcp-mmp-lapp02.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) id <0RRZ00J00L974400@ma-mailsvcp-mmp-lapp02.apple.com>; Thu,
 23 Mar 2023 11:44:42 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: ee775fe296fae01696e403bd65ae1163
X-Va-E-CD: af28a15ebe77da117276f0d01d89457e
X-Va-R-CD: c83db1447db106106efa14a4ecf7bb8d
X-Va-ID: bd75baae-49a7-4ab0-85d3-f94314a7c0cf
X-Va-CD: 0
X-V-A:  
X-V-T-CD: ee775fe296fae01696e403bd65ae1163
X-V-E-CD: af28a15ebe77da117276f0d01d89457e
X-V-R-CD: c83db1447db106106efa14a4ecf7bb8d
X-V-ID: f07ee16a-a1f1-4e4c-b073-33eba200ba36
X-V-CD: 0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.573,18.0.942
 definitions=2023-03-23_02:2023-03-23,2023-03-22 signatures=0
Received: from st57p01nt-relayp01.apple.com (unknown [17.233.46.8])
 by ma-mailsvcp-mmp-lapp02.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) with ESMTPSA id <0RRZ00A7WLEG5000@ma-mailsvcp-mmp-lapp02.apple.com>;
 Thu, 23 Mar 2023 11:44:41 -0700 (PDT)
From:   Eric Sage <eric_sage@apple.com>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, kadlec@netfilter.org, pablo@netfilter.org,
        Eric Sage <eric_sage@apple.com>
Subject: [PATCH v3] netfilter: nfnetlink_queue: enable classid socket info
 retrieval
Date:   Thu, 23 Mar 2023 14:44:38 -0400
Message-id: <20230323184438.42218-1-eric_sage@apple.com>
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
v3
- Renamed NFQA_CLASSID to NFQA_CGROUP_CLASSID.
- Changed guard from builtin to builtin/module (IS_ENABLED).
v2
- Remove classid flag, always include with NET_CLASSID.
- Include cgroup-defs header.
- Remove lock.

 .../uapi/linux/netfilter/nfnetlink_queue.h    |  1 +
 net/netfilter/nfnetlink_queue.c               | 20 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index ef7c97f21a15..efcb7c044a74 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -62,6 +62,7 @@ enum nfqnl_attr_type {
 	NFQA_VLAN,			/* nested attribute: packet vlan info */
 	NFQA_L2HDR,			/* full L2 header */
 	NFQA_PRIORITY,			/* skb->priority */
+	NFQA_CGROUP_CLASSID,		/* __u32 cgroup classid */
 
 	__NFQA_MAX
 };
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 87a9009d5234..689e291e38eb 100644
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
+#if IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)
+	if (sk && sk_fullsock(sk)) {
+		u32 classid = sock_cgroup_classid(&sk->sk_cgrp_data);
+
+		if (classid && nla_put_be32(skb, NFQA_CGROUP_CLASSID, htonl(classid)))
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
+#if IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)
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

