Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4181636921A
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 14:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770130539; cv=none; b=SYrlSxqi0jhRpoVGdY+6jluGZ4Yt9TAq7rKXIWwxqoQy5lXmJ9kK1qgIrZNQ/aylX8q79HULB8gncvdlmDaBAoFumZKuUUSjXWpSS6hDCMQHO/hDPgp/9PGEN+5d0wff0jjji2VdXl31LYwKAsgou11UlW2X/WzytJ10YWp/8Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770130539; c=relaxed/simple;
	bh=NRgVJBul0Y8zpGSgGKNgKM+I9r7ovGTkQ6APHRuS7mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKmLVetWK1B1m4YRaQy77zraviCc6qzmk8Qs5O5Y3GxGZWXFZQlW+AVom57CJHMW2t8yTtF7A31ZNeSIs5+merAnXaw3vp3GUuZpD6DCXtA+bYVEcZePiJSk7D8zECIQ/ppcgH+NsOB7+ldnP7G3H4AkglsGj6XkpEIjuQXYjRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lMgcB7gV; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lMgcB7gV"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2b7070acfdcso6244414eec.0
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Feb 2026 06:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770130533; x=1770735333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ARM7OCB27g2Bz6Y1P5CF31jTt4HxwnIXMV7CLDf4O6g=;
        b=lMgcB7gVLJBqTU6jI+7fIlgIRS3Vf8c5SWyknBT7xxEXWcWGwdv9zTuwu4rNlEm6iI
         797OXgkwkgvklpjyzSqmztvg2yMR8o3/YY/84nfBKDhsaJA7QwVAY8a2YflCt5M/mD0v
         fdJjKHv+Rmf0gHSBexfJCKxPLLtXB4iKBfpTLlQPuWaD6oLFwSs31vr5+/nVNMV10xGL
         jv0tQkhNaOcUy5sjfg+aWQWp5fIJbW0MmQskvMUihYS+E9DK/mgM+acQakQmF4buGXDk
         f/UyVOuktw8HZzmNJUVxxcwxAJ7ztOFFe5DRkVAD95RQxePX2gT53O2bty/O/DXufsU9
         Nu6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770130533; x=1770735333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ARM7OCB27g2Bz6Y1P5CF31jTt4HxwnIXMV7CLDf4O6g=;
        b=qjGZ6daNG7jbV5CWjgk4iPLCbIdntP9z3lvfiM2xIPLqxo1JkGlPa738rBzjaRIyfz
         MJMpAqegX85LPLCSvRXz9res2W2XA/9CSXsX82z1+oz3kWHsMGBWVZ3tWtBGyzZR39qY
         FonOQ2pofdii3z9w6MFR8zX0StavR00sNTnl6b35MhcmsYcEfYPP5ga3VG5QfITrb7CL
         usNLif6kHm6ZevuKvffRqqdln0htVubkoUDvDW0t7y8JOXGrk7yMCZyCU8q1xDsC65ck
         aq0MH1NqZFfk3PxnL6w8jNE7qqyl7GUVOHq/aaXqFLC8ZtbSCepoKGZjkPma0nGVNp7N
         XWpg==
X-Forwarded-Encrypted: i=1; AJvYcCUaIP/ceaGE13l+szBPDQLcghnEgZ0AUVjJPY4GK68rkYfAZWj4dodu20PoF1eejcaHDOyZB9Thel/HqYBJl+o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiKAIvy0SX3bSolbf8IBYkatDdeXL/wMyaTCKY7OdP8Tu+st6x
	5nWjYLbD9bae15MqYQYfc04U1PF8JMtmDv0s6Ccc7MLl4rYJkguhR/4c
