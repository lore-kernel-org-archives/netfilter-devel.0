Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CD940DFBF
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 12:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779107343; cv=none; b=eKUPnPqX4CjyJmCfrnNIPprnm6p/Q6wG3nbaYhd7wLQr374NQ8+csgSJTluE6YsQIBhVEPuc3FnbyYZ30bKvV+dBP734Ygoue/dnWnCbsg65MHeEvJ4ZpsL5QJfvYHBdyjvP2+34DCF2VQB07EhOLWLPOZOJgid5Y6ZfSO3VA2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779107343; c=relaxed/simple;
	bh=Num5UEhWWJ++iqjNr0FXZD7Ac7NkxKnhx4f0uF+t0kE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YZRr5GtZcvXD+e2/wB9Qq9oEpy/8FAQnCo25bP5mIKkReXp7UKKup8ucDL+xoi4yZCwRvqGgw+wWHiPTj725LCchnQX2O3burhE1Ua2VB1XsxPmi6kP1qgbXNmrWCi2j4s561l2E+G504Jk+CmEo4fsxAeELo+uK+W6k4OH+32g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zxylhhel; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zxylhhel"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488b0046078so20019525e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 05:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779107340; x=1779712140; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GmdaOMheTN7BSD4uqOVA1U64VwWQ6C8IBhVvwLhEjBM=;
        b=ZxylhhelVASHMBjkazwzCcRhQ838zqaiyBBJo82L4FyINFUAi5A5Ml7OzwhuMLxgL8
         8NDADbPjNteueuaeDZQ/7qrVOsuw+sNZ2uLDLHbEJpLInTEQCzZrmrCluB+WeBoHfcTK
         aKPMlsGHNeHWnii2UN3rXAKl1PJi/hNpNYbe+i+KWLtXvFc0kpGdGgGxRVuWvRNx5jUj
         t2TJV0Yj/EdixOHfSflNuYYIb8XSKYVImCGCWzodQBXsSsRfYv1S90JUGeq5FJ2CYwiG
         vFto1E12iLvt6wRo6QKNMdxLisP/nQxkCkXsxq/ZdRXsM2999EEN9/qqoBJ8XwZJRd56
         fJgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779107340; x=1779712140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GmdaOMheTN7BSD4uqOVA1U64VwWQ6C8IBhVvwLhEjBM=;
        b=m2Fp7NS2/HRShqwB48rPKhGnCzt6+CAo0sesIbqNMcSeS/My5BxxKSey+VZqn/4i/c
         HWCQ8ZIsrUM5uchETXDhEIVtSxbpQ3banJjOrf/k5c27qHDOrSZY/jZ2/8qWcUZgYcTs
         RTMqgtJfCggQDq19PRG1I+7VR0zR/vRbZQ8lHcxhFoQdD+kHIj6RzxWQSWkoERtgt2ur
         Bf63+iodXiihaqwQQnXNCJ2p0VgWEvUO/W2/6EAHU1024C/TZlKElzBxvKnDrasymr41
         r2F+3udObSLrqYhztLlFFRQzYJKHgzFZqMsDjTaitu8kIjg8he4NY5i47a0dKkGAFgtk
         yuQw==
X-Forwarded-Encrypted: i=1; AFNElJ/PiElcTdfundutiI0jCcTJ5hCh4X+cBAsCbE0RdTDAxZLPoTAO4LbT7PlxR0v39LltAPPYjGNreH6AqLJI4fk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwS7GHQkzE2K0VWGKwX9qoQV+U7CUq6elncKasWe/8r72a1fyk1
	egRsLBrFqHJLwrD60+I+shrLOjHvG0vQZWaRg6z4LcITubj0jmVhhkAJ
X-Gm-Gg: Acq92OGZBMnLnmJB+uDXv07j5eEiuxP6dwdO6a3lDY9aURtp2Tt75RcNkhfcL8GNcxS
	oE0pMFLjQ9K20rjV516maEeuV+IaaYaO7wN3ex+COQ//sYJbtHrxgPIBE1LPL7CkXC8lR78Amau
	B8D8q2oDe028D6uqvKhaBK8DTSbDJiT80ccgg4ABBwY1w9GrAfcL0NyBYwG2kn/EKVGk0xjYe87
	pSU56GcL/5W6fOBSBdZ/lBieXtzgVJh1xPQEdeuFwuNo3I9e3IIlCStWkjGaFaIcYpz5N6MpjoU
	A5tTkWR/Xin3YJ60dyBGvNwTdQqksLahAXGNqhOGiWNfBT7kKigVVLzfiC+FwlUyWs9CQQHnkBb
	ibLfZg34I0GceohTVR/xMX0GtYCfTdOd7mFc2dFtRdjFaR0I9fApFo/8lbus7FBPdg3zOJpW209
	izUI2GQF3l5Kdav4Wy5Ki9Jxx+gmZ4ZP4gC6aMmw==
