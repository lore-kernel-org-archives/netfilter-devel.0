Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795538061;
	b=YHQgKTKMNYQmUXGnKtVxdqC8bLA7OfRXsZwxwuNhjrfoKvYmwXB8B+C7wBTSuceFtvEv
	 A5FNKAOFxo/h1V0KpbJ+mT8sQVcAWTnq8kBLrjSnIFCcYB5Dj23w+DhxN9kkfYALEGoIR
	 qNV1Faejif5irmPy582ygqPY0XfSEVrhhQJ8QbcTsR0OHl1T8BO4eOPwY3m8XNHR8Lj/7
	 3AIFKUhCFdPnPZRaRPhpP9KX8+yvNNCbmMzu4tZnRgbI71cbVr+DJWPgjL1KccZn4GjNf
	 24OMtu4JdqpGA8GIlNEL8FsGUwXDOMk7vakj2zYbZTtCkHZiXousF06hbk1F5OLZEcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795538061;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qBpX9eD/Y1u/lvzmHcfOgzl+QJm/PvOjVer0pSOyAQ4=;
	b=s0BSj2aFDOAOFCHernmdCpBjPfoqTapeSYxWEKLRTXT9eJzdt3CtUv9AhK1Y/MQHKxnM
	 7qtSKP424PL0q07eey0UyNUJcCAP47nfV4QrDBb4LmAMzMS5m64MgZy6rznW1fzpD0/tT
	 KKh/0iWbxTazRgL14ISisBBoLyp2ztkVY0QWZemmeZkvKu5Rs0Abg2DKXjJpdfqNMMfPs
	 cXHLkiMGEiimG1V5RNz6Qy0Get6Cbz5uP79gyQrN9dX+M2kVjJ9gQ4XdmSZMvMIxNXIlG
	 0HSxAVJ0gTMJbjJ8JNxFGxAtvMWec8wR3otntsuptDhDxf/hwC+nj9HfClBMkHN1CKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tWrCri4C;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082D1606A332
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 16:34:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 082D1606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tWrCri4C
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c516a192844so391847966b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 08:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795538059; x=1796142859; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qBpX9eD/Y1u/lvzmHcfOgzl+QJm/PvOjVer0pSOyAQ4=;
        b=tWrCri4CWnTG22uOM9C+jp/befCVypiSR14ss4Hhuw4nQttam+vHWjhBIEnqPCrADa
         C2HDs9OgrZ8A+wz8/LswPqpENVfLvEEj0/oiOOEXqx1cxSvUS/4S0h/rL3nNJNNBJS3D
         Sl56mCRN+MPh+Zn8aGmIT1KZn8UvzbDcxXBgYKE6Gkysp3v0RpXILpd6khsmXaUtiP7K
         Yi9cjmvBEHJJrBPiA1eBfTVO+82+19L3Fb1dECfEpUAdjvDHhBsX8BE/DyJGpcWosNw5
         wp2pQXVv2LFi4pqSkz1xoLVMxRw2ur7RzNe8WfvBZMLZh3gVTNaJSJuEOL5yGS8b216x
         HXGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795538059; x=1796142859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qBpX9eD/Y1u/lvzmHcfOgzl+QJm/PvOjVer0pSOyAQ4=;
        b=nyNy/udP2Nzg7IrT4Bd6GkyJKyCmG7f7dJIaRHN9TTZnP6vIlDnzGjs0rKz+uEbgDB
         RXN8gSee+c5YEnnVIJsJ9C7tUseF+NNrdbEU1lV88kvjgQlmKFDdbSYfT3HhGAyqA1TD
         BJdDW2lzHE9iQuRXW6SCa9zU4RyqGpAu3fU+/v3CS8TkjuSNAFc1EEYyuFyuRPIaL/0E
         FcThG6eVUmNCwFZZN5NNlAAPzN348e1lDOswS6pMpzmXpKs7WjNdkRCjMiHB6VN/VE8b
         9dG7d6pNw91t5MO5RjsdV6Kxq+kxZjGCwwsynic7hFROXCn1F2wKHYs9WHZOaSIJb/Eo
         s37Q==