X-Gm-Gg: AZuq6aKiNKoeIkXZLgTvPhI/7W0hip5fRMYA4CUFbM4FRzjgi31ZgjxjiI+NsAyNaVE
	DLB4YBTBtXzScdXrdOgoJ6d77rPbMkPZcIFqBFuPiToRSuxYW3CNZ0jiLbPADsfIg645tedegvG
	wovMYEX5pecfOkRCUpSLJ52hfsEWDl9FSbSRbaYP1NRPyV/qMjbGqa/Bdod36oQmlESw2mM3Tq8
	n1+7cabhowyXIELfyiqZnE1Z7tSeCdM/JqJdurq7Gjw4JNMqb8E3UDY3wDhuP1EvsmLrh0vHC5Y
	kcpVwcWPmhHYoh+utHkYk5xI9whsjes6xUhBEjmcaaib4eeacDF683WcvwJaQ3Nw0y2qMNp1ZGC
	gbny9tt8Gdrq90Tmt1kXMzQv9Vlj3kL4OnrraknFrwDU9WijECI/VQZp/3DaWtGBp371zocUF1U
	/oF0DLAlzX+Zv121yQR4ZaZMV7MrYaHZzj4f24PO/hEf893l+McoGa9/s1u2OW+E5b7xTaTMb3c
	aviwwR3SCDOZQ/F7XH5
X-Received: by 2002:a05:7300:220f:b0:2b8:209d:5980 with SMTP id 5a478bee46e88-2b8209d5c4amr1327259eec.30.1770130533426;
        Tue, 03 Feb 2026 06:55:33 -0800 (PST)
Received: from localhost.localdomain (108-214-96-168.lightspeed.sntcca.sbcglobal.net. [108.214.96.168])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a16ef40asm21806765eec.13.2026.02.03.06.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 06:55:33 -0800 (PST)
From: Sun Jian <sun.jian.kdev@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sun Jian <sun.jian.kdev@gmail.com>
Subject: [PATCH v2] netfilter: amanda: fix RCU pointer typing for nf_nat_amanda_hook
Date: Tue,  3 Feb 2026 22:55:11 +0800
Message-ID: <20260203145511.164485-1-sun.jian.kdev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260203080109.2682183-1-sun.jian.kdev@gmail.com>
References: <20260203080109.2682183-1-sun.jian.kdev@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sparse reports "incompatible types in comparison expression" error in
nf_conntrack_amanda.c because nf_nat_amanda_hook is used with
rcu_dereference() but lacks the proper __rcu annotation.

Fix this by correctly placing the __rcu annotation inside the pointer
parentheses in both the declaration and definition. This allows the
standard rcu_dereference() to work correctly.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
---
v2:
  - Correctly place __rcu annotation inside the parentheses as
    suggested by Florian Westphal.
  - Use standard rcu_dereference() instead of rcu_dereference_raw().
---
 include/linux/netfilter/nf_conntrack_amanda.h | 12 +++++------
 net/netfilter/nf_conntrack_amanda.c           | 21 ++++++++++++-------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_amanda.h b/include/linux/netfilter/nf_conntrack_amanda.h
index 6f0ac896fcc9..9f957598a9da 100644
--- a/include/linux/netfilter/nf_conntrack_amanda.h
+++ b/include/linux/netfilter/nf_conntrack_amanda.h
@@ -7,10 +7,10 @@
 #include <linux/skbuff.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 
-extern unsigned int (*nf_nat_amanda_hook)(struct sk_buff *skb,
-					  enum ip_conntrack_info ctinfo,
-					  unsigned int protoff,
-					  unsigned int matchoff,
-					  unsigned int matchlen,
-					  struct nf_conntrack_expect *exp);
+extern unsigned int (__rcu *nf_nat_amanda_hook)(struct sk_buff *skb,
+						enum ip_conntrack_info ctinfo,
+						unsigned int protoff,
+						unsigned int matchoff,
+						unsigned int matchlen,
+						struct nf_conntrack_expect *exp);
 #endif /* _NF_CONNTRACK_AMANDA_H */
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 7be4c35e4795..2e3753758b9b 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -37,13 +37,13 @@ MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
 module_param(ts_algo, charp, 0400);
 MODULE_PARM_DESC(ts_algo, "textsearch algorithm to use (default kmp)");
 
-unsigned int (*nf_nat_amanda_hook)(struct sk_buff *skb,
-				   enum ip_conntrack_info ctinfo,
-				   unsigned int protoff,
-				   unsigned int matchoff,
-				   unsigned int matchlen,
-				   struct nf_conntrack_expect *exp)
-				   __read_mostly;
+unsigned int (__rcu *nf_nat_amanda_hook)(struct sk_buff *skb,
+					 enum ip_conntrack_info ctinfo,
+					 unsigned int protoff,
+					 unsigned int matchoff,
+					 unsigned int matchlen,
+					 struct nf_conntrack_expect *exp)
+					 __read_mostly;
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
-- 
2.43.0

