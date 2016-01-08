From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_cgroup: Add translation to nft
Date: Sat, 9 Jan 2016 01:23:13 +0530
Message-ID: <20160108195313.GA2507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34483 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbcAHTxU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 14:53:20 -0500
Received: by mail-pf0-f176.google.com with SMTP id q63so14317330pfb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Jan 2016 11:53:20 -0800 (PST)
Received: from gmail.com ([171.50.114.192])
        by smtp.gmail.com with ESMTPSA id q8sm167194019pap.45.2016.01.08.11.53.17
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 08 Jan 2016 11:53:18 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for the network classifier cgroup to nftables.

Examples:

$ sudo iptables-translate -A input -m cgroup --cgroup 0x100001 -j DROP
nft add rule ip filter input meta cgroup 1048577 counter drop

$ sudo iptables-translate -A input -m cgroup ! --cgroup 0x100001 -j DROP
nft add rule ip filter input meta cgroup != 1048577 counter drop

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_cgroup.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/extensions/libxt_cgroup.c b/extensions/libxt_cgroup.c
index e304e33..dea1417 100644
--- a/extensions/libxt_cgroup.c
+++ b/extensions/libxt_cgroup.c
@@ -48,6 +48,17 @@ static void cgroup_save(const void *ip, const struct xt_entry_match *match)
 	printf("%s --cgroup %u", info->invert ? " !" : "", info->id);
 }
 
+static int cgroup_xlate(const struct xt_entry_match *match,
+			struct xt_buf *buf, int numeric)
+{
+	const struct xt_cgroup_info *info = (void *) match->data;
+
+	xt_buf_add(buf, "meta cgroup%s %u ",
+		   info->invert ? " !=" : "", info->id);
+
+	return 1;
+}
+
 static struct xtables_match cgroup_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "cgroup",
@@ -59,6 +70,7 @@ static struct xtables_match cgroup_match = {
 	.save		= cgroup_save,
 	.x6_parse	= cgroup_parse,
 	.x6_options	= cgroup_opts,
+	.xlate		= cgroup_xlate,
 };
 
 void _init(void)
-- 
1.9.1

