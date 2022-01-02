Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4B8C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Jan 2022 22:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiABWPD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Jan 2022 17:15:03 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56130 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiABWPC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Jan 2022 17:15:02 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3B12862BD8
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Jan 2022 23:12:17 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables,v2 2/7] src: error reporting with -f and read from stdin
Date:   Sun,  2 Jan 2022 23:14:47 +0100
Message-Id: <20220102221452.86469-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220102221452.86469-1-pablo@netfilter.org>
References: <20220102221452.86469-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reading from stdin requires to store the ruleset in a buffer so error
reporting works accordingly, eg.

 # cat ruleset.nft | nft -f -
 /dev/stdin:3:13-13: Error: unknown identifier 'x'
                 ip saddr $x
                           ^

The error reporting infrastructure performs a fseek() on the file
descriptor which does not work in this case since the data from the
descriptor has been already consumed.

This patch adds a new stdin input descriptor to perform this special
handling which consists on re-routing this request through the buffer
functions.

Fixes: 935f82e7dd49 ("Support 'nft -f -' to read from stdin")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables.h |  2 ++
 src/erec.c         |  8 +++++++-
 src/libnftables.c  | 48 ++++++++++++++++++++++++++++++++++++++++++----
 src/scanner.l      |  2 +-
 4 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 7b6339053b54..d6d9b9cc7206 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -128,6 +128,7 @@ struct nft_ctx {
 	struct scope		*top_scope;
 	void			*json_root;
 	json_t			*json_echo;
+	const char		*stdin_buf;
 };
 
 enum nftables_exit_codes {
@@ -175,6 +176,7 @@ enum input_descriptor_types {
 	INDESC_FILE,
 	INDESC_CLI,
 	INDESC_NETLINK,
+	INDESC_STDIN,
 };
 
 /**
diff --git a/src/erec.c b/src/erec.c
index 7c9165c290d8..32fb079fa8b4 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -101,10 +101,11 @@ void print_location(FILE *f, const struct input_descriptor *indesc,
 			iloc = &tmp->location;
 		}
 	}
-	if (indesc->name != NULL)
+	if (indesc->type != INDESC_BUFFER && indesc->name) {
 		fprintf(f, "%s:%u:%u-%u: ", indesc->name,
 			loc->first_line, loc->first_column,
 			loc->last_column);
+	}
 }
 
 const char *line_location(const struct input_descriptor *indesc,
@@ -145,6 +146,11 @@ void erec_print(struct output_ctx *octx, const struct error_record *erec,
 		line = indesc->data;
 		*strchrnul(line, '\n') = '\0';
 		break;
+	case INDESC_STDIN:
+		line = indesc->data;
+		line += loc->line_offset;
+		*strchrnul(line, '\n') = '\0';
+		break;
 	case INDESC_FILE:
 		line = line_location(indesc, loc, buf, sizeof(buf));
 		break;
diff --git a/src/libnftables.c b/src/libnftables.c
index 7b9d7efaeaae..e76f32eff7ca 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -424,13 +424,14 @@ static const struct input_descriptor indesc_cmdline = {
 };
 
 static int nft_parse_bison_buffer(struct nft_ctx *nft, const char *buf,
-				  struct list_head *msgs, struct list_head *cmds)
+				  struct list_head *msgs, struct list_head *cmds,
+				  const struct input_descriptor *indesc)
 {
 	int ret;
 
 	parser_init(nft, nft->state, msgs, cmds, nft->top_scope);
 	nft->scanner = scanner_init(nft->state);
-	scanner_push_buffer(nft->scanner, &indesc_cmdline, buf);
+	scanner_push_buffer(nft->scanner, indesc, buf);
 
 	ret = nft_parse(nft, nft->scanner, nft->state);
 	if (ret != 0 || nft->state->nerrs > 0)
@@ -439,11 +440,42 @@ static int nft_parse_bison_buffer(struct nft_ctx *nft, const char *buf,
 	return 0;
 }
 
+static char *stdin_to_buffer(void)
+{
+	unsigned int bufsiz = 16384, consumed = 0;
+	int numbytes;
+	char *buf;
+
+	buf = xmalloc(bufsiz);
+
+	numbytes = read(STDIN_FILENO, buf, bufsiz);
+	while (numbytes > 0) {
+		consumed += numbytes;
+		if (consumed == bufsiz) {
+			bufsiz *= 2;
+			buf = realloc(buf, bufsiz);
+		}
+		numbytes = read(STDIN_FILENO, buf + consumed, bufsiz - consumed);
+	}
+	buf[consumed] = '\0';
+
+	return buf;
+}
+
+static const struct input_descriptor indesc_stdin = {
+	.type	= INDESC_STDIN,
+	.name	= "/dev/stdin",
+};
+
 static int nft_parse_bison_filename(struct nft_ctx *nft, const char *filename,
 				    struct list_head *msgs, struct list_head *cmds)
 {
 	int ret;
 
+	if (nft->stdin_buf)
+		return nft_parse_bison_buffer(nft, nft->stdin_buf, msgs, cmds,
+					      &indesc_stdin);
+
 	parser_init(nft, nft->state, msgs, cmds, nft->top_scope);
 	nft->scanner = scanner_init(nft->state);
 	if (scanner_read_file(nft, filename, &internal_location) < 0)
@@ -510,7 +542,8 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 	if (nft_output_json(&nft->output))
 		rc = nft_parse_json_buffer(nft, nlbuf, &msgs, &cmds);
 	if (rc == -EINVAL)
-		rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &cmds);
+		rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &cmds,
+					    &indesc_cmdline);
 
 	parser_rc = rc;
 
@@ -578,7 +611,7 @@ retry:
 	}
 	snprintf(buf + offset, bufsize - offset, "\n");
 
-	rc = nft_parse_bison_buffer(ctx, buf, msgs, &cmds);
+	rc = nft_parse_bison_buffer(ctx, buf, msgs, &cmds, &indesc_cmdline);
 
 	assert(list_empty(&cmds));
 	/* Stash the buffer that contains the variable definitions and zap the
@@ -608,6 +641,10 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 	if (!strcmp(filename, "-"))
 		filename = "/dev/stdin";
 
+	if (!strcmp(filename, "/dev/stdin") &&
+	    !nft_output_json(&nft->output))
+		nft->stdin_buf = stdin_to_buffer();
+
 	rc = -EINVAL;
 	if (nft_output_json(&nft->output))
 		rc = nft_parse_json_filename(nft, filename, &msgs, &cmds);
@@ -656,5 +693,8 @@ err:
 		json_print_echo(nft);
 	if (rc)
 		nft_cache_release(&nft->cache);
+
+	xfree(nft->stdin_buf);
+
 	return rc;
 }
diff --git a/src/scanner.l b/src/scanner.l
index f28bf3153f0b..7dcc45c2fd50 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -1032,7 +1032,7 @@ void scanner_push_buffer(void *scanner, const struct input_descriptor *indesc,
 	new_indesc = xzalloc(sizeof(struct input_descriptor));
 	memcpy(new_indesc, indesc, sizeof(*new_indesc));
 	new_indesc->data = buffer;
-	new_indesc->name = NULL;
+	new_indesc->name = xstrdup(indesc->name);
 	scanner_push_indesc(state, new_indesc);
 
 	b = yy_scan_string(buffer, scanner);
-- 
2.30.2

