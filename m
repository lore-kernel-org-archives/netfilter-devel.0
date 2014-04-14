From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/5] extensions: libxt_tcp: add translation to nft
Date: Mon, 14 Apr 2014 12:41:05 +0200
Message-ID: <1397472066-13011-5-git-send-email-pablo@netfilter.org>
References: <1397472066-13011-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45237 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbaDNKlR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:41:17 -0400
In-Reply-To: <1397472066-13011-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Translation for the TCP option matching is not yet implemented as we
don't have a way to match this yet.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_tcp.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index bbdec45..dddefb4 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -362,6 +362,85 @@ static void tcp_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
+static const struct tcp_flag_names tcp_flag_names_xlate[] = {
+	{ "fin", 0x01 },
+	{ "syn", 0x02 },
+	{ "rst", 0x04 },
+	{ "psh", 0x08 },
+	{ "ack", 0x10 },
+	{ "urg", 0x20 },
+};
+
+static void print_tcp_xlate(struct xt_buf *buf, uint8_t flags)
+{
+	int have_flag = 0;
+
+	while (flags) {
+		unsigned int i;
+
+		for (i = 0; (flags & tcp_flag_names_xlate[i].flag) == 0; i++);
+
+		if (have_flag)
+			xt_buf_add(buf, "|");
+
+		xt_buf_add(buf, "%s", tcp_flag_names_xlate[i].name);
+		have_flag = 1;
+
+		flags &= ~tcp_flag_names_xlate[i].flag;
+	}
+
+	if (!have_flag)
+		xt_buf_add(buf, "none");
+}
+
+static int tcp_xlate(const struct xt_entry_match *match, struct xt_buf *buf)
+{
+	const struct xt_tcp *tcpinfo = (const struct xt_tcp *)match->data;
+
+	if (tcpinfo->spts[0] != 0 || tcpinfo->spts[1] != 0xffff) {
+		if (tcpinfo->spts[0] != tcpinfo->spts[1]) {
+			xt_buf_add(buf, "tcp sport %s%u-%u ",
+				   tcpinfo->invflags & XT_TCP_INV_SRCPT ?
+					"!= " : "",
+				   tcpinfo->spts[0], tcpinfo->spts[1]);
+		} else {
+			xt_buf_add(buf, "tcp sport %s%u ",
+				   tcpinfo->invflags & XT_TCP_INV_SRCPT ?
+					"!= " : "",
+				   tcpinfo->spts[0]);
+		}
+	}
+
+	if (tcpinfo->dpts[0] != 0 || tcpinfo->dpts[1] != 0xffff) {
+		if (tcpinfo->dpts[0] != tcpinfo->dpts[1]) {
+			xt_buf_add(buf, "tcp dport %s%u-%u ",
+				   tcpinfo->invflags & XT_TCP_INV_DSTPT ?
+					"!= " : "",
+				   tcpinfo->dpts[0], tcpinfo->dpts[1]);
+		} else {
+			xt_buf_add(buf, "tcp dport %s%u ",
+				   tcpinfo->invflags & XT_TCP_INV_DSTPT ?
+					"!= " : "",
+				   tcpinfo->dpts[0]);
+		}
+	}
+
+	/* XXX not yet implemented */
+	if (tcpinfo->option || (tcpinfo->invflags & XT_TCP_INV_OPTION))
+		return 0;
+
+	if (tcpinfo->flg_mask || (tcpinfo->invflags & XT_TCP_INV_FLAGS)) {
+		xt_buf_add(buf, "tcp flags & ");
+		print_tcp_xlate(buf, tcpinfo->flg_mask);
+		xt_buf_add(buf, " %s ",
+			   tcpinfo->invflags & XT_TCP_INV_FLAGS ? "!= ": "==");
+		print_tcp_xlate(buf, tcpinfo->flg_cmp);
+		xt_buf_add(buf, " ");
+	}
+
+	return 1;
+}
+
 static struct xtables_match tcp_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "tcp",
@@ -374,6 +453,7 @@ static struct xtables_match tcp_match = {
 	.print		= tcp_print,
 	.save		= tcp_save,
 	.extra_opts	= tcp_opts,
+	.xlate		= tcp_xlate,
 };
 
 void
-- 
1.7.10.4

