Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212D8346A08
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Sep 2026 07:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198813; cv=pass; b=tH1pu8Xn5rqpx1RJ8E8j6pVkkXGMSjrWtsNkCQPL9SoHN25ziwThhztC55eKAhJtWsxOwjTJDSBi/jZb3vMEM7elzBeNRxoOUQL0EQ5KVhGcXeUp9G7hCOBRFRe4JzHvqOex2ZOGhUvsqrtT0lzknIXw7/EyMGG0NVIbtnSR2AY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198813; c=relaxed/simple;
	bh=a5BgZIa2nN3V7GG8MnhDOEO9Xluz3rwKpxUKZrZY1y0=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=M8i+2p7S/PTO2pRStH6wSFlfC+bOf9Uh25UNZhZShMxLO6+e78G/5o9UjK0QjhYRtDtGyUGOGnkSVyh2efcwWFTYGjXA0vKpJgdIpAUg/SKUtDasMN1x0qoJ3Z8Rz+IhVgmk1VXv2u/A0zXoS0M/zx8wj7lkmqrO4uTwOh4RzFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=OMN+nqkl; arc=pass smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="OMN+nqkl"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4bdf8acd6so494753a12.1
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Sep 2026 00:40:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789198811; cv=none;
        d=google.com; s=arc-20260327;
        b=JCIvHkAFVQ7UPM+tyPC3fwzO1L89Z1ClvpFCVg91641MHZRHFC3TAL/BKc14b8TaWm
         AzLOv40MaJ3zK+F0wSACN4eZidVv3QIQfs3nOtQbX+FULn9vTi4faHahlqgVwgz3HWSu
         MWSX5TgBeGXihZDfbm6QmDDVh1rePby+Y7XMHqHbF25NYuhhspPtHL5nEPqZ7Ih6Ye3R
         roJskLA8KGIBR9KVcitxYy2SNVBgdDt55J8UmCqcXT+ColQIanazebpywqMK0OI/CMQE
         X2FPX92D+UvpndtIizpFsgN2Dj92nxkOXAc4hqEuq8qa3QovcQxNKDrF/N8ukvpnyote
         wJrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=QG2SNeNOqKf6itNXVRATkNtIQBJP4qkHEst2cXeq/Oc=;
        fh=eTDwCOGkVlyYfFTr+KK5fM2V9LhZd5BeA4cEaDy9UZw=;
        b=g8XLuR0vuePxLDNujCqnerJyKQqfWP061fh/7DZha0EVZabGacijogrLto23tBxDWG
         1G5Cr60p1yulMMVZvY+kvoZUVl6tiq+gFI27YnRhq4lKBRAyi+zeTp5PEEjMvmpuVzh0
         /wPMtNPN0+0K7gz1sQEoFdrZnCQZbWGQfhwWGNVP/f9i1h+w1NMuR34lQ0q7u78IH6xN
         IZwEIfa27xSvk/bLrveUKubPP/RMxqX/9D+Kok3tnCg8usBIJv6Ngq6yCJ0InN5R/73J
         ZDd4unWt5CAPexZo+asu8EfiVH9bXvB0ksoOWHWRCAQxFZdKCaxRYX6C3asca2e2QOHc
         P9Dg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1789198811; x=1789803611; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QG2SNeNOqKf6itNXVRATkNtIQBJP4qkHEst2cXeq/Oc=;
        b=OMN+nqklVDfMdt0nt/oR8IX/v2tMsZLPn7d5gYUNxzhpm9jH0ORZw2hKmqg8lWA0rB
         lzwa1bcYSLxPxJbrw0VCk6T4Zrq03uEZfbeDk1GQbLSbRhMoZHUrIySl0qSiMFCrWOe7
         LEDz/C7y57r0G14FWil9ccCN5nfGtSkZ/ryy2NWWN47c3JLy0cRu14fi5nIm2bV2P2NI
         X3PsPA4NxDRDgVqXTkSAsPvQEjMBtr9G6u8VZ3NCmxsYpM22RI1/40hd3uFJVOkbylCI
         e6otxTorETJ0MtznvOJNQLO3YpPQu/IADoppXDIwBE9my5qCEu9brIez2rm+oGKdeHNb
         UDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789198811; x=1789803611;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QG2SNeNOqKf6itNXVRATkNtIQBJP4qkHEst2cXeq/Oc=;
        b=d3TETt7xFD/epSwJXAAg/27Xid6PDpXOcxSPxjmMdSvhIAXi4tSu81Ro8e+wsH+REs
         8lTpC2XExqykovfLt27Zt4R6HQh1KDNCi6hqhqsUBvQFBvZLbCFqCEVI3+RbEMpT/UvQ
         eQ09kqRvtIaYGqNC3O8+AaSrY2Jep/Ze58owGfZ6ulY2/2UbQyo3y1N3W1a1M+b3nk6h
         VJQuueurle3sqvAq5Gv+I1kRUdAFEejfQfU4YQ2tjJkM7zcaSm09V5jB3UNCqo85i31O
         0wH5NwSx9llzR1wblBIrjtL9MdwzxZSu9sZ/yGDRgJq2ZxATRfB7ob4/JgnxYPvyjq7Q
         GviQ==
