Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2FC70818;
	Mon,  2 Dec 2024 18:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733162766; cv=none; b=Eg6r7+y0mYtxie2GpVTXVYuBcF/UAqfD4qYSDmftlye3fbFhjmLfvxpbOG9RPh0MwI6f/OCAgStksu0fRzplpycbnppkakh4GdsAdYRBXeNz+CBghzQOD/koq3srCSCp6yzym0Aav9zPzEGuhyFXhDdouqpFNM837NESHE8K2Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733162766; c=relaxed/simple;
	bh=SohDtRB2amvWbKYSjyiIAT7+gtkuiaHkuHOOcBzknVA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rm+rzeUAlsg44EcTTBJ5X2B09CI0moe1kF/cJygP6mgQVnK6WQgoExX4MtxR6EcraGTOr3KAoBl3e7av0cOoeHN/JHJQXvlT0Hj4LQrui+UaHIS4Wo5ZxjbxJtWnNqkv32A+ZT6nK9tysNVb+llVnyZC7EAVRaUn1PUY0YVPG5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IAd9D1Xi; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IAd9D1Xi"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B2Hfe3K014348;
	Mon, 2 Dec 2024 18:05:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=vZpce4mcEz8PyoN6JDO85pkM1Kepr
	SPv/e3K+egDxO8=; b=IAd9D1Xiaecpt9eWvvzznsaxiU9U8zhVU0mrPtP1jW21V
	XH6Y+WVCJu4L4eOD1LqYvNGAGFK+gfGiYa8KPg9qw1Nd0oMmQYb3CJUGEryEgJc3
	EbIZL6zwy1Eo0XB2lU0HHas7l1IwIvsmLFq+esoMft6oOiEcYvbrrnGyHZREQj4F
	OCKIpW+fYPWAZ1RNfX2Zge0JlDsy1l6ArzUFtf4YyGinI4SK+c8UFMPegpK2C3+a
	JtT/upfLPeuQtPj5ZPxHZBGGig8+96UjlDxKvaY29DO3h+vqtEf3i0Ihn1rw24jU
	OeFzdvdts6SHSdVnQs25Vk5RC+jvKTxt0KbGvW2Ag==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437s4c491n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Dec 2024 18:05:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B2I30p9001973;
	Mon, 2 Dec 2024 18:05:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437s56sea7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Dec 2024 18:05:09 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4B2HxeaY005058;
	Mon, 2 Dec 2024 18:05:09 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 437s56se83-1;
	Mon, 02 Dec 2024 18:05:09 +0000
From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To: 
Cc: saeed.mirzamohammadi@oracle.com, Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        xingwei lee <xrivendell7@gmail.com>, yue sun <samsun1006219@gmail.com>,
        syzbot+e5167d7144a62715044c@syzkaller.appspotmail.com,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH 4.19.y 1/1] inet: inet_defrag: prevent sk release while still in use
Date: Mon,  2 Dec 2024 10:04:58 -0800
Message-ID: <20241202180503.1099928-1-saeed.mirzamohammadi@oracle.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-02_13,2024-12-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412020153
X-Proofpoint-ORIG-GUID: ioy_Iu373wvvx6Q5kAErRhXCIl2pAOLL
X-Proofpoint-GUID: ioy_Iu373wvvx6Q5kAErRhXCIl2pAOLL

From: Florian Westphal <fw@strlen.de>

commit 18685451fc4e546fc0e718580d32df3c0e5c8272 upstream.

ip_local_out() and other functions can pass skb->sk as function argument.

If the skb is a fragment and reassembly happens before such function call
returns, the sk must not be released.

This affects skb fragments reassembled via netfilter or similar
modules, e.g. openvswitch or ct_act.c, when run as part of tx pipeline.

Eric Dumazet made an initial analysis of this bug.  Quoting Eric:
  Calling ip_defrag() in output path is also implying skb_orphan(),
  which is buggy because output path relies on sk not disappearing.

  A relevant old patch about the issue was :
  8282f27449bf ("inet: frag: Always orphan skbs inside ip_defrag()")

  [..]

  net/ipv4/ip_output.c depends on skb->sk being set, and probably to an
  inet socket, not an arbitrary one.

  If we orphan the packet in ipvlan, then downstream things like FQ
  packet scheduler will not work properly.

  We need to change ip_defrag() to only use skb_orphan() when really
  needed, ie whenever frag_list is going to be used.

Eric suggested to stash sk in fragment queue and made an initial patch.
However there is a problem with this:

If skb is refragmented again right after, ip_do_fragment() will copy
head->sk to the new fragments, and sets up destructor to sock_wfree.
IOW, we have no choice but to fix up sk_wmem accouting to reflect the
fully reassembled skb, else wmem will underflow.

This change moves the orphan down into the core, to last possible moment.
As ip_defrag_offset is aliased with sk_buff->sk member, we must move the
offset into the FRAG_CB, else skb->sk gets clobbered.

This allows to delay the orphaning long enough to learn if the skb has
to be queued or if the skb is completing the reasm queue.

