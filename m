Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE511C84A5;
	Tue, 17 Jun 2025 07:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750143625; cv=none; b=PmSBYdezMIeoM7SzBmVlCSOnWantjaBEGQvZE38DG9fsAVDPVHH468Xuve9jpkSWEX2MF7vOtvoZUbNcdoIuCCpo8UPqUvxnU8hOI1W2fHTySoao6uv9EjIi6GapgnCs3+oZSXEAfLrBSF+r67CHdulnIz+wabqOg6MaRF0kGgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750143625; c=relaxed/simple;
	bh=fnXKC+kE1kzapP6V7PA3GQvLCLfe3+4m4/aZQual+C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvurfrrDhL3f4imfJsmAHHqofUJaZlwipaGxpGfpVthy/eIayrIw/ukSwoRVwoA0bN+k9BWiw7mv4iKRZjTA56XKC4g6wPMomRlJA6FErjKI7BN22LABUHFkQkWVTkUermESh9b3EvHhX9WBRSJEsY49/ZT4x2cgBWoTvPv/zd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cwO62h5S; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cwO62h5S"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ad883afdf0cso1049771466b.0;
        Tue, 17 Jun 2025 00:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750143622; x=1750748422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yDayaxCfi+rJ03DBA+oRwGPXv42rdoS6h5/CyVbxNJ4=;
        b=cwO62h5Sjcw4UBhZi+moyVVVdNYfkN1jWVS+FV+YQJDpOm16jkB67jcU3LRrK3VO9X
         1J0mh7cNj9EMeXLYdHksRtHq0UqaI+NX9eX5aghEzuO64mBMsn2DmDLe7x3TYLufZxcO
         DMsml2v7jpcsZLEdcmZFr5OxkrevPjMU3mx2jkzIH34qUU5fBjxsICnfdaDFk8m5Mvet
         BSpIeyAbvLi/fFvIx27TfXzM/YJbxRJaGceATrNf86tdHBNkc8sxDmLiP2mUX9ZZscIt
         Ipjanagl+9fEwNnrsk9FHQrekTtkmbeaa3E0uLHO6WkkKyuchn+z6niyrJvGRCeHUtXS
         6zjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750143622; x=1750748422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yDayaxCfi+rJ03DBA+oRwGPXv42rdoS6h5/CyVbxNJ4=;
        b=PH18085Tc0GZAC+QHltYJOcFLKE8ap4+N1L+HUxZk+xXNvfxoTnEqSl2Rngm41oQVc
         jw5BlKTWc/nWwBrCun2ucfGKvZO0THEOl+MEb9M2K1wq8C0XtWgrlx+GDErITsVDF+IT
         3dFQ+3PYEIvzSAi3q3cde+UlylohqXCmEB60B/RELwTeWGdmZbo8SquZbhhmmdiYp/mS
         xgO8FYpR8NGkiyl73kFy1lWf1SmXjMRBvAisJN52tNWBJ2CU3s9VKZ71Dux/PvmKiny6
         ar/m42C0oiA5UJnfLSMwbtQrqQ55yWW0chdoqnjtSGrV/sRhiE1u3fTEoyXvkygchdO7
         oDEA==
X-Forwarded-Encrypted: i=1; AJvYcCUQeEzJRsskJp2ytiZXYmPs3L+5bbq8MM49HLSrE1zT3YkTiAyz+NFI7DH5McPsDwu98nqswy8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPnNoDeCcRteEzYEqR0q1mEGrzfovQtcYH3wubtKL/6qg263Ns
	ZkrWpKf71pJDur53+T4lWep+X7bpMA/7dVRocri28dE02uZ/Rmge37w9
X-Gm-Gg: ASbGnctUIULh8KEojzyCuLoqCZiFZP6qsz9FK3ckxZWkdMElQNIPW8SLqWjx0hxN+lb
	KHmUA83SOkbKBYbL3H0F5/nW5ZaN+dSvoupdfIGffZAdpM8yfvt6ZsOMWLhWvIHlcR2WaONlx9k
	aYgH3t/N83rmgsDv3rFPqGKP7kHPo9Vf+hOyics7Wy+WCDBMG99jSLOrjN3dQ9VugSL9W8siW8s
	hgK15uQxuMc7oiMQGG3N73tCyKoUhrBngA6JT0P+detS2AegHzSLUt8oAc2JnHhj0qaaNVJQppD
	3EFeQkqcGEdEGo0dyK9tTx/rOa/o3RATU69rbjzzyJVhJ+tVlVBpGGH0d6jNS/+O9kScNM6iIyV
	DM5DAREiklo7ISzIRFEvjUhqBqPOyrcC16he+3lZb0pmBuPpXCRP4laRujjEfX2KaDRUcJJ7dd6
	ZKSiyg
X-Google-Smtp-Source: AGHT+IGB1d864rebUPjTIBayjkj+hWN0qYl/oV57wC28kC+xP+wzFoFmZxBw1zB0+2OwDXVxNpufdw==
X-Received: by 2002:a17:907:1c10:b0:adb:469d:2221 with SMTP id a640c23a62f3a-adfad4f5325mr1247003466b.45.1750143621773;
        Tue, 17 Jun 2025 00:00:21 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec8158d4dsm800843066b.28.2025.06.17.00.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 00:00:21 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v3 nf-next 1/3] netfilter: flow: Add bridge_vid member
Date: Tue, 17 Jun 2025 09:00:05 +0200
Message-ID: <20250617070007.23812-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250617070007.23812-1-ericwouds@gmail.com>
References: <20250617070007.23812-1-ericwouds@gmail.com>
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
index 9441ac3d8c1a..992958db4a19 100644
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

