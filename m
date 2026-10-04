Received: from mail-ej2-f41.google.com (mail-ej2-f41.google.com [74.125.228.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D9F46D2B9
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134188; cv=none; b=hHFdAsXrnwSPrYGSmwKr8+Me0TQW54HHDvqAn21RnCAFReGRrtE3FZSci2b5fhg+vwPKdVelwU5GXzIM2n8Jc32dt336MdXjnfF1A37MhSau+tUAB+D2zHzasTx3N9okCxaz+NHTpd2U24XSHeWPWJsPCnN24jpusyXtwMNcCfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134188; c=relaxed/simple;
	bh=dj3NwmJPrPWb/bw6YKz6XnTWInhGE7dX0FcP3wklm9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKQjTqGf1bWpfSynit5NKWqirjehF2zSrMaiYGxBSFGRTWD/r7qdM5BXlziqeTdI7yt9qlroM5sJM5hZvocM5QR+t8FfeRJYeJPa1J6uViozNudWEYP7rvp+KuOBsAus7MqP2MOxuJgF2hPiu/MpSR4OZrWtIAmr0HutYG1Bujg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=Mm2sSM17; arc=none smtp.client-ip=74.125.228.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="Mm2sSM17"
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2e0b486d91so194212466b.2
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 10:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134181; x=1791738981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DQy1p6uH5D5EZA+BdR7YHzdsKEg9LefUPPRF/B7n4zU=;
        b=Mm2sSM17vVAzKT20oK0g+uDXswxBLImaEhGqc5eS2W6BQ0fQLZQkSY4HBP/KXxCE7t
         K327YbYlwP6WbZqWvZBDImm0ULDv9OxztUnJslzzlNrRdaTprV0/CHOonmKFaVQZf+ta
         7P3LXOTL30Py3LJhv0yMWRrmb2cvMgmYnar2XvOq95pg1wpyB4or1iiKjzo0m0l5n8SY
         eWdcrTny2rKauowywnxX8IOi510RUd+ZXGUEsDFfkrroIsk2aRFDx9FKW+ovwRXCNHoq
         XI4nQoCDvZQis7rPLfOPDH7lwjHVEc4T7ciNN2R8kQh2lnJU7ljA9CqcOBuabHZMAHaQ
         jF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134181; x=1791738981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DQy1p6uH5D5EZA+BdR7YHzdsKEg9LefUPPRF/B7n4zU=;
        b=kh4UaJK46CIGPB84w+pk7qTDbAQfMFQalDNnsFbm9fIpnKjw5YKoBJJJ3DSNX3pG2B
         dJWvci6Kv8hdOxIAw2HfSm3coLgqvwPRN/AJQIwpLqlMqp2af+MBAc29TEeQq+8M/z22
         LOM2vHptP1pT+14WMg5kA56Ezf5Mqt3V0UN6eYJQ1Ka889XY4/Y1ty9Y8ynoLGAEjSOU
         wiPZ+8Txct8NCwz9JF61EO36JvbNiCydMblOtYoomEmdKncHx9Df5ABWUPAGTjK9hYoS
         DLxvVrEVT4FpHnt7P3jvA8IdpRC6jFX04C1GPAwBU5vMp8xVfw06ZOH5kd3aburq8D8B
         Ruyw==
X-Gm-Message-State: AFuF++n6RbccjX7RKbSP04KsIZV8OsfldHkhxdxmMSFNIEZWU/OYquk7
	mbG2raGXxRluydSwSmjvm2catBbMG4ya4pHbQMKapxyfCm+/5HeaBas2JmgbQo4M+uJdQaXdOLp
	KmGcrzQ==
X-Gm-Gg: AYBFou0nvgEO1I7X43RPawb2bX2HHrs1DBeY6iYvMWrrAnTHFExpWJQt3tMONdl4cJ9
	0x3Q5JNbNCV3bfjumzOP8mOSaQW4SFsl5s546a9mGfCj+98vQG/jn+xfPgSvKMYvuOJvRNW1z5K
	CBqQUGvxutKiDDXnP0YvNCknprTl6vwBzCn38Y7MUmDK1flninuVzAfvabTuAMBo7oLRu21/TkN
	rK2+1S2EEOKEyYM2dwY06uZzR2Dhnrb6WJ5penUsgut25LLhsDX427iNO/MdOYyXeMd/pdXTm8O
	OlImGX5rtPa3HTDlR0woQSB7xTFc1cmWNWkZ+iQgFHuCtNtqJLmPzOiUc0p9jKcWXB1bXtcoNWU
	ODUuV70bGvLv6qpgLYWtjsyfVNkG6Ey9RTAJ3cwiHwEmmynA8aAlySQBsf148sazfFdx21t/tLS
	A91m7e0CYy/jb3MMp/zoVNI45JqZXWy6gwfdXtEDwS0H+MtIZqf2ptmc4JIqThOW8PkNUHUWJfp
	QHunmTJ6wDzvnHETdKWXK6sTBlr6QCrNxn9ryRzahZdYMUuNzM5qztHDqztDxwqIzLYrCxI2TTm
	KFL9Mvdf+CeNKgXJFN1iOWf/KASzNMmsA9J2qEo650qMYsIRU/vm+UgALDBmb0aoFWgNGIDSKbk
	pHCa7ecAOca4prYDkbjSrihRtkvX2yfjbFE0smuu30uH4PS7A/80Rv9HBmwgh9bE5mGwdqtWgoA
	ZkV5yFyuWcI8XGCP3OE3+I9Z5j
X-Received: by 2002:a17:907:7281:b0:c2d:c6e7:9e9f with SMTP id a640c23a62f3a-c2e4ad3fe21mr707178466b.27.1791134181453;
        Sun, 04 Oct 2026 10:16:21 -0700 (PDT)
Received: from Desktop (pd9513667.dip0.t-ipconnect.de. [217.81.54.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e4cd278cesm314885266b.37.2026.10.04.10.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:16:21 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nbd@nbd.name
Subject: [PATCH nf-next 1/3] 8021q: add vlan_dev_sw_netstats_rx_add() and vlan_dev_sw_netstats_tx_add()
Date: Sun,  4 Oct 2026 19:16:14 +0200
Message-ID: <20261004171616.3544880-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261004171616.3544880-1-julius@bairaktaris.de>
References: <20261004171616.3544880-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let code that forwards packets on behalf of a VLAN device update its
per-cpu counters, like dev_sw_netstats_rx_add() and
dev_sw_netstats_tx_add() do for devices with tstats. The netfilter
flowtable fast path uses them in the next patch.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 include/linux/if_vlan.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 20cc16ea4e5a..4873a12958da 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -231,6 +231,31 @@ vlan_dev_get_egress_qos_mask(struct net_device *dev, u32 skprio)
 	return vlan_qos;
 }
 
+static inline void vlan_dev_sw_netstats_rx_add(struct net_device *dev,
+					       unsigned int len)
+{
+	struct vlan_pcpu_stats *stats;
+
+	stats = this_cpu_ptr(vlan_dev_priv(dev)->vlan_pcpu_stats);
+	u64_stats_update_begin(&stats->syncp);
+	u64_stats_inc(&stats->rx_packets);
+	u64_stats_add(&stats->rx_bytes, len);
+	u64_stats_update_end(&stats->syncp);
+}
+
+static inline void vlan_dev_sw_netstats_tx_add(struct net_device *dev,
+					       unsigned int packets,
+					       unsigned int len)
+{
+	struct vlan_pcpu_stats *stats;
+
+	stats = this_cpu_ptr(vlan_dev_priv(dev)->vlan_pcpu_stats);
+	u64_stats_update_begin(&stats->syncp);
+	u64_stats_add(&stats->tx_packets, packets);
+	u64_stats_add(&stats->tx_bytes, len);
+	u64_stats_update_end(&stats->syncp);
+}
+
 extern bool vlan_do_receive(struct sk_buff **skb);
 
 extern int vlan_vid_add(struct net_device *dev, __be16 proto, u16 vid);
@@ -249,6 +274,17 @@ static inline bool is_vlan_dev(const struct net_device *dev)
 	return false;
 }
 
+static inline void vlan_dev_sw_netstats_rx_add(struct net_device *dev,
+					       unsigned int len)
+{
+}
+
+static inline void vlan_dev_sw_netstats_tx_add(struct net_device *dev,
+					       unsigned int packets,
+					       unsigned int len)
+{
+}
+
 static inline struct net_device *
 __vlan_find_dev_deep_rcu(struct net_device *real_dev,
 		     __be16 vlan_proto, u16 vlan_id)
-- 
2.53.0

