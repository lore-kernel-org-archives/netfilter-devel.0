Received: from mail-vs2-f40.google.com (mail-vs2-f40.google.com [74.125.227.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770BD4854EA
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Sep 2026 20:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281564; cv=none; b=gRCOIi2scS4t50Xp5HiuqI/abCR5cuaJ8HlYTo+paf9mBHTrjR3aYsGvI2yOPGxXYXfLga61N9RGQ68BuWPwmyXyCMdHBGNo6Veo90b9N+42/ag+wNdCOKFtOYUrJf9AN7ban2qslRxDHSEZHLdue+VtbFj3t5HT22wKON9eDyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281564; c=relaxed/simple;
	bh=uRYPAtAtLif7i10854CTEewWmJAf/TWjXqRBv41TdEI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U9l8u9J9DzPyxCSd22SEvAPKeQEfFgj6QTx8x/mNP5CXLb9egimtGXgtG+CP+UXm/AKzdkV++aGQAlkR+ZaGlWLbGC5aqPrP9Qnkz0QB7Mvya5fZQs1FOZHhiQFpcKMJmtfq0+EfQuzcl9hxQdT++xAZ2j0qMpy/b+s9wdShvHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XI4oiPFE; arc=none smtp.client-ip=74.125.227.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XI4oiPFE"
Received: by mail-vs2-f40.google.com with SMTP id ada2fe7eead31-78565b4db79so117806137.3
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Sep 2026 13:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790281556; x=1790886356; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iv7JMCOOiStR26xduJ20yGu4jGk3+F31OuSygzoMJug=;
        b=XI4oiPFEvODXpDmkNwakyL26cPhBZO0fAkDbzIYLDNg6xgLvTAkKVqFwgam4Ojh4Zj
         1GsuEzJTH641jtPyku/gQLRYwtmylTydyUEgM6R0XYjqO6LGZEQI8LQ6hN6nxkyZXhGa
         7d1Q2uGNumuVABxni+c/deDXTBa1yO+AD0L0ULPNlplrPe2cglZXELUCSDIyrI2aWov5
         ZX4pL92GWVccxd6S1hNDBIqNpDDlruf1vOlgZCSbcJdlmfUE7ZquB+Trl1/bo7HO6XIU
         UWlwBKvq/NhavnzSHYDMqsVk5wnicTTlA+E9Is4YjVr0z4S5eJI7duLF57KyhTtzy2Ec
         1sLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790281556; x=1790886356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iv7JMCOOiStR26xduJ20yGu4jGk3+F31OuSygzoMJug=;
        b=24AOSwHmsMJ/W7e0aYdg2+DjVFvUQ2Qivkg3D3QnYMantqbb/2J7K8cobXnk/NRF2V
         ciaDj6N+EIiCdnpx0lyTnMCIFRIkP/UAvJ0L1cF9lkeRWz0TCjPEwm3IsXU7F0V8oXmw
         xL/7Fkxj9c2oP5BsiL7xC2+GheDPzJ1SaXQxdRtvXnhP2dmW/clNkZcAuTTCQpPnX0P7
         uWJKLKl78qZhG0qJV2GJ16FeU873H3VlycGLx+IOv7Q5KoWZEBdg6n4ba8919BH2NTXO
         oliK4vEngLw7p43ytR3P6eCbZJvLYsH+bl/5EG6Lv0KxrWI93s23Gy7j4NJTN4PShRfV
         nnZw==
X-Gm-Message-State: AFuF++k8dZZwPGN43bEabMXmRd1eEuHop3N8LEzublDIFbd/1Z6TP3GE
	yW67uE/t1QxmVKNiyhghWVcFsLP+nxwC6eMxMb3+J7e29QJEr8XwAhth
X-Gm-Gg: AYBFou15aC6oHIwBQpjFWCnAAEdfZhW+ncs8BJm2nMJX4Xcn7EI6JWBnJEvmz0/da+Q
	aMjiN8pQhm1DSRXCB4ayxV/pQRr30DdgJOkSx4LtBraFuZjlLwpz5R5fzNP/1X9JIPMLeSJxf8c
	dUP9chtmgit0XWuIsHX9VM56Ibabw/diRL+G5LBU0zN6d/svIwb4nOC2wp8uYnc+Btc9ljYE+tb
	sZ/cqQsp/kUiU2jZdWr8TXCbsv3VKDIHbcNux94X28OwbPaUKjDimymhEl2zcmN+hhxbmJ1no8u
	4Hr3zcm41nDqJNVupNGw1hWWy0m5n1rggZKQtJfrUNBuWZ77FhK1/XAdKJGoKQHKNkuqQJi1D9p
	iFcSbTrWVq/BsVM6B5qzQJDmK9fp1AAm6bxOdDIFtI6jINvRno2W0L1eJ7aUdUzdmYeMMUcjpDL
	aw7P2Sce4A0VTnVdtuSPOljmR3+G6bfUNaWVR7dtVTPGVbEWjvTH33zVA86XR3KU/49xJCJPbpv
	3rnxf383xqy
X-Received: by 2002:a05:6102:c53:b0:7a1:f7c3:3a45 with SMTP id ada2fe7eead31-7af1d6c4296mr1934116137.18.1790281556440;
        Thu, 24 Sep 2026 13:25:56 -0700 (PDT)
Received: from adriano.lan ([2803:9810:3dd5:d810:440b:4079:aa61:d217])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7b0db1d1152sm782102137.6.2026.09.24.13.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 13:25:55 -0700 (PDT)
From: Adriano Cordova <adrianox@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Adriano Cordova <adrianox@gmail.com>
Subject: [PATCH net-next] netfilter: nf_flow_table_bpf: populate VLAN encap in XDP flowtable lookup
Date: Thu, 24 Sep 2026 17:25:43 -0300
Message-ID: <20260924202543.1090535-1-adrianox@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

encap[] is part of the flow_offload_tuple rhashtable key
(flow_offload_hash() hashes up to __hash), so a lookup has to fill it like
the skb path does.  bpf_xdp_flow_lookup() builds its key from struct
bpf_fib_lookup only, which has no encap fields, so it leaves encap[]
zeroed and can never match a flow whose tuple carries a VLAN encap.

Fill encap[0] from an in-band 802.1Q tag, mirroring the ETH_P_8021Q case
of nf_flow_tuple_encap().

Link: https://github.com/xdp-project/xdp-tools/issues/488
Signed-off-by: Adriano Cordova <adrianox@gmail.com>
---
 net/netfilter/nf_flow_table_bpf.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/nf_flow_table_bpf.c b/net/netfilter/nf_flow_table_bpf.c
index cbd5b97a6329..479f8242da2b 100644
--- a/net/netfilter/nf_flow_table_bpf.c
+++ b/net/netfilter/nf_flow_table_bpf.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/if_vlan.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <linux/bpf.h>
 #include <linux/btf.h>
@@ -60,6 +61,8 @@ bpf_xdp_flow_lookup(struct xdp_md *ctx, struct bpf_fib_lookup *fib_tuple,
 		    struct bpf_flowtable_opts *opts, u32 opts_len)
 {
 	struct xdp_buff *xdp = (struct xdp_buff *)ctx;
+	const struct ethhdr *eth = xdp->data;
+	const struct vlan_hdr *vh;
 	struct flow_offload_tuple tuple = {
 		.iifidx = fib_tuple->ifindex,
 		.l3proto = fib_tuple->family,
@@ -91,6 +94,18 @@ bpf_xdp_flow_lookup(struct xdp_md *ctx, struct bpf_fib_lookup *fib_tuple,
 		return NULL;
 	}
 
+	/* encap[] is part of the lookup key, fill it from the 802.1Q tag. */
+	if (eth + 1 <= (const struct ethhdr *)xdp->data_end &&
+	    eth->h_proto == htons(ETH_P_8021Q)) {
+		vh = (const struct vlan_hdr *)(eth + 1);
+		if (unlikely(vh + 1 > (const struct vlan_hdr *)xdp->data_end)) {
+			opts->error = -EINVAL;
+			return NULL;
+		}
+		tuple.encap[0].id = ntohs(vh->h_vlan_TCI);
+		tuple.encap[0].proto = htons(ETH_P_8021Q);
+	}
+
 	tuplehash = bpf_xdp_flow_tuple_lookup(xdp->rxq->dev, &tuple, proto);
 	if (IS_ERR(tuplehash)) {
 		opts->error = PTR_ERR(tuplehash);
-- 
2.51.0

