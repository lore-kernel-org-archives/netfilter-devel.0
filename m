Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66BB39B976
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 10:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776682715; cv=none; b=cTiOSa1Wvjs9/RkG5XlV2OzYJw5xvCzbnjuRV4e91hS/VKbMrq8SVeVQLhxcYvRtO1Cv2f9b1I9OkX9dZa2n9ldY0EWQvCjTUB5VJvLdI2L0V28Z24FdAyyATpKypaabFYjUhELwgWrdWXLbpMVfHIg5qNFFuAgtwRcSUBKDTs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776682715; c=relaxed/simple;
	bh=tGFWlJ9Emn6lMayfM7X7YT7f2+X67E/6qliDHAALv6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H1t9oJLPKpP6NfomjB106A3uX6FIio6kY19L/veT6EzJ9Vi0X3b/La4tNpnPr232vNFs/yPdW5L83ajQueELPdunbPLJdoKMbAwfPg+3QHRHw2g9X5vr7ltZiIzasFEifPBO4kH2OGTpJV32xw0MX1z99Inc2XxeZ0VL8GRfFyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kuwejd4m; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kuwejd4m"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4891f625344so6812145e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 03:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776682712; x=1777287512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xo1ra+dvGbFs6OJejHFLsiY9EUjfbBrgYOeoScEsTuc=;
        b=kuwejd4m+mq5a0aewiDuTaXsOZPk0oZtw4A9PqEl9cdOeyrCJulozNifgRHjgsakvg
         CZGT+PgRajEUScOTjIOmPqvTI1JSscnGehNWVDRog2tPhK+q9O+7Ybe9XOLneMZ9k4AQ
         oLyan1IdB6e6f4AYH1xLaFO6082Ts4FzhyyNaq7QgkH1TdtkKkbB3/IXVwHVdP/CWDVO
         rsb5tpeLWk+sYMEnorzbNNB56vyv+vDQfj76Q/AuWSx+9WnR5fYJowZryjZdCS+2CgVY
         huyGvi7YJlHxWHOMdv+TTs1tcHo/WZ2ZYGL3kKVRcEPF5l8dibk3daJXrBW+zD4bykei
         zt1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776682712; x=1777287512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xo1ra+dvGbFs6OJejHFLsiY9EUjfbBrgYOeoScEsTuc=;
        b=ZoNHuerj1y31Cce/08RmiD5vuJ4n63+UEAXpLxROs/osQiT7RtWEzV0eJdNnq0q3vZ
         9ShAxmsLtGIwWeEcltjwjXPufftbSFEUomhmdFRcMjN+n/sPO3/P5s8+UE1qqrcna4zV
         FaqcVlEC8PflYqXUzDEbhUx2GiUjvuzSdfHprJv4w3RKMoANw333flANETT72rHZexQz
         I6l4hOIagpAYoY4k9ckwoHaH+TtOAN3vjggYnveY7sOJqaS9s2GxBKQIfdc8I/kHz771
         Ww3I+sikrElkPESIXMMkPmqi8pLoOsPK7JP+s1P61O4jhpmT2+BOTBRhGYw06f4NPfQ9
         oo8Q==
X-Forwarded-Encrypted: i=1; AFNElJ+q6n/ECCRV69dWjc9rPlL3ivOmYMdycl0niubTQu7vCASU6QqVc1FsEUhoE0FIxhVgU++VaWdP4OZOnnBUngs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRLCG+v4KmXzZSNSbRZjH/OSZEVDwI2raw5Q9qkRCpUb5YzQ5D
	M43dK7UhkKiE2QbAI16XL3Ux7dq+PO2rH+4RLTyDS2AMFSUHUj4KEu9D
X-Gm-Gg: AeBDietBRrQI5KC7M1qju2mzwHwQDlIlrvpPDYncTWMc9d21aJN0EL1wGybD3TC7Ycu
	9ca9SbzLWA4GK3Y3PMg3OCCT3N4hkBI1/KvGst0GijmKuujKBu4LzNjcRywD0H3rKKHKvUpe53I
	kdhdHOxAQwJDz7gTo0AYd/jtlVn5anyjZpDOPrjFQa6l6Eir8wwuuckdR8b+Ta+sgGjLUiBGNex
	EH30NUlE1la945JTc49rThvFUS6GbjziJ5SXrerSfeN/UhvIWo0eZP2/OWvsRrRV+yt6ZttCQkq
	BVZ4XNvV2ZFMz5aYSIQcC5xP4WOgR2hY3/7WZAnvSCegDhUrjgd/hcPURq8TagTEpIf7W1D9NSb
	zxzG9l7WayI6i03PtKxx3ho7aobXa/WPGeFncu0XSdF/+WV7ttGZjni9maikBNWbGAd3rW0WW3l
	i6/uidddHGTEA4pUjpFW2CgDF3xH5Wf6vW26l1lg==
X-Received: by 2002:a05:600c:870e:b0:488:aa33:dc8f with SMTP id 5b1f17b1804b1-488fb84ffb8mr180290575e9.0.1776682711829;
        Mon, 20 Apr 2026 03:58:31 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-488fc1cfbf2sm290929495e9.15.2026.04.20.03.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 03:58:31 -0700 (PDT)
