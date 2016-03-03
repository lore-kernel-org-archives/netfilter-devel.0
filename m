From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v3] extensions: libxt_dccp: Add translation to nft
Date: Fri, 4 Mar 2016 03:31:45 +0530
Message-ID: <20160303220145.GA6872@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32781 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbcCCWBw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Mar 2016 17:01:52 -0500
Received: by mail-pf0-f194.google.com with SMTP id 63so2045283pfe.0
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Mar 2016 14:01:52 -0800 (PST)
Received: from gmail.com ([223.176.176.65])
        by smtp.gmail.com with ESMTPSA id 81sm414937pfa.12.2016.03.03.14.01.49
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 03 Mar 2016 14:01:50 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for dccp to nftables.

Full translation of this match awaits the support for --dccp-option.

Examples:

$ sudo iptables-translate -A INPUT -p dccp -m dccp --sport 100
nft add rule ip filter INPUT dccp sport 100 counter

$ sudo iptables-translate -A INPUT -p dccp -m dccp --dport 100:200
nft add rule ip filter INPUT dccp dport 100-200 counter

$ sudo iptables-translate -A INPUT -p dccp -m dccp ! --dport 100
nft add rule ip filter INPUT dccp dport != 100 counter

$ sudo iptables-translate -A INPUT -p dccp -m dccp --dport 100 --dccp-types REQUEST,RESPONSE,DATA,ACK,DATAACK,CLOSEREQ,CLOSE,SYNC,SYNCACK
nft add rule ip filter INPUT dccp dport 100 dccp type {request, response, data, ack, dataack, closereq, close, sync, syncack} counter

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v3:
	Return 0 if translation for dccp-option is demanded

Changes in v2:
        Fix bugs and remove invalid dccp type

Following is not added in commit message as it is not translation code
issue:
* Since inversion of set is not possible in nftables, using dccp
with rules like
...dccp type != {request, response}..
* dccp type reset
is going to throw errors.

 extensions/libxt_dccp.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index a35cabb..0d4f369 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -277,6 +277,97 @@ static void dccp_save(const void *ip, const struct xt_entry_match *match)
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
+};
+
+static int dccp_type_xlate(const struct xt_dccp_info *einfo,
+			   struct xt_xlate *xl)
+{
+	bool have_type = false, set_need = false;
+	uint16_t types = einfo->typemask;
+
+	if (types & (1 << DCCP_PKT_INVALID))
+		return 0;
+
+	xt_xlate_add(xl, "dccp type%s ", einfo->invflags ? " !=" : "");
+
+	if ((types != 0) && !(types == (types & -types))) {
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
+		xt_xlate_add(xl, "%s", dccp_pkt_types_xlate[i]);
+
+		types &= ~(1 << i);
+	}
+
+	if (set_need)
+		xt_xlate_add(xl, "}");
+
+	xt_xlate_add(xl, " ");
+
+	return 1;
+}
+
+static int dccp_xlate(const struct xt_entry_match *match,
+		      struct xt_xlate *xl, int numeric)
+{
+	const struct xt_dccp_info *einfo =
+			(const struct xt_dccp_info *)match->data;
+	int ret = 1;
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
+	if (einfo->flags & XT_DCCP_TYPE)
+		ret = dccp_type_xlate(einfo, xl);
+
+	if (einfo->flags & XT_DCCP_OPTION)
+		ret = 0;
+
+	return ret;
+}
 static struct xtables_match dccp_match = {
 	.name		= "dccp",
 	.family		= NFPROTO_UNSPEC,
@@ -288,6 +379,7 @@ static struct xtables_match dccp_match = {
 	.save		= dccp_save,
 	.x6_parse	= dccp_parse,
 	.x6_options	= dccp_opts,
+	.xlate		= dccp_xlate,
 };
 
 void _init(void)
-- 
1.9.1

