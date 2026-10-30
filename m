Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793334119;
	b=FTyjrW66faSLLuCVin2GrM7WTJyBo3z33WAIn2GygvHIcIVBFQ8pj8SH71iFj40QFAMf
	 HVxacIRV52jJWexs06FS9be7A0iAdCPfJe3rtE/3TfbHGJIVKyNT4ZyWjK17iCS0KyYdI
	 TvlqgHO8YDd17QymXqxS7dWdIWTtpBOwi4Y+dMW+H4VRGp/6LE0gi2m5WVt76McesrOBG
	 vv0z+RHSOzQ0EmXP2e1CXzf6lxUI3moFhKNPJa+W7p+12B5yJn5zAVdy6tG4yRZpHZERf
	 WWfKaxIxUURSgFZG3lWC9zvcZ44Y5rt94Y4sG0xtHy8xXGzpGPIympXFDLS64NaCdFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793334119;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=uu4+KvWwIV0d7oHG+0bpuFJz50WGRRgzdpZ6XppMrug=;
	b=c6lp9ijpu66VFL+WFEK73IldPoLRbLKnw/qwrxuv9I1eBzXyBzsArc39d5v+oej6/09U
	 wyn1CieBhoZ/ZNi46/RTWjGG2IsoCLgZMNfk3IZiHzYmlGkMbTw/vuQFgojdtkP0c/H21
	 Sjy4kHdXLsT9HP5hqj+9NLsSkEX26XM1DlDHf7+JJj6lP7FYyQKmZnKTurSo/o4EkN0Kz
	 sfzp+45wT3l2VH5rcJoer59hVBxeUlpGscGtHvSYsOsKb1G7OyqP/+vc9x0pYFuhAlfpv
	 hLGoRJZqWxdQk/d01xzpsG73hHG4vUNxxXmMDakt3Kg3e9tpSDutbwAqEw8vlOVusAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openai.com;
	spf=pass smtp.mailfrom=openai.com;
	dkim=pass header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=UQt10XbB;
	arc=none smtp.remote-ip=209.85.167.177
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1488D606A31F
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 04:21:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1488D606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=UQt10XbB
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-4a451915d8aso214647b6e.2
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 21:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1793334118; x=1793938918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uu4+KvWwIV0d7oHG+0bpuFJz50WGRRgzdpZ6XppMrug=;
        b=UQt10XbBkkvXiGl5Qft/UotQH8UE3kbVRvvtssudQnkCaG9GnY6433nC1ryUbs88XD
         U8nWbPb0vXcjs5jWmQ+K5Iz7gQYZ2eJrm1GRmeXjRzkjoT1doVzYm+Lb1QYaEa59mFby
         LK0jstYeyvXJrZFbBo842W2EzZPw4CA3v1VVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793334118; x=1793938918;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uu4+KvWwIV0d7oHG+0bpuFJz50WGRRgzdpZ6XppMrug=;
        b=MosX+rdKMhGiK4eVLQQaVXfOCfrP0luODGJvB3lOU33ybazV3a6miGF76MDPOlt3x1
         4CwEyoeY4iH3+cg20h7BFDzkBleWIQhRf/iIKjQ37m5ax+2ArdftGQJuHBFpAS4U9Rw2
         tEGu2A8DMEXr7FsKjWmHfasssuRpHKk/82LSMAPkWp93LqcyY9kayU2b4eBX3E/bD2WI
         bFl0rpZu84JaVrWRJ6yFBFlKcEKCt+tHSB99jJOkK2BwDXctmaf5pGmTfykFW8DH1ugy
         xMnD58Qp2tFHqa1mVqPLNlt/D4EI4QZGIetrUL5k0V8gO7CH3OTHWO/wRK5BJLVPaDVX
         cPhg==
X-Gm-Message-State: AFq9FYJ+l0cgc5+EmdV9Z1NcnQB0QNRBAfnIY1n0fU1YX9NdZL9RBXxO
	YiYTbTGmFY40yGB24CCm4AsB0lUB63baTGPLvVzU0zgyscwEJo0J+NK0GjaS9yUDbKkgOL54kYP
	Y/CaKuKM=
