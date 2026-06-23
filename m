Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E033C4563;
	Tue, 23 Jun 2026 22:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782252971; cv=none; b=oAp3OPBZVzTW2yBZSUdNDWxZtIt7arcBYUrrU+fXQoy5TuTM+Fi25o48kxkKFjmoti2S6ugTSJw9qiAzUsM+Ft2Rd2TzC/PjTPTw3kcBIbaa2BMDLNWtIGEa6w+wknMVZCMzhCxyIcxujj95wXF39Vp0HXV/Zww4vG5tTenrFuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782252971; c=relaxed/simple;
	bh=qeJMbr71q5ZFr4xQofD3kRXveloFPuyf5oByNw4dsfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTai2sWlA+quo3qohYIrrk4m3FfASBCFFAJsOg9UHIXum6gYiFKVqKLxVNhZxlUfoSuJ5L/YfOTAUDL2Iy2uxNXZGwmKYHcrvMmzOm76iMcf4SfxIMOmNAwEpNFklq187k9JuArtwd0CW1v4b6tJv6W9gA1qE/xLctchVC3921Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nwTn3Z4f; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nwTn3Z4f"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A8D2D60584;
	Wed, 24 Jun 2026 00:16:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782252966;
	bh=4gndbP0FGjKnXMGzg8NuaUFB/1Ulk6/PKEQ6YmEbJu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwTn3Z4fPmOh4eTO6K+mAiPTzQhW1Wf1lA6lWTfL3r6G2Il4pYFIaKfiRudxrKfvr
	 UWz7rqSXiyMySZ8vRpi2EBtZoZY3eLWqj0CPTEFEw/o4YJw11saCvkjhr0mAPUYcUG
	 rCIDSzI71JCfZe4xOmHbzcFpK4FXJpjUT09aubAujuFeTl5m6Y1SnmXBbf3gpKNJGE
	 aVYQV8/8S93m/RNaCZ5UmZmLq6hQsBomHDyYr3R35kSd0LkYXAh4BJ2l10pI4ctBgf
	 UJFpeN/Hs/MAtXUBnixK7u/uSJwvs8+h6lHf8pIw1lcG8XQnHLZmLKq43e5gPmUMon
	 CMnvrzwkfHJ6Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 10/14] netfilter: conntrack: add deprecation warnings for irc and pptp trackers
Date: Wed, 24 Jun 2026 00:15:43 +0200
Message-ID: <20260623221548.701545-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623221548.701545-1-pablo@netfilter.org>
References: <20260623221548.701545-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

IRC Direct client-to-client requires plaintext.  IRC over TLS should be
preferred, making this helper ineffective.  Add a deprecation warning and
update the help text to better reflect that this is needed for the DCC
extension, not IRC itself.

PPTP is esoteric these days and it is the only helper that requires the
destroy callback in the conntrack helper API.

Removal would simplify the conntrack core.

Both helpers are IPv4 only.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_helper.h |  4 ++++
 net/netfilter/Kconfig                       | 11 ++++++-----
 net/netfilter/nf_conntrack_irc.c            |  2 ++
 net/netfilter/nf_conntrack_pptp.c           |  2 ++
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 81025101f86d..c761cd8158b2 100644
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
index 776505a78e64..80fc14c87ddc 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -545,6 +545,8 @@ static int __init nf_conntrack_pptp_init(void)
 
 	pptp.destroy = gre_pptp_destroy_siblings;
 
+	nf_conntrack_helper_deprecated(pptp.name);
+
 	return nf_conntrack_helper_register(&pptp, &pptp_ptr);
 }
 
-- 
2.47.3

