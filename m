Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A2483CA7
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 14:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709820693; cv=none; b=o/x0rq6wAwP4nOn+Rr+5JK3AEudAF73WCxVk56suIiloR8X0HNv+Ddn9tBWlt9ZqZs5RPqIyjcplnAjM5+sikyL8j7f0HXp7v2ixkCHHh2fketDsBKc8fjjvreO55yIqKXFM/iXk2ig5CEffxWjTuU0I7Gf+NQOLgaUaixeRPVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709820693; c=relaxed/simple;
	bh=lk5ocZG1OuvH33+ab5D4IFNzdGo2UJg1oU4we3bHedE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DFsAlDtKfRaLVFJWQAa7bjcf+FpkBBfG2aANMLYK2YjBWcLggmowXh1moh1bs4dVqj/DFsXExQvEU87uHtW8LXMxEolhwDYXcfkju9oQPM01Dd/GlkNpy1Is9utQXw9BmPq9YT86EltYgu0zkAhOLaNOiZyorvMNXxrS21tNlQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1riET3-0007mK-VS; Thu, 07 Mar 2024 15:11:29 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH xtables] extensions: xt_TPROXY: add txlate support
Date: Thu,  7 Mar 2024 15:05:28 +0100
Message-ID: <20240307140531.9822-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_TPROXY.c      | 59 ++++++++++++++++++++++++++++++++++
 extensions/libxt_TPROXY.txlate | 17 ++++++++++
 2 files changed, 76 insertions(+)
 create mode 100644 extensions/libxt_TPROXY.txlate

diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index d13ec85f92d0..4d2d7961ca2c 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -147,6 +147,62 @@ static void tproxy_tg1_parse(struct xt_option_call *cb)
 	}
 }
 
+static int tproxy_tg_xlate(struct xt_xlate *xl,
+			   const struct xt_tproxy_target_info_v1 *info)
+{
+	int family = xt_xlate_get_family(xl);
+	uint32_t mask = info->mark_mask;
+	bool port_mandatory = false;
+	char buf[INET6_ADDRSTRLEN];
+
+	xt_xlate_add(xl, "tproxy to");
+
+	inet_ntop(family, &info->laddr, buf, sizeof(buf));
+
+	if (family == AF_INET6 && !IN6_IS_ADDR_UNSPECIFIED(&info->laddr.in6))
+		xt_xlate_add(xl, "[%s]", buf);
+	else if (family == AF_INET && info->laddr.ip)
+		xt_xlate_add(xl, "%s", buf);
+	else
+		port_mandatory = true;
+
+	if (port_mandatory)
+		xt_xlate_add(xl, " :%d", ntohs(info->lport));
+	else if (info->lport)
+		xt_xlate_add(xl, ":%d", ntohs(info->lport));
+
+	/* xt_TPROXY.c does: skb->mark = (skb->mark & ~mark_mask) ^ mark_value */
+	if (mask == 0xffffffff)
+		xt_xlate_add(xl, "meta mark set 0x%x", info->mark_value);
+	else if (mask || info->mark_value)
+		xt_xlate_add(xl, "meta mark set meta mark & 0x%x or 0x%x",
+			     ~mask, info->mark_value);
+
+	return 1;
+}
+
+static int tproxy_tg_xlate_v1(struct xt_xlate *xl,
+			      const struct xt_xlate_tg_params *params)
+{
+	const struct xt_tproxy_target_info_v1 *data = (const void *)params->target->data;
+
+	return tproxy_tg_xlate(xl, data);
+}
+
+static int tproxy_tg_xlate_v0(struct xt_xlate *xl,
+			      const struct xt_xlate_tg_params *params)
+{
+	const struct xt_tproxy_target_info *info = (const void *)params->target->data;
+	struct xt_tproxy_target_info_v1 t = {
+		.mark_mask = info->mark_mask,
+		.mark_value = info->mark_value,
+		.laddr.ip = info->laddr,
+		.lport = info->lport,
+	};
+
+	return tproxy_tg_xlate(xl, &t);
+}
+
 static struct xtables_target tproxy_tg_reg[] = {
 	{
 		.name          = "TPROXY",
@@ -160,6 +216,7 @@ static struct xtables_target tproxy_tg_reg[] = {
 		.save          = tproxy_tg_save,
 		.x6_options    = tproxy_tg0_opts,
 		.x6_parse      = tproxy_tg0_parse,
+		.xlate	       = tproxy_tg_xlate_v0,
 	},
 	{
 		.name          = "TPROXY",
@@ -173,6 +230,7 @@ static struct xtables_target tproxy_tg_reg[] = {
 		.save          = tproxy_tg_save4,
 		.x6_options    = tproxy_tg1_opts,
 		.x6_parse      = tproxy_tg1_parse,
+		.xlate	       = tproxy_tg_xlate_v1,
 	},
 	{
 		.name          = "TPROXY",
@@ -186,6 +244,7 @@ static struct xtables_target tproxy_tg_reg[] = {
 		.save          = tproxy_tg_save6,
 		.x6_options    = tproxy_tg1_opts,
 		.x6_parse      = tproxy_tg1_parse,
+		.xlate	       = tproxy_tg_xlate_v1,
 	},
 };
 
diff --git a/extensions/libxt_TPROXY.txlate b/extensions/libxt_TPROXY.txlate
new file mode 100644
index 000000000000..0dfe3bbb430d
--- /dev/null
+++ b/extensions/libxt_TPROXY.txlate
@@ -0,0 +1,17 @@
+iptables-translate -t mangle -A PREROUTING -p tcp -j TPROXY --on-port 12345 --on-ip 10.0.0.1 --tproxy-mark 0x23/0xff
+nft 'add rule ip mangle PREROUTING ip protocol tcp counter tproxy to 10.0.0.1:12345 meta mark set meta mark & 0xffffff00 or 0x23'
+
+iptables-translate -t mangle -A PREROUTING -p udp -j TPROXY --on-port 12345 --on-ip 10.0.0.1 --tproxy-mark 0x23
+nft 'add rule ip mangle PREROUTING ip protocol udp counter tproxy to 10.0.0.1:12345 meta mark set 0x23'
+
+iptables-translate -t mangle -A PREROUTING -p udp -j TPROXY --on-port 12345 --on-ip 10.0.0.1
+nft 'add rule ip mangle PREROUTING ip protocol udp counter tproxy to 10.0.0.1:12345'
+
+iptables-translate -t mangle -A PREROUTING -p udp -j TPROXY --on-ip 10.0.0.1 --on-port 0
+nft 'add rule ip mangle PREROUTING ip protocol udp counter tproxy to 10.0.0.1'
+
+iptables-translate -t mangle -A PREROUTING -p tcp -j TPROXY --on-port 12345
+nft 'add rule ip mangle PREROUTING ip protocol tcp counter tproxy to :12345'
+
+iptables-translate -t mangle -A PREROUTING -p tcp -j TPROXY --on-port 0
+nft 'add rule ip mangle PREROUTING ip protocol tcp counter tproxy to :0'
-- 
2.43.0

