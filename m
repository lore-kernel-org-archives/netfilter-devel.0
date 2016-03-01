From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_dccp: Add translation to nft
Date: Tue, 1 Mar 2016 18:41:33 +0530
Message-ID: <20160301131133.GA9134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34451 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbcCANLl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 08:11:41 -0500
Received: by mail-pa0-f42.google.com with SMTP id fy10so111859219pac.1
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Mar 2016 05:11:41 -0800 (PST)
Received: from gmail.com ([223.183.15.73])
        by smtp.gmail.com with ESMTPSA id ac1sm45713764pad.41.2016.03.01.05.11.38
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 01 Mar 2016 05:11:39 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for dccp to nftables.

Full translation of this match awaits the support for --dccp-option.
Also, since inversion of set is not possible in nftables, using dccp
with rules like
...dccp type != {request, response}..
is going to throw errors.

Examples:

$ sudo iptables-translate -A INPUT -p dccp -m dccp --sport 100
nft add rule ip filter INPUT dccp sport 100 counter

$ sudo iptables-translate -A INPUT -p dccp -m dccp --dport 100:200
nft add rule ip filter INPUT dccp dport 100-200 counter

$ sudo iptables-translate -A INPUT -p dccp -m dccp ! --dport 100
nft add rule ip filter INPUT dccp dport != 100 counter

$ sudo iptables-translate -A INPUT -p dccp -m dccp --dccp-type REQUEST,RESPONSE
nft add rule ip filter INPUT dccp type {request, response} counter

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_dccp.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index a35cabb..27dd625 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -277,6 +277,93 @@ static void dccp_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
+static const char *const dccp_pkt_types_xlate[] = {
+	[DCCP_PKT_REQUEST]      = "request",
+	[DCCP_PKT_RESPONSE]     = "response",
+	[DCCP_PKT_DATA]         = "data",
+	[DCCP_PKT_ACK]          = "ack",
+	[DCCP_PKT_DATAACK]      = "dataack",
+	[DCCP_PKT_CLOSEREQ]     = "closereq",
+	[DCCP_PKT_CLOSE]        = "close",
+	[DCCP_PKT_RESET]        = "reset",
+	[DCCP_PKT_SYNC]         = "sync",
+	[DCCP_PKT_SYNCACK]      = "syncack",
+	[DCCP_PKT_INVALID]      = "invalid",
+};
+
+static void
+print_types_xlate(uint16_t types, struct xt_xlate *xl, int numeric)
+{
+	bool have_type = false, set_need = false;
+
+	if (types > 1) {
+		xt_xlate_add(xl, "{");
+		set_need = true;
+	}
+
+	while (types) {
+		unsigned int i;
+
+		for (i = 0; !(types & (1 << i)); i++);
+
+		if (have_type)
+			xt_xlate_add(xl, ", ");
+		else
+			have_type = true;
+
+		if (numeric)
+			xt_xlate_add(xl, "%u", i);
+		else
+			xt_xlate_add(xl, "%s", dccp_pkt_types_xlate[i]);
+
+		types &= ~(1 << i);
+	}
+
+	if (set_need)
+		xt_xlate_add(xl, "}");
+
+	xt_xlate_add(xl, " ");
+}
+
+static int dccp_xlate(const struct xt_entry_match *match,
+		      struct xt_xlate *xl, int numeric)
+{
+	const struct xt_dccp_info *einfo =
+		(const struct xt_dccp_info *)match->data;
+
+	xt_xlate_add(xl, "dccp ");
+
+	if (einfo->flags & XT_DCCP_SRC_PORTS) {
+		if (einfo->spts[0] != einfo->spts[1])
+			xt_xlate_add(xl, "sport%s %u-%u ",
+				     einfo->invflags & XT_DCCP_SRC_PORTS ? " !=" : "",
+				     einfo->spts[0], einfo->spts[1]);
+		else
+			xt_xlate_add(xl, "sport%s %u ",
+				     einfo->invflags & XT_DCCP_SRC_PORTS ? " !=" : "",
+				     einfo->spts[0]);
+	}
+
+	if (einfo->flags & XT_DCCP_DEST_PORTS) {
+		if (einfo->dpts[0] != einfo->dpts[1])
+			xt_xlate_add(xl, "dport%s %u-%u ",
+				     einfo->invflags & XT_DCCP_DEST_PORTS ? " !=" : "",
+				     einfo->dpts[0], einfo->dpts[1]);
+		else
+			xt_xlate_add(xl, "dport%s %u ",
+				     einfo->invflags & XT_DCCP_DEST_PORTS ? " !=" : "",
+				     einfo->dpts[0]);
+	}
+
+	if (einfo->flags & XT_DCCP_TYPE) {
+		xt_xlate_add(xl, "type%s ",
+			     einfo->invflags & XT_DCCP_TYPE ? " !=" : "");
+		print_types_xlate(einfo->typemask, xl, 0);
+	}
+
+	return 1;
+}
+
 static struct xtables_match dccp_match = {
 	.name		= "dccp",
 	.family		= NFPROTO_UNSPEC,
@@ -288,6 +375,7 @@ static struct xtables_match dccp_match = {
 	.save		= dccp_save,
 	.x6_parse	= dccp_parse,
 	.x6_options	= dccp_opts,
+	.xlate		= dccp_xlate,
 };
 
 void _init(void)
-- 
1.9.1

