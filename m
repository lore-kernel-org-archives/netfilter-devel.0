Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3196535B8
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2024 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709907879; cv=none; b=Uwg9SGv9kH92UqglwfzG18NcL3BuH5miEeoUx34fCYonwabdcDRGJllVAtbkhRUIbzfNE+4JsORe6NMO51NPcI7F60bk7GXm/UK7EbkTM52i5zOgHsT0UP1jwkvoqiEAXkaKb1ino1L4PNYOvER0c8tM8X7TZajeEBe6oQ/Ius8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709907879; c=relaxed/simple;
	bh=kDVJyYg3hwcXEHfuM46qKQcJfu+8PxAWPq+LE6fx5iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YCk3ljVCvvDG/Ij7KEHHYUWyr/hgyS5CLUBLbmPDEUq1kG7/0pl5Kn4MIMFL/vFdkGR2q0Z41YIekVb8P+c+PUV5quvIy0LvqxXsJM3novN7M4uqRy5yGICd6Ons6VwVrrqn2zp4j37W1KEUHmLCNRiNH61hCSNAYj23Yrp8VUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rib9G-0008Ry-Qx; Fri, 08 Mar 2024 15:24:34 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 xtables] extensions: xt_TPROXY: add txlate support
Date: Fri,  8 Mar 2024 15:24:28 +0100
Message-ID: <20240308142431.7960-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: add ipv6 test case, use xor instead of or

 extensions/libxt_TPROXY.c      | 59 ++++++++++++++++++++++++++++++++++
 extensions/libxt_TPROXY.txlate | 20 ++++++++++++
 2 files changed, 79 insertions(+)
 create mode 100644 extensions/libxt_TPROXY.txlate

diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index d13ec85f92d0..ffc9da1383b8 100644
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
+		xt_xlate_add(xl, "meta mark set meta mark & 0x%x xor 0x%x",
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
index 000000000000..239bbe0dc8f9
--- /dev/null
+++ b/extensions/libxt_TPROXY.txlate
@@ -0,0 +1,20 @@
+iptables-translate -t mangle -A PREROUTING -p tcp -j TPROXY --on-port 12345 --on-ip 10.0.0.1 --tproxy-mark 0x23/0xff
+nft 'add rule ip mangle PREROUTING ip protocol tcp counter tproxy to 10.0.0.1:12345 meta mark set meta mark & 0xffffff00 xor 0x23'
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
+
+ip6tables-translate -t mangle -A PREROUTING -p tcp -j TPROXY --on-port 12345 --on-ip dead::beef --tproxy-mark 0x23/0xffff
+nft 'add rule ip6 mangle PREROUTING meta l4proto tcp counter tproxy to [dead::beef]:12345 meta mark set meta mark & 0xffff0000 xor 0x23'
-- 
2.44.0

