Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40723ACA64;
	Thu,  2 Jul 2026 10:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989424; cv=none; b=dzN3ZWpi4/IKNcvPK6zctVYNmBy3zgl3FPT09d3oecOj6VMgSfhBcv2NFmW3m2ugXv6m/4MICILajuphICSqgY9uYF+LOoQXEiuPLJ5UxT51yG9dJZZghk8xNTIsCmGsHbxc/uBLsd/LS+caqm7X0yuuGNnhfnQXCuLTYzq/0nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989424; c=relaxed/simple;
	bh=6j4dqiXeB6O8iPce9uppX9Fhkr9FogfrOhqB/0Uo5gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jh3jvNU7NLgKKfmzAQTfkla7vKAmI9InU+348jCpbhhpN528D0VDQJjrby0BUutgQTqRXBSFrdjJ7S8VivA7gedcy8uo3b4qcsiCz+on7AFqzbV+xrRKGxwYaugnVZ6OvkjCQJ8IEhl6iYg/WeSSmLIhziOTnpZTOdBtMxPrMlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 344766032C; Thu, 02 Jul 2026 12:50:21 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 02/12] netfilter: x_tables: replace strlcat() with snprintf()
Date: Thu,  2 Jul 2026 12:49:53 +0200
Message-ID: <20260702105003.13550-3-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260702105003.13550-1-fw@strlen.de>
References: <20260702105003.13550-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ian Bridges <icb@fastmail.org>

In preparation for removing the deprecated strlcat() API[1], replace the
strscpy()/strlcat() pairs in xt_proto_init() and xt_proto_fini() with
snprintf(), which builds each /proc file name in a single call.

Each name is "<prefix><suffix>", where <prefix> is the address-family
string xt_prefix[af] and <suffix> is one of the FORMAT_TABLES,
FORMAT_MATCHES or FORMAT_TARGETS literals. Prepend %s to the FORMAT
macros and switch to snprintf().

Link: https://github.com/KSPP/linux/issues/370 [1]
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/x_tables.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 4e6708c23922..e64116bf2637 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1920,9 +1920,9 @@ static const struct seq_operations xt_target_seq_ops = {
 	.show	= xt_target_seq_show,
 };
 
-#define FORMAT_TABLES	"_tables_names"
-#define	FORMAT_MATCHES	"_tables_matches"
-#define FORMAT_TARGETS 	"_tables_targets"
+#define FORMAT_TABLES	"%s_tables_names"
+#define	FORMAT_MATCHES	"%s_tables_matches"
+#define FORMAT_TARGETS	"%s_tables_targets"
 
 #endif /* CONFIG_PROC_FS */
 
@@ -2033,8 +2033,7 @@ int xt_proto_init(struct net *net, u_int8_t af)
 	root_uid = make_kuid(net->user_ns, 0);
 	root_gid = make_kgid(net->user_ns, 0);
 
-	strscpy(buf, xt_prefix[af], sizeof(buf));
-	strlcat(buf, FORMAT_TABLES, sizeof(buf));
+	snprintf(buf, sizeof(buf), FORMAT_TABLES, xt_prefix[af]);
 	proc = proc_create_net_data(buf, 0440, net->proc_net, &xt_table_seq_ops,
 			sizeof(struct seq_net_private),
 			(void *)(unsigned long)af);
@@ -2043,8 +2042,7 @@ int xt_proto_init(struct net *net, u_int8_t af)
 	if (uid_valid(root_uid) && gid_valid(root_gid))
 		proc_set_user(proc, root_uid, root_gid);
 
-	strscpy(buf, xt_prefix[af], sizeof(buf));
-	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
+	snprintf(buf, sizeof(buf), FORMAT_MATCHES, xt_prefix[af]);
 	proc = proc_create_seq_private(buf, 0440, net->proc_net,
 			&xt_match_seq_ops, sizeof(struct nf_mttg_trav),
 			(void *)(unsigned long)af);
@@ -2053,8 +2051,7 @@ int xt_proto_init(struct net *net, u_int8_t af)
 	if (uid_valid(root_uid) && gid_valid(root_gid))
 		proc_set_user(proc, root_uid, root_gid);
 
-	strscpy(buf, xt_prefix[af], sizeof(buf));
-	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
+	snprintf(buf, sizeof(buf), FORMAT_TARGETS, xt_prefix[af]);
 	proc = proc_create_seq_private(buf, 0440, net->proc_net,
 			 &xt_target_seq_ops, sizeof(struct nf_mttg_trav),
 			 (void *)(unsigned long)af);
@@ -2068,13 +2065,11 @@ int xt_proto_init(struct net *net, u_int8_t af)
 
 #ifdef CONFIG_PROC_FS
 out_remove_matches:
-	strscpy(buf, xt_prefix[af], sizeof(buf));
-	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
+	snprintf(buf, sizeof(buf), FORMAT_MATCHES, xt_prefix[af]);
 	remove_proc_entry(buf, net->proc_net);
 
 out_remove_tables:
-	strscpy(buf, xt_prefix[af], sizeof(buf));
-	strlcat(buf, FORMAT_TABLES, sizeof(buf));
+	snprintf(buf, sizeof(buf), FORMAT_TABLES, xt_prefix[af]);
 	remove_proc_entry(buf, net->proc_net);
 out:
 	return -1;
@@ -2087,16 +2082,13 @@ void xt_proto_fini(struct net *net, u_int8_t af)
 #ifdef CONFIG_PROC_FS
 	char buf[XT_FUNCTION_MAXNAMELEN];
 
-	strscpy(buf, xt_prefix[af], sizeof(buf));
-	strlcat(buf, FORMAT_TABLES, sizeof(buf));
+	snprintf(buf, sizeof(buf), FORMAT_TABLES, xt_prefix[af]);
 	remove_proc_entry(buf, net->proc_net);
 
-	strscpy(buf, xt_prefix[af], sizeof(buf));
-	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
+	snprintf(buf, sizeof(buf), FORMAT_TARGETS, xt_prefix[af]);
 	remove_proc_entry(buf, net->proc_net);
 
-	strscpy(buf, xt_prefix[af], sizeof(buf));
-	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
+	snprintf(buf, sizeof(buf), FORMAT_MATCHES, xt_prefix[af]);
 	remove_proc_entry(buf, net->proc_net);
 #endif /*CONFIG_PROC_FS*/
 }
-- 
2.54.0

