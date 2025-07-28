Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC314202C45;
	Mon, 28 Jul 2025 10:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753698330; cv=none; b=fslESJKe7cpXSww+CwY97d2qovPs7e56X1UfMJyobdI6/fO4IIkS1SJ2t7DYIYv9LtmAsI038nBlRoTjU91uv6Gwd9nJi2iFYDG4RofFUAUbES1F0wYgosFv6hcl8oqhWqiLdp3QxyWVQV5GjwOOjlPS28fOuxht0eT4gGtv2RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753698330; c=relaxed/simple;
	bh=ZGGJmWvw8y8FePEMxJlxbl0/RNMsx/NZRPH4wIj6ef0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VeyanOaxt8y/0TVU/rZRA9GCxPacEwDPGZ1DYVIwIaE7yWsRjQRW8ibDALGSVZrn1z3fIvQ2S0iy7BidkMws3NPgDclU498yPoNZz5YSyyvx9boauFJQ3pJ2aYvmz4UrstOvGejo3O8HbbZRcoqfGdAw1PFef77BemP4g8Z52OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2403df11a2aso4012605ad.0;
        Mon, 28 Jul 2025 03:25:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753698328; x=1754303128;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D33KJ5gEdYuE57UlDiaZQfRX2uPPgB5PQIxEHRzRcFM=;
        b=LlhZiFFHvLBvicFgtusDhwz0m4YraMTIZQS1w6gMmGnXBHCER9IxfOyWQn4ZPKB+zb
         Ce/GXbQPK3sCP7rANzmc61JXcf02gzyvB3KMcKitKem6N9kvGquHibuPYgOxXd0hsfqB
         UzduCGvZZXf/j6kMY4mNHLL/nW94kFNf4dncOvrKXbusY4Hl352VF+wRajevT0mC1GfK
         yFIaSUtYnSJ9+DmlM1p1A5xjWQSh9fzSmSA2uQZFS4480PYsM5ik8BLK0M7WxQxyOBv9
         cQDe2q7Zt6woyykA3JRzVGJwaslKhgjp83hVWtQg+lcnspMtpXzp8C24L6i4TOTXEIVh
         RBlg==
X-Forwarded-Encrypted: i=1; AJvYcCUpTI5N2JxDAwNKT6+Tf9MiW+o+v80tnFWEEWPgk2W37ht0c+ueZNPplfmH0QcChDBEFimlqJIN/WvSQ3s=@vger.kernel.org, AJvYcCVIz/P/M+E4+qXSJwtY3U+wNwYd70UZrscIhVsnrQ5CMbEweSGbVesEkeqgnTWzu/iE127miM/t6/dkxXIV7O62@vger.kernel.org
X-Gm-Message-State: AOJu0YyYPzvSul4ZHVm/qQ0624HMOsusm6luxhU32TZ+CYBEz75cMnUf
	c3NIpU8F3Hx5zLJCJYbxnsfrrqExcHJbBu/JgE97lICl+Yd+T+F+ZFa2
X-Gm-Gg: ASbGnctiR7E8k7buLzOFpgniY1R4si6t0i27Relvb1Rk0gmnIBueyP9emmz606c+/vi
	dP1RsUfD3XaIT8uHDYLUSo8NkihDvt9YOIUufD5GNsQ58Y3vbrmgtjNcAhy8eB7KWqHyB7Wx+1+
	C/X1yaeUBI1ap3yD0VLi+QMSz7Dk6g120/hnxKZF7X6U+tPyWZjVrJp1djuwruuhBmJOjuCUu+g
	td9wNOmgM6wdkIwREKwzG5bR0UJc3epC/w01Hvub38tCgRhL1H76zPMTHmSANMxYgK+GOW61tHy
	yTiHOr9cjkzxM/eVo8ToIzVIoAkVgY/N/7+61CCkcO2u/+uinaX2t5h5r9xiy2nBdwknbW+JuGg
	8PlJzl/LzBtTJpPU=
X-Google-Smtp-Source: AGHT+IGLjSSzCoXq+cvU6qer/Fd9OilEAbRu9xYH54Qar6m2g9eXOj18GF/+3o3YSZGBX0s4wytE1g==
X-Received: by 2002:a17:903:204c:b0:23f:f96d:7579 with SMTP id d9443c01a7336-23ff96d7ab4mr47014715ad.37.1753698327977;
        Mon, 28 Jul 2025 03:25:27 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2403:2c80:17::10:402c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31e66376377sm9171866a91.28.2025.07.28.03.25.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Jul 2025 03:25:27 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: fw@strlen.de,
	pablo@netfilter.org