X-Received: by 2002:a05:600c:8906:b0:48f:e3e7:3d39 with SMTP id 5b1f17b1804b1-48fe5fdd63fmr177619075e9.11.1779107339331;
        Mon, 18 May 2026 05:28:59 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-48ff2cb4ae0sm104304315e9.0.2026.05.18.05.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 05:28:58 -0700 (PDT)
From: Mahe Tardy <mahe.tardy@gmail.com>
To: bpf@vger.kernel.org
Cc: martin.lau@linux.dev,
	daniel@iogearbox.net,
	john.fastabend@gmail.com,
	ast@kernel.org,
	andrii@kernel.org,
	yonghong.song@linux.dev,
	jordan@jrife.io,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	Mahe Tardy <mahe.tardy@gmail.com>
Subject: [PATCH bpf-next v6 3/6] bpf: add bpf_icmp_send kfunc
Date: Mon, 18 May 2026 12:28:39 +0000
Message-Id: <20260518122842.218522-4-mahe.tardy@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260518122842.218522-1-mahe.tardy@gmail.com>
References: <20260518122842.218522-1-mahe.tardy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is needed in the context of Tetragon to provide improved feedback
(in contrast to just dropping packets) to east-west traffic when blocked
by policies using cgroup_skb programs. We also extend this kfunc to tc
program as a convenience.

This reuses concepts from netfilter reject target codepath with the
differences that:
* Packets are cloned since the BPF user can still let the packet pass
  (SK_PASS from the cgroup_skb progs for example) and the current skb
  need to stay untouched (cgroup_skb hooks only allow read-only skb
  payload).
* We protect against recursion since the kfunc, by generating an ICMP
  error message, could retrigger the BPF prog that invoked it.

For now, we support cgroup_skb and tc program types. For cgroup_skb and
tc egress, almost everything should be good. However for tc ingress:
- packet will not be routed yet: need to set the net device for
  icmp_send, thus the call to ip[6]_route_reply_fill_dst.
- fragments could trigger hook: icmp_send will only reply to fragment 0.
- ensure the ip headers is linearized before processing, and zero out
  the SKB control block after cloning to prevent icmp_send()/icmpv6_send()
  from misinterpreting garbage data as IP options.

Only ICMP_DEST_UNREACH and ICMPV6_DEST_UNREACH are currently supported.
The interface accepts a type parameter to facilitate future extension to
other ICMP control message types.

Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
---
 net/core/filter.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 9590877b0714..843fa775596b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -84,6 +84,8 @@
 #include <linux/un.h>
 #include <net/xdp_sock_drv.h>
 #include <net/inet_dscp.h>
+#include <linux/icmpv6.h>
+#include <net/icmp.h>

 #include "dev.h"

@@ -12464,6 +12466,110 @@ __bpf_kfunc int bpf_xdp_pull_data(struct xdp_md *x, u32 len)
 	return 0;
 }

