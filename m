Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4BB5DF29
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2024 10:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709719902; cv=none; b=hEJEbRRB8iaFrIi1uTUbfnFRCVz80tCU8HZD3Bz4lu3e1prohEJN0MycPlKhMa8dcG/2x3UVm5QxAJO6R9LjUwtzziH79aHhkXlEXtIANVQBUrn+7LMsZX2QfzWhkfb5pJ7kKCRQBwtZgcn/RrXbnpOfFqwGtgKM5xVwIGZHMVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709719902; c=relaxed/simple;
	bh=gvIXHjbp2eGyAZpbEmD03/9eMsXI9OQ0gPkJ0oHjAXs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VNDGEGNngRmVMPUDzB+IweOo0bajqrsUVsSdNyYkzdLk//krNM2wBlaFJ/VSXJkLL9hmaJsJmcTct9la4m8ov3HxPy7ncKmIv+HABT6ZCBlCT3zYglGmxfOg9zTOrIQBttvLG61Mu1o8rPdiZY+swNM+WhioU0nifN/03qzzMic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rhoFO-0005iO-CJ; Wed, 06 Mar 2024 11:11:38 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH xtables-nft v2] extensions: xt_socket: add txlate support for socket match
Date: Wed,  6 Mar 2024 11:11:25 +0100
Message-ID: <20240306101132.55075-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: document the match semantics of -m socket.

Ignore --nowildcard if used with other options when translating
and add "wildcard 0" if the option is missing.

"-m socket" will ignore sockets bound to 0.0.0.0/:: by default,
unless --nowildcard is given.

So, xlate must always append "wildcard 0", can elide "wildcard"
if other options are present along with --nowildcard.

To emulate "-m socket --nowildcard", check for "wildcard <= 1" to
get a "socket exists" type matching.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_socket.c      | 39 ++++++++++++++++++++++++++++++++++
 extensions/libxt_socket.txlate | 17 +++++++++++++++
 2 files changed, 56 insertions(+)
 create mode 100644 extensions/libxt_socket.txlate

diff --git a/extensions/libxt_socket.c b/extensions/libxt_socket.c
index a99135cdfa0a..016ea3435339 100644
--- a/extensions/libxt_socket.c
+++ b/extensions/libxt_socket.c
@@ -159,6 +159,42 @@ socket_mt_print_v3(const void *ip, const struct xt_entry_match *match,
 	socket_mt_save_v3(ip, match);
 }
 
+static int socket_mt_xlate(struct xt_xlate *xl, const struct xt_xlate_mt_params *params)
+{
+	const struct xt_socket_mtinfo3 *info = (const void *)params->match->data;
+	const char *space = "";
+
+	/* ONLY --nowildcard: match if socket exists. It does not matter
+	 * to which address it is bound.
+	 */
+	if (info->flags == XT_SOCKET_NOWILDCARD) {
+		xt_xlate_add(xl, "%ssocket wildcard le 1", space);
+		return 1;
+	}
+
+	/* Without --nowildcard, restrict to sockets NOT bound to
+	 * the any address.
+	 */
+	if ((info->flags & XT_SOCKET_NOWILDCARD) == 0) {
+		xt_xlate_add(xl, "socket wildcard 0");
+		space = " ";
+	}
+
+	if (info->flags & XT_SOCKET_TRANSPARENT) {
+		xt_xlate_add(xl, "%ssocket transparent 1", space);
+		space = " ";
+	}
+
+	/* If --nowildcard was given, -m socket should not test
+	 * the bound address.  We can simply ignore this; its
+	 * equal to "wildcard <= 1".
+	 */
+	if (info->flags & XT_SOCKET_RESTORESKMARK)
+		xt_xlate_add(xl, "%smeta mark set socket mark", space);
+
+	return 1;
+}
+
 static struct xtables_match socket_mt_reg[] = {
 	{
 		.name          = "socket",
@@ -180,6 +216,7 @@ static struct xtables_match socket_mt_reg[] = {
 		.save          = socket_mt_save,
 		.x6_parse      = socket_mt_parse,
 		.x6_options    = socket_mt_opts,
+		.xlate	       = socket_mt_xlate,
 	},
 	{
 		.name          = "socket",
@@ -193,6 +230,7 @@ static struct xtables_match socket_mt_reg[] = {
 		.save          = socket_mt_save_v2,
 		.x6_parse      = socket_mt_parse_v2,
 		.x6_options    = socket_mt_opts_v2,
+		.xlate	       = socket_mt_xlate,
 	},
 	{
 		.name          = "socket",
@@ -206,6 +244,7 @@ static struct xtables_match socket_mt_reg[] = {
 		.save          = socket_mt_save_v3,
 		.x6_parse      = socket_mt_parse_v3,
 		.x6_options    = socket_mt_opts_v3,
+		.xlate	       = socket_mt_xlate,
 	},
 };
 
diff --git a/extensions/libxt_socket.txlate b/extensions/libxt_socket.txlate
new file mode 100644
index 000000000000..7731e42eabf7
--- /dev/null
+++ b/extensions/libxt_socket.txlate
@@ -0,0 +1,17 @@
+# old socket match, no options.  Matches if sk can be found and it is not bound to 0.0.0.0/::
+iptables-translate -A INPUT -m socket
+nft 'add rule ip filter INPUT socket wildcard 0 counter'
+
+iptables-translate -A INPUT -m socket --transparent
+nft 'add rule ip filter INPUT socket wildcard 0 socket transparent 1 counter'
+
+# Matches if sk can be found.  Doesn't matter as to what addess it is bound to.
+# therefore, emulate "exists".
+iptables-translate -A INPUT -m socket --nowildcard
+nft 'add rule ip filter INPUT socket wildcard le 1 counter'
+
+iptables-translate -A INPUT -m socket --restore-skmark
+nft 'add rule ip filter INPUT socket wildcard 0 meta mark set socket mark counter'
+
+iptables-translate -A INPUT -m socket --transparent --nowildcard --restore-skmark
+nft 'add rule ip filter INPUT socket transparent 1 meta mark set socket mark counter'
-- 
2.44.0

