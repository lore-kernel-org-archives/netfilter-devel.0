Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4723190664;
	Sat, 15 Mar 2025 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742068823; cv=none; b=EQRLjdqOEuUwm/utdR9kfKxbEHJMJqwYMOY7i3LwthchDJv2LOY+Aeef5z/OE/WRsVhlpqbCANbTQeTiTjHEFIaV2v1ime0dsF4bF9pmaGOQJ+jp3oR+r1SeGOIV5DfTUPy2bm83EyVCcxsu7bwah4CL4AoJBm2JMu9LhjozWRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742068823; c=relaxed/simple;
	bh=3Z4njUTIUlYavMf+0Y+ElzJTSDR75D1216ryx3PQ8E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Be3eObHPMBmcHCcRj7R5wmu2K8IA6oVMxfvoMTjYYW90L11EDfJQWef/QSmnA6IplksElyzuZVJRWNbxiIfllV+0g/eNh5QF4wlWn9CrIzuj3VEbdgP542VHN3Pe9Q8k/HMNsBObDfT6I7ZOFeYOBEMPxeVaxHJIpmZWi0ZXVRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B36OXZcm; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B36OXZcm"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e5e63162a0so4685241a12.3;
        Sat, 15 Mar 2025 13:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742068820; x=1742673620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sg9tWiv/Uu1QtqV/HdubXaG2hKDCUR8SadULn3NLk+U=;
        b=B36OXZcmco99jLmTHmr+rhmBzdf6RiJVyFbzBSV+qKuCRYjn1My9xXw1ITG454jvHQ
         ghO0PONyz56TURCKh/s1vRktNTv27sK1Uc0vef+tKxjFQbjWk71bOzIGEQQVBSJ7DxwF
         2S13k0zHgg9AfslnAH+z6eZuZ4hqs3tVfVQCwquL3JOPrVKf5t/gcW/lQdvQMyGYzH6s
         PFfw7lxt3CQ06gmL8Cr/D5HPLtqoN+WGaZbW7BiYjU3CFAhtIeHBYRD70+T4Am1lb7F8
         CFNnBR1gH1Gi+DKzzPDQSDPQ4G+9Rp5k3m4OUkZWWqDlqnsnrgRYUBNuX2e//8/DJo4h
         mPTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742068820; x=1742673620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sg9tWiv/Uu1QtqV/HdubXaG2hKDCUR8SadULn3NLk+U=;
        b=Sf08FlfXKUauQ7YTTWrk6l6MRR1RFUZ73hlSdwvzYmre+hBLIZ0Z5YnttyTkd/ovSa
         FL+38OqjtdSqDg18PiQ9FLxqWxd5baWdu3wJlmcnavLTDQQaFUaEMNWBpKnn8EmgLJqF
         RXESBEiRUzYzqZYBv0sohagNesu7oAFYnKspXw7BcdM01VY8BRWNGZvBoFNl68ZesFMQ
         BO6/gsXAqF+awcqhw/7Ffx6+FcX1yLukvCn9s29k91Y+Jz203obEQln34diXZqqWMJa8
         prcY7FAc86tj3HTl8SETQ9f0o+LH9faKaoi5FSprW1/IEaQVUeX3HfmB/ri7ml0LZNKx
         yw9w==
X-Forwarded-Encrypted: i=1; AJvYcCUHfv50TX/O6HXSobVKJx5BJRpMu1HQiJFGDd2UtqjGwFde1i1+aNKQVUHXQ3/PgIKIlA+wpf7dKhjmPGbYtGYO@vger.kernel.org, AJvYcCXmRhzBlT4lUrfpglD8xc1CfBvWiCw514RMrbEtbkdpuMili6mgBjoLcILp9pyFahapaoBV+YsXSUWZSYNmFnE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyMbOXOx9MoL8j6qoSTLKAp8k4OSWHlMp2VK3irWynsW44SzUP
	EypJFHGst3AATr54ZSiZxK9D9VixP5zfcf0x0++hyfbODFG6UvoE
X-Gm-Gg: ASbGncuCDz6K3ATUhT5PliNOscFCWMtjgdtXkfTkDwfc07/w9GHAzv2J5MrERCYS3gc
	fqrhmF5Avypj/+dMVeUs5yCd4XHwLKQnYBO06fcID1ht6ue4Yzp/kJqA+zawEevOU4YPgARCcRg
	bkEHtyj9pNioryHdIK7XGqXegK/oaXH+10564U799iBHPh9GspHjmBayUbj4xWl0xfYuClwRFtH
	HCYREXhPyadGXZI4x+0hfbIWcX2upKMPBiP0iLE0VyLZ7MwkuN/kL2qspUrjugXUcDJt3kcaQbN
	Xqqy5bzSwT1pFkCyTRiA1/owk9YSM77rbb7SivKaXJyF3xRmU0NH9Fv6Lm1I2kXj1ogyQEm89n3
	pRYVxE43i6yzObvVgA/nO5SPkN+DTYaVaHPDC/tuGces8B+ddktaTcwGh82iLF/s=
X-Google-Smtp-Source: AGHT+IE7w8dvIGOKdRY4QHJODvPRQb8+3NYkPP+jZDmV5KukTNaP0CK1hlDzOrp9qKK/qHIoelVMYg==
X-Received: by 2002:a05:6402:1d53:b0:5e7:f728:5812 with SMTP id 4fb4d7f45d1cf-5e89f646e18mr7741671a12.19.1742068819796;
        Sat, 15 Mar 2025 13:00:19 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e816ad9ca5sm3519503a12.50.2025.03.15.13.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Mar 2025 13:00:19 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v10 nf-next 1/3] net: pppoe: avoid zero-length arrays in struct pppoe_hdr
Date: Sat, 15 Mar 2025 20:59:08 +0100
Message-ID: <20250315195910.17659-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250315195910.17659-1-ericwouds@gmail.com>
References: <20250315195910.17659-1-ericwouds@gmail.com>
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

---

Split from patch-set: bridge-fastpath and related improvements v9

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