X-Forwarded-Encrypted: i=1; AKwUvBz4zf7rwFqJANlLcTZalVROo2+NwCXvzMYKH6MVnRWH4Kf9dcayf5UtszZKaLbep15A/IhoNZz0h81M/2/frek=@vger.kernel.org
X-Gm-Message-State: AFuF++kv4CXuf2b4/fCdAMOIJ7+j1mMkrvzMzQH/Z+CMz2IxU1eYCzJK
	2lxRyvu4W/0aYAZkdg3BLxb+SWZn89FhpWHiPWiFP598q+ch6rAAfBqcdCCckCtGMMQnZ+Eloay
	QxjIo27flaA5dG/bgLrXA7YSxzGOoqNyyS/izST7n
X-Gm-Gg: AYBFou06fIioteob9m4sOX3oIHk3gE6kjlId/xUPeyDul6wZdYPhcQCML2qDA+BIfeK
	Lhev6NJskD5sAUQJK8wbfUJUSD8J9zi8X+YjXn7PGnYbN+S7uiKylPv1x1aNTAnQEevajR+euqO
	bDavGsURuLbG7kCpAT9nMYJTeL8iQLrHWiTnwdTD4tvneuUD+PdBMFy4fzurw2e9ObW4PuKxzx1
	0n3N9sGrrARbOTKOQInyOkbhns5MTXVBkxQMK5emel0LiX0IkvcsMGC00x8XhVt/4VuJQ1NhNw7
	L/+JBfDzrt46QSYrtehgqwG17xpHCubFTqfCsA2jCsHnQR47FOPuBZTi7S49ELTFfxTTS4deLe9
	GKOazRdQLv77SLOxcWZreffkQzqHyBmz8jRo5kXtykTU=
X-Received: by 2002:a05:6a20:3ca8:b0:3d0:868d:8ccb with SMTP id
 adf61e73a8af0-3daed418649mr14691447637.13.1789198810266; Sat, 12 Sep 2026
 00:40:10 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 12 Sep 2026 07:40:09 +0000
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 12 Sep 2026 07:40:09 +0000
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 12 Sep 2026 07:40:09 +0000
X-Gm-Features: AcwNN1U7oiMPPggvAGkLxJ8f4FS-S3NfnynfUNKYcvJ3EJSPIXU-keM5UBnvdpg
Message-ID: <CA+0ovCgKDOk+Bg6Gh5Lwx94u_jJjQ30-vY1JcY2BYfhnWJJbPA@mail.gmail.com>
Subject: [PATCH net v2] net: remove WARN_ON_ONCE() from the
 dev_fill_forward_path() loop check
To: David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: falemi@asu.edu, Simon Horman <horms@kernel.org>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Xuanqiang Luo <xuanqiang.luo@linux.dev>, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ipip_fill_forward_path() and ip6_tnl_fill_forward_path() look up the
route to the tunnel's remote endpoint and set ctx->dev to its device,
which is the tunnel itself when that route resolves back to the tunnel.
dev_fill_forward_path() then makes no progress and trips
WARN_ON_ONCE(last_dev == ctx->dev) as soon as a flowtable tries to
offload a flow through the tunnel. That routing loop is a configuration
any CAP_NET_ADMIN user can set up, and ip_tunnel_xmit() and
ip6_tnl_xmit() already treat it as a tx error, so remove the warning and
just fail the walk, as commit 008e7a7c293b ("net: remove WARN_ON_ONCE
when accessing forward path array") did for the path stack overflow.

Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
Fixes: d98103575dcd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration")
Closes: https://lore.kernel.org/all/CA+0ovCgaRvbd0Udj70b2xxG8Cx3CaCpNhnf1V4RWQuDveZYZhA@mail.gmail.com/
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Assisted-by: Claude:claude-opus-5 syzkaller
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
---
v2:
 - Remove the WARN_ON_ONCE() in dev_fill_forward_path() instead of
   rejecting the looping route in the tunnel drivers (Pablo Neira Ayuso).
 - Add the Fixes: tags (Xuanqiang Luo).

v1: https://lore.kernel.org/all/CA+0ovCj+Pd5owGH+51rA8-RDu9YFx5oYUv8bV0zOE72QgVfY0A@mail.gmail.com/

diff --git a/net/core/dev.c b/net/core/dev.c
index ecfbd72d5d1a..c67900354fa6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -789,7 +789,7 @@ int dev_fill_forward_path(struct net_device_path_ctx
 			goto err_out;

 		stack->num_paths++;
-		if (WARN_ON_ONCE(last_dev == ctx->dev))
+		if (last_dev == ctx->dev)
 			goto err_out;
 	}

-- 
2.53.0