+static DEFINE_PER_CPU(bool, bpf_icmp_send_in_progress);
+
+/**
+ * bpf_icmp_send - Send an ICMP control message
+ * @skb_ctx: Packet that triggered the control message
+ * @type: ICMP type (only ICMP_DEST_UNREACH/ICMPV6_DEST_UNREACH supported)
+ * @code: ICMP code (0-15 for IPv4, 0-6 for IPv6)
+ *
+ * Sends an ICMP control message in response to the packet. The original packet
+ * is cloned before sending the ICMP message, so the BPF program can still let
+ * the packet pass if desired.
+ *
+ * Currently only ICMP_DEST_UNREACH (IPv4) and ICMPV6_DEST_UNREACH (IPv6) are
+ * supported.
+ *
+ * Recursion protection: If called from a context that would trigger recursion
+ * (e.g., root cgroup processing its own ICMP packets), returns -EBUSY on
+ * re-entry.
+ *
+ * Return: 0 on success, negative error code on failure:
+ *         -EINVAL: Invalid code parameter
+ *         -EBADMSG: Packet too short or malformed
+ *         -ENOMEM: Memory allocation failed
+ *         -EBUSY: Recursion detected
+ *         -EHOSTUNREACH: Routing failed
+ *         -EPROTONOSUPPORT: Non-IP protocol
+ *         -EOPNOTSUPP: Unsupported ICMP type
+ */
+__bpf_kfunc int bpf_icmp_send(struct __sk_buff *skb_ctx, int type, int code)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct sk_buff *nskb;
+	bool *in_progress;
+
+	in_progress = this_cpu_ptr(&bpf_icmp_send_in_progress);
+	if (*in_progress)
+		return -EBUSY;
+
+	switch (skb->protocol) {
+#if IS_ENABLED(CONFIG_INET)
+	case htons(ETH_P_IP):
+		if (type != ICMP_DEST_UNREACH)
+			return -EOPNOTSUPP;
+		if (code < 0 || code > NR_ICMP_UNREACH)
+			return -EINVAL;
+
+		nskb = skb_clone(skb, GFP_ATOMIC);
+		if (!nskb)
+			return -ENOMEM;
+
+		if (!pskb_network_may_pull(nskb, sizeof(struct iphdr))) {
+			kfree_skb(nskb);
+			return -EBADMSG;
+		}
+
+		if (!skb_dst(nskb) && ip_route_reply_fill_dst(nskb) < 0) {
+			kfree_skb(nskb);
+			return -EHOSTUNREACH;
+		}
+
+		memset(IPCB(nskb), 0, sizeof(struct inet_skb_parm));
+
+		*in_progress = true;
+		icmp_send(nskb, type, code, 0);
+		*in_progress = false;
+		kfree_skb(nskb);
+		break;
+#endif
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6):
+		if (type != ICMPV6_DEST_UNREACH)
+			return -EOPNOTSUPP;
+		if (code < 0 || code > ICMPV6_REJECT_ROUTE)
+			return -EINVAL;
+
+		nskb = skb_clone(skb, GFP_ATOMIC);
+		if (!nskb)
+			return -ENOMEM;
+
+		if (!pskb_network_may_pull(nskb, sizeof(struct ipv6hdr))) {
+			kfree_skb(nskb);
+			return -EBADMSG;
+		}
+
+		if (!skb_dst(nskb) && ip6_route_reply_fill_dst(nskb) < 0) {
+			kfree_skb(nskb);
+			return -EHOSTUNREACH;
+		}
+
+		memset(IP6CB(nskb), 0, sizeof(struct inet6_skb_parm));
+
+		*in_progress = true;
+		icmpv6_send(nskb, type, code, 0);
+		*in_progress = false;
+		kfree_skb(nskb);
+		break;
+#endif
+	default:
+		return -EPROTONOSUPPORT;
+	}
+
+	return 0;
+}
+
 __bpf_kfunc_end_defs();

 int bpf_dynptr_from_skb_rdonly(struct __sk_buff *skb, u64 flags,
@@ -12506,6 +12612,10 @@ BTF_KFUNCS_START(bpf_kfunc_check_set_sock_ops)
 BTF_ID_FLAGS(func, bpf_sock_ops_enable_tx_tstamp)
 BTF_KFUNCS_END(bpf_kfunc_check_set_sock_ops)

+BTF_KFUNCS_START(bpf_kfunc_check_set_icmp_send)
+BTF_ID_FLAGS(func, bpf_icmp_send)
+BTF_KFUNCS_END(bpf_kfunc_check_set_icmp_send)
+
 static const struct btf_kfunc_id_set bpf_kfunc_set_skb = {
 	.owner = THIS_MODULE,
 	.set = &bpf_kfunc_check_set_skb,
@@ -12536,6 +12646,11 @@ static const struct btf_kfunc_id_set bpf_kfunc_set_sock_ops = {
 	.set = &bpf_kfunc_check_set_sock_ops,
 };

+static const struct btf_kfunc_id_set bpf_kfunc_set_icmp_send = {
+	.owner = THIS_MODULE,
+	.set = &bpf_kfunc_check_set_icmp_send,
+};
+
 static int __init bpf_kfunc_init(void)
 {
 	int ret;
@@ -12557,6 +12672,9 @@ static int __init bpf_kfunc_init(void)
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
 					       &bpf_kfunc_set_sock_addr);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_kfunc_set_tcp_reqsk);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SKB, &bpf_kfunc_set_icmp_send);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_kfunc_set_icmp_send);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT, &bpf_kfunc_set_icmp_send);
 	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SOCK_OPS, &bpf_kfunc_set_sock_ops);
 }
 late_initcall(bpf_kfunc_init);
--
2.34.1

