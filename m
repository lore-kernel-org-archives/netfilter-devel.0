Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141E280034;
	Tue,  8 Apr 2025 14:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122545; cv=none; b=nNmVcF0UKmRUDLExdm7ri4BxzMaFePgkqRxd31/wtkHdZQFcT7YnAeKDRO4llE4wLbsGfOKZniLSmVaMZ1zDmEgmAHrLu6WMVl+XXNqfq1ADDvgEg6zwjoVow/Y21xb1GQXXi996RMlok8+/pGL6fNIaJMmbAy7kwpEXDrqdsbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122545; c=relaxed/simple;
	bh=nOrYqMubqxTGv5KNtjF1O7oZK/JDz3+D59IpKd0gg8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmNqIt3fi108X/ka8+9k95CvAllC2v02r/EEg+laLdvpqep1CZF8WvERQE4iDDu8gFAJyDEFCgBMhKsSdv6goTrCAnjya6l48IQFhX0Vhp4T3waazh9nv57pcHJtCLxtpFny3XOxgwUY6VjSn6slUfROTXBQV8luE8vsl6f1Pbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V/p/GK5d; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V/p/GK5d"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac2963dc379so4798166b.2;
        Tue, 08 Apr 2025 07:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122542; x=1744727342; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r6pm8m5p7l3Wl6ad4KPvTV2CLgdg/3JhHtUU/9SLOuI=;
        b=V/p/GK5dKHe9Uqg6D8cMZW5vIgdrkwBtthnkXbvbkNcu45uTNQq9tbGozMK5aeiT1i
         2Dz8MjgBZPaEoTQ60buE4PsXLee8xEzUtbslhFp7m9JowNeXhx8BMW8ghNS+zbQNET5B
         WMG9ifIWVscD3O46Soqyolm+Y6npnVy1uQYaylJO+J6wy7qoa49bHkXDQRLUSm6WEsG9
         1/OLy01/VQ9wap6ki+QR6Ip7XozFY/Rsccbkxu2K00Th+bBdh3tpJ+FJ9yUxCfWP5BvV
         35KmFEcOX6As1cZGLTclrXidb66KtEpeG+MoglKeOpkfwTLk7rNEtr0uS7SdLf/cJIMd
         31Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122542; x=1744727342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r6pm8m5p7l3Wl6ad4KPvTV2CLgdg/3JhHtUU/9SLOuI=;
        b=UaIcyKlCWhgGETFRz5aW4Jzkbi1oTSRfQu5fWTIz529kQz2MKpwGOWG1fvopUr8FNW
         yXy7VNih6IKEPY4Fo1U4/iDf5uW3KLZza/o4gLE8BYV79uiPizz+WrH+LKym7TSWlRC7
         SNxKuJeKAdUEqv/VrJ+padGBJ7CRKtobQZsUW+hbBE1LG4E/Y1aK183xDPW6zX4APmPX
         7xsu3eufuKy2BFcwTJ+zCT5u/OR3LZSJDkbV02A9ub3qHh3WJrhJNsVFqSin/z99mf/X
         0cxf6NRCSuX8mOclp2523ATIVEgG1BMxamzCtwXnWd4NR0Eet+rhJNPZIbQwCG/VL9M5
         jVvw==
X-Forwarded-Encrypted: i=1; AJvYcCWa/xMHoX9jFSWNm+gLocvt4fvbUdAEd5Pr+UKHOs69Z4q4M8dvr2b41gHqCEEacVVSHI0wbns=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc+SeJRguVa89sf6vfilBp5wlWRoiGcPwXpLcthYxZTcgA3OVa
	u1jJK/QK9XFXo5aDx4K5KBa/SHWvOH68LOMiSxSIheY0mUKH+esz
