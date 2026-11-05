Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882752;
	b=Ie1bvQv2jF9/nbjv+pJOUKK62Qq5+QQ5dLSXJkfQj5z/2/wsZvAX5214U5NVV84NcBJZ
	 Z9Do0V31GVXOU8s0FgSUPd7boFfKhfQsW3kLvWhKnDASh7iIovZBfjr1XVZidQv0XY74U
	 hPLiRRrDkgrs4mnWE9dXfJws6c9GeVnvITzHxIJT2IaDzkXFilbM5feehvzlQVA0zMm9o
	 Bq3Un3FFOqdNgQWMrpVpMCpy7+yLJs4GPQZjSPUSBNYR8cb8jP2NZ7pPWbdGNi5n+FcNx
	 b9/JoUzjeWwrDdMRfiR1X22im7HII1LFYXiTDSPh2u/RsnYkGnnhBxFBq59GxtTzmgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882752;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=XClvt/H6YMd9+Exyu1R4Oy60MLFqQ2fw95DTYxl2feU=;
	b=gxjIr2UvUK7NE6r9wprvUg13eSP538VP3cgbjZasXpLW+BZWcYaLsl862ZMUMdYhciZE
	 p+n5DXHvPQiYqJPLeWLGW61POvhqAf4f+YVxlrbo9/1Ci181zNNHEEeSXX0SqcqH1MqpM
	 TRlZh5k5ZU165lrQAwX2YzFhvnuKLYvUMJSNqx9jA18Glp6C1EI4YGUUXSGliUcRj8V0M
	 RMVpw8lCO3XAGUiZe9dpQnYHU3Idqm2NrUFsok2c1v3fDGY0asvxevXYakAWXiQp+KR/4
	 CB8aLN7a1+U5xksfjH58xjIwBPNJq6iY94HM48lEgMIlsfahviZOvzYDPg7KtJ/ug5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=K+4jFZdi;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024C8606EE85;
	Thu,  5 Nov 2026 12:45:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 024C8606EE85
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=K+4jFZdi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793882750;
	bh=XClvt/H6YMd9+Exyu1R4Oy60MLFqQ2fw95DTYxl2feU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+4jFZdiO/6ai0708Xowj/K9p2ok61UKX5g7P13Y3ISXAOm+2a4WjqlB0uh4JjLx0
	 KCr3LL9lyv+lB4E6rfprjQmD5eVUg53JxTlMst7yO0NkBPhiNFT1gVB1xVUd8efzpW
	 OwccK7Dvf+Y7XEjrYdgBheUDYpt+79FAVetyZJoAJO2e2fDtE8rSiLx8T6fIi6AsOL
	 nTT2g/LRmO/Jgu5pwL3OHRypAmnbm+JmfLZGjj2Y9AXn8Eakl/CScplTnU8cSfunX5
	 KHPZLrnGCCp4PmURqeRpQ6fTq6pNIieuna9LZ9PWGOCE7OA2EwcqJzl9MJfH3MfFZD
	 4bVG8JykZOmfA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 25D5560096;
	Thu,  5 Nov 2026 13:45:50 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 08/12] netfilter: x_tables: check target name before accessing verdict
Date: Thu,  5 Nov 2026 13:45:32 +0100
Message-ID: <20261105124536.1009301-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105124536.1009301-1-pablo@netfilter.org>
References: <20261105124536.1009301-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Non-standard targets may contain only struct xt_entry_target.
mark_source_chains() nevertheless reads the target as an
xt_standard_target before checking its name, potentially reading four
bytes beyond a header-only target.

Check that the target is standard before reading its verdict.
Non-standard targets remain handled as fallthrough rules.

See the following KASAN trace:

BUG: KASAN: slab-out-of-bounds in translate_table+0x1660/0x1a40 [ip6_tables]
Read of size 4 at addr ffff88800ed56ff8 by task rep/432

Call Trace:
 kasan_report+0xfa/0x120
 translate_table+0x1660/0x1a40 [ip6_tables]
 do_ip6t_set_ctl+0x667/0xa76 [ip6_tables]
 nf_setsockopt+0x77/0xd0
 do_sock_setsockopt+0x118/0x490
 __sys_setsockopt+0xe4/0x160
 __x64_sys_setsockopt+0xbd/0x190
 do_syscall_64+0xde/0x4f0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Allocated by task 432:
 kasan_save_stack+0x2f/0x50
 __kasan_kmalloc+0x7f/0x90
 __kvmalloc_node_noprof+0x1b1/0x5c0
 xt_alloc_table_info+0x3c/0xa0
 do_ip6t_set_ctl+0x5ee/0xa76 [ip6_tables]
 nf_setsockopt+0x77/0xd0
 do_sock_setsockopt+0x118/0x490
 __sys_setsockopt+0xe4/0x160
 __x64_sys_setsockopt+0xbd/0x190
 do_syscall_64+0xde/0x4f0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arp_tables.c | 5 +++--
 net/ipv4/netfilter/ip_tables.c  | 5 +++--
 net/ipv6/netfilter/ip6_tables.c | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index cf747e1e17a3..7ff3d1f0ffd4 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -371,11 +371,12 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
-				int newpos = t->verdict;
+				int newpos;
 
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
-				    newpos >= 0) {
+				    t->verdict >= 0) {
+					newpos = t->verdict;
 					/* This a jump; chase it. */
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 809441cedced..b302bd77180a 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -422,11 +422,12 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
-				int newpos = t->verdict;
+				int newpos;
 
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
-				    newpos >= 0) {
+				    t->verdict >= 0) {
+					newpos = t->verdict;
 					/* This a jump; chase it. */
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 313c4aac377a..010baaa60665 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -440,11 +440,12 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
-				int newpos = t->verdict;
+				int newpos;
 
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
-				    newpos >= 0) {
+				    t->verdict >= 0) {
+					newpos = t->verdict;
 					/* This a jump; chase it. */
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
-- 
2.47.3

