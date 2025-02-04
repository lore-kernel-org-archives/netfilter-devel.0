Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0757121A446;
	Tue,  4 Feb 2025 19:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698673; cv=none; b=obXSUUeeYNmHmhh51MxHJdPwI0tNWBWXBXT+8RbZuQmvoG8+6bAILMz5P+8oOytEvGyZ8yTj3mQDfOj9nyQ0v+HYFaDGmel6asAn61aGf0hRpiU7PdNd8l7HInOjIoHI9Jxh7VGbQeCgE4Yn/vFIq71vkajqnQvyKAi6WDJ9+/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698673; c=relaxed/simple;
	bh=YU4JoCvfHaJnfYC+QQbtlfDg9S6rBysnokHj5YZayaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maTCoiHJF/803eajfZClBKuAFhY7gbIg2NqC6M+t9NvoO8h4g9RwpoTvk0bCYZZ6QS/h7kNAdVzXq1vdTYj/0kWYu0RuhQe1xnPACtSrJKI5nKqBihP1qk3xP+QMwfma/3j0JsnOKfFk5r206C69F9Ee9mMKJyaXIPcjNTi2ZiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lCv1PKo3; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lCv1PKo3"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5dca451f922so5219352a12.2;
        Tue, 04 Feb 2025 11:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738698670; x=1739303470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n8HvkZmJkZm57OV0vPcPBoeyYDqVrx/cFN1Q/4mgUYY=;
        b=lCv1PKo34uenAss+iKab/jpHgpneIhKXst0TP5voQYw24OcF0ZcJFGO4vCiHPfbVHd
         6nq3wWSyy5WfWra2Oiod3reXWa3i50aqClRW0sXtfZ1/ithKf6FBctu1d21YCRD+Mf1p
         H8+6a1dsnztRX8qUESlPWICfEYvhwMo5m/FW5GCzP2PyplS0AHXnrzB40y4jn+9U540B
         IqpT88MrtY9IEr7B95vAVTUn8EGMK2LbAl5XFGqSKSDadrIaAcNrNzjdjqQbiiJ3E9ff
         7nnLoG//4JHlGDH9CRp/mxkIP6Ws19uATRvRzndlkPhRu64pMVpgwpkGMQIfNb+GNKAS
         shgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698670; x=1739303470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n8HvkZmJkZm57OV0vPcPBoeyYDqVrx/cFN1Q/4mgUYY=;
        b=F6W59jixn8tU+6i9JQX5T2tGYk9zc1h+574pQFrsYmjFB2i/LmQMtebUe1E6diNkYV
         1RHN4ljRBDpKgMLh7llbcynf/rV17ZKXyMsm104mFH1BHJYLIVPXga/K69iXNSP4y1/p
         MLNyyCGAM6lUoEQNSd6wKtiHDwZu58dUfAF5Fy+tQdCKkwLqoctpaykIOttF/TBR56EZ
         d+YZpWGvCI+cIe8kJ5J9zk9ykgMQp8PBRLTsvONL9LVOSLqE1HlzUr99YHKybUo4SMbr
         ZjEtvp1Egf5+BVTlG+jVnVM2J0PBnZlF5VYkHlsw3A2Mwfo9vlzHpHi2zzml/qLcVS6T
         lSjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjsgPbBRk1bjVcpJwQhxxOy1SAHfe2TcmrxYdghJYcZK6PCdw+1g0H8x/9A25yr4fBiiqdThfn@vger.kernel.org, AJvYcCW1S5v7spZGieka48o/yFXmAKP2tl+mdm2XZlVXaUzf2+7lBJNjG4OK7GqWR4WBT3bqGK6x7HWciv3u3Xo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxG50Nhwj+vBinSOG5xnD/vTHKEjdR06r1a3wu7Pq+7fGQolAM3
	Fzes/DmzdY4fLRyr42oA0SXpJ+/NZ/nDWeVJwRTy3Pecx5u6iB4d
