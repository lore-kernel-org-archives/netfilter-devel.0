Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E193016FC
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 11:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165700; cv=none; b=CYYto0gxIUokr0M0TVPecYtWkp6HTkS4OPoMJNzKhxkYjlJrLZu3F+O2IRyGnbYrwBJqcAlg09jKmDiAQYtr5IP3DD+0Amaz6PGPYc1+UZCtNML2iavj6PqrDUB4Kmi0I5iCnNokAY8im2QDjVz3ME0QHLEIH9nm7VPUmQsbFkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165700; c=relaxed/simple;
	bh=HNw0+spdTOu60fa7PI1Xd858IwuDlVTKSwE3Fp5tlxA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oc2EJCscsGwak4pX6lXNK3D2P/1VHhBVRpnITPDGzTBO7DYY2TOyUPN3F6fOZ7CaXDkbzl+X0Xivo9lZDqEiBPHyfhQEDV8rgJKoomNv5Xm988AuvBz9jBO6Gyj23Q8+noWn6QvrsOWALDB8vZkEeuomRjaiG7x6iUF0eXO62W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rvw8ESC3; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rvw8ESC3"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-66f727d6849so8052222a12.1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 04:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776165697; x=1776770497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R6fUbZJjiAUJqseR0AfY4kN5/jG1XsjI0aKzIVoGFQI=;
        b=rvw8ESC38vPj4NcWY7znjv9Iuo7K7FAOAsKKRxd+ZnpTR5yfQHiDBFQKLD/FkWN9jd
         oill3VmnfQNBbQ7XOtC7OZVbwXH8xjnEyVWm31IfT5ATpolFCuWNGnSxLD2vLDU89lbb
         HiycfR7prbI2QLSI3upEwz9l+N94DO1LJ7kkP8q7aNRMFBmSCwLgJdOiJ3XubYas4Y8j
         nM7UiUUy7NCzt0JD22sUguB1LghPY7nEDS5iwG3y0KOxRSJ+aJDUnQ+PevP0Q9EpEhiM
         xWBsUYUSH5TNZwJ47OCAHNLkys/RLmmQIcmWDfyZ6Af/bAeSbOy3sxyaSSCUXtYdSJ4Z
         DZ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776165697; x=1776770497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6fUbZJjiAUJqseR0AfY4kN5/jG1XsjI0aKzIVoGFQI=;
        b=T4RMhltLBZMpe7EU7WveWtzTB54CCn9bMi0U5OadpHIU5nf5wiIDT1XpdebgIFMKvC
         eCgXsZj6o+AC0/Jbcr98jyl9BMJdZWQajmJjeVosKFbLavdK2RNXWmsJQLmgn5zKYu+G
         651I8D0mnttfDIvFW1sxJ63fCZy+wxG130OXvfYMj1OtYJFNPjGvxS1BzEPRjdS4qPgM
         1qWwK2AlJ2HQZJ3hX985Qe2/KH6GAEB4wi/zexg6d85sOV15/kjE4B23tCpHt+U0+pCj
         cJ/VQJoecCZ6sydYZEqbjlGMGB0QsBOFxB9kPIaNMKVGlq3YHeGXi7G8ffmiAZlrNcez
         x17w==
X-Gm-Message-State: AOJu0Yx4dd+hQtDkgfugZVwaRrR9ukBbrxlChTUkPMH3cqilxwid1cDG
	6Sqb9vSP+IlWGYiuA3HzSHxneGrrBpczJ3/wZnX5Bs4PQpOlQwfw6WitCthLPw==
