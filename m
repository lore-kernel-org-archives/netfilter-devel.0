From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] extensions: libxt_cgroup: Add translation to nft
Date: Thu, 9 Jun 2016 21:54:22 +0200
Message-ID: <20160609195419.GA1677@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36184 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbcFITy0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2016 15:54:26 -0400
Received: by mail-wm0-f66.google.com with SMTP id m124so13136410wme.3
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2016 12:54:26 -0700 (PDT)
Received: from sonyv (cli-5b7e49a2.wholesale.adamo.es. [91.126.73.162])
        by smtp.gmail.com with ESMTPSA id f73sm225245wmg.1.2016.06.09.12.54.24
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 09 Jun 2016 12:54:24 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for cgroup to nft. Path parameter not supported in nft
yet.

Examples:

$ sudo iptables-translate -t filter -A INPUT -m cgroup --cgroup 0 -j ACCEPT
nft add rule ip filter INPUT meta cgroup 0 counter accept

$ sudo iptables-translate -t filter -A INPUT -m cgroup ! --cgroup 0 -j ACCEPT
nft add rule ip filter INPUT meta cgroup != 0 counter accept

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 extensions/libxt_cgroup.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/extensions/libxt_cgroup.c b/extensions/libxt_cgroup.c
index 3be42ad..1191815 100644
--- a/extensions/libxt_cgroup.c
+++ b/extensions/libxt_cgroup.c
@@ -121,6 +121,32 @@ static void cgroup_save_v1(const void *ip, const struct xt_entry_match *match)
 		       info->classid);
 }
 
+static int cgroup_xlate_v0(const void *ip, const struct xt_entry_match *match,
+			   struct xt_xlate *xl, int numeric)
+{
+	const struct xt_cgroup_info_v0 *info = (void *)match->data;
+
+	xt_xlate_add(xl, "meta cgroup %s%u ", info->invert ? "!= " : "",
+		     info->id);
+	return 1;
+}
+
+static int cgroup_xlate_v1(const void *ip, const struct xt_entry_match *match,
+			   struct xt_xlate *xl, int numeric)
+{
+	const struct xt_cgroup_info_v1 *info = (void *)match->data;
+
+	if (info->has_path)
+		return 0;
+
+	if (info->has_classid)
+		xt_xlate_add(xl, "meta cgroup %s%u ",
+			     info->invert_classid ? "!= " : "",
+			     info->classid);
+
+	return 1;
+}
+
 static struct xtables_match cgroup_match[] = {
 	{
 		.family		= NFPROTO_UNSPEC,
@@ -134,6 +160,7 @@ static struct xtables_match cgroup_match[] = {
 		.save		= cgroup_save_v0,
 		.x6_parse	= cgroup_parse_v0,
 		.x6_options	= cgroup_opts_v0,
+		.xlate		= cgroup_xlate_v0,
 	},
 	{
 		.family		= NFPROTO_UNSPEC,
@@ -147,6 +174,7 @@ static struct xtables_match cgroup_match[] = {
 		.save		= cgroup_save_v1,
 		.x6_parse	= cgroup_parse_v1,
 		.x6_options	= cgroup_opts_v1,
+		.xlate		= cgroup_xlate_v1,
 	},
 };
 
-- 
2.7.0

