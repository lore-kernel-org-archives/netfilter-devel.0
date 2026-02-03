Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634C137BE97
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 08:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770105698; cv=none; b=jHmhGvFZeFLwp1/UDXklm4cSuzJXRCdFICYZfvxLG5o/04eukfkkAPG6AjCYb/c0JAM9E6PHNneeRGBnx5ZnaCWkA/50umu9/jTTN/mYjn+AL9AE785bFI9wc2f4Z8xQYjL4YUXPUBK06NYcG8+B42gU3NS3b/UQyY8T/x/Y9Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770105698; c=relaxed/simple;
	bh=q3X6LXGY4pvrxPIY1+ZdGtvX1s6x9ZtFOSXn48a+I78=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TbFmYu+yXAx2aWSvtpFmsYo9u9rcyKDuIEUUWA5bjHbpnf8EJwR4o8IqKrq108oOMDuQq4Kkbx9MCd9/NSZu05umz/5NTowS0PUxLuw3KuOwt8l7JfYE5xJoboyl746C+5EB6+Lwq7ytT8gtc0u0HJHud8bvLcDjcLBIj1GiA78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L63pAZLn; arc=none smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L63pAZLn"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-649b1ca87ddso2868951d50.3
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Feb 2026 00:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770105696; x=1770710496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qnK1EPBJzbPse5QDMYYT7zPjH8hy43jPBzPzSg4c+hU=;
        b=L63pAZLnProgbZeVf8Xr500kKtlCp+q8LRJHWZyhyoDMmVyZDOrTVFo6/fiAcCg//k
         Qlmq+avt/MG5/Ek1+lHhaxmXkCUdYv09FjJsQC8gf/7lac5SEIqgQPN3Na/RICVchTSm
         rr+MI+gC6gWxB8D4qQXhJDD1giF1fh56y4l7qf/AqnKEWi0sB4PUwQRk4uh2TnyILrhD
         GPbHSKPtgceM5H6TOk4etDlA2yaxX/4AAXihR00IoXsoy4mfhcMOS4aF7EE0sR7XF1wO
         62XHPp4ufppMe4x4tsZpIW5h0EKGArjF5BvhpbIW5vIGZ1QlidrdjKCQf6qN4MCZANBC
         vFXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770105696; x=1770710496;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qnK1EPBJzbPse5QDMYYT7zPjH8hy43jPBzPzSg4c+hU=;
        b=Zm8TSnafuKPg+F8lXjdCs7wtNvZL+dUg5FV8/Hu1XebmcsRqd6vpImxOcMV3NTx7vG
         qtf98BT8OgsKSDQpEdk2NeY6imumNHudtSikGabU0p482YuWYC+UfTabs+FqsLsLKJxm
         K4i3qZ5/eySDcev31slLy+DOjCO3P3ZnyDujvjP37GEl+V8luJ5oJFj7aNmUZpJBn0AQ
         RkDjTB9wl9z1HUH/6CmSGPSSj35pq5EOD7Xn31Bnfr+05DPmubnu5R785Ap14hS4cj3g
         fQmafy6lCdB9XSdZ7eiTQhOOcjcNhMYMoUdrGLFLi34vi8Vu48i+D6sELO9x2k/lB6s6
         aLdQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4Ar4+ZIlVMH//M8XI9Mgi/iywsR3HfeZBFEIds7jeb6fTChBQqyEtO2EHQMSEvcwoYKV83nCivjQnNb+PWjc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSiLVsbL5xlPXWadWh8MRpublAvzQTEuD2gN8J5ApqpoWi5IWK
	sqFzys+qJMf/wvqTs5U32THE2zcc1Rp/+Iq1WD6Cz/eafcEsthyA+7D1
X-Gm-Gg: AZuq6aLeuVw7bw5tcASrir2lDmnzyoy/CmTfYLMOn0VfBgWXqUSQwtlcCLj2PJm2n5t
	jMEbsmxSA8dCcHqsHh1XjMtAR0WxrDKOCP80b3r+h/7Jgfa0P9lonNptVzRxhIyoZpU8B6uwdYD
	Jmd5ZlJE+EUNKxoGqVonI9sCcEWmlzeV3zwfut6GiExQA5pDAk1VhsVUWTLr4hOPw/v5UPI0neM
	9LWhcHrN1nJrWYGKfaOQICtI63yNp5oR0tQUMNBPttlpYCKMnUMcyYEE+ifuHBYc6fAEudtfMMw
	W33/A3FAPQy/2HJaxuOpT1C8HPE8muJT00XnilRrlJzVpsPwbfRgS2/iQXdYTqB8tSl7xMEdrxt
	k0k5QHZxourmUv3O4SjkvMtM51kZxcBsyvPX5y5rjPjMHWIDLEOYY7IQhLj2paKiaALJb4BDxH0
	KqVZJFu8X1o2Osk4dxPtNOYS7VLlrPJr1KqGRdaAoTuiLnzYkwgyApjh0IUuQorjWyisAluLOl1
	s+Da2cMjIw9M5HwFTfwrgtpcES22Ia06fD+
