Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794938341;
	b=hwKPTb5jdC5uAVoa7+R7RPGfniKmuPDGbpRf58UvUswkhPKYyOWaJRmJ865E+lmATP1B
	 eS1rsqfKktQKpdtmrtcWztmG28MlTbtVSw4jno4p0o2B/Y1jwJ5q27Lh3ZuVaKftvwbne
	 QgoKpT9GnAGQmQYUWmRoIf1D+4YALK2v+U+lLFE5Wk0uGlxhyeRViK8bQ/g9vc82SeY17
	 biqa9HY0vs91S3KZbCc4/K/Q+2fveHbbT1bkPf/JHvRKjga5tABIHH2+UmgNmRwsBBLeg
	 HBfAa9DHa+WDgNS9NKaYhE8oUwRG++/+H+2Q1BHL0iKslNQMFqvvWYa3ptfmubPDP1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794938341;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eeMFyQdeqRi5I2iFwKqkLeQDvy+259l96uYLdOZ0I4E=;
	b=1ajSYCcLMDYEbSuxB8dMXnvbzEDPrEpPCkPybsg22Fw1aCUipKpvMtegiTwTQ1plzhIp
	 zBxmJv2vW5S5+qafPm6xbmF/1qsMaspBwNoIbZBR2s5Y0DyTiYxX+GaxTYwiMWcvkGUt3
	 0OSTRvsfeg2RYr+m521Ycr/c0gD4mbbbT4e/GbWIPgjPfciZN4wGZHrc+D4/uEch3+MNd
	 JTtKaAqHpKuaWV3mw8UBYXz8lbAw88epihdyecaH6+HvQF6qTpZ1JavWyEuGN76kpcMv2
	 Q/kbsb/8LBwT3TsA/LeEyp62ufIifRM3t03yN1GEOqUj3kLDKOMp6CPVSL9l+OuidrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ejwlZkxr;
	arc=none smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08374606A32C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 17:59:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08374606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ejwlZkxr
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso335961a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 09:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794938339; x=1795543139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eeMFyQdeqRi5I2iFwKqkLeQDvy+259l96uYLdOZ0I4E=;
        b=ejwlZkxro6B1K9ewd6PVBNay4oobYKfkcQzDZbLMxFSK+a3XN4lU7szJxjXN/i1ZvE
         ft7Miqdl+ykTlBuqtq82ZELfSMITqtepYILZP4kJgCWSikDh6d38WNYsRYWmPzwkxmvY
         Z2Z8QEwezlkJ4CSv3nbuOTHTlN7cOi/+s+rlGskqKN3yFRDFKa96KhkT28ICHIislsyG
         c+OH8zYKjCIoYDmzogilW24vtzjGstcMIPEj8FzAwpDLeUfuG6yYSYYhrOwrL8ovKYsb
         fpKuszOnGsu8ksVr0qp7EjDy2ZFCkKtOQThWAomg7a2FD8f/v3h5iDh1gQsVsayXeHVF
         mGMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794938339; x=1795543139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eeMFyQdeqRi5I2iFwKqkLeQDvy+259l96uYLdOZ0I4E=;
        b=N1Wk29OB4HlP6jwpoZG8Ss2FkJSE6rkUJLi2nf0aH6gc6aJvogRgLmwyFgi56BkdRP
         UfcBlFwpZATkBhRBUjCtrLet3YxvwMtpZ+CN8sS9Xz0NWwgZ76TqeXhOQ/jjP5bkIKdj
         QYFkqlyqaziuIVUajvQdMkGMUiYTVbs3644bHGV1Zm/nlpCcmj10a5vxqZpuXA0Wl0zX
         PxZ+9EtmzBFtGs05gy4gzjg5IBi1MJxQCTXKmzx4WVkVcG/XlLP12yrd85HSd20VRpWG
         iNTrQrCmAoC5yeTwoUXNXxk4yGj0gP0RztlCfPB5c9MHK8GXBF7E1fRpyRbmEDKzu2+h
         JfmQ==
X-Forwarded-Encrypted: i=1; AL+hErEYDBnIykZaqd/P8Mmpnr0JnfaMRVCAS4xEpJHZJYLjwZohdg+Nnbmm5m/uA9yNcFT2X2LJC+yJ5pxxJtiocUQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z/pBwTDMG825F0HZtXPVPe9ZqzyQnjzmeDzq1+FdcRVrk++Ty+A
	+8vdZYmWgUlSNO5bQDeQGsVN4IerVXrJTkgdbkOYnbAtw44EAzBcX2R9
X-Gm-Gg: AYBFou3/4EMm3u3rjsYZCJlB5Ji9Xc6h/W5YnUu9agUDMpaaBFL11zEWVoRCMsHh7eV
	0yty+IlsvHhfJRy/rUTScyRAWlIrRkU0KOTGiQNYaU0bshPEIWqZq0WenkHGViuaEx/jhqoytwL
	rkouYI0uFkqim8pCUg5X9smD8zWZ3+Sml1PM9XmdMxz+GJQqBFJQPQmm9cB1zf7jToNkWpeO5yq
	MudD9VnC99ckEN7KlGmzfTSMfAOnWpwn0kPOeSAtZQCxY95p9Q7PKrPvhIMiqstm3Ci+K6S/73h
	iSrHKvlaVOfukixqK9EPp1OXKVoTfsnKSRYB5eQp7IZ0NI/1PO5Oa/3BNyNMPF7USLxdMEzD15O
	6wQ96EJxAx8SlACZa4d/9OkrWiTCPaTZKJ+Bi0gv7xdMQTbWVPKdxefrLcbej6XFsVROfr/GoOg
	wvb+vq88Kb5ZECFboxeqNCDfSZbyGf9KURIHhR+ZR1qruxppYwt0r3SKY8qnpRiB7Gp8XRl/bn0
	maFr7s1jUT7hJxlzohva7nxq33w2op5+9SsuTrxOzMNhTREDYWmly51lYYwBtpnEbo5J/S36d1H
	0iXa1LwJWzwUSfgtdk0gcf+Hr+PqIW2pKEzrZYOnWRbTYs/P9YC+eovKvSJO7w==
X-Received: by 2002:a17:907:3f9a:b0:c3f:c878:7c1d with SMTP id a640c23a62f3a-c510e28e068mr4634366b.9.1794938339308;
        Tue, 17 Nov 2026 09:58:59 -0800 (PST)
Received: from theodors-laptop.. ([5.255.118.7])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b886a82951sm78666a12.9.2026.11.17.09.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 09:58:58 -0800 (PST)
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
Subject: [PATCH net v2 2/2] net: unset the mac header of a pskb copy that points into headroom
Date: Tue, 17 Nov 2026 20:58:35 +0300
Message-Id: <20261117175835.745796-3-theodorlarionov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261117175835.745796-1-theodorlarionov@gmail.com>
References: <20261117175835.745796-1-theodorlarionov@gmail.com>
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

__pskb_copy_fclone() copies the data from skb->data onwards, while
skb_copy_header() keeps the mac_header offset. When the link-layer
header was pulled, the copy's mac header points into uninitialised
headroom. nft dup is one such caller: a link-layer payload read of the
duplicated packet on LOCAL_OUT or POST_ROUTING loads those bytes, and a
set element returns them to userspace:

  BUG: KMSAN: kernel-infoleak in _copy_to_iter

Unset the mac header of the copy in that case. Callers that need it,
such as the bridge, push the link-layer header before copying.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Florian Westphal <fw@strlen.de>
Cc: stable@vger.kernel.org
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
---
 net/core/skbuff.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1ac1e327ac4c..7f6d0344efa6 100644
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

