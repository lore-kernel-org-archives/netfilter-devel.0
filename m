From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] extensions: libxt_sctp: Add translation to nft
Date: Thu, 3 Mar 2016 00:58:48 +0530
Message-ID: <20160302192848.GA683@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:36754 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbcCBT2z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 14:28:55 -0500
Received: by mail-pa0-f68.google.com with SMTP id a7so11360348pax.3
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Mar 2016 11:28:55 -0800 (PST)
Received: from gmail.com ([223.176.182.21])
        by smtp.gmail.com with ESMTPSA id 83sm35159876pfr.22.2016.03.02.11.28.52
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 02 Mar 2016 11:28:53 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for sctp to nftables.
Full translation of this match awaits the support for --chunk-types
option.

Examples:

$ sudo iptables-translate -A INPUT -p sctp --dport 80 -j DROP
nft add rule ip filter INPUT sctp dport 80 counter drop

$ sudo iptables-translate -A INPUT -p sctp ! --sport 80:100 -j ACCEPT
nft add rule ip filter INPUT sctp sport != 80-100 counter accept

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v2:
	Add code to check if flags is set

 extensions/libxt_sctp.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 56a4cdf..3b0b048 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -485,6 +485,42 @@ static void sctp_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
+static int sctp_xlate(const struct xt_entry_match *match,
+		      struct xt_xlate *xl, int numeric)
+{
+	const struct xt_sctp_info *einfo =
+		(const struct xt_sctp_info *)match->data;
+
+	if (!einfo->flags)
+		return 0;
+
+	xt_xlate_add(xl, "sctp ");
+
+	if (einfo->flags & XT_SCTP_SRC_PORTS) {
+		if (einfo->spts[0] != einfo->spts[1])
+			xt_xlate_add(xl, "sport%s %u-%u ",
+				     einfo->invflags & XT_SCTP_SRC_PORTS ? " !=" : "",
+				     einfo->spts[0], einfo->spts[1]);
+		else
+			xt_xlate_add(xl, "sport%s %u ",
+				     einfo->invflags & XT_SCTP_SRC_PORTS ? " !=" : "",
+				     einfo->spts[0]);
+	}
+
+	if (einfo->flags & XT_SCTP_DEST_PORTS) {
+		if (einfo->dpts[0] != einfo->dpts[1])
+			xt_xlate_add(xl, "dport%s %u-%u ",
+				     einfo->invflags & XT_SCTP_DEST_PORTS ? " !=" : "",
+				     einfo->dpts[0], einfo->dpts[1]);
+		else
+			xt_xlate_add(xl, "dport%s %u ",
+				     einfo->invflags & XT_SCTP_DEST_PORTS ? " !=" : "",
+				     einfo->dpts[0]);
+	}
+
+	return 1;
+}
+
 static struct xtables_match sctp_match = {
 	.name		= "sctp",
 	.family		= NFPROTO_UNSPEC,
@@ -497,6 +533,7 @@ static struct xtables_match sctp_match = {
 	.print		= sctp_print,
 	.save		= sctp_save,
 	.extra_opts	= sctp_opts,
+	.xlate		= sctp_xlate,
 };
 
 void _init(void)
-- 
1.9.1