X-Forwarded-Encrypted: i=1; AL+hErFglbcudj5wyzPbPwSWdYroXRdh2yrVrtdcMQjwYbmr2iaMwUv1kuxVCrTb8OT3L4bC/vdh8OW7RR7m4M72CFE=@vger.kernel.org
X-Gm-Message-State: APuU4Z+XK+gU5nzjbvJ5+hj/GB4tJHgINqzqcyYIEXo4iZojgOzcF9v0
	oqBdTelHOcvmD4HLeQCpeS+WW0YFzp1V7bp+x7Cf68lM0LCQDMUcqiaO
X-Gm-Gg: AZFdTZduSvAKBBHYdPedwzhAllrNkJI6p4/NgkMajo1ojWdKLOewGCigAytQnmHC1D/
	pDeIO/N/ZGMBbr+s/0ii7l8smDPPmpFEQm+bUxuC5u9Wy8on5NJAZb/gWGpJn5jCGm0arlC3aQd
	/mxYfPyfQ3TKJp6MUUgEGcrWiot45Ehd6qG4bZKYvRCivCVRU47cBmOgg1jgM2wY1tmMVgD1X55
	GB5ehvv9BHqj6QDEUQvdmGzYq7CZb481ZIS+NBXAnUbXPq1Ne3RRxrg1grAd8jGSSN5pJ3zLKiS
	piyd1Y3lKbLQEJ/7r9F9g/kVFlAiCTPyjt7IPLpjs5d5lZd4WhRtNT7Bjx9YA086ftvwsqSdNYX
	HXqXgXmrZqvAyiMyOXa5HcGWRRQ9yxm4u4Z7hQbEK7MG7/mr5856u1XwuCzR6UaIrSYBy/VBDin
	+DXpuqPX5s/sHLo8drXAzeuqEZS+C3OAoHbXEkKx+xalQ8yoodjQdDOx5lJe6ZYDlnsHvX4O1bx
	r5N5ISaomRII+v/3U0RZmXolYVz9H+94lKpviuZ63Mx0iNF4ASwjHLvhrmZTOFfLfsdtGSYhlJ6
	T3r/pw4fztpOYkv6kev8rfJlN5C/6SNC+2+n3k4oLmHbiLOIoIaT044=
X-Received: by 2002:a17:906:7944:b0:c50:564b:c63 with SMTP id a640c23a62f3a-c513a43559cmr1313486866b.6.1795538059334;
        Tue, 24 Nov 2026 08:34:19 -0800 (PST)
Received: from theodors-laptop.dotcomltd.ru ([5.255.118.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513afeca8dsm542032866b.75.2026.11.24.08.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 08:34:19 -0800 (PST)
From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Subject: [PATCH net v3 2/2] net: unset the mac header of a pskb copy that points into headroom
Date: Tue, 24 Nov 2026 19:33:58 +0300
Message-Id: <20261124163358.755345-3-theodorlarionov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261124163358.755345-1-theodorlarionov@gmail.com>
References: <20261124163358.755345-1-theodorlarionov@gmail.com>
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

__pskb_copy_fclone() copies the data from skb->data onwards but keeps
the mac_header offset, so if the link-layer header was pulled, the
copy's mac header points into uninitialised headroom. With nft dup, a
link-layer payload load on the copy at LOCAL_OUT or POST_ROUTING reads
those bytes, and a set element hands them to userspace:

  BUG: KMSAN: kernel-infoleak in _copy_to_iter

Unset the mac header in that case. Callers that use the copy's mac
header push the link-layer header before copying, as
maybe_deliver_addr() in the bridge does, so the header is copied and
stays valid.

Depends on "netfilter: nf_dup: do not duplicate packets from
br_netfilter"; without it, a tcp reset reject of a bridged dup copy
reads out of bounds.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Florian Westphal <fw@strlen.de>
Cc: stable@vger.kernel.org
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
---
 net/core/skbuff.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 85d5caa08887..e38d0de59e06 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2278,6 +2278,8 @@ struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
 	}
 
 	skb_copy_header(n, skb);
+	if (skb_mac_header_was_set(n) && skb_mac_offset(n) < 0)
+		skb_unset_mac_header(n);
 out:
 	return n;
 }
-- 
2.34.1

