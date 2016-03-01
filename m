From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_sctp: Add translation to nft
Date: Wed, 2 Mar 2016 02:10:56 +0530
Message-ID: <20160301204056.GA18229@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34220 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbcCAUlE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 15:41:04 -0500
Received: by mail-pf0-f181.google.com with SMTP id 4so40839619pfd.1
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Mar 2016 12:41:03 -0800 (PST)
Received: from gmail.com ([223.183.15.73])
        by smtp.gmail.com with ESMTPSA id ko9sm47628499pab.37.2016.03.01.12.41.00
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 01 Mar 2016 12:41:01 -0800 (PST)
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
 extensions/libxt_sctp.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 56a4cdf..626e873 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -485,6 +485,39 @@ static void sctp_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
+static int sctp_xlate(const struct xt_entry_match *match,
+		      struct xt_xlate *xl, int numeric)
+{
+	const struct xt_sctp_info *einfo =
+		(const struct xt_sctp_info *)match->data;
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
@@ -497,6 +530,7 @@ static struct xtables_match sctp_match = {
 	.print		= sctp_print,
 	.save		= sctp_save,
 	.extra_opts	= sctp_opts,
+	.xlate		= sctp_xlate,
 };
 
 void _init(void)
-- 
1.9.1

