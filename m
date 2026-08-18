Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD1947255F
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 12:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787056082; cv=none; b=gnRKwSMW7zhF3/Tu1nSgbwvcugx6vQqDUF5Pa0oD9ojMQCMZwe3Cg0Qob9tnCxbAMkR8ceOgQRydGpABEL0rsEZBrssFA6IiZyYH0k+m0CUADx2RvwS0tSXYRf2IUix+VFGWxMEVQPluEipZn9AHlQrK0bUSYZGdRMOaYGaa+34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787056082; c=relaxed/simple;
	bh=lMEVuVVRGnJvmwxOsVy0qzVkO8ZealLF2uSDM4Oy474=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcCaIyqZcdISlaSA/X0XA+deRIoKEy9DZsF083vo06/zlyv9WiMjdIRmkjflXRLsiQV409M2k2Ycu5KJJATNGvQSYp0QFNsFgipRMjLX5RnFj4r+VfZ6QVLPb5MHlWclex+os+8aOn6NIvjNIvN7zt+ITS/5jUIVM4V3Ywc1cPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gn35Tim+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gn35Tim+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787056076;
	bh=62KGDNgtF1YQzYYG5nkFS7vrOTzzxEcdG8QblpAZgqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gn35Tim+2WJnCrlFw8y7SqIA/781ghvaE/sV7dPh3j2mMGrF+KAVnTfyk4YSgBCLF
	 baAfHRBNHwcVsnobmqSnJGMdjIuCyywuc52KBfoQgyZmUI85M53awM78jODU0YuWxD
	 64ka8LbeaolQ7ZEo1ni6336srAqsTEEo3yEORwjnLdA6sBpg6PacRsCkSKvPVoxlHn
	 hrEw1pOKCj869KuzNa+UaGQ7vJ4GYOBwqD3GvUjn+tzfTH7Hmtz1bcxcU6JeilZui8
	 iHs7I8cXI2tUjtjsZZwcMYCrR2ZNkWJApio27cQPwcTkXg7goAhOynex1/O5T8/gSc
	 w4eP39bd6y13A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7570160058;
	Tue, 18 Aug 2026 14:27:56 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	fmancera@suse.de
Subject: [PATCH nf-next 3/4] netfilter: x_tables: do not print specified table
Date: Tue, 18 Aug 2026 14:27:40 +0200
Message-ID: <20260818122741.1329660-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260818122741.1329660-1-pablo@netfilter.org>
References: <20260818122741.1329660-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is defensive, possibly this string has been already been sanitized
but simply print that this match/target extension can only be used for a
given table.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_rpfilter.c  | 3 +--
 net/ipv6/netfilter/ip6t_rpfilter.c | 2 +-
 net/netfilter/xt_CONNSECMARK.c     | 3 +--
 net/netfilter/xt_SECMARK.c         | 3 +--
 4 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 6d9bf5106868..2c38fd6624aa 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -95,8 +95,7 @@ static int rpfilter_check(const struct xt_mtchk_param *par)
 
 	if (strcmp(par->table, "mangle") != 0 &&
 	    strcmp(par->table, "raw") != 0) {
-		pr_info_ratelimited("only valid in \'raw\' or \'mangle\' table, not \'%s\'\n",
-				    par->table);
+		pr_info_ratelimited("only valid in \'raw\' or \'mangle\' table\n");
 		return -EINVAL;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index 67c87a88cde4..af8d10d49de8 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -118,7 +118,7 @@ static int rpfilter_check(const struct xt_mtchk_param *par)
 
 	if (strcmp(par->table, "mangle") != 0 &&
 	    strcmp(par->table, "raw") != 0) {
-		pr_info_ratelimited("only valid in \'raw\' or \'mangle\' table, not \'%s\'\n",
+		pr_info_ratelimited("only valid in \'raw\' or \'mangle\' table\n",
 				    par->table);
 		return -EINVAL;
 	}
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 1494b3ee30e1..4e4436a9104b 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -87,8 +87,7 @@ static int connsecmark_tg_check(const struct xt_tgchk_param *par)
 
 	if (strcmp(par->table, "mangle") != 0 &&
 	    strcmp(par->table, "security") != 0) {
-		pr_info_ratelimited("only valid in \'mangle\' or \'security\' table, not \'%s\'\n",
-				    par->table);
+		pr_info_ratelimited("only valid in \'mangle\' or \'security\' table\n");
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 5bc5ea505eb9..38e8e410b4e8 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -79,8 +79,7 @@ secmark_tg_check(const char *table, struct xt_secmark_target_info_v1 *info)
 
 	if (strcmp(table, "mangle") != 0 &&
 	    strcmp(table, "security") != 0) {
-		pr_info_ratelimited("only valid in \'mangle\' or \'security\' table, not \'%s\'\n",
-				    table);
+		pr_info_ratelimited("only valid in \'mangle\' or \'security\' table\n");
 		return -EINVAL;
 	}
 
-- 
2.47.3

