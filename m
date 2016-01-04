From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH 2/2] extensions: libipt_ttl: Add translation to nft
Date: Mon, 4 Jan 2016 22:50:06 +0530
Message-ID: <4ee7213d044e0f088542553d2e14f0b19950a5e0.1451927507.git.shivanib134@gmail.com>
References: <cover.1451927507.git.shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35572 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbcADRUN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 12:20:13 -0500
Received: by mail-pa0-f66.google.com with SMTP id gi1so22669738pac.2
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2016 09:20:12 -0800 (PST)
Received: from gmail.com ([106.201.42.190])
        by smtp.gmail.com with ESMTPSA id m3sm93828688pfi.87.2016.01.04.09.20.10
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 04 Jan 2016 09:20:11 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <cover.1451927507.git.shivanib134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for module ttl to nftables.

Examples:

$ sudo iptables-translate -A INPUT -m ttl --ttl-eq 3 -j ACCEPT
nft add rule ip filter INPUT ip ttl 3 counter accept

$ sudo iptables-translate -A INPUT -m ttl --ttl-gt 5 -j ACCEPT
nft add rule ip filter INPUT ip ttl \> 5 counter accept

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libipt_ttl.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 5fe08cc..5df014b 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -100,6 +100,33 @@ static void ttl_save(const void *ip, const struct xt_entry_match *match)
 	printf(" %u", info->ttl);
 }
 
+static int ttl_xlate(const struct xt_entry_match *match,
+		     struct xt_buf *buf, int numeric)
+{
+	const struct ipt_ttl_info *info =
+			(struct ipt_ttl_info *) match->data;
+
+		switch (info->mode) {
+		case IPT_TTL_EQ:
+			xt_buf_add(buf, "%u ", info->ttl);
+			break;
+		case IPT_TTL_NE:
+			xt_buf_add(buf, "!= %u ", info->ttl);
+			break;
+		case IPT_TTL_LT:
+			xt_buf_add(buf, "\\< %u ", info->ttl);
+			break;
+		case IPT_TTL_GT:
+			xt_buf_add(buf, "\\> %u ", info->ttl);
+			break;
+		default:
+			/* error */
+			break;
+	}
+
+	return 1;
+}
+
 #define s struct ipt_ttl_info
 static const struct xt_option_entry ttl_opts[] = {
 	{.name = "ttl-lt", .id = O_TTL_LT, .excl = F_ANY, .type = XTTYPE_UINT8,
@@ -126,6 +153,7 @@ static struct xtables_match ttl_mt_reg = {
 	.x6_parse	= ttl_parse,
 	.x6_fcheck	= ttl_check,
 	.x6_options	= ttl_opts,
+	.xlate		= ttl_xlate,
 };
 
 
-- 
1.9.1