In the former case, things work as before, skb is orphaned.  This is
safe because skb gets queued/stolen and won't continue past reasm engine.

In the latter case, we will steal the skb->sk reference, reattach it to
the head skb, and fix up wmem accouting when inet_frag inflates truesize.

Fixes: 7026b1ddb6b8 ("netfilter: Pass socket pointer down through okfn().")
Diagnosed-by: Eric Dumazet <edumazet@google.com>
Reported-by: xingwei lee <xrivendell7@gmail.com>
Reported-by: yue sun <samsun1006219@gmail.com>
Reported-by: syzbot+e5167d7144a62715044c@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240326101845.30836-1-fw@strlen.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 include/linux/skbuff.h                  |  5 +-
 net/core/sock_destructor.h              | 12 +++++
 net/ipv4/inet_fragment.c                | 70 ++++++++++++++++++++-----
 net/ipv4/ip_fragment.c                  |  2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
 5 files changed, 72 insertions(+), 19 deletions(-)
 create mode 100644 net/core/sock_destructor.h

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f97734f34746..f5f76a04fdac 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -682,10 +682,7 @@ struct sk_buff {
 		struct list_head	list;
 	};
 
-	union {
-		struct sock		*sk;
-		int			ip_defrag_offset;
-	};
+	struct sock		*sk;
 
 	union {
 		ktime_t		tstamp;
diff --git a/net/core/sock_destructor.h b/net/core/sock_destructor.h
new file mode 100644
index 000000000000..2f396e6bfba5
--- /dev/null
+++ b/net/core/sock_destructor.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _NET_CORE_SOCK_DESTRUCTOR_H
+#define _NET_CORE_SOCK_DESTRUCTOR_H
+#include <net/tcp.h>
+
+static inline bool is_skb_wmem(const struct sk_buff *skb)
+{
+	return skb->destructor == sock_wfree ||
+	       skb->destructor == __sock_wfree ||
+	       (IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree);
+}
+#endif
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 9f69411251d0..9144c3cf984c 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -28,6 +28,8 @@
 #include <net/ip.h>
 #include <net/ipv6.h>
 
+#include "../core/sock_destructor.h"
+
 /* Use skb->cb to track consecutive/adjacent fragments coming at
  * the end of the queue. Nodes in the rb-tree queue will
  * contain "runs" of one or more adjacent fragments.
@@ -43,6 +45,7 @@ struct ipfrag_skb_cb {
 	};
 	struct sk_buff		*next_frag;
 	int			frag_run_len;
+	int			ip_defrag_offset;
 };
 
 #define FRAG_CB(skb)		((struct ipfrag_skb_cb *)((skb)->cb))
@@ -319,12 +322,12 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 	 */
 	if (!last)
 		fragrun_create(q, skb);  /* First fragment. */
-	else if (last->ip_defrag_offset + last->len < end) {
+	else if (FRAG_CB(last)->ip_defrag_offset + last->len < end) {
 		/* This is the common case: skb goes to the end. */
 		/* Detect and discard overlaps. */
-		if (offset < last->ip_defrag_offset + last->len)
+		if (offset < FRAG_CB(last)->ip_defrag_offset + last->len)
 			return IPFRAG_OVERLAP;
-		if (offset == last->ip_defrag_offset + last->len)
+		if (offset == FRAG_CB(last)->ip_defrag_offset + last->len)
 			fragrun_append_to_last(q, skb);
 		else
 			fragrun_create(q, skb);
@@ -341,13 +344,13 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 
 			parent = *rbn;
 			curr = rb_to_skb(parent);
-			curr_run_end = curr->ip_defrag_offset +
+			curr_run_end = FRAG_CB(curr)->ip_defrag_offset +
 					FRAG_CB(curr)->frag_run_len;
-			if (end <= curr->ip_defrag_offset)
+			if (end <= FRAG_CB(curr)->ip_defrag_offset)
 				rbn = &parent->rb_left;
 			else if (offset >= curr_run_end)
 				rbn = &parent->rb_right;
-			else if (offset >= curr->ip_defrag_offset &&
+			else if (offset >= FRAG_CB(curr)->ip_defrag_offset &&
 				 end <= curr_run_end)
 				return IPFRAG_DUP;
 			else
@@ -361,7 +364,7 @@ int inet_frag_queue_insert(struct inet_frag_queue *q, struct sk_buff *skb,
 		rb_insert_color(&skb->rbnode, &q->rb_fragments);
 	}
 
-	skb->ip_defrag_offset = offset;
+	FRAG_CB(skb)->ip_defrag_offset = offset;
 
 	return IPFRAG_OK;
 }
@@ -371,13 +374,28 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 			      struct sk_buff *parent)
 {
 	struct sk_buff *fp, *head = skb_rb_first(&q->rb_fragments);
-	struct sk_buff **nextp;
+	void (*destructor)(struct sk_buff *);
+	unsigned int orig_truesize = 0;
+	struct sk_buff **nextp = NULL;
+	struct sock *sk = skb->sk;
 	int delta;
 
+	if (sk && is_skb_wmem(skb)) {
+		/* TX: skb->sk might have been passed as argument to
+		 * dst->output and must remain valid until tx completes.
+		 *
+		 * Move sk to reassembled skb and fix up wmem accounting.
+		 */
+		orig_truesize = skb->truesize;
+		destructor = skb->destructor;
+	}
+
 	if (head != skb) {
 		fp = skb_clone(skb, GFP_ATOMIC);
-		if (!fp)
-			return NULL;
+		if (!fp) {
+			head = skb;
+			goto out_restore_sk;
+		}
 		FRAG_CB(fp)->next_frag = FRAG_CB(skb)->next_frag;
 		if (RB_EMPTY_NODE(&skb->rbnode))
 			FRAG_CB(parent)->next_frag = fp;
@@ -386,6 +404,12 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 					&q->rb_fragments);
 		if (q->fragments_tail == skb)
 			q->fragments_tail = fp;
+
+		if (orig_truesize) {
+			/* prevent skb_morph from releasing sk */
+			skb->sk = NULL;
+			skb->destructor = NULL;
+		}
 		skb_morph(skb, head);
 		FRAG_CB(skb)->next_frag = FRAG_CB(head)->next_frag;
 		rb_replace_node(&head->rbnode, &skb->rbnode,
@@ -393,13 +417,13 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 		consume_skb(head);
 		head = skb;
 	}
-	WARN_ON(head->ip_defrag_offset != 0);
+	WARN_ON(FRAG_CB(head)->ip_defrag_offset != 0);
 
 	delta = -head->truesize;
 
 	/* Head of list must not be cloned. */
 	if (skb_unclone(head, GFP_ATOMIC))
-		return NULL;
+		goto out_restore_sk;
 
 	delta += head->truesize;
 	if (delta)
@@ -415,7 +439,7 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 
 		clone = alloc_skb(0, GFP_ATOMIC);
 		if (!clone)
-			return NULL;
+			goto out_restore_sk;
 		skb_shinfo(clone)->frag_list = skb_shinfo(head)->frag_list;
 		skb_frag_list_init(head);
 		for (i = 0; i < skb_shinfo(head)->nr_frags; i++)
@@ -432,6 +456,21 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
 		nextp = &skb_shinfo(head)->frag_list;
 	}
 
+out_restore_sk:
+	if (orig_truesize) {
+		int ts_delta = head->truesize - orig_truesize;
+
+		/* if this reassembled skb is fragmented later,
+		 * fraglist skbs will get skb->sk assigned from head->sk,
+		 * and each frag skb will be released via sock_wfree.
+		 *
+		 * Update sk_wmem_alloc.
+		 */
+		head->sk = sk;
+		head->destructor = destructor;
+		refcount_add(ts_delta, &sk->sk_wmem_alloc);
+	}
+
 	return nextp;
 }
 EXPORT_SYMBOL(inet_frag_reasm_prepare);
@@ -439,6 +478,8 @@ EXPORT_SYMBOL(inet_frag_reasm_prepare);
 void inet_frag_reasm_finish(struct inet_frag_queue *q, struct sk_buff *head,
 			    void *reasm_data)
 {
+	struct sock *sk = is_skb_wmem(head) ? head->sk : NULL;
+	const unsigned int head_truesize = head->truesize;
 	struct sk_buff **nextp = (struct sk_buff **)reasm_data;
 	struct rb_node *rbn;
 	struct sk_buff *fp;
@@ -484,6 +525,9 @@ void inet_frag_reasm_finish(struct inet_frag_queue *q, struct sk_buff *head,
 	skb_mark_not_on_list(head);
 	head->prev = NULL;
 	head->tstamp = q->stamp;
+
+	if (sk)
+		refcount_add(sum_truesize - head_truesize, &sk->sk_wmem_alloc);
 }
 EXPORT_SYMBOL(inet_frag_reasm_finish);
 
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 5a1d39e32196..84544e5df7fc 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -380,6 +380,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	}
 
 	skb_dst_drop(skb);
+	skb_orphan(skb);
 	return -EINPROGRESS;
 
 insert_error:
@@ -477,7 +478,6 @@ int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 	struct ipq *qp;
 
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMREQDS);
-	skb_orphan(skb);
 
 	/* Lookup (or create) queue header */
 	qp = ip_find(net, ip_hdr(skb), user, vif);
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 35d5a76867d0..8aab62c330ef 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -307,6 +307,7 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 	}
 
 	skb_dst_drop(skb);
+	skb_orphan(skb);
 	return -EINPROGRESS;
 
 insert_error:
@@ -473,7 +474,6 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 	hdr = ipv6_hdr(skb);
 	fhdr = (struct frag_hdr *)skb_transport_header(skb);
 
-	skb_orphan(skb);
 	fq = fq_find(net, fhdr->identification, user, hdr,
 		     skb->dev ? skb->dev->ifindex : 0);
 	if (fq == NULL) {
-- 
2.46.0

