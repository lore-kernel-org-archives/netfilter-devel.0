Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3731D30AAB8
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2026 06:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771915997; cv=none; b=BaqORi1Nd6WyJwOkCZlSXQyZ1pEn40YsmxhexPUUU+Xc3ZVAIkfgcdDf8pVE06/B3FCfMXBRsyOXWCqR/oLGMCM8aJjK3Gvq36/NvMIzeCpoAkCBdwJ9kwg5iqB/jx4KIvehJbPhKmStuC5TwuYaS0PYcMBtvfmkNphcxKTwERo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771915997; c=relaxed/simple;
	bh=s5w90tjQkJYYzbC3vOYs6oXg7h6S7OJfWNsP/+o7GlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQAtzrEHjSc4IxdCueIM3a1v0ossVc8vQpGwJ5DWARRs1VNNJLWkintATkZ8DKe1Y8Tg83PKl3L19t6Xq1BV/TBCKNEMtkzJ3TGJg2ZV/zmbziiI3uS2E7NPfLFn7K9gWfAjFnwQaDrKM125AUCuSOHfpCrfjDpdbXhKb+tBzEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hhk52DEA; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hhk52DEA"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b886fc047d5so818368166b.3
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Feb 2026 22:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771915995; x=1772520795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TWLpgkJWRF7bEw/Zu91fLz8PWNtrMB/wH+bAcmEPFvw=;
        b=hhk52DEAYcaUOc50p/Tu45xjiuPLoKFj42Up34NHhs3VpxGny8pv+L7DfhWTffPxFk
         h3u5gnEfeUm9z9a20Viy5ru4n9nNQl92hBJNmpRopaCr1UCN5/hFDR/Gres9fAY/0L7o
         EE5f8kXA5UhJSSt09n1ELOlW31KkYfsNmlPRnSj3RKyiiWXywx8DHKXxvdlxQ/JgIgmO
         NryzkJWnm4tDJLuxjU/jB3dvGl0sWpkGluRJ1DoQUaFakX28EhsejcJSBrcu51zmQqzt
         bhOJeXeKtSFSv9kSGfdIzQ0zdJskS1aZHA/enpCDlgTRVqX0LHrrRLT5ZHAQpv1emvHa
         mp3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771915995; x=1772520795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TWLpgkJWRF7bEw/Zu91fLz8PWNtrMB/wH+bAcmEPFvw=;
        b=B4EDeDC2xZUAi49bu7tSZiRE9iSRlMJOiQvS1T2igP3kPLvaD4Fz7rj+nfS8wwAI3h
         U0mr/FycLsRpLSnHAicm7OLaIM5wNmjbffmlyBmLc7rpdR/ku+yStqVIry3Vg1gq4cuR
         w2OBA34jVLXKozVDr4Rpl1LYm2Lx5nON6U3CbvaSS75CQZlJ/N0foo3Po8sVZNEom7iS
         wF6Q4TBXF9pyvh05tR2y9cujwNYqtpWhfEc0B6EIBLQ/6ZwIWdJw14R11oupPJIjqvnZ
         /LNgA++z9KscSFoYrR+LeV/p854lZt3hOZcRRLSQnYd6Y9e5n8bascBVAl+PdjmFisRu
         mupg==
X-Forwarded-Encrypted: i=1; AJvYcCWW2AyO8inWD9j+ZIAHuifvLViQLpu4Miyo4klnes5l23h71v5SHHOoVWIfeNS2D2Re1Rn0kOx+LdJn7A2Q/Ak=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxuw9ohQFuxSKoAFbO9CZYxCCm1MGkaIaK+4E75/Z9uiVKpnL3K
	4dnxuVOZLu0F4eDbzCPUcNSy1cs3NuROwoY4k1oN+fn9KwDnw9myHO1O1WFlJw==
X-Gm-Gg: AZuq6aKuVvCR0Jy5wOFdHJJQXU9zFGTSKgGDS8ofDW11QOFIrQCFupXdeI1ek/5gt+/
	IGifOgPvhML6r58k+vkUunxEvXihatHfEBNltEs97W+2Bvk32pD6ZljBSdcosHzwuWx+ZTMBqQ4
	tijRvQYVuWsFpmB1OJdUuDaarEe/ZB3XvtUNDPAisvD/AOqbqKD34BlHg38SE4Ajc3kPSCfzO0q
	guvgHaYMn06CPnesOnYBV5nVybQVZmN0EkYhXByKIJ+yjgC4sA/d8eBzI4IegPeAZO/vtJE1CqX
	5V8eoEJBk//Y5CvmBNKSqShGQUBkeNrBmAucudAwHYQP117M7c5Hd5ZyZ9THDYft02leofW6Ovg
	KvdQ40WyHf9FLESlPGvrB5c0JmPsRc+DEmnt1scfqFkMh+CAOEC5dUOqHrZw0faQ4BfMZ71alOA
	VvMYNB9Xdw17Q24hH9TisfAwVqzHwfJBpoeeJFENFaLFxKGEVgZGNO0DNes8HiGSgCF8xNaCY7k
	KwE1YkBgwbFLsihYlvFa1q1AOqPz9MAfhMu3Q2aEJvSWV5wwAX7FgQ=
X-Received: by 2002:a17:906:4455:b0:b8f:8ff5:45d with SMTP id a640c23a62f3a-b9081c19dd5mr506369666b.53.1771915994218;
        Mon, 23 Feb 2026 22:53:14 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65eaba13866sm3096698a12.18.2026.02.23.22.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 22:53:13 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH v19 nf-next 1/5] net: pppoe: avoid zero-length arrays in struct pppoe_hdr
Date: Tue, 24 Feb 2026 07:53:02 +0100
Message-ID: <20260224065307.120768-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224065307.120768-1-ericwouds@gmail.com>
References: <20260224065307.120768-1-ericwouds@gmail.com>
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
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 drivers/net/ppp/pppoe.c       | 2 +-
 include/uapi/linux/if_pppox.h | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 4275b393a454..7900cc3212a5 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -885,7 +885,7 @@ static int pppoe_sendmsg(struct socket *sock, struct msghdr *m,
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
2.53.0