X-Received: by 2002:a05:690e:1484:b0:649:6581:a683 with SMTP id 956f58d0204a3-649a83c1a29mr11604677d50.12.1770105696377;
        Tue, 03 Feb 2026 00:01:36 -0800 (PST)
Received: from u2404-VMware-Virtual-Platform.localdomain (108-214-96-168.lightspeed.sntcca.sbcglobal.net. [108.214.96.168])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-649d51511cdsm803782d50.6.2026.02.03.00.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 00:01:36 -0800 (PST)
From: Sun Jian <sun.jian.kdev@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sun Jian <sun.jian.kdev@gmail.com>
Subject: [PATCH] netfilter: amanda: fix RCU pointer typing for nf_nat_amanda_hook
Date: Tue,  3 Feb 2026 16:01:09 +0800
Message-ID: <20260203080109.2682183-1-sun.jian.kdev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nf_nat_amanda_hook pointer is accessed via rcu_dereference(), but
it lacks the __rcu annotation in its declaration and definition. Sparse
reports "incompatible types in comparison expression (different
address spaces)" errors in nf_conntrack_amanda.c.

Fix this by:
1. Adding __rcu and __read_mostly to the global nf_nat_amanda_hook
   declaration.
2. Adding __rcu to the global nf_nat_amanda_hook definition.
3. Explicitly declaring the local nf_nat_amanda function pointer
   without __rcu to store the dereferenced pointer.
4. Using rcu_dereference_raw() to fetch the hook address, which
   satisfies sparse's type checking for function pointers.

Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 include/linux/netfilter/nf_conntrack_amanda.h |  3 ++-
 net/netfilter/nf_conntrack_amanda.c           | 11 ++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_amanda.h b/include/linux/netfilter/nf_conntrack_amanda.h
index 6f0ac896fcc9..edf1d30135a3 100644
--- a/include/linux/netfilter/nf_conntrack_amanda.h
+++ b/include/linux/netfilter/nf_conntrack_amanda.h
@@ -12,5 +12,6 @@ extern unsigned int (*nf_nat_amanda_hook)(struct sk_buff *skb,
 					  unsigned int protoff,
 					  unsigned int matchoff,
 					  unsigned int matchlen,
-					  struct nf_conntrack_expect *exp);
+					  struct nf_conntrack_expect *exp)
+					  __rcu __read_mostly;
 #endif /* _NF_CONNTRACK_AMANDA_H */
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 7be4c35e4795..7b3fffea45da 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -43,7 +43,7 @@ unsigned int (*nf_nat_amanda_hook)(struct sk_buff *skb,
 				   unsigned int matchoff,
 				   unsigned int matchlen,
 				   struct nf_conntrack_expect *exp)
-				   __read_mostly;
+				   __rcu __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_amanda_hook);
 
 enum amanda_strings {
@@ -98,7 +98,12 @@ static int amanda_help(struct sk_buff *skb,
 	u_int16_t len;
 	__be16 port;
 	int ret = NF_ACCEPT;
-	typeof(nf_nat_amanda_hook) nf_nat_amanda;
+	unsigned int (*nf_nat_amanda)(struct sk_buff *skb,
+				      enum ip_conntrack_info ctinfo,
+				      unsigned int protoff,
+				      unsigned int matchoff,
+				      unsigned int matchlen,
+				      struct nf_conntrack_expect *exp);
 
 	/* Only look at packets from the Amanda server */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
@@ -155,7 +160,7 @@ static int amanda_help(struct sk_buff *skb,
 				  &tuple->src.u3, &tuple->dst.u3,
 				  IPPROTO_TCP, NULL, &port);
 
-		nf_nat_amanda = rcu_dereference(nf_nat_amanda_hook);
+		nf_nat_amanda = rcu_dereference_raw(nf_nat_amanda_hook);
 		if (nf_nat_amanda && ct->status & IPS_NAT_MASK)
 			ret = nf_nat_amanda(skb, ctinfo, protoff,
 					    off - dataoff, len, exp);
-- 
2.43.0