X-Gm-Gg: AYBFou2kWHJs+K5XICpvIJd6sQIhe8KuVgbPe0aI8BTSQPbsEQfwPOzFYej6TgcmQmp
	DGRb0xiv5wviihnjXE5m5h4MrqSuTQF4GshJbmamjrRKXndhQIWcCWgihmNEB0V0FWZquSuPclt
	k+42UyXDnoe2/3K4IIOyDSOYgrEkkkYka/V1SyyjOIli6ywP+hzaPZfb9lL9IE/2lbrYLMCXgCq
	kWfYihfeB0GMJDjT0Z1Hi6yYdc95aHK8pGzBVheZtjkEgx/2Q4WLxO1ZYvUmiiYtxMl+0EeIpF4
	7r4BEz+ZZOuaWE4m8IJTnsinSHh3UEQYsO7il/hdUUk3RKOEZbINPOsjjtmslhr2Zu1YxrF2Zpm
	jYpGuviOP8Xhus5zRvIPWmpcy7rN1tAA7KCuUAlgrZjDp9PfrZn1AOvdyKx7pOgm1BNYJg+IOo7
	XlPSP8yQ7vFGsZisGLZCk+CHWGcLbaumcaiVA6BH3D0gRhZjeAcAW93PjTUUB+o7FWTXVOLW6ef
	TJZ2ZM+4OtIEHaDBeZV7MsMF60f3vctqiP0lLNd8Sh9rdjpSRMwZvmj0DpOTdb30mNECg3TSKzd
	vVngD2g1bsIX+Z2SksSx3Mc9CzWRekW4gp/KKLuNLwsxal4yCKDK2WRMEcgscU3z9AtFMYbh053
	Ldq3LIdOjM/7QjTEbuE9iBDnrpo3gJw==
X-Received: by 2002:a05:6808:17a3:b0:4ec:4c7e:37b5 with SMTP id 5614622812f47-5640ddb4f38mr841806b6e.29.1793334117847;
        Thu, 29 Oct 2026 21:21:57 -0700 (PDT)
Received: from com-75606.corp.openai.org ([199.47.143.5])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-5640fd9888bsm764152b6e.5.2026.10.29.21.21.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 29 Oct 2026 21:21:57 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	outbounddisclosures@openai.com
Subject: [PATCH] netfilter: br_netfilter: reject unsafe neighbour devices for DNAT
Date: Thu, 29 Oct 2026 21:21:55 -0700
Message-ID: <20261030042155.73844-1-kylebot@openai.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The IPv4 and IPv6 bridge prerouting callbacks classify DNAT traffic using
the logical input device saved in skb->dev. The physical input port can
have a different bridge master when prerouting resumes, for example after
an NFQUEUE verdict. Netfilter reassembly can also combine the first
fragment's bridge information with a different fragment's input device.

br_nf_pre_routing_finish_bridge() replaces skb->dev with the port's
current bridge master, but looks up the neighbour using the existing
route. This can put an skb with skb->dev pointing to bridge B on an
unresolved neighbour of bridge A. Deleting B and resolving the neighbour
on A then causes a use-after-free in __dev_queue_xmit().

Before calling the neighbour output method, check that the neighbour
keeps skb->dev alive. A neighbour holds its device, and a VLAN device
also holds its real device, so allow a VLAN whose real device is the
bridge. Release the neighbour and drop the skb on a mismatch.

Doing this in the shared continuation covers both protocol families,
including a queue in the remaining bridge prerouting hooks. Leave the
cached-header path unchanged since it does not enqueue the skb.

Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
I have a reproducer for this issue and can share via DM

 net/bridge/br_netfilter_hooks.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index e15355ff215a..726a2d17ed3a 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -307,6 +307,18 @@ int br_nf_pre_routing_finish_bridge(struct net *net, struct sock *sk, struct sk_
 
 			ret = br_handle_frame_finish(net, sk, skb);
 		} else {
+			struct net_device *dev = neigh->dev;
+
+			/* The neighbour queue must keep skb->dev alive. A VLAN
+			 * device also holds a reference to its real device.
+			 */
+			if (is_vlan_dev(dev))
+				dev = vlan_dev_real_dev(dev);
+			if (dev != skb->dev) {
+				neigh_release(neigh);
+				goto free_skb;
+			}
+
 			/* the neighbour function below overwrites the complete
 			 * MAC header, so we save the Ethernet source address and
 			 * protocol number.

base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
-- 
2.56.0
