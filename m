Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7A5207DF4;
	Wed,  5 Mar 2025 10:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741170607; cv=none; b=Pl9kn1mAY3a901LuOKkObhy+dM6l51eN22H3/h2xcGmqfHpEjAdJLnaN9wYXC03bwR5M1ntfDmLYbSQftrqAzWnXVtc1FyTX7CkgKyj4VQ3ZF0/E8m7xuyXt6ZEdyo71EbTN+J3/3GFiW72tqvfGNURpoDx7XYZ84rX2hfPRzE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741170607; c=relaxed/simple;
	bh=4chn1/0IJNSwJ1oT95Yplw/ROsSLsSsjiBPzOuAxsgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLuf036whkFwBSP0IDKx3sKFmlcUIAzONFQhVMPEqR3H5ucJWzRLSLDTMSYpIdOvMF0K83mUeWwyLzbTTJrOrv+07vSP56Y2a+f4ywxEEJOl/dANO5NxCWQeHhqoFYmFI+vjtUTJlKVUik+JW1XfwjX0n4n5Tex/x+lg70pBg5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G9eChVED; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G9eChVED"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-abf48293ad0so699086466b.0;
        Wed, 05 Mar 2025 02:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741170604; x=1741775404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UWSHNbB5JKEbeWuUj8vjDFfUx12Bd6PhpeoYLsDsQTU=;
        b=G9eChVEDb0pzmzecohmxB2UWNYUHEeHbNEzsTRJwRJ8HUkvHe739KZLX3cnG7APQUr
         CQjLe65k1VoNwbaf7Ym0Uz6qnxhL0he+GpriYlHwAtLiJNiRNkSMMDZdHNdP0zYqmL6M
         hgnR8DxjLN+ekrYKDzopwThFlFQIHYeILmvLku4soTubRMrD01T/9QPrMbXsYDFMjKUs
         /QyekwrgmTRu0YwUsQHN6R468TEd1by4LnO8GHWn8EIyv08XEUoU+aZXn3JbLRBJzxXs
         z+/seNEXQ4JoEKB94Y4tahaHsObRPJsh3Od1nTNlfunqmNV9bd3ynlYzFSdv9ncG8MPy
         dJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741170604; x=1741775404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UWSHNbB5JKEbeWuUj8vjDFfUx12Bd6PhpeoYLsDsQTU=;
        b=nuLqGTt+/ZVURJkQSWMTivl1fv6BGmzRWrG1FzII7YMoFQl5pTzRgE7/7vdxdXLfIK
         f7T0EC0U1iRMmHF2SDdxwF6GDG9ZpYkYYGKHmKjPRbztjZnUXgFlK1UayxHp7ZhhlOXN
         a7m9lp1nsR1SybykJPymuwqNhVrVBAGDLa4Kkg5EBZ7y8AchIiR2CETAzKUp0Nj9KDX5
         BkeMO3VSztd+vGHi5jiz9WYbqtSgkbncoJ8+bkXHipGhpDGnLlQjeS8H+9XL74g33SYg
         hRT94Qpb4bz1h3icHAdqVEStBEBFVPd5w1zTQlZrAAJcTH+7pRKQJXtucYNvwS1e9IuG
         DPyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUV+U440nfcvmHUyGQgbBcbt64lsezXZ56fYySACbY2BkIeDraDpuw44HvPOMigd9BafB80jtWSizlXDzOM4bKf@vger.kernel.org, AJvYcCVa5Qsk1UGrqgQgvTC7ODLSUQkb5/HMFJAS1KYycA3c5KKI56smcDF1fo2tUcVXvNYBBH1W2y2/O1nDP+dw@vger.kernel.org, AJvYcCXYBosG1+b9vc6dXIuyz+0Utj0h7zTdj2Wz+0D+IuhmI0AOnldm/xMkNleQNw2qrrG7gyQjc6WEruxCw739xOs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9OH4gwc64JqSyiXZybrXe++3Am0obZAhl3+WYsEdk751Z9jNd
	aChXVMxHAZ3Q7BA2SoxzFRUnJlo3YnidEIUBntjD1sw5D8vta/g0
