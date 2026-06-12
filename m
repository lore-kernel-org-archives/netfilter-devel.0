Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCC236309C
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jun 2026 06:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781244253; cv=none; b=Azt3Wlmoiz1mRDaAXbM/7A4yrRZ/EFkJQ+N8ZJh9d6s/3msUw3avkyiuZLwvsofFuDjY0L8tSpfN3BvD1Wp25j8OWF2yCSsvFKrCz1mfhvYUzbPIdDfEEuEveCZIHMwZV6Qck2bwOkUbaAx2cHl5iQeTYRrQ70ka1D8poesKj0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781244253; c=relaxed/simple;
	bh=KDF2czuAha2gJ/5Mey8qXDjjGJYHH1td6aRP7zv6Fr0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I824g8KeBu5qbT+zH6NbUGW0fswasIPSZflV7DFjT8uXpFMFy19GmlIPnvtZbiudGG2Rdt4/aI4TGJpElBiIQNEjTN+r066dkUDmegW6841mav26rLYiDWGFzhelL3BpnmgADpeXlz7ZIjVrsPQKAFjK7KNvcgJfL3y9I5q5nDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 66EAB607E1; Fri, 12 Jun 2026 08:04:09 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: add deprecation warnings for irc and pptp trackers
Date: Fri, 12 Jun 2026 08:03:50 +0200
Message-ID: <20260612060354.15939-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
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
extension, not IRC itself.

PPTP is esoteric these days and it is the only helper that requires the
destroy callback in the conntrack helper API.

Removal would simplify the conntrack core.

Both helpers are IPv4 only.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_helper.h |  4 ++++
 net/netfilter/Kconfig                       | 11 ++++++-----
 net/netfilter/nf_conntrack_irc.c            |  2 ++
 net/netfilter/nf_conntrack_pptp.c           |  2 ++
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index ed93a5a1adc8..eb00f91170aa 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -114,6 +114,10 @@ int nf_conntrack_helpers_register(struct nf_conntrack_helper *, unsigned int,
 void nf_conntrack_helpers_unregister(struct nf_conntrack_helper **,
 				     unsigned int);
 
+#define nf_conntrack_helper_deprecated(name) \
+	pr_warn("The %s conntrack helper is scheduled for removal.\n"	\
+		"Please contact the netfilter-devel mailing list if you still need this.\n", name)
+
 struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
 
 int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 665f8008cc4b..4c04cd8d40a2 100644
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
index 0c117b8492e9..193ab34db795 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -262,6 +262,8 @@ static int __init nf_conntrack_irc_init(void)
 {
 	int i, ret;
 
+	nf_conntrack_helper_deprecated(HELPER_NAME);
+
 	if (max_dcc_channels < 1) {
 		pr_err("max_dcc_channels must not be zero\n");
 		return -EINVAL;
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index ed567a1cf7fd..d4c9b013ce3d 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -536,6 +536,8 @@ static int __init nf_conntrack_pptp_init(void)
 
 	pptp.destroy = gre_pptp_destroy_siblings;
 
+	nf_conntrack_helper_deprecated(pptp.name);
+
 	return nf_conntrack_helper_register(&pptp, &pptp_ptr);
 }
 
-- 
2.53.0

