From: Felix Janda <felix.janda@posteo.de>
Subject: [ebtables PATCH 1/2] extensions: Use stdint types
Date: Sat, 16 May 2015 12:22:39 +0200
Message-ID: <20150516102239.GI14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:32975 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbbEPKXJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 06:23:09 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 4C68925AF534
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 12:23:08 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpjNr14tLz5vN2
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 12:23:08 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 extensions/ebt_ip6.c   |  4 ++--
 extensions/ebt_limit.c | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/extensions/ebt_ip6.c b/extensions/ebt_ip6.c
index e3e0956..dd48547 100644
--- a/extensions/ebt_ip6.c
+++ b/extensions/ebt_ip6.c
@@ -53,8 +53,8 @@ static const struct option opts[] =
 
 struct icmpv6_names {
 	const char *name;
-	u_int8_t type;
-	u_int8_t code_min, code_max;
+	uint8_t type;
+	uint8_t code_min, code_max;
 };
 
 static const struct icmpv6_names icmpv6_codes[] = {
diff --git a/extensions/ebt_limit.c b/extensions/ebt_limit.c
index ee40e5c..d189a09 100644
--- a/extensions/ebt_limit.c
+++ b/extensions/ebt_limit.c
@@ -59,11 +59,11 @@ static void print_help(void)
 "                                default %u\n", EBT_LIMIT_BURST);
 }
 
-static int parse_rate(const char *rate, u_int32_t *val)
+static int parse_rate(const char *rate, uint32_t *val)
 {
 	const char *delim;
-	u_int32_t r;
-	u_int32_t mult = 1;  /* Seconds by default. */
+	uint32_t r;
+	uint32_t mult = 1;  /* Seconds by default. */
 
 	delim = strchr(rate, '/');
 	if (delim) {
@@ -151,7 +151,7 @@ static void final_check(const struct ebt_u_entry *entry,
 struct rates
 {
 	const char *name;
-	u_int32_t mult;
+	uint32_t mult;
 };
 
 static struct rates g_rates[] =
@@ -162,7 +162,7 @@ static struct rates g_rates[] =
 	{ "sec", EBT_LIMIT_SCALE }
 };
 
-static void print_rate(u_int32_t period)
+static void print_rate(uint32_t period)
 {
 	unsigned int i;
 
-- 
2.3.6
