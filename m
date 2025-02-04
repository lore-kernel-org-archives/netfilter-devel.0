Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67756218EA2;
	Tue,  4 Feb 2025 19:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698613; cv=none; b=DyLF8ThiOSEg0YSZgU5kGNp1q91Hd3ZO2iRl3cS2AwHMVov0e9RlDoP0uN4Si21QUz9RVkGlfqiT4+QJWc6RqlkcKw/8+iWa6cuOTDEwC6nZ+QmefRKE5Ge21lzy6O00bx0i1YDbku7VbX/SgB0Iz9Ob1A6INOIKrYukACgqBlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698613; c=relaxed/simple;
	bh=EMFBUpkmd5COgfTIlW8tvi9/f+9voyjto4Z8+2IBLWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejynbUvHJ8kqoWuvp1E/hPc4Ez923qbHgY5ZBnBL5ky90/poYPv3X3JKrBjkOpfaVJBFCkyG36waY/B7a04oxgglU1+NtoQDjvz09/gqW6j3Knd836a2lxkj3mWcM+WM+zf5dKRTEZvlGxS0dFXSBkWmruIZjcjhuRBEJaPFVjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lN6w6bnp; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lN6w6bnp"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ab74ecfdae4so142944966b.2;
        Tue, 04 Feb 2025 11:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738698609; x=1739303409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=//RthvClo4JzPeEnG1PywSOoZnVfBt6m8pYgKggGTpU=;
        b=lN6w6bnpjqKCBdet/OSaB8z/osYrgNGaFGmSkHo3I6vzvS3RP89P+PoKN0hfMZ+eaM
         lT/1/JFg8di+ob2RdHYDZW+YjfrbjcI23f/BOyC89vX5OzvOsaYMD8Ur4uwONuqcGI+z
         ZzhAeX0y6xetFGMAahoLn8289O607oSIPHthbFWHuJIj047Kbe04LkXj+d0Kq2o9B5AS
         7Bo9dTnXfP3ZL8EJz4bq9KScRCcRGgYTl7YRH7jrKUavFpS+vmiPL5fDHMlbLStE31FM
         oy4PhUXsgwm5BBHfE8tlJ2Sq1315CUAfXNHJaoo76x4867fPSEMBEHhJ7LTkXMCQ2Vk+
         Qq/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698609; x=1739303409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=//RthvClo4JzPeEnG1PywSOoZnVfBt6m8pYgKggGTpU=;
        b=QS1xkQRRRsLGpaj2GDnpyxIFL/ujTT5tLtCCmSO76w4IhcU3JJm5aYt8G4MSjSCme5
         nCXml6wB4joKXD+1e251gyiWQync4Ui5MfCgRZURnvQzzQVM1DPIAgBmoan1IGm/OZEz
         tnBD895hpLgp446YHeYgcm5zFo58z3/0sVDaihgZkDBC1u5wOoJ8iSiCwXN5lukzsnBw
         YIP/brWkBgjBYCpwm2eZE6N6dxFJqQdhXp6JGy3wY9YjB1ttM+NyEXtACMc/uTuyvulI
         39JGKcvlRwv1DlB543Uc+PGgZFSlK4umIvk6f7ekUh0gVrt5+gMiR70Bhrq9FoYAKMjy
         p/MA==
X-Forwarded-Encrypted: i=1; AJvYcCUpq3c0AN0KVv5qdFli6TdlDYdd7BrOB9MiSxY2j+U0gpkogZl2nSuOEuo8vu7JFpOEkVM+gP7iwvLZwZXcld4W@vger.kernel.org, AJvYcCVvsHSxEC2Q8fnsHUglbEeDq8LQL7J6nCEumSbQzneUg3ZeyBTJYhHUeUUjZLcdzyWi1Kui3/GLaqsZnQA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp++EMZ5JUhrRaLpv837V9hCwvKe/o9zy6x6f5/SWcLXer2dQc
	yyFOVA6MRazqK0YdxeCg1Hjsdrj0b9AufQ2vb1/2jr7uw3PgWD8q
