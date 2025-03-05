Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4BA21322F;
	Wed,  5 Mar 2025 10:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741170624; cv=none; b=m6Tv7MLEeJzRSRV08Nc8kPw49whyWvt/qh3j64znk3v8pCVuSWgZmiUw5ch3OS8IstHAAI/YRG78Nq4VNeclQWwjP/4gaI2kMUTfnpqu6jfL/MxGySmwhOzBvyQ4sqXqMXeZHGwW6sI4cmFaaAJiuY5Rw6Y3GDg0m0AkedxbDyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741170624; c=relaxed/simple;
	bh=p0tnMWIGIA/InZaEbYJ4fAsQNt/ffCRDvXF7e95d80s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtPN9s1JZnEdjHsmcRKfjzquqbCbXGqUzyLaGotSW2wl39sNyvR6qam34LA/lHxD+3ahZtkBFnzaRApzydds103EL7/qfIHht1d2uwKpAFdsb9aQ4NzASRLzz2m0IMmsUyKRJjSyBCJlhba0lihc7ZVzjx0Ey8Z1JnmenLv31VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iS2YDNIc; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iS2YDNIc"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aaedd529ba1so775696966b.1;
        Wed, 05 Mar 2025 02:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741170620; x=1741775420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rqdSTt2FRKV/rdzSsxvtYL3VjKNAZZPUvxCgkaQgdZ4=;
        b=iS2YDNIctBjKxlKDMxuFT3xiXrj2yhHgEYd58OE7PwJKDla7dkc5oMI2iXtar7RFwj
         bAfq4CHGHdQXXxGqBcKRGCLSPd3ny7MojaMyU6NOO7g8ZTREA/9mrX/GxBSzP9HXOox2
         WUvvblWCI11q2iwQvE21/F+pvO1ANcDfhVo5SHl3zeQTA5XhHx3nCrJpbdL/Ymk5nFgY
         HQiefn/F3hnUIeg8XHwa7qOWdI/VgBaseqatMwxuTE4Qgtloo6H7hZ1426kJdhXSs/tf
         o3B5KDWDc1+0FvG6tLNCpWWEQwBN7jA5QZ7j/Fh769n23Vm7r5k7PhqE5+Ox18mj0wwO
         7wbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741170620; x=1741775420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rqdSTt2FRKV/rdzSsxvtYL3VjKNAZZPUvxCgkaQgdZ4=;
        b=b4Mr6rmf+dx+pBqk/YNOigVUE9z9AWGntDgOLfRgVPJLTM0HhIESS9zK858XZB0cIE
         +ZhCgKyigXeuUu5wLC2jck9j6k77S5Y7OQdaxJbbN0Xnq9jYrtTgcaIIXYjUj99atSha
         X6p/hCdYFdE8Wy3Xk8ksFSuGK4FtF+H9qWQl8HUfoq2ZLcIFcBlgCX00wzr7/nZKySBG
         foeFgDqDXM0jyy6xqevdf6THrRqBhk84aNRLqHK1mh/gNGxF7PAwKpp6A7ZO73jjqzZU
         o/e7dpoLGgKqOBykTKsl+fBh4jMEQXziDZhCOdfWxLu7ALk1W08T/mQsSBp3POvR4qbT
         6noA==
X-Forwarded-Encrypted: i=1; AJvYcCUcJ0g8H42bfmlWjIzzqn3ylW7ZPbHN8kA5Rvrq0HHF2GUXlwjMT6+pBN2zgEqTO8RjlpYMJIlKEcqK53IA@vger.kernel.org, AJvYcCV04OiasbIfVIsooKmailh59iC5QQZTUV0AHFDCVEZMdF9RvBnNCx0DOE87AkMTW6/GWbf2lCvkogvk+8F18tEG@vger.kernel.org, AJvYcCVbU4PQ77stC/sbxUK/GnlCjnAsi3XVolymZ4rFc00P3wyp6BoAO4347tyo1k7lmR4IMfXl9LY4NiyQNHt2t5k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYdX8iTf7PyhfmB2R8IrvLj1vvm1BTcmaQHLj+iWPMRQ/7aaiz
	unwwEC0M18zfpqTMaZ9W32ksVqY/u4LA4kR5zzFL09GF4MdZlEWw
X-Gm-Gg: ASbGncueR+cV/HDfv+V5WytCkDgAxqX44R2VGdtmFu54WQK93vjsYh1NQ4ZN2QmS6o2
	iCDFFh6lQ9Nk5xjngi9vYTj5+7b6BklkvZt5dQL7YXJixisGMW3jrqgpkPeL7xNwkrZxV1Qwtyy
	aNM0SRdWW3EHpyZiZ+mmikbR7mA/6FeZyRYk0b5BhEQwepAU8Bh6vE5EAz0meoMMazb6PqXfuZX
	8tKMiFuokZwQTA320JH98ZDSMplFoNE8lrGnParKSsvw8QlJSGUb3DIHqK2DldDdZlvyG38p6/w
	sV/LrWnOwlXDCHcFvM/YcAEa2e6TqwbwaGQiCeXUabUx1rNxp8RvPflXOd6yubYOITXLuH8dtc4
	/Syn5Qk/BGeazsquG95CI8A0Mo5QGmmjo9yuFZeXDPCTyRUA4dGdLCxMiw7OyFA==
X-Google-Smtp-Source: AGHT+IEyEAbGkolCRetfSsPG/N4aNUq3eQAwNjiWAcgniXnsiF//es41+w34cXFkZ+c7lQRDgQiBdA==
X-Received: by 2002:a05:6402:274a:b0:5e4:92ca:34d0 with SMTP id 4fb4d7f45d1cf-5e59f47f014mr5890447a12.20.1741170620303;
        Wed, 05 Mar 2025 02:30:20 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1f7161a4esm247154266b.161.2025.03.05.02.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 02:30:19 -0800 (PST)
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
	Ahmed Zaki <ahmed.zaki@intel.com>,
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
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v9 nf 14/15] bridge: Introduce DEV_PATH_BR_VLAN_KEEP_HW for bridge-fastpath
Date: Wed,  5 Mar 2025 11:29:48 +0100
Message-ID: <20250305102949.16370-15-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250305102949.16370-1-ericwouds@gmail.com>
References: <20250305102949.16370-1-ericwouds@gmail.com>
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

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/linux/netdevice.h        |  1 +
 net/bridge/br_device.c           |  4 ++++
 net/bridge/br_vlan.c             | 18 +++++++++++-------
 net/netfilter/nft_flow_offload.c |  3 +++
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 81cdad85d9f1..1e2f519e8802 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -887,6 +887,7 @@ struct net_device_path {
 				DEV_PATH_BR_VLAN_TAG,
 				DEV_PATH_BR_VLAN_UNTAG,
 				DEV_PATH_BR_VLAN_UNTAG_HW,
+				DEV_PATH_BR_VLAN_KEEP_HW,
 			}		vlan_mode;
 			u16		vlan_id;
 			__be16		vlan_proto;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 02eb23e8aab8..55c64a1d2758 100644
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
index aea94d401a30..114d47d5f90f 100644
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

