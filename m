Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58DF3A5E80
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 10:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773742651; cv=none; b=tNeSlJFVodDpOE7yxv3RUkPrGoca/tCX9DFe8jGnAumlttyS8LFTANA2ShOYz7EasCSpkmNqpC6lgdpOPesE+scNqe4waJip+n4i44WIlYZ5livCUoA2xX/CTSzoPxmyWtaRLPX0ILThHu+vlZaSiGTWXUB8FHR2mhdaM/2V4Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773742651; c=relaxed/simple;
	bh=pBr7wKOt1VHnhEwSeJAROYu062K84Dc7BzVFIGRYKAY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CPuH/K1LawiRxH1S94kMR8DOgxd5PqPjBT1YtCZw4a0+yNJlb/GgKyjYCbf3tkF6JJlxD9YAdm7drCXKYABEO9vH/ia6JoinzOwrkjpDOtoFm4jKwU//tGnd0uEacJo2AG0IDx+7QkwzMbjoXAdm1nAbZkDrTj3FH2/Q9zyOD0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HmGVIblM; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HmGVIblM"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6670ba39400so1350873a12.3
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 03:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773742648; x=1774347448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7Jj1znMuSQTPO/G2m5vicgYLbzdRn+Ba//APkQrLGbo=;
        b=HmGVIblMnbk64xAeY8hdlnNjTj6+w7QCeGjInCAq6bYuoTmaVHa1foXv0Tis2cbSq8
         lfMvCpc/12teQ803Zwkp/FXnT+43TueKImH9LuahdiExJ7lOAtD5cY4QiV2uiehgxiWE
         K0jen+UZIrzakcr5TfRnv9MIS6B63wqYE1eG5zzS1m+q2owB8XCPH6mOUkY/VZipq27M
         GPBnKN1I75YhKMZ8aOUvSFt6TZsPBWO9I2l/JH7CEUHBWryWqmAIf5QGlkzcmC5wWTE5
         xih4ZVc4qfC9zcwtoCfJOX19AgYkHn+r2crWn5+oq64rMn4JSCeL/Ym0lCatsk8qEbTX
         FpVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773742648; x=1774347448;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Jj1znMuSQTPO/G2m5vicgYLbzdRn+Ba//APkQrLGbo=;
        b=L3i9aQQxF3F/cghVsgvqa4wC4tXQeN3KR1XRt4i7XHIq+WZOeWV8yXMgX0FoGwjZJu
         cCbYSww3D61VL99UVqgqFafrX+enQByq5CHfT5aJuTt2fvUlq8pMGVKN6FrfRKusZSzT
         +7wa9UlIDoaJ9BzSYqsduoBBlfq3B9vKG0f1+S8ky+YyQPyb7J5Ppiooe179LEb1JyVM
         6sKOUWO/Tz/YqfoOJrOfkkFSafebVc3wHgBJnUoZRvcg4PqIzpkrwtPxm3QCeZhEE13X
         y4t5gozR1aCiV1+/TW2dyRijNHd5edTCO/I9X3H2CXWnolVDt/Ykm7KmD2EoKJfplZnI
         LzgA==
X-Forwarded-Encrypted: i=1; AJvYcCVBR5L/RIbe3m/iVrjNLDUjM23stnXuZdK+QrALXWcuGFPIT3JnnRZVoVJj7QRf8rzSRobFpj1eIxv9khk5I5k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ9Uphze+p1gxdwSIW1dQw5s6+b+B/rhd8pMdtEvzQk16D04Ul
	UsgEAND3Qjn4H+7fWK22H2GXQBYJPvyMT+/QYM0IS2aqAEjY1N8Ham8x
X-Gm-Gg: ATEYQzwDxWujDPmI+Ld7gvTLjsy1YjNptbOVkZb/mXmDFwajqN/5dcvDS+fDNfS3YtE
	zCLcXNSNS1DWtYAR8hf/z6krZ/ZPI432ALNFfXvCmTywJrNjOYaHgcp3xnpQ8rbH5JjlwBWB1iC
	qwtBul2cUqQ69AwwT/6bGEZQEge2KO6ZALq1kJFQidcUq8iddtd0QHAg2gg/0I4+JOfisL/vasv
	H9CeWC8DglC7TdoPI5OfexYKgP0kUpIyrKlDqIAdUr6LO03ql/YhJYDAEuYP+5YSm43XtRZx6iZ
	+xmW+uGdh4hLI6Pq6noNXsUi127ALnwHoGuPZD8n0TvxSiuEMol9CizTV6e7LxlneyNhFej0Il4
	jkhY4pThBYv6YMw+SszePRu37HX4c0r8b5SKCQYX8la2v2qZShki9w8wFPdDym8r3XOU4dacaIs
	940FAgK/eud2ZWFFBlXrC/TIl6UWfegriU3GDzED2zf1h8IiIlBhZ1Zg6YeJjo60WQN3tUC6f9y
	eGoHyYad6pG5p3Go0Qyq5j3zoXXcaWPMQfi6bq0NRmu6GppnsYvdYk=