X-Gm-Gg: ASbGncsd8hNW0qielPNokFq9Npvxr5DkRnhd3hxX8oiga+2+HXfmN1kANqxNXEFNW5d
	U29Rgt9gWA92p/6eR6LCSftHS5mKStX0wjhVQ/4vpfCclJIwS/pY/DBH5gC0DWCokbWv/MBoRW7
	2WTaKjsOA8icXVTEg5h2d2CxHtjaVkKxjTmx0zZ7rPS17GhvX0SG8a01qIrpGIklH8Vq2olTyHB
	t1L3GgZoC3QrkEj2ZSwbWOZ7i8TjY/3qtegq5hUwf3FljmU+KoxcfbsOnJV7cP4M1sP6OsCZg9p
	zMxy2HFsJtonunz3IvFiEVhKtjv4hzxcoAq5UyOSppE9v0KWxRGT9uBaQ/wyVmgtJlK8ZKovf4C
	pB3MIqBa9z5NUDww5RywNyESojNSXLiWt
X-Google-Smtp-Source: AGHT+IGt/6VgWu/uR4UpsMkru0toFiQ+1d3xhaiHmAvPsdOeeBceqic1mQLjOAWdzpkUw3jzvfdFrQ==
X-Received: by 2002:a17:907:9714:b0:ab6:621e:7587 with SMTP id a640c23a62f3a-ab6cfcb3a0amr3155424666b.4.1738698608664;
        Tue, 04 Feb 2025 11:50:08 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a5635bsm964684466b.164.2025.02.04.11.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:50:08 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v5 net-next 13/14] bridge: Introduce DEV_PATH_BR_VLAN_KEEP_HW for bridge-fastpath
Date: Tue,  4 Feb 2025 20:49:20 +0100
Message-ID: <20250204194921.46692-14-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250204194921.46692-1-ericwouds@gmail.com>
References: <20250204194921.46692-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces DEV_PATH_BR_VLAN_KEEP_HW. It is needed in the
bridge fastpath for switchdevs supporting SWITCHDEV_OBJ_ID_PORT_VLAN.

It is similar to DEV_PATH_BR_VLAN_TAG, with the correcponding bit in
ingress_vlans set.

In the forward fastpath it is not needed.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/linux/netdevice.h        |  1 +
 net/bridge/br_device.c           |  4 ++++
 net/bridge/br_vlan.c             | 18 +++++++++++-------
 net/netfilter/nft_flow_offload.c |  3 +++
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 872235e30629..5a7b0843dfad 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -868,6 +868,7 @@ struct net_device_path {
 				DEV_PATH_BR_VLAN_TAG,
 				DEV_PATH_BR_VLAN_UNTAG,
 				DEV_PATH_BR_VLAN_UNTAG_HW,
+				DEV_PATH_BR_VLAN_KEEP_HW,
 			}		vlan_mode;
 			u16		vlan_id;
 			__be16		vlan_proto;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index c7646afc8b96..112fd8556217 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -430,6 +430,10 @@ static int br_fill_forward_path(struct net_device_path_ctx *ctx,
 	case DEV_PATH_BR_VLAN_UNTAG:
 		ctx->num_vlans--;
 		break;
+	case DEV_PATH_BR_VLAN_KEEP_HW:
+		if (!src)
+			path->bridge.vlan_mode = DEV_PATH_BR_VLAN_KEEP;
+		break;
 	case DEV_PATH_BR_VLAN_KEEP:
 		break;
 	}
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 3e50adaf8e1b..8ac1a7a22b2e 100644
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
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index c95fad495460..c0c310c569cd 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -148,6 +148,9 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			case DEV_PATH_BR_VLAN_UNTAG_HW:
 				info->ingress_vlans |= BIT(info->num_encaps - 1);
 				break;
+			case DEV_PATH_BR_VLAN_KEEP_HW:
+				info->ingress_vlans |= BIT(info->num_encaps);
+				fallthrough;
 			case DEV_PATH_BR_VLAN_TAG:
 				info->encap[info->num_encaps].id = path->bridge.vlan_id;
 				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
-- 
2.47.1

