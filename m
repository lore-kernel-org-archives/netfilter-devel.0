Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D609043DA42
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Feb 2026 16:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772209812; cv=none; b=CJ3H/lAw+0vnGuIlAlfhrYAjgONDP8aBp3ybMEInf8OMC2NFTjpjJd/4aHCb53Fad8XToAZxaA8lwtmhBWlUCue+fzJqeBwvXYzJ8pJH/mBNwEkoUZnvEbvdWaUILOYelHiNz7hOr2s27cewgkgxbJfPSPdUUjDkTHvJsV19768=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772209812; c=relaxed/simple;
	bh=gRRzJAYut20vuX+uLpiXEe4mAnxSpcr+TglGWaXxAvo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LwLiDiWyQsvfKJrkVWCntUepIdI0vAsXUXPb0WKjUG0CAJKU389h3+Iz/aRBKkrNDvDIrdiBLNs96Erdj9WnL3OMM+akd02pD9EDSCxIEB9Lg8O8HtAVcndoyni9eRQHjEYA/6wxUI3k0nK3ZWxKRybKoS0RFo4z5Oms0d9IY9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aXPeikX4; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aXPeikX4"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65c01595082so3778278a12.3
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Feb 2026 08:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772209807; x=1772814607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+l62BqL9NmRegeedzc1yCU+VeOAMH0TTIRf5fPEPPLc=;
        b=aXPeikX40VflgBP1DAiWyua+9n4XyyqmLqs+Ueqnty9fQJLNdw5jwl4cR5nuYeP8eM
         35zJz9Oeo1c6DWREO9eVZNrnvgmjH55i5axVNcq7Al1rmZw9Psr8YyOUUYc/DA923+5r
         4SZ783P/HKcsHAyOXUpdQOY3BEfA1VQfSKWZk54nKaF+gZ9H1nh4koI+Msco3iUB5+jD
         IKQ0nH42pH1PnsJIBIDnDxnD57DGzEZfPnQsdiZe8KbDcldA7+LiBcY1S3gIFzdv7QDc
         OcQ0ULI9rfH6y99fyGJvElaEKjsljhffrmpCv16sduwd731DDDvMhfqAAgh9yuro69IP
         z9nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772209807; x=1772814607;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+l62BqL9NmRegeedzc1yCU+VeOAMH0TTIRf5fPEPPLc=;
        b=bbibVQZH8KOMdzLpkfaARg/Ee9Hq3lvOgyDsBffiuI98E/Fx1iomLyLeYTzo7KG0wX
         i9iXRnK+YMcvBwJ1Ar10rf5BdPfehYIe3A2Nlf/Loox4JzadQ/9e9aEU4HzJUIztS5iA
         l5sG6/Ooow6xHT7G/0Lcyj8kfiUn9s0EdPbdeEJyo4A9rZJX7rsJpGKIjRO5UgIOoe6j
         uCUKlmse7CF50KuZ77x0/vRkuhVTl6/egjMvbUQ/LYGl9+X6pJemzbNBTuejQn/AKd8v
         l1+WkaLSExNqqw5CIpF90x8/IWe023G8UV0OvDDog0qXmc0J2RXJPUfVqIFCHLtcxa8A
         KOeg==
X-Gm-Message-State: AOJu0YwmFLCBmX+R7k9qFGV6FUrgPxs84BnQWqWu5DyceDT/mBP5JySQ
	Oppa5s9y9Zn8rT5gTfD7mdzMK/oKaOQmi6jzemrOP5S7m2rINiweCjEz
X-Gm-Gg: ATEYQzyr/465+tKGc8kbnrI4vxGg9FSKeUSUXxh89bxMjDgtIujLkbHi9x33lql11t0
	3xa20ocdWveAx84VzNNBI8aEfHjMGyLbjerkoklNPNzkd/amzsyJSZunye6C+R4KNGsY+3uUKgc
	3Wa3/9MR7Je9qUV6svBN8DQ4dnUfh9KDU4XWyizlTe5Csnkbm5EJEiCR5fWGTuFCTl0HuN68SLb
	yIRJFQzO4h/0n3c73rwCfRWxPNop2Z2W9GkqCIIKvCAZrAILy2fcMF9wR5Scn5w2d983E4l+Lny
	9VWmfxYH8KvLC4pcYAz3+3HdD6o3CZDY7kpnlDTLeE1jfuwyGUxdNKsU+IRS4Sk73ohtWVUi4P8
	8JgoO/k13ak1xU29qXhuipbyh2uftxm6f+Ci7cXVcFRYi7iwlpQMrVCTZ364DRMoJygmv3tLlLj
	PArNRLDjtwnndYBTRb2Y+/pocd1Fcgwyma4VBgLzt00ccILIv6ouiC6JH1Ft+YmmZPQppwbeiS3
	TGXHxEG3Oa9ol3z9xrO6Ke+VtjKn76jybBjRb/7ndaXWJV1T0lVXM0=
X-Received: by 2002:a05:6402:2803:b0:65f:aecc:4f17 with SMTP id 4fb4d7f45d1cf-65fddaf6ce1mr1828410a12.21.1772209806611;
        Fri, 27 Feb 2026 08:30:06 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65fac07c06csm1380458a12.33.2026.02.27.08.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 08:30:06 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v2 nf] netfilter: nf_flow_table_ip: Introduce nf_flow_vlan_push()
Date: Fri, 27 Feb 2026 17:29:55 +0100
Message-ID: <20260227162955.122471-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With double vlan tagged packets in the fastpath, getting the error:

skb_vlan_push got skb with skb->data not at mac header (offset 18)

Introduce nf_flow_vlan_push(), that can correctly push the inner vlan
in the fastpath. It is closedly modelled on existing nf_flow_pppoe_push()

Fixes: c653d5a78f34 ("netfilter: flowtable: inline vlan encapsulation in xmit path")
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>

---

Changes in v2:

- Targetting nf.git
- Amended commit message

 net/netfilter/nf_flow_table_ip.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 3fdb10d9bf7f..e65c8148688e 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -544,6 +544,27 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
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
+
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
@@ -738,8 +759,8 @@ static int nf_flow_encap_push(struct sk_buff *skb,
 		switch (tuple->encap[i].proto) {
 		case htons(ETH_P_8021Q):
 		case htons(ETH_P_8021AD):
-			if (skb_vlan_push(skb, tuple->encap[i].proto,
-					  tuple->encap[i].id) < 0)
+			if (nf_flow_vlan_push(skb, tuple->encap[i].proto,
+					      tuple->encap[i].id) < 0)
 				return -1;
 			break;
 		case htons(ETH_P_PPP_SES):
-- 
2.53.0