Cc: coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	horms@kernel.org,
	kadlec@netfilter.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	zi.li@linux.dev,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v3 1/1] netfilter: load nf_log_syslog on enabling nf_conntrack_log_invalid
Date: Mon, 28 Jul 2025 18:25:14 +0800
Message-ID: <20250728102514.6558-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lance Yang <lance.yang@linux.dev>

When no logger is registered, nf_conntrack_log_invalid fails to log invalid
packets, leaving users unaware of actual invalid traffic. Improve this by
loading nf_log_syslog, similar to how 'iptables -I FORWARD 1 -m conntrack
--ctstate INVALID -j LOG' triggers it.

Acked-by: Florian Westphal <fw@strlen.de>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Zi Li <zi.li@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v2 -> v3:
 - Remove the unnecessary check and comment (per Pablo)
 - Pick AB from Florian - thanks!
 - https://lore.kernel.org/lkml/20250526085902.36467-1-lance.yang@linux.dev/

v1 -> v2:
 - Add a new, simpler helper (per Florian)
 - Load the module only when no logger is registered (per Florian)
 - https://lore.kernel.org/all/20250514053751.2271-1-lance.yang@linux.dev/

 include/net/netfilter/nf_log.h          |  3 +++
 net/netfilter/nf_conntrack_standalone.c | 23 +++++++++++++++++++++-
 net/netfilter/nf_log.c                  | 26 +++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index e55eedc84ed7..00506792a06d 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -59,6 +59,9 @@ extern int sysctl_nf_log_all_netns;
 int nf_log_register(u_int8_t pf, struct nf_logger *logger);
 void nf_log_unregister(struct nf_logger *logger);
 
+/* Check if any logger is registered for a given protocol family. */
+bool nf_log_is_registered(u_int8_t pf);
+
 int nf_log_set(struct net *net, u_int8_t pf, const struct nf_logger *logger);
 void nf_log_unset(struct net *net, const struct nf_logger *logger);
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 6c4cff10357d..8f6108c0c308 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -14,6 +14,7 @@
 #include <linux/sysctl.h>
 #endif
 
+#include <net/netfilter/nf_log.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
@@ -561,6 +562,26 @@ nf_conntrack_hash_sysctl(const struct ctl_table *table, int write,
 	return ret;
 }
 
+static int
+nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
+				void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret, i;
+
+	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
+	if (ret < 0 || !write)
+		return ret;
+
+	/* Load nf_log_syslog only if no logger is currently registered */
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
+		if (nf_log_is_registered(i))
+			return ret;
+	}
+	request_module("%s", "nf_log_syslog");
+
+	return ret;
+}
+
 static struct ctl_table_header *nf_ct_netfilter_header;
 
 enum nf_ct_sysctl_index {
@@ -667,7 +688,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.data		= &init_net.ct.sysctl_log_invalid,
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dou8vec_minmax,
+		.proc_handler	= nf_conntrack_log_invalid_sysctl,
 	},
 	[NF_SYSCTL_CT_EXPECT_MAX] = {
 		.procname	= "nf_conntrack_expect_max",
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 6dd0de33eebd..74cef8bf554c 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -125,6 +125,32 @@ void nf_log_unregister(struct nf_logger *logger)
 }
 EXPORT_SYMBOL(nf_log_unregister);
 
+/**
+ * nf_log_is_registered - Check if any logger is registered for a given
+ * protocol family.
+ *
+ * @pf: Protocol family
+ *
+ * Returns: true if at least one logger is active for @pf, false otherwise.
+ */
+bool nf_log_is_registered(u_int8_t pf)
+{
+	int i;
+
+	if (pf >= NFPROTO_NUMPROTO) {
+		WARN_ON_ONCE(1);
+		return false;
+	}
+
+	for (i = 0; i < NF_LOG_TYPE_MAX; i++) {
+		if (rcu_access_pointer(loggers[pf][i]))
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL(nf_log_is_registered);
+
 int nf_log_bind_pf(struct net *net, u_int8_t pf,
 		   const struct nf_logger *logger)
 {
-- 
2.49.0

