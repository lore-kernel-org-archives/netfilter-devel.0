Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C02F32C957
	for <netfilter-devel@vger.kernel.org>; Fri, 22 May 2026 05:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779426131; cv=none; b=rh7weqUeHL7/biee6zlqfOUUqHjmJBHNm9IBu7lEsYzGiPXmjX26xIdB7fp5/PrG9A9vrmhgM3z7tj3Ew0d1ypIm162n96xMbMXPelrbxVRNyJS9kbDaK6aTTYRQAqpPWNXk4ES05iiAayvB21VkQ+/AXlF4QfMSy58n61zM23E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779426131; c=relaxed/simple;
	bh=XsmfSucsxcfuHhjB9XAPwjAnKViTzlpeLaYXkfkJqAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CA3t6Lxqq8WSbxZx+mrJJkLR3h6/FvBqNrwxeQTjVwfieuq+0tt9kYJk4HhVxTPKF5MnEmHgwJKPcs6dei05X1VvUkHnNpPOth34UncrcuB+6LR/V+OzNRyPNVcGjcLbBSIogTmead0K9tUA/xBLi+mAW+wTUOuuUAiePvPgcAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 96F8460232; Fri, 22 May 2026 07:02:08 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 5/5] netfilter: conntrack: add deprecation warnings for irc and pptp trackers
Date: Fri, 22 May 2026 07:01:34 +0200
Message-ID: <20260522050140.4838-6-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522050140.4838-1-fw@strlen.de>
References: <20260522050140.4838-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IRC Direct client-to-client requires plaintext.  IRC over TLS should be
preferred, making this helper ineffective.  Add a deprecation warning and
update the help text to better reflect that this is needed for the DCC
extenion, not IRC itself.

PPTP is esoteric these days and it is the only helper that requires the
destroy callback in the conntrack helper API.

Removal would simplify the conntrack core.

Both helpers are IPv4 only as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_helper.h |  4 ++++
 net/netfilter/Kconfig                       | 11 ++++++-----
 net/netfilter/nf_conntrack_irc.c            |  2 ++
 net/netfilter/nf_conntrack_pptp.c           |  2 ++
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 2e1fea8b0a8d..9e7bea89de92 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -98,6 +98,10 @@ int nf_conntrack_helpers_register(struct nf_conntrack_helper *, unsigned int);
 void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *,
 				     unsigned int);
 
+#define nf_conntrack_helper_deprecated(name) \
+	pr_warn("The %s conntrack helper is scheduled for removal.\n"	\
+		"Please contact the netfilter-devel mailing list if you still need this.\n", name)
+
 struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
 
 int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 682c675125fc..133f03d90c0f 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -256,8 +256,7 @@ config NF_CONNTRACK_H323
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NF_CONNTRACK_IRC
-	tristate "IRC protocol support"
-	default m if NETFILTER_ADVANCED=n
+	tristate "IRC DCC protocol support (obsolete)"
 	help
 	  There is a commonly-used extension to IRC called
 	  Direct Client-to-Client Protocol (DCC).  This enables users to send
@@ -267,6 +266,8 @@ config NF_CONNTRACK_IRC
 	  using NAT, this extension will enable you to send files and initiate
 	  chats.  Note that you do NOT need this extension to get files or
 	  have others initiate chats, or everything else in IRC.
+	  DCC tracking behind NAT requires plaintext (unencrypted) IRC, so
+	  this helper is of limited use these days.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
@@ -308,17 +309,17 @@ config NF_CONNTRACK_SNMP
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NF_CONNTRACK_PPTP
-	tristate "PPtP protocol support"
+	tristate "PPtP protocol support (deprecated)"
 	depends on NETFILTER_ADVANCED
 	select NF_CT_PROTO_GRE
 	help
 	  This module adds support for PPTP (Point to Point Tunnelling
 	  Protocol, RFC2637) connection tracking and NAT.
 
-	  If you are running PPTP sessions over a stateful firewall or NAT
+	  If you are still running PPTP sessions over a stateful firewall or NAT
 	  box, you may want to enable this feature.
 
-	  Please note that not all PPTP modes of operation are supported yet.
+	  Please note that not all PPTP modes of operation are supported.
 	  Specifically these limitations exist:
 	    - Blindly assumes that control connections are always established
 	      in PNS->PAC direction. This is a violation of RFC2637.
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 4e07963a5c73..cebf73f34c77 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -264,6 +264,8 @@ static int __init nf_conntrack_irc_init(void)
 {
 	int ret;
 
+	nf_conntrack_helper_deprecated(HELPER_NAME);
+
 	if (max_dcc_channels < 1) {
 		pr_err("max_dcc_channels must not be zero\n");
 		return -EINVAL;
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index c079d4db52b8..afb67a31ab26 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -600,6 +600,8 @@ static int __init nf_conntrack_pptp_init(void)
 {
 	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nf_ct_pptp_master));
 
+	nf_conntrack_helper_deprecated(pptp.name);
+
 	return nf_conntrack_helper_register(&pptp);
 }
 
-- 
2.53.0