X-Gm-Gg: ASbGncufJdkALghjrX1NPtZKjC+vqZY8FKvxILLVi5UjKRUKAJQnPctqvZoB2KL/tk4
	cUZYbYUOkWC30Reur3WtEuS/rGKOpBIpKyNlJLxYEnGKVkmC5O5GgDLgflQp7JDUgZERlIVypIH
	epSmp5+KjCnwCOM/16Pi2k9aqit1xKohN3HnVEUhwrTsM3FqZZmafXEhjE4LA0cCkBlA71u13Gf
	OitfwYfIxRNZNv9taoKSbO10RbtC7v/YofPyaQaKJOdWvfVWXVgxCfLXCA4XUiydW4v0DABBvDf
	21XqurD9uonVpOJHeFh4baxy7/HZyxm8gu9McqA9blVc3GoQBOltHUvOKsjAvJMHxs8hFCbLWgJ
	OUyPh+ehjD5GSQAurq+ulOMYGb9EhCX6oVS1eveFKgUSkhjnafdu4PAEb8NedSA==
X-Google-Smtp-Source: AGHT+IFmOl+znPOCyIBVoWXbUGUsHEWWessyONqSdjDiGli0zSAoB+kKDiPnSaw44bEm0nFmaT3VhQ==
X-Received: by 2002:a17:907:3f0a:b0:ac1:ddaa:2c03 with SMTP id a640c23a62f3a-ac20d036458mr300465466b.0.1741170603887;
        Wed, 05 Mar 2025 02:30:03 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1f7161a4esm247154266b.161.2025.03.05.02.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 02:30:03 -0800 (PST)
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
Subject: [PATCH v9 nf 01/15] net: pppoe: avoid zero-length arrays in struct pppoe_hdr
Date: Wed,  5 Mar 2025 11:29:35 +0100
Message-ID: <20250305102949.16370-2-ericwouds@gmail.com>
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

Jakub Kicinski suggested following patch:

W=1 C=1 GCC build gives us:

net/bridge/netfilter/nf_conntrack_bridge.c: note: in included file (through
../include/linux/if_pppox.h, ../include/uapi/linux/netfilter_bridge.h,
../include/linux/netfilter_bridge.h): include/uapi/linux/if_pppox.h:
153:29: warning: array of flexible structures

It doesn't like that hdr has a zero-length array which overlaps proto.
The kernel code doesn't currently need those arrays.

PPPoE connection is functional after applying this patch.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 drivers/net/ppp/pppoe.c       | 2 +-
 include/uapi/linux/if_pppox.h | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 68e631718ab0..17946af6a8cf 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -882,7 +882,7 @@ static int pppoe_sendmsg(struct socket *sock, struct msghdr *m,
 	skb->protocol = cpu_to_be16(ETH_P_PPP_SES);
 
 	ph = skb_put(skb, total_len + sizeof(struct pppoe_hdr));
-	start = (char *)&ph->tag[0];
+	start = (char *)ph + sizeof(*ph);
 
 	error = memcpy_from_msg(start, m, total_len);
 	if (error < 0) {
diff --git a/include/uapi/linux/if_pppox.h b/include/uapi/linux/if_pppox.h
index 9abd80dcc46f..29b804aa7474 100644
--- a/include/uapi/linux/if_pppox.h
+++ b/include/uapi/linux/if_pppox.h
@@ -122,7 +122,9 @@ struct sockaddr_pppol2tpv3in6 {
 struct pppoe_tag {
 	__be16 tag_type;
 	__be16 tag_len;
+#ifndef __KERNEL__
 	char tag_data[];
+#endif
 } __attribute__ ((packed));
 
 /* Tag identifiers */
@@ -150,7 +152,9 @@ struct pppoe_hdr {
 	__u8 code;
 	__be16 sid;
 	__be16 length;
+#ifndef __KERNEL__
 	struct pppoe_tag tag[];
+#endif
 } __packed;
 
 /* Length of entire PPPoE + PPP header */
-- 
2.47.1