X-Gm-Gg: AeBDiesupB3QKp0LNVQXUZG7e9tDyAqW7mP1ThqxCQ3r2Ke2el6m77KJJ0fl21UcAfo
	0hiLuyH45Js5JM5613OCJBGoouDUO5EvKhjir000TPzW3G32/NIKK21IX1ENF7zkM8wQ/nJqPN8
	6vNl23Fk5WeuloUnfhZwNS9OGY6xmyFKTwzv3LtUtgo3DOc0n7iETA1bKGKzqGM5FowYK+XKX/D
	oIT/y+E9cJ2Qq/P8Lvx/eTGSD75PJkoXUrkGUIZXpxSeSQJ8VT1f6IsvYSyz5C24adSB/6cKaBU
	UdD/GParpQ/OeelwGJC/DXPUesUIVdyPT0LJhpXpXNUUg1p03qYoL56updMCjyT+FsTInC9v0mY
	bvgwpUseVFbNgaZ004I4dq+vUlL37Lz2VII8O90cBOYW7LPMq8tI44s+4G7P7zpq0SWck5s56gA
	diLAgoWDt0VbwRAf4jHWQAa1pBFRrswHVY5FMNAx/EHRpl4GVhJ1a8GeZ2SjwKENQp6vV39Ijkk
	hNXuj+Dv3joojDFvammH4DLO4qxg17HK6Ihp872kyOWEJCnqeWxeXo=
X-Received: by 2002:a17:907:1b08:b0:b98:6177:2f16 with SMTP id a640c23a62f3a-b9d72ad9ff6mr827094966b.53.1776165696277;
        Tue, 14 Apr 2026 04:21:36 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9d6e5c544asm389679366b.33.2026.04.14.04.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 04:21:35 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v2 nf] netfilter: nf_flow_table_ip: Introduce nf_flow_vlan_push()
Date: Tue, 14 Apr 2026 13:21:20 +0200
Message-ID: <20260414112120.248744-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Calling skb_reset_mac_header() before calling skb_vlan_push() does
remove the error:

"skb_vlan_push got skb with skb->data not at mac header (offset 18)"

But the inner vlan tag is still not inserted correctly.

skb_vlan_push() uses __vlan_insert_inner_tag() to insert the tag
at offset ETH_HLEN. But the inner tag should only be pushed, without
offset, similar to nf_flow_pppoe_push().

Fixes: c653d5a78f34 ("netfilter: flowtable: inline vlan encapsulation in xmit path")
Fixes: a3aca98aec9a ("netfilter: nf_flow_table_ip: reset mac header before vlan push")
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>

---

 net/netfilter/nf_flow_table_ip.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index fd56d663cb5b..0086f8a1a0d6 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -544,6 +544,26 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	return 1;
 }
 
+static int nf_flow_vlan_push(struct sk_buff *skb, __be16 proto, u16 id)
+{
+	if (skb_vlan_tag_present(skb)) {
+		struct vlan_hdr *vhdr;
+
+		if (skb_cow_head(skb, VLAN_HLEN))
+			return -1;
+
+		__skb_push(skb, VLAN_HLEN);
+		skb_reset_network_header(skb);
+		vhdr = (struct vlan_hdr *)(skb->data);
+		vhdr->h_vlan_TCI = htons(id);
+		vhdr->h_vlan_encapsulated_proto = skb->protocol;
+		skb->protocol = proto;
+	} else {
+		__vlan_hwaccel_put_tag(skb, proto, id);
+	}
+	return 0;
+}
+
 static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id)
 {
 	int data_len = skb->len + sizeof(__be16);
@@ -738,9 +758,8 @@ static int nf_flow_encap_push(struct sk_buff *skb,
 		switch (tuple->encap[i].proto) {
 		case htons(ETH_P_8021Q):
 		case htons(ETH_P_8021AD):
-			skb_reset_mac_header(skb);
-			if (skb_vlan_push(skb, tuple->encap[i].proto,
-					  tuple->encap[i].id) < 0)
+			if (nf_flow_vlan_push(skb, tuple->encap[i].proto,
+					      tuple->encap[i].id) < 0)
 				return -1;
 			break;
 		case htons(ETH_P_PPP_SES):
-- 
2.53.0