X-Gm-Gg: ASbGncswa5ymA8D4gj8W3fjfCzi4cg0SdbQFvr9kgxfP+JVEyJzAr6Vu+cvE77ofziq
	vCioU4BzZvaWQ4LeMwZejeIVW/pe41kI7w3HMssyxAIA8PHxZF4YuY+3BaYjXVs+dHR9FMS86cM
	5WjR6DSuLVaMzx1dXY80ciqMZqmMS3jlVbJwkvXfDjlEIhBFY4qqh887R6MjxLsDEU5XT8+kwbZ
	s5qe/BdcaqUQl6dukKuq/0w2zZ+CNQlwNtMbTO3nUZ3uJZD200xSDJ8N7A4zvSB73CXZmHVyIXL
	9Gnm8GKkFgJBy8oDN+4J6gyx+yRTKEh8vOZIJ4tcAtL/jCj5q1Gbh5d3OTMAEOc0IQCY+Obpr94
	lHKY5iIAuSt8Tyg1EBM+vNzUUGBxz+oApKTM28OGo33sbMzcs094oM0hkqkuKS/X2bjMrgLSjmw
	==
X-Google-Smtp-Source: AGHT+IF0VfoWhcj22hp/qAvT8MEVXQfTt4oEprg2BiX/bNN18z0aAZkQ6GME4rn3FW8rh2x2n8W73g==
X-Received: by 2002:a17:906:dc92:b0:ac1:e6bd:a568 with SMTP id a640c23a62f3a-ac7d1990002mr1417752066b.37.1744122542179;
        Tue, 08 Apr 2025 07:29:02 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c01c2c13sm910586466b.182.2025.04.08.07.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:29:01 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v2 nf-next 1/3] netfilter: flow: Add bridge_vid member
Date: Tue,  8 Apr 2025 16:28:46 +0200
Message-ID: <20250408142848.96281-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250408142848.96281-1-ericwouds@gmail.com>
References: <20250408142848.96281-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Store the vid used on the bridge in the flow_offload_tuple, so it can be
used later to identify fdb entries that relate to the tuple.

The bridge_vid member is added to the structures nft_forward_info,
nf_flow_route and flow_offload_tuple. It can now be passed from
net_device_path->bridge.vlan_id to flow_offload_tuple->out.bridge_vid.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/net/netfilter/nf_flow_table.h | 2 ++
 net/netfilter/nf_flow_table_core.c    | 1 +
 net/netfilter/nft_flow_offload.c      | 3 +++
 3 files changed, 6 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index d711642e78b5..9d9363e91587 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -146,6 +146,7 @@ struct flow_offload_tuple {
 		struct {
 			u32		ifidx;
 			u32		hw_ifidx;
+			u16		bridge_vid;
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
 		} out;
@@ -212,6 +213,7 @@ struct nf_flow_route {
 		struct {
 			u32			ifindex;
 			u32			hw_ifindex;
+			u16			bridge_vid;
 			u8			h_source[ETH_ALEN];
 			u8			h_dest[ETH_ALEN];
 		} out;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9d8361526f82..f6a30fc14fec 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -128,6 +128,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
 		flow_tuple->out.hw_ifidx = route->tuple[dir].out.hw_ifindex;
+		flow_tuple->out.bridge_vid = route->tuple[dir].out.bridge_vid;
 		dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index fdf927a8252d..31372a8ef37e 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -85,6 +85,7 @@ struct nft_forward_info {
 		__u16	id;
 		__be16	proto;
 	} encap[NF_FLOW_TABLE_ENCAP_MAX];
+	u16 bridge_vid;
 	u8 num_encaps;
 	u8 ingress_vlans;
 	u8 h_source[ETH_ALEN];
@@ -159,6 +160,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
 			}
+			info->bridge_vid = path->bridge.vlan_id;
 			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		default:
@@ -223,6 +225,7 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
 		route->tuple[dir].out.ifindex = info.outdev->ifindex;
 		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
+		route->tuple[dir].out.bridge_vid = info.bridge_vid;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 }
-- 
2.47.1

