Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9610EC6FD1C
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Mar 2023 02:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjCZCY5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Mar 2023 22:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCZCY5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Mar 2023 22:24:57 -0400
Received: from ma-mailsvcp-mx-lapp02.apple.com (ma-mailsvcp-mx-lapp02.apple.com [17.32.222.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B525359D
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Mar 2023 19:24:55 -0700 (PDT)
Received: from ma-mailsvcp-mta-lapp04.corp.apple.com
 (ma-mailsvcp-mta-lapp04.corp.apple.com [10.226.18.136])
 by ma-mailsvcp-mx-lapp02.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) with ESMTPS id <0RS300X0MW1H1S10@ma-mailsvcp-mx-lapp02.apple.com> for
 netfilter-devel@vger.kernel.org; Sat, 25 Mar 2023 19:24:54 -0700 (PDT)
X-Proofpoint-GUID: z6cCh9avy3OhngCvbyCksKNNMiyJ9hQ6
X-Proofpoint-ORIG-GUID: z6cCh9avy3OhngCvbyCksKNNMiyJ9hQ6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.573,18.0.942
 definitions=2023-03-24_11:2023-03-23,2023-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=interactive_user_notspam
 policy=interactive_user score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303260015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=from : to
 : cc : subject : date : message-id : mime-version : content-transfer-encoding;
 s=20180706; bh=blliniZxsCKmpdiOLCrOEeVWhVaDbIpogdiViZZrCSA=;
 b=gcUNqBYln8kUSlLPYZugArBoTdQ3pvuhtNap2oI70vr/+dn/EmD5LUyosk8p8OzqyeZh
 CVa57C99FHfqUWtijckbfENJFPz8MNGGbuvgukyFd8z3at2f53qXU4s4JdMq3MV0Qo8k
 kYX6BbByQI7yyjt1C0sbBsshApFX90qkigvSCTutb7Q8pR2vfvBRZsn8qcRkGJroVQ+W
 j8EWSvsrFpU1gR2+kIHbplwvl095kyeqYV/0cTfWsB+FWUUfdIsxqoX07Dz2Y54GA13d
 m1zEJl/p9n6eg5GzLbVWoYavKy65KJtnv3ghnVToMpHEcWVRerRG42v4iOhPg4OYosKW nQ==
Received: from ma-mailsvcp-mmp-lapp02.apple.com
 (ma-mailsvcp-mmp-lapp02.apple.com [17.32.222.15])
 by ma-mailsvcp-mta-lapp04.corp.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023))
 with ESMTPS id <0RS300WCAW1H4U00@ma-mailsvcp-mta-lapp04.corp.apple.com>; Sat,
 25 Mar 2023 19:24:53 -0700 (PDT)
Received: from process_milters-daemon.ma-mailsvcp-mmp-lapp02.apple.com by
 ma-mailsvcp-mmp-lapp02.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) id <0RS300X00VX1GA00@ma-mailsvcp-mmp-lapp02.apple.com>; Sat,
 25 Mar 2023 19:24:53 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: ee775fe296fae01696e403bd65ae1163
X-Va-E-CD: 95f3290d03d6b90feeaaa3d41a3a1906
X-Va-R-CD: 317e03692b2bae07536854479c8d59ac
X-Va-ID: 2c374593-c59a-42e2-a917-31eb23aa0679
X-Va-CD: 0
X-V-A:  
X-V-T-CD: ee775fe296fae01696e403bd65ae1163
X-V-E-CD: 95f3290d03d6b90feeaaa3d41a3a1906
X-V-R-CD: 317e03692b2bae07536854479c8d59ac
X-V-ID: d5215916-ab51-478f-863b-23c0b330faa7
X-V-CD: 0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.573,18.0.942
 definitions=2023-03-24_11:2023-03-23,2023-03-20 signatures=0
Received: from st57p01nt-relayp01.apple.com (unknown [17.233.53.191])
 by ma-mailsvcp-mmp-lapp02.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) with ESMTPSA id <0RS30000CW1GCR00@ma-mailsvcp-mmp-lapp02.apple.com>;
 Sat, 25 Mar 2023 19:24:53 -0700 (PDT)
From:   Eric Sage <eric_sage@apple.com>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, kadlec@netfilter.org, pablo@netfilter.org,
        Eric Sage <eric_sage@apple.com>
Subject: [PATCH v4] netfilter: nfnetlink_queue: enable classid socket info
 retrieval
Date:   Sat, 25 Mar 2023 22:24:49 -0400
Message-id: <20230326022449.92668-1-eric_sage@apple.com>
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
v4
- Fixed unused expression bug.
v3
- Renamed NFQA_CLASSID to NFQA_CGROUP_CLASSID.
- Changed guard from builtin to builtin/module (IS_ENABLED).
v2
- Remove classid flag, always include with NET_CLASSID.
- Include cgroup-defs header.
- Remove lock.

 .../uapi/linux/netfilter/nfnetlink_queue.h    |  1 +
 net/netfilter/nfnetlink_queue.c               | 22 ++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

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
index 87a9009d5234..5e7aa31d233a 100644
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
@@ -406,7 +420,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		+ nla_total_size(sizeof(u_int32_t))	/* priority */
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hw))
 		+ nla_total_size(sizeof(u_int32_t))	/* skbinfo */
-		+ nla_total_size(sizeof(u_int32_t));	/* cap_len */
+		+ nla_total_size(sizeof(u_int32_t))	/* cap_len */
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
2.31.1

