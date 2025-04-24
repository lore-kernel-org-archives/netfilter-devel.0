Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16721226CEB
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Apr 2025 11:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745495588; cv=none; b=ZuQh2Fe24sJAColWZ1o/uVQ0AsBlmy7ZJXQlMAHXs2qsLZ0blISTP3GSW8Sa2qTz6wPX6FCbCZpxFPRS0TNnQh7r2YX+jXpmGoEGua7qEb7DD9gI9Fes0ptJeMrz9dwXezGiQroLJst5WZYw1seRE6TLWOIdBK2EXJBaOLxKng8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745495588; c=relaxed/simple;
	bh=BUiUilA9EosIWNp7Jp6/Oub+vGf7R4Ja8hjDd77XdDw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cERRYrLsK8PZWeT3KUdrS4kKv3VU/NThBHlejQH7oa47aMBm+LCNEkXm+p+QpGNSOWy3XfuCL6D4Sh0JYQ3aTaVVOhFm6BoaKRoK0g/c0aw2ukoZQ/sUwxmynVStfc5YSqbS1QsziggEQhPRNw0xQ163WgkzZlbksVHsXuaAgdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u7v8U-0003Fs-Fk; Thu, 24 Apr 2025 13:52:58 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] tools: selftests: prepare for non-default IP_TABLES_LEGACY
Date: Thu, 24 Apr 2025 15:49:27 +0200
Message-ID: <20250424134930.24043-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable relevant iptables config options explicitly, this is needed
to avoid breakage when symbols related to iptables-legacy
will depend on NETFILTER_LEGACY resp. IP_TABLES_LEGACY.

This also means that the classic tables (Kernel modules) will
not be enabled by default, so enable them too.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Hi Pablo

 with this nf tests pass with iptables-legacy.
 The problematic net tests pass for me as well with either iptables-nft
 or -legacy.

 Problem with iptables-nft was that TARGET_TTL is ignored by Makefile,
 the symbol picks up TARGET_HL behind the scenes but not after the
 mentioned commit.

 This could be squashed with
 netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
 Or it could be added before.  In that case the commit
 message needs to be updated (CONFIG_NETFILTER_LEGACY knob
 doesn't exist yet in this case).

 tools/testing/selftests/net/config           | 11 +++++++++++
 tools/testing/selftests/net/netfilter/config |  5 +++++
 2 files changed, 16 insertions(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 3cfef5153823..20deec955d39 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -29,17 +29,26 @@ CONFIG_INET_ESP_OFFLOAD=y
 CONFIG_NET_FOU=y
 CONFIG_NET_FOU_IP_TUNNELS=y
 CONFIG_NETFILTER=y
+CONFIG_NETFILTER_LEGACY=y
 CONFIG_NETFILTER_ADVANCED=y
 CONFIG_NF_CONNTRACK=m
 CONFIG_IPV6_MROUTE=y
 CONFIG_IPV6_SIT=y
 CONFIG_NF_NAT=m
 CONFIG_IP6_NF_IPTABLES=m
+CONFIG_IP6_NF_IPTABLES_LEGACY=m
 CONFIG_IP_NF_IPTABLES=m
+CONFIG_IP_NF_IPTABLES_LEGACY=m
+CONFIG_IP6_NF_MANGLE=m
+CONFIG_IP6_NF_FILTER=m
 CONFIG_IP6_NF_NAT=m
 CONFIG_IP6_NF_RAW=m
+CONFIG_IP_NF_MANGLE=m
+CONFIG_IP_NF_FILTER=m
 CONFIG_IP_NF_NAT=m
 CONFIG_IP_NF_RAW=m
+CONFIG_IP_NF_TARGET_REJECT=m
+CONFIG_IP6_NF_TARGET_REJECT=m
 CONFIG_IP_NF_TARGET_TTL=m
 CONFIG_IPV6_GRE=m
 CONFIG_IPV6_SEG6_LWTUNNEL=y
@@ -57,6 +66,8 @@ CONFIG_NF_TABLES_IPV6=y
 CONFIG_NF_TABLES_IPV4=y
 CONFIG_NFT_NAT=m
 CONFIG_NETFILTER_XT_MATCH_LENGTH=m
+CONFIG_NETFILTER_XT_TARGET_HL=m
+CONFIG_NETFILTER_XT_NAT=m
 CONFIG_NET_ACT_CSUM=m
 CONFIG_NET_ACT_CT=m
 CONFIG_NET_ACT_GACT=m
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 43d8b500d391..55ffb6f77ad4 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -1,6 +1,8 @@
 CONFIG_AUDIT=y
 CONFIG_BPF_SYSCALL=y
 CONFIG_BRIDGE=m
+CONFIG_NETFILTER_LEGACY=y
+CONFIG_BRIDGE_NF_EBTABLES_LEGACY=m
 CONFIG_BRIDGE_EBT_BROUTE=m
 CONFIG_BRIDGE_EBT_IP=m
 CONFIG_BRIDGE_EBT_REDIRECT=m
@@ -14,7 +16,10 @@ CONFIG_INET_ESP=m
 CONFIG_IP_NF_MATCH_RPFILTER=m
 CONFIG_IP6_NF_MATCH_RPFILTER=m
 CONFIG_IP_NF_IPTABLES=m
+CONFIG_IP_NF_IPTABLES_LEGACY=m
 CONFIG_IP6_NF_IPTABLES=m
+CONFIG_IP6_NF_IPTABLES_LEGACY=m
+CONFIG_IP_NF_NAT=m
 CONFIG_IP_NF_FILTER=m
 CONFIG_IP6_NF_FILTER=m
 CONFIG_IP_NF_RAW=m
-- 
2.49.0

