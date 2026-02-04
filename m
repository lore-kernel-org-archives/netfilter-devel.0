Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371E740FD98
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 15:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219518; cv=none; b=HEmcI0GERSUikgg/z0H8wt9Mcxs82oRSGPKmq05ViGiNeeCW3aPNmBvJiGj+QK9lu8ubMY9qGhle4M/rUaj4y3CgWiqBvyxBVg9jEUKZuZSyYwHDUHuTvWgFu4W9idiqYqhrfOF2U3CdD8xyy7U4WTlDN8YoEVyrfizo1pyF3Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219518; c=relaxed/simple;
	bh=MxODx3pS4AdMwobsyC+HGet1jyKV2KIg3yAsOJarsoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWrXpZPPkbGNBzdwwli7wg/WQa0qoxPxmHKR5fWRavFt0iwpPmCNg3+J8e66Xk8ZQK6yHB81aspDawYnmtt+Rj67M+Clox9dCBR4vZZ9Pm63px1CQ9URC3WnRF7SEmRuOZ1NCZaq8RxZ1QEOaR5ZMGpNlAhdwzhA72cU1z6JjOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J5gYtpMT; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J5gYtpMT"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-794719afcd4so72001497b3.1
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Feb 2026 07:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770219517; x=1770824317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQXv16HV512qbYg7bqvE7dda3nhbD1riX7k58Uh8FtI=;
        b=J5gYtpMTq/mSafxZ551ErP9w41VsyklmB0KP6zZCBay29es79skMvuBCYNEjJyC0eE
         ybog4Dov6zlqkbv1t4cqMRIIjaf04/qyuA0Af8QQqNw9Mu1JJj7TjC6CSBShcoLU6cS9
         j3G/oW7GSWssSWVIaAMPLy2Si2oC2XXqJmHqE2aHwOpsracMPtKNzTaqigFNMj9/NTd1
         6EM6BeatX8tECkUzKnrdlUVPko/fsTM23KTy3a8dchL6hk71wvBudCqEmrjLnI9Gf3pd
         esJWRJjYmQEonHe8DRPZOb6TCjF+eNlrowEMXgFvCq0hyQaUqJFMvb1iLbFpg6z0SxJ/
         e0Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770219517; x=1770824317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IQXv16HV512qbYg7bqvE7dda3nhbD1riX7k58Uh8FtI=;
        b=vcogYvNL+jKF9Nh+tNI6fVrMFFdwNX14axgJu+3MH+CIfabFgY50u+4wi1UF/ZObaA
         vOfNsJxFxcVgiop/ON6TdEGwEvt2KKwNmYMl6fgBnIxzGCxVbH1rHHZE2AEh8rgbVzua
         doFDcHMhaMIRPZtgLv4hJ0UG79UkaCtD9TdTaFEzTpdQ8/79x394vzgxH/GXxtIyt3im
         b6SLFd2T2BOEb4P09l2Bu0W+YzdJffL0FUavMb4aIJCGH/SIcWxL7JjSPts2KKmYOC2+
         Br7fp/eHHReOho9va03tQ60NYH22ZrIlLoJ40sRGxr7HynMQeP9JhgQ4nEJP7/AsNcMd
         ysIw==
X-Forwarded-Encrypted: i=1; AJvYcCXFA/r9064pY31jnWdQwIm3IfSfOlwVk1J24l8eWaSGzMA0hCUWAkSyC1u98rYZd6GpyG1ZUnpWXpdKaZbZ+oU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVdKUZLZ3KV8lOnyXxsmE4aA4OIpLNwjykDCZEs96FrsBfddO+
	4qXpMBXhYnP5PHBMiHvsfLpuDckBJUapztYa5h5zsw5m50DBMHSvL+a1
X-Gm-Gg: AZuq6aJlbNggBx9f3f1xeSUqfotHCw6FXxLZjc+nRRcr25AGqIoksVnvW36If9VTSoh
	2X2jikM2u4G0xe4E1UdC1LoLqBeB09bVw3p4n3i2FGpW0VboO1KwcpHk1QzIpWtReCaiwxsZfSt
	g6H0tmdqb1ITP45apCBSnA8COzyQn0Tj9mFm9knoXx68h1jd61E6yiARBMi7G+VQiZpPMhwpC25
	VfjC0Zog57e1oQWVVOZ0qSEkmm5wbD7zScfN5kGsmswr1s3ygQLckeKWgdmVFM53sINFHmSgrRQ
	MgsP8lEwk+2YZi1prfFtx1GT+GC5dw/lcu+jN0nxi1yTZr2IKIMfI8oDf0dxZqKpQlQ+/eWgODH
	t55A6kATNedZ/XkcYQEKQlJpnQFsmqxO1OnYw4s6zDfx6GDz1KR3XgqmFL6hlWq8CVJhtaPYwwX
	LwHzq8VrzsMDmsietbs9nWxYgy9+2hn6zxT8sfJhht81TOncjQNmVNiupRDeOJv9uG4AMrhV2hn
	7q2VeEeeg==
X-Received: by 2002:a05:690c:dc7:b0:794:3392:5d64 with SMTP id 00721157ae682-794fe74783bmr34112767b3.44.1770219517080;
        Wed, 04 Feb 2026 07:38:37 -0800 (PST)
Received: from localhost.localdomain (108-214-96-168.lightspeed.sntcca.sbcglobal.net. [108.214.96.168])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-794fefedd4bsm23609397b3.48.2026.02.04.07.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 07:38:36 -0800 (PST)
From: Sun Jian <sun.jian.kdev@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sun Jian <sun.jian.kdev@gmail.com>
Subject: [PATCH v4 1/5] netfilter: amanda: annotate nf_nat_amanda_hook with __rcu
Date: Wed,  4 Feb 2026 23:38:08 +0800
Message-ID: <20260204153812.739799-2-sun.jian.kdev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260204153812.739799-1-sun.jian.kdev@gmail.com>
References: <aYM6Wr7D4-7VvbX6@strlen.de>
 <20260204153812.739799-1-sun.jian.kdev@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nf_nat_amanda_hook is an RCU-protected pointer but lacks the
proper __rcu annotation. Add the annotation to ensure the declaration
correctly reflects its usage via rcu_dereference().

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 include/linux/netfilter/nf_conntrack_amanda.h | 12 ++++++------
 net/netfilter/nf_conntrack_amanda.c           | 14 +++++++-------
 2 files changed, 13 insertions(+), 13 deletions(-)

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
index 7be4c35e4795..c0132559f6af 100644
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
-- 
2.43.0

