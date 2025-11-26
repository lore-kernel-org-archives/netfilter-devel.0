Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBA130F524
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2025 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764170046; cv=none; b=YMWrcZl+OuB6UKCPyvgh5G/tYlhPaSIMaWlQh0cyXzsFmgecVh6Rl1PPxYn5v8HZNbCiSsspoOkfCw6aswhZt3YCEJKOTAeb/xzNcVcAE/AdDuxn3aetL4CaF2DUn4EID4d5bz6qnDn05qlQH5UmXobvU2VeXPUQus0X8dNgLIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764170046; c=relaxed/simple;
	bh=lLffg6LiiNVcI/gnVIw2AKHJKEsYWUT4il+OgWdnco4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkgORceb5imU3rOnYgZWYSnbx6FLopdPrGbGexW5ylm22rS95Gf2JnLvWTMXuiiWCgaAPRvWe5TXhQGBgulazWY3a0Lo8Dlg70JiBx41UiwSdzTays4TpVC4MDzAmoneoQnQTFNCOXOQK97MUAEDBRjZTZlyjwzbirjypN2vfPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YhkFTBz3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YhkFTBz3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=A4pLRmLBTE1kQnSgRXNt6dD072/veKL1I0C8iAZgjmY=; b=YhkFTBz3lq36S8k2lNnCSmtpiG
	07EL1a1i0C3tgZ29+gPWh6ce1LZtJ4LgTlNeBc6qcVQA8K1C+JVWikXWycVeR9STWxrRTZdeAvZoE
	hqIWgL2hWxkHWSNV0Tjf7MMopuBvgM8QT7+upIexBqhVmdAejLwLQdk+qvwgAly26KVBaeOAqtNIh
	Fzu2EJgsbhrNHxuOhe5Yv/WVS+Rk9BQObnahDiapxTF6w7Wvo9iko4hkvIL4mfEhfOhrJnhtYohsv
	isvVOF2hqagDb6wgNrCaUY7k8rWLLFTttbfUswUwL0Suldlfc0ylL0lMRed1l9qZCijiJqzd7EBrt
	s5BmMBgw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vOHDO-000000001Ab-2yCY;
	Wed, 26 Nov 2025 16:13:55 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH RFC 1/6] parser_bison: Introduce tokens for monitor events
Date: Wed, 26 Nov 2025 16:13:41 +0100
Message-ID: <20251126151346.1132-2-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126151346.1132-1-phil@nwl.cc>
References: <20251126151346.1132-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There already is a start condition for "monitor" keyword and also a
DESTROY token. So just add the missing one and get rid of the
intermediate string buffer.

Keep checking the struct monitor::event value in eval phase just to be
on the safe side.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/rule.h     | 11 +++++++++--
 src/evaluate.c     | 22 +++-------------------
 src/parser_bison.y | 10 +++++-----
 src/rule.c         |  3 +--
 src/scanner.l      |  2 ++
 5 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index e8b3c0376e367..4c647f732caf2 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -739,15 +739,22 @@ enum {
 	CMD_MONITOR_OBJ_MAX
 };
 
+enum {
+	CMD_MONITOR_EVENT_ANY,
+	CMD_MONITOR_EVENT_NEW,
+	CMD_MONITOR_EVENT_DEL,
+	CMD_MONITOR_EVENT_MAX
+};
+
 struct monitor {
 	struct location	location;
 	uint32_t	format;
 	uint32_t	flags;
 	uint32_t	type;
-	const char	*event;
+	uint32_t	event;
 };
 
-struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event);
+struct monitor *monitor_alloc(uint32_t format, uint32_t type, uint32_t event);
 void monitor_free(struct monitor *m);
 
 #define NFT_NLATTR_LOC_MAX 32
diff --git a/src/evaluate.c b/src/evaluate.c
index 4be5299274d26..45de3ad6e5998 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -6452,13 +6452,6 @@ static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
-enum {
-	CMD_MONITOR_EVENT_ANY,
-	CMD_MONITOR_EVENT_NEW,
-	CMD_MONITOR_EVENT_DEL,
-	CMD_MONITOR_EVENT_MAX
-};
-
 static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
 	[CMD_MONITOR_EVENT_ANY] = {
 		[CMD_MONITOR_OBJ_ANY]		= 0xffffffff,
@@ -6528,20 +6521,11 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
 
 static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 {
-	uint32_t event;
-
-	if (cmd->monitor->event == NULL)
-		event = CMD_MONITOR_EVENT_ANY;
-	else if (strcmp(cmd->monitor->event, "new") == 0)
-		event = CMD_MONITOR_EVENT_NEW;
-	else if (strcmp(cmd->monitor->event, "destroy") == 0)
-		event = CMD_MONITOR_EVENT_DEL;
-	else {
-		return monitor_error(ctx, cmd->monitor, "invalid event %s",
+	if (cmd->monitor->event >= CMD_MONITOR_EVENT_MAX)
+		return monitor_error(ctx, cmd->monitor, "invalid event %u",
 				     cmd->monitor->event);
-	}
 
-	cmd->monitor->flags = monitor_flags[event][cmd->monitor->type];
+	cmd->monitor->flags = monitor_flags[cmd->monitor->event][cmd->monitor->type];
 	return 0;
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3ceef79469d7d..96d0e151b1586 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -353,6 +353,7 @@ int nft_lex(void *, void *, void *);
 %token DESCRIBE			"describe"
 %token IMPORT			"import"
 %token EXPORT			"export"
+%token NEW			"new"
 %token DESTROY			"destroy"
 
 %token MONITOR			"monitor"
@@ -985,9 +986,7 @@ int nft_lex(void *, void *, void *);
 %destructor { expr_free($$); }	osf_expr
 
 %type <val>			markup_format
-%type <string>			monitor_event
-%destructor { free_const($$); }	monitor_event
-%type <val>			monitor_object	monitor_format
+%type <val>			monitor_event monitor_object monitor_format
 
 %type <val>			synproxy_ts	synproxy_sack
 
@@ -1892,8 +1891,9 @@ monitor_cmd		:	monitor_event	monitor_object	monitor_format
 			}
 			;
 
-monitor_event		:	/* empty */	{ $$ = NULL; }
-			|       STRING		{ $$ = $1; }
+monitor_event		:	/* empty */	{ $$ = CMD_MONITOR_EVENT_ANY; }
+			|	NEW		{ $$ = CMD_MONITOR_EVENT_NEW; }
+			|       DESTROY		{ $$ = CMD_MONITOR_EVENT_DEL; }
 			;
 
 monitor_object		:	/* empty */	{ $$ = CMD_MONITOR_OBJ_ANY; }
diff --git a/src/rule.c b/src/rule.c
index 8f8b77f1e8836..a915c395acffb 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1389,7 +1389,7 @@ void markup_free(struct markup *m)
 	free(m);
 }
 
-struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event)
+struct monitor *monitor_alloc(uint32_t format, uint32_t type, uint32_t event)
 {
 	struct monitor *mon;
 
@@ -1404,7 +1404,6 @@ struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event)
 
 void monitor_free(struct monitor *m)
 {
-	free_const(m->event);
 	free(m);
 }
 
diff --git a/src/scanner.l b/src/scanner.l
index df8e536be2276..99ace05773816 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -322,6 +322,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_CMD_MONITOR>{
 	"rules"			{ return RULES; }
 	"trace"			{ return TRACE; }
+	"new"			{ return NEW; }
+	"destroy"		{ return DESTROY; }
 }
 "hook"			{ return HOOK; }
 "device"		{ return DEVICE; }
-- 
2.51.0

