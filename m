From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_cpu: Add translation to nft
Date: Wed, 23 Dec 2015 22:11:58 +0530
Message-ID: <20151223164158.GA19616@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36053 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbbLWQmG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 11:42:06 -0500
Received: by mail-pa0-f48.google.com with SMTP id q3so114727912pav.3
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 08:42:05 -0800 (PST)
Received: from gmail.com ([106.212.16.211])
        by smtp.gmail.com with ESMTPSA id zu6sm36578648pac.8.2015.12.23.08.42.02
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 23 Dec 2015 08:42:03 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for module cpu to nftables.

Examples:

$ sudo iptables-translate -A INPUT -p tcp --dport 80 -m cpu --cpu 0 -j ACCEPT
nft add rule ip filter INPUT tcp dport 80 cpu 0 counter accept

$ sudo iptables-translate -A INPUT -p tcp --dport 80 -m cpu ! --cpu 1 -j ACCEPT
nft add rule ip filter INPUT tcp dport 80 cpu != 1 counter accept

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_cpu.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_cpu.c b/extensions/libxt_cpu.c
index 404a6a6..74e6077 100644
--- a/extensions/libxt_cpu.c
+++ b/extensions/libxt_cpu.c
@@ -44,9 +44,19 @@ static void cpu_save(const void *ip, const struct xt_entry_match *match)
 	printf("%s --cpu %u", info->invert ? " !" : "", info->cpu);
 }
 
+static int cpu_xlate(const struct xt_entry_match *match,
+		     struct xt_buf *buf, int numeric)
+{
+	const struct xt_cpu_info *info = (void *)match->data;
+
+	xt_buf_add(buf, "cpu%s %u ", info->invert ? " !=" : "", info->cpu);
+
+	return 1;
+}
+
 static struct xtables_match cpu_match = {
 	.family		= NFPROTO_UNSPEC,
- 	.name		= "cpu",
+	.name		= "cpu",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_cpu_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_cpu_info)),
@@ -55,6 +65,7 @@ static struct xtables_match cpu_match = {
 	.save		= cpu_save,
 	.x6_parse	= cpu_parse,
 	.x6_options	= cpu_opts,
+	.xlate		= cpu_xlate,
 };
 
 void _init(void)
-- 
1.9.1