X-Gm-Gg: ASbGncuQMi3oG7sYLToOHu7V6n2Z/5O8nTu67y81v4qexvewzL470MIP8Ys3SgYfp9e
	k3PWhXn5CtTDunCSjldRkaJBv8zH2tW/piscgfLgL+zf3OHJ1tZLaV3RZruf4c8ZBhARrKwMFwW
	EwgpChev9/TpXbSYSCNg0Y1UAFbvIrCbp+OVrdUWrL6ycrWvGhPA9VbA6leIIgzEshdTZX/oGwT
	PmyxgK6RuW1RmjZTJFiZaaH1yRlu8zBjBCE5U+3EV0pqsznR8540pB49a0PmptqZnxACTQfgIEa
	8hM0b/p4E4vHW20lp7oVJBCDHy4S+RCx1wmZ3f4jiWvJxPHOBlWznzplp1CrL06+rwwXYpSDMQQ
	/zA2JAJTHqCNNq5mPbj4nnZuuChY/uppk
X-Google-Smtp-Source: AGHT+IEgkR9cngeYGSBKrtj60P/qntixfamjgLo9a+91GbtMaXaiAtoRDutp4FoHkLaTPQBmEU/WBQ==
X-Received: by 2002:a05:6402:1ecf:b0:5dc:584e:8537 with SMTP id 4fb4d7f45d1cf-5dcdb774929mr241864a12.23.1738698670223;
        Tue, 04 Feb 2025 11:51:10 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc724d9de2sm10074894a12.81.2025.02.04.11.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:51:09 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [RFC PATCH v1 net-next 1/3] netfilter: flow: Add bridge_vid member
Date: Tue,  4 Feb 2025 20:50:28 +0100
Message-ID: <20250204195030.46765-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250204195030.46765-1-ericwouds@gmail.com>
References: <20250204195030.46765-1-ericwouds@gmail.com>
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
 net/netfilter/nft_flow_offload.c      | 4 ++++
 3 files changed, 7 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a7f5d6166088..77d6098badd4 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -145,6 +145,7 @@ struct flow_offload_tuple {
 		};
 		struct {
 			u32		ifidx;
+			u16		bridge_vid;
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
 		} out;
@@ -210,6 +211,7 @@ struct nf_flow_route {
 		} in;
 		struct {
 			u32			ifindex;
+			u16			bridge_vid;
 			u8			h_source[ETH_ALEN];
 			u8			h_dest[ETH_ALEN];
 		} out;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 1e5d3735c028..bcf9435638e2 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -127,6 +127,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
+		flow_tuple->out.bridge_vid = route->tuple[dir].out.bridge_vid;
 		dst_release(dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 03a0b5f7e8d2..95cc58cf068e 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -84,6 +84,7 @@ struct nft_forward_info {
 		__u16	id;
 		__be16	proto;
 	} encap[NF_FLOW_TABLE_ENCAP_MAX];
+	u16 bridge_vid;
 	u8 num_encaps;
 	u8 ingress_vlans;
 	u8 h_source[ETH_ALEN];
@@ -162,6 +163,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
 			}
+			info->bridge_vid = path->bridge.vlan_id;
 			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		default:
@@ -252,6 +254,7 @@ static int nft_dev_fill_bridge_path(struct flow_offload *flow,
 	ether_addr_copy(th[dir].tuple.out.h_source, src_ha);
 	ether_addr_copy(th[dir].tuple.out.h_dest, dst_ha);
 	th[dir].tuple.out.ifidx = info.outdev->ifindex;
+	th[dir].tuple.out.bridge_vid = info.bridge_vid;
 	th[dir].tuple.xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 
 	return 0;
@@ -344,6 +347,7 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
 		route->tuple[dir].out.ifindex = info.outdev->ifindex;
+		route->tuple[dir].out.bridge_vid = info.bridge_vid;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 }
-- 
2.47.1

