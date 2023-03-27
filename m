Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174B9C76195
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Mar 2023 17:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjC0RpY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Mar 2023 13:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjC0RpX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2023 13:45:23 -0400
Received: from ma-mailsvcp-mx-lapp03.apple.com (ma-mailsvcp-mx-lapp03.apple.com [17.32.222.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB901BE8
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2023 10:45:01 -0700 (PDT)
Received: from ma-mailsvcp-mta-lapp03.corp.apple.com
 (ma-mailsvcp-mta-lapp03.corp.apple.com [10.226.18.135])
 by ma-mailsvcp-mx-lapp03.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) with ESMTPS id <0RS600A5RXAVUN30@ma-mailsvcp-mx-lapp03.apple.com> for
 netfilter-devel@vger.kernel.org; Mon, 27 Mar 2023 10:45:00 -0700 (PDT)
X-Proofpoint-GUID: gp--CYl4FwariaOvA-ITiuNdK5jHaQ19
X-Proofpoint-ORIG-GUID: gp--CYl4FwariaOvA-ITiuNdK5jHaQ19
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.573,18.0.942
 definitions=2023-03-21_11:2023-03-21,2023-03-21 signatures=0
X-Proofpoint-Spam-Details: rule=interactive_user_notspam
 policy=interactive_user score=0 spamscore=0 suspectscore=0 mlxscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303210127
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=from : to
 : cc : subject : date : message-id : mime-version : content-transfer-encoding;
 s=20180706; bh=VCfhwtp9mfty6qVScHW51MmNBRNTqLjYRKuEMe0x5Kg=;
 b=afTgZiC4XHfxnV6d2ce65se9TSG0QvJy0Ynj4aLZXi1PWQUIbjjb4t0lu7KC6O/6UTto
 XwnV2wyb+Na0Tfp4ReP1TxxUzzflJwb0hkNOb/1I0GrViyFmtqzDr64y+d2sD410cZ/O
 o1O2LCwXcb6etNYFT42xCMTRu49ULxUXL+UNaJKp+tWLVFoOAVoWBG7U8Q6COo2PsfVJ
 eYHadlSPWdiqXKWjhyRZaOQpmyPco9HDA6fvqlcJNbLvG1n0esup0tNjEyjU24ABgcRi
 4MA7WWuaAJm9S43OLhxwGznUOm2MQkEiPK5s2Z72/M4Q4JkYDtP4d6CwMtjw+nJ8gGLU PQ==
Received: from ma-mailsvcp-mmp-lapp01.apple.com
 (ma-mailsvcp-mmp-lapp01.apple.com [17.32.222.14])
 by ma-mailsvcp-mta-lapp03.corp.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023))
 with ESMTPS id <0RS600A55XAVTT40@ma-mailsvcp-mta-lapp03.corp.apple.com>; Mon,
 27 Mar 2023 10:44:55 -0700 (PDT)
Received: from process_milters-daemon.ma-mailsvcp-mmp-lapp01.apple.com by
 ma-mailsvcp-mmp-lapp01.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) id <0RS600H00X0YDO00@ma-mailsvcp-mmp-lapp01.apple.com>; Mon,
 27 Mar 2023 10:44:55 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: ee775fe296fae01696e403bd65ae1163
X-Va-E-CD: 022846d2e0a7218f29e37446f5d78849
X-Va-R-CD: 500d9952cc856a99303c4fc64caa8f2a
X-Va-ID: 57e8f1db-ae5b-4dcc-8071-58060fd0db1f
X-Va-CD: 0
X-V-A:  
X-V-T-CD: ee775fe296fae01696e403bd65ae1163
X-V-E-CD: 022846d2e0a7218f29e37446f5d78849
X-V-R-CD: 500d9952cc856a99303c4fc64caa8f2a
X-V-ID: 10040ad9-b9ee-417d-bdef-7a854901999e
X-V-CD: 0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.573,18.0.942
 definitions=2023-03-27_02:2023-03-27,2023-03-20 signatures=0
Received: from st57p01nt-relayp02.apple.com (unknown [17.233.54.32])
 by ma-mailsvcp-mmp-lapp01.apple.com
 (Oracle Communications Messaging Server 8.1.0.22.20230228 64bit (built Feb 28
 2023)) with ESMTPSA id <0RS6002FUXAR7K00@ma-mailsvcp-mmp-lapp01.apple.com>;
 Mon, 27 Mar 2023 10:44:52 -0700 (PDT)
From:   Eric Sage <eric_sage@apple.com>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, kadlec@netfilter.org, pablo@netfilter.org,
        Eric Sage <eric_sage@apple.com>
Subject: [PATCH v5] netfilter: nfnetlink_queue: enable classid socket info
 retrieval
Date:   Mon, 27 Mar 2023 13:44:49 -0400
Message-id: <20230327174449.37015-1-eric_sage@apple.com>
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
v5
- Moved size adjust so that it compiles cleanly with/without flag.
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
index 87a9009d5234..e311462f6d98 100644
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
@@ -406,6 +420,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		+ nla_total_size(sizeof(u_int32_t))	/* priority */
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hw))
 		+ nla_total_size(sizeof(u_int32_t))	/* skbinfo */
+#if IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)
+		+ nla_total_size(sizeof(u_int32_t))	/* classid */
+#endif
 		+ nla_total_size(sizeof(u_int32_t));	/* cap_len */
 
 	tstamp = skb_tstamp_cond(entskb, false);
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

