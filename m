Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCE31F150B;
	Mon, 26 May 2025 08:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748249966; cv=none; b=EjKhSf97eOW/QQHo/hEv4D8q6rLPvDHjarT/T3uj1gJJMNn76ViuB6CaZtL8YqnbxU5MnHFcuWU/dYCu5Qd/bFKoNJwuUDb6VCnVYCEsQAG8n1qEh/WVYdcUUlYyFS6tf7MvXvAGowM4+zTXIy7vHA/zNy64ZoWdrKHtB3hIz7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748249966; c=relaxed/simple;
	bh=R2xHFwVJvcQXnjsRfwwZjgibnVNWyOXMqLEdx99mjRg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r974QokfgV3SMBqM51ESVvluVenh+/OfLxhVf5L50aZzBe9pWRNyDXmrsz03+Bky+ZULmbC0uLwhoP0ROnTRJu1w1AnQnY7KLO6n0qoE/TwLr0HmqGfauorXBdwiMr7hQRZSOyngRU9+DG+lf6Hg2Of9aNFuEcm4yHPpgcZkcXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lGEwIV25; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lGEwIV25"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22d95f0dda4so20082075ad.2;
        Mon, 26 May 2025 01:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748249964; x=1748854764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QbSsVYXZJHifZegsZIPzssQ+9OXSUAcl35ezly/7agU=;
        b=lGEwIV25wijVjR0s5v6ngrSyl8iuW/sWKvcZKNOiwj5DdlFj8Kbj3UiIfD1P2xW3xC
         RmWolCtkLanYQ/9p01GFWtRhexOpGLzDOoWYv0VirSp9V0puV0mcUAfB80EM+KcFCgf5
         DISJC7AuGisJvMG+yPGD2xTf5f18C4cJf8v55gSmnfC6riFmMrL9kf6IhrygmtryPz4i
         E+eSoUz7nIngf852sPpcSnyS7OyiQb2QUNUr+pQ9BcGNLtganMZqX+wJ4DGCXlVTc9az
         Hskm4dm+ON45neEpCNXQdEQZ+J93t0zSYl80ECh8XBip4ufYT45p77+ffArj4EXBNXo5
         yzSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748249964; x=1748854764;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QbSsVYXZJHifZegsZIPzssQ+9OXSUAcl35ezly/7agU=;
        b=sne8LgP2CkqWs94S/oKvAa9pkpaK0w6ALn1wsmRGXy6InxwcfV3tywu1Lj5vAh4NlK
         mDUuqNTKIq6FPC0+U+T3odbqFkxf8imomp26ZCAJcyC9AatIT1t2yMN0+HbACnCoYwYL
         pGey5wJYip9OVZmlYEtdKlDruSohT7Ryc7EezjkZfq/BR/yj0UxXkPiTJMLOzY2mgDOJ
         DX9OvdIrOgUwSvkrHcw6YEWkB4+KNQdUMwHTR1WdcigpVn/zvzWdftyVTVfqARsObZ5P
         HTG785vTGgYcQsHJKK08qArNVpdryza/kqTJYpZYr7NhTv0b0CVsh/QUZJYEsW4sWOYR
         xlJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSRIX0VhfWIDRbuQzAUyLD1LpUiGUphFU02llxr8yho4hsCpgxOy0rUpSAQg5BLqi/JoybFwrgwehfIJEi4MJV@vger.kernel.org, AJvYcCW5Zn9C8+GY6IT9fMkqo+6RHPqiXlrT5tbmaVhCyIhKN5HVJthdt/VhJiGe+ywTpp4KaDMyTAPG05Gd5Q0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9wjdENdC/6/VMtfcwARi9CVCzVE0IXKMhyMAQyYhroJQHzmet
	f6r2zMMddS2ODZsgwRd50E28FlNANw4shfuy91045CJmSV39zS+4NlLn+WQi6Baz
X-Gm-Gg: ASbGncuhLlLO0pJouKG3ITHFkuJvq9ayj7AN3ftbTBeyb0nTl0WfW/ArcLCzbV3nlU4
	ve4OI6DipFgzPUzVFk33wNE6N1PC3nPzYwkPGS6jV1g+aHIT5GszznVDNkeo1AKBwp8LKQnWu2g
	xKw7OQ4RqIFK7UNkdDnVA65kht02ueDTHngMzw6I6eQYHezhqA3J3SFLKx8YugYuV2J9KohzSa0
	mMKfzGeSChfgq1zFRfat6HEKhy5m3QSV0mVNWCj4aYMlRZOsfR1niYY6A1kBdsmPu7W5L2IQ0bY
	lFLmYFGDPRDCxGKA51iS1tOpUWRVN7Cas8TST1t/g+DnEF0RD8P0Hl3NJY5w
X-Google-Smtp-Source: AGHT+IHUQfKErD6unO52zIUWOxca53o0fkvBi747lM2AhxfmKQUg9IcZvmLz4dA4ltoHdRQ9HCzTjA==
X-Received: by 2002:a17:902:ccc5:b0:224:24d3:6103 with SMTP id d9443c01a7336-23414feac55mr146081325ad.35.1748249964026;
        Mon, 26 May 2025 01:59:24 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([103.88.46.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-233fdb6d480sm46503145ad.213.2025.05.26.01.59.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 26 May 2025 01:59:23 -0700 (PDT)
From: Lance Yang <ioworker0@gmail.com>
X-Google-Original-From: Lance Yang <lance.yang@linux.dev>
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
Subject: [PATCH v2 1/1] netfilter: load nf_log_syslog on enabling nf_conntrack_log_invalid
Date: Mon, 26 May 2025 16:59:02 +0800
Message-ID: <20250526085902.36467-1-lance.yang@linux.dev>
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

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Zi Li <zi.li@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v1 -> v2:
 - Add a new, simpler helper (per Florian)
 - Load the module only when no logger is registered (per Florian)
 - https://lore.kernel.org/all/20250514053751.2271-1-lance.yang@linux.dev/

 include/net/netfilter/nf_log.h          |  3 +++
 net/netfilter/nf_conntrack_standalone.c | 26 +++++++++++++++++++++++-
 net/netfilter/nf_log.c                  | 27 +++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 1 deletion(-)

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
index 2f666751c7e7..cdc27424f84a 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -14,6 +14,7 @@
 #include <linux/sysctl.h>
 #endif
 
+#include <net/netfilter/nf_log.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
@@ -543,6 +544,29 @@ nf_conntrack_hash_sysctl(const struct ctl_table *table, int write,
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
+	if (*(u8 *)table->data == 0)
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
@@ -649,7 +673,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.data		= &init_net.ct.sysctl_log_invalid,
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dou8vec_minmax,
+		.proc_handler	= nf_conntrack_log_invalid_sysctl,
 	},
 	[NF_SYSCTL_CT_EXPECT_MAX] = {
 		.procname	= "nf_conntrack_expect_max",
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 6dd0de33eebd..c7dd5019a89d 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -125,6 +125,33 @@ void nf_log_unregister(struct nf_logger *logger)
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
+	/* Out of bounds. */
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