X-Received: by 2002:a05:6402:50cf:b0:663:44f0:640d with SMTP id 4fb4d7f45d1cf-663babe2665mr9318190a12.29.1773742647466;
        Tue, 17 Mar 2026 03:17:27 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-66753a078c0sm318154a12.17.2026.03.17.03.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 03:17:26 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v12 nf-next] bridge: Introduce DEV_PATH_BR_VLAN_KEEP_HW
Date: Tue, 17 Mar 2026 11:17:22 +0100
Message-ID: <20260317101722.358640-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following the path through a bridge, there are 2 situations where the
action is to keep:

1. Packets have the encap, and keep the tag at ingress and keep it at
   egress. It is typical in the forward path, when a vlan-device and
   bridge are combined.

2. Packets do not have the encap, are tagged at ingress and untagged
   at egress. Can be found when only a bridge is in the forward path.
   It is also possible in the bridged path, that maybe added later.

For switchdev userports that support SWITCHDEV_OBJ_ID_PORT_VLAN in
sitaution 2, it is necessary to introduce DEV_PATH_BR_VLAN_KEEP_HW.
The typical situation 1 is unchanged: DEV_PATH_BR_VLAN_KEEP.

DEV_PATH_BR_VLAN_KEEP_HW is similar to DEV_PATH_BR_VLAN_TAG, with the
correcponding bit in ingress_vlans set.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>

---

Changes in v12:
 -Split from [PATCH v11 nf-next] netfilter: fastpath fixes

Changes in v11: (results of testing with bridge_fastpath.sh)
- Dropped "No ingress_vlan forward info for dsa user port" patch.
- Added Introduce DEV_PATH_BR_VLAN_KEEP_HW, which changed from
   applying only in the bridge-fastpath to all fastpaths. Added
   a better explanation to the description.

Changes in v10:
- Split from patch-set: bridge-fastpath and related improvements v9

 include/linux/netdevice.h          |  1 +
 net/bridge/br_device.c             |  1 +
 net/bridge/br_vlan.c               | 18 +++++++++++-------
 net/netfilter/nf_flow_table_path.c | 10 ++++++++++
 4 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d4e6e00bb90a..8a0dba788703 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -907,6 +907,7 @@ struct net_device_path {
 				DEV_PATH_BR_VLAN_TAG,
 				DEV_PATH_BR_VLAN_UNTAG,
 				DEV_PATH_BR_VLAN_UNTAG_HW,
+				DEV_PATH_BR_VLAN_KEEP_HW,
 			}		vlan_mode;
 			u16		vlan_id;
 			__be16		vlan_proto;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index a818fdc22da9..80b75c2e229b 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -423,6 +423,7 @@ static int br_fill_forward_path(struct net_device_path_ctx *ctx,
 	case DEV_PATH_BR_VLAN_UNTAG:
 		ctx->num_vlans--;
 		break;
+	case DEV_PATH_BR_VLAN_KEEP_HW:
 	case DEV_PATH_BR_VLAN_KEEP:
 		break;
 	}
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 636c86fa1183..a42bc75bc883 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1494,13 +1494,17 @@ int br_vlan_fill_forward_path_mode(struct net_bridge *br,
 	if (!(v->flags & BRIDGE_VLAN_INFO_UNTAGGED))
 		return 0;
 
-	if (path->bridge.vlan_mode == DEV_PATH_BR_VLAN_TAG)
-		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
-	else if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
-		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG_HW;
-	else
-		path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG;
-
+	if (path->bridge.vlan_mode == DEV_PATH_BR_VLAN_TAG) {
+		if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP_HW;
+		else
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
+	} else {
+		if (v->priv_flags & BR_VLFLAG_TAGGING_BY_SWITCHDEV)
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG_HW;
+		else
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_UNTAG;
+	}
 	return 0;
 }
 
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index f2d7822824bc..e8e4465263e2 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -154,6 +154,16 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			case DEV_PATH_BR_VLAN_UNTAG_HW:
 				info->ingress_vlans |= BIT(info->num_encaps - 1);
 				break;
+			case DEV_PATH_BR_VLAN_KEEP_HW:
+				info->ingress_vlans |= BIT(info->num_encaps);
+				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
+					info->indev = NULL;
+					break;
+				}
+				info->encap[info->num_encaps].id = path->bridge.vlan_id;
+				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
+				info->num_encaps++;
+				break;
 			case DEV_PATH_BR_VLAN_TAG:
 				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
 					info->indev = NULL;
-- 
2.53.0

