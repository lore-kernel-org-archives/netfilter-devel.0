Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F09F5EE60
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2024 08:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709715552; cv=none; b=I6q06gncvz4vt1QlTI8GOtOjZOZRFdQ4caR+N1Av7kSVcVgclYo0MBLR5VEVCZs7lcQF/KAyubDfMfGf7F6HtQkmhmJ9oQIaGUVcOOc9Qc7tJHzlsKAcIdhBN7MxcHCNELP0acOndQ1sdkvedfs/i3iJVJaal59mtAmEvmWv8Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709715552; c=relaxed/simple;
	bh=Ny/OCgNXzteFdtjxFyNT/OG/6Ou5G4zaXZ1zeGD4nRc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k0GsnIs/tSCGf3cXTWH4YL+HfCNjzI32OKvIN0T7sjoPm4rQcb5IkqIr7K0IgBfBYbNOYkdeHiF4tp6l3LjAsmKIDXgB28EbBnN8t5+2VMbIxcWlRn9GsbTeUEW3QT8h9209IyNkW0Acg3H/7tBdsIrvUJaFCl+hd/gYcai0ekk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rhn78-00056x-HM; Wed, 06 Mar 2024 09:59:02 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH xtables-nft] extensions: xt_socket: add txlate support for sk match v3
Date: Wed,  6 Mar 2024 09:58:49 +0100
Message-ID: <20240306085854.39838-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_socket.c      | 24 ++++++++++++++++++++++++
 extensions/libxt_socket.txlate | 11 +++++++++++
 2 files changed, 35 insertions(+)
 create mode 100644 extensions/libxt_socket.txlate

diff --git a/extensions/libxt_socket.c b/extensions/libxt_socket.c
index a99135cdfa0a..387e10ea0dea 100644
--- a/extensions/libxt_socket.c
+++ b/extensions/libxt_socket.c
@@ -159,6 +159,27 @@ socket_mt_print_v3(const void *ip, const struct xt_entry_match *match,
 	socket_mt_save_v3(ip, match);
 }
 
+static int socket_mt_xlate(struct xt_xlate *xl, const struct xt_xlate_mt_params *params)
+{
+	const struct xt_socket_mtinfo3 *info = (const void *)params->match->data;
+	const char *space = "";
+
+	if (info->flags & XT_SOCKET_TRANSPARENT) {
+		xt_xlate_add(xl, "socket transparent 1");
+		space = " ";
+	}
+
+	if (info->flags & XT_SOCKET_NOWILDCARD) {
+		xt_xlate_add(xl, "%ssocket wildcard 0", space);
+		space = " ";
+	}
+
+	if (info->flags & XT_SOCKET_RESTORESKMARK)
+		xt_xlate_add(xl, "%smeta mark set socket mark", space);
+
+	return 1;
+}
+
 static struct xtables_match socket_mt_reg[] = {
 	{
 		.name          = "socket",
@@ -180,6 +201,7 @@ static struct xtables_match socket_mt_reg[] = {
 		.save          = socket_mt_save,
 		.x6_parse      = socket_mt_parse,
 		.x6_options    = socket_mt_opts,
+		.xlate	       = socket_mt_xlate,
 	},
 	{
 		.name          = "socket",
@@ -193,6 +215,7 @@ static struct xtables_match socket_mt_reg[] = {
 		.save          = socket_mt_save_v2,
 		.x6_parse      = socket_mt_parse_v2,
 		.x6_options    = socket_mt_opts_v2,
+		.xlate	       = socket_mt_xlate,
 	},
 	{
 		.name          = "socket",
@@ -206,6 +229,7 @@ static struct xtables_match socket_mt_reg[] = {
 		.save          = socket_mt_save_v3,
 		.x6_parse      = socket_mt_parse_v3,
 		.x6_options    = socket_mt_opts_v3,
+		.xlate	       = socket_mt_xlate,
 	},
 };
 
diff --git a/extensions/libxt_socket.txlate b/extensions/libxt_socket.txlate
new file mode 100644
index 000000000000..1fe73f9b510d
--- /dev/null
+++ b/extensions/libxt_socket.txlate
@@ -0,0 +1,11 @@
+iptables-translate -A INPUT -m socket --transparent
+nft 'add rule ip filter INPUT socket transparent 1 counter'
+
+iptables-translate -A INPUT -m socket --nowildcard
+nft 'add rule ip filter INPUT socket wildcard 0 counter'
+
+iptables-translate -A INPUT -m socket --restore-skmark
+nft 'add rule ip filter INPUT meta mark set socket mark counter'
+
+iptables-translate -A INPUT -m socket --transparent --nowildcard --restore-skmark
+nft 'add rule ip filter INPUT socket transparent 1 socket wildcard 0 meta mark set socket mark counter'
-- 
2.44.0