From: Mahe Tardy <mahe.tardy@gmail.com>
To: mahe.tardy@gmail.com
Cc: alexei.starovoitov@gmail.com,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	coreteam@netfilter.org,
	daniel@iogearbox.net,
	fw@strlen.de,
	john.fastabend@gmail.com,
	lkp@intel.com,
	martin.lau@linux.dev,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	pablo@netfilter.org
Subject: [PATCH bpf-next v4 3/6] bpf: add bpf_icmp_send_unreach kfunc
Date: Mon, 20 Apr 2026 10:58:13 +0000
Message-Id: <20260420105816.72168-4-mahe.tardy@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260420105816.72168-1-mahe.tardy@gmail.com>
References: <aI0MkNvWlE4FXMV8@gmail.com>
 <20260420105816.72168-1-mahe.tardy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is needed in the context of Tetragon to provide improved feedback
(in contrast to just dropping packets) to east-west traffic when blocked
by policies using cgroup_skb programs.

This reuse concepts from netfilter reject target codepath with the
differences that:
* Packets are cloned since the BPF user can still let the packet pass
  (SK_PASS from the cgroup_skb progs for example) and the current skb
  need to stay untouched (cgroup_skb hooks only allow read-only skb
  payload). The kfunc set the dst of the cloned skb by using the saddr
  as the daddr and routing it.
* Checksums are not computed or verified and IPv4 fragmentation is not
  checked early (icmp_send will check).
* We protect against recursion since the kfunc, by generating an ICMP
  error message could retrigger the BPF prog that invoked it.

Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
---
 net/core/filter.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index fcfcb72663ca..a6c3b9145c93 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -84,6 +84,10 @@
 #include <linux/un.h>
 #include <net/xdp_sock_drv.h>
 #include <net/inet_dscp.h>
+#include <linux/icmp.h>
+#include <net/icmp.h>
+#include <net/route.h>
+#include <net/ip6_route.h>

 #include "dev.h"

@@ -12423,6 +12427,86 @@ __bpf_kfunc int bpf_xdp_pull_data(struct xdp_md *x, u32 len)
 	return 0;
 }

+static DEFINE_PER_CPU(bool, bpf_icmp_send_in_progress);
+
+/**
+ * bpf_icmp_send_unreach - Send ICMP destination unreachable error
+ * @skb: Packet that triggered the error
+ * @code: ICMP unreachable code (0-15 for IPv4, 0-6 for IPv6)
+ *
+ * Sends an ICMP destination unreachable message in response to the
+ * packet. The original packet is cloned before sending the ICMP error,
+ * so the BPF program can still let the packet pass if desired.
+ *
+ * Recursion protection: If called from a context that would trigger
+ * recursion (e.g., root cgroup processing its own ICMP packets),
+ * returns -EBUSY on re-entry.
+ *
+ * Return: 0 on success, negative error code on failure:
+ *         -EINVAL: Invalid code parameter
+ *         -ENOMEM: Memory allocation failed
+ *         -EHOSTUNREACH: Routing lookup failed
+ *         -EBUSY: Recursion detected
+ *         -EPROTONOSUPPORT: Non-IP protocol
+ */
+__bpf_kfunc int bpf_icmp_send_unreach(struct __sk_buff *__skb, int code)
+{
+	struct sk_buff *skb = (struct sk_buff *)__skb;
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
+		if (code < 0 || code > NR_ICMP_UNREACH)
+			return -EINVAL;
+
+		nskb = skb_clone(skb, GFP_ATOMIC);
+		if (!nskb)
+			return -ENOMEM;
+
+		if (!skb_dst(nskb) && ip_route_reply_fetch_dst(nskb) < 0) {
+			kfree_skb(nskb);
+			return -EHOSTUNREACH;
+		}
+
+		*in_progress = true;
+		icmp_send(nskb, ICMP_DEST_UNREACH, code, 0);
+		*in_progress = false;
+		kfree_skb(nskb);
+		break;
+#endif
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6):
+		if (code < 0 || code > ICMPV6_REJECT_ROUTE)
+			return -EINVAL;
+
+		nskb = skb_clone(skb, GFP_ATOMIC);
+		if (!nskb)
+			return -ENOMEM;
+
+		if (!skb_dst(nskb) && ip6_route_reply_fetch_dst(nskb) < 0) {
+			kfree_skb(nskb);
+			return -EHOSTUNREACH;
+		}
+
+		*in_progress = true;
+		icmpv6_send(nskb, ICMPV6_DEST_UNREACH, code, 0);
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
@@ -12442,6 +12526,7 @@ int bpf_dynptr_from_skb_rdonly(struct __sk_buff *skb, u64 flags,

 BTF_KFUNCS_START(bpf_kfunc_check_set_skb)
 BTF_ID_FLAGS(func, bpf_dynptr_from_skb)
+BTF_ID_FLAGS(func, bpf_icmp_send_unreach)
 BTF_KFUNCS_END(bpf_kfunc_check_set_skb)

 BTF_KFUNCS_START(bpf_kfunc_check_set_skb_meta)
--
2.34.1

