Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF64118A6DB
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Apr 2025 19:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745176566; cv=none; b=W2V1SCBu/87nwFz44yQR5gUs28Nw1YfxZ2tc9sL1FPGxf6X4dDs3EdcYQ27EPOMoJSQSK1K+9Ps9xv55/TwUhbXubuXFDqfCbWx90cFIhP8q7GU5UKQWeqUL9SXiCfNC50YdtLbrRiOHu7ZPaqo8oCJfYrrc0akyKE7TCF4wtDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745176566; c=relaxed/simple;
	bh=lQGG6m+EbpOOZ8wmJz4+waZNgBxAG3YsBPmG75E7f9Q=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=kDXQZN2bEPG+Ppa+jhLgndU71/xUOYu2uVHhuO1OESP9ZvSPUxYSJvBSbDHjSZdXBAGCEIcJ4YKwyqBaBxJYDaHagI8ZZm27gsRmzwyR0uXoum0EhaTldnQnlHs+Nv2DJZyTrRO0W/8TOYbD+Kzx3BNkNez5ib4fKOtjxEBpmU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=W5v/d/xR; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="W5v/d/xR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SAkFlBPDt/l5ulNJeehlitqlS419pv/Y3/p64WfBhPE=; b=W5v/d/xRGwlIL+2gMwdkXKn/7Q
	tjpFPR5eGhaYaLKFhpzkpXXi5OPY6mxGwJHHx6DA1rfU5ccQBaeXP5muVigh9zsjGRZVxvlicTPXv
	kUcB8DqicNDQCovIcYiPDXC+K2lxqQbvcvtpP9GfGkGhXoXnBb6r2WKj+ZVq1LhS3UswHCmbi50B7
	WynBzP1hgL3Oe44RJ4fSqRjADe7BYXG8xVDCOFyBSF43lpgPai2O4Hd3KHK89/BKR/J1k3JM/Bdgu
	BS0tqxuyaFpqO951g0tuVnhVwEu/Qe/p17TQPRKDJoVt27yvc8zYTzMnmXJts0VrQBLBvntqfbGSM
	nmqsASUA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1u6a94-005Vxx-18
	for netfilter-devel@vger.kernel.org;
	Sun, 20 Apr 2025 20:16:02 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next] netfilter: use `NFPROTO_*` constants in "nf-logger-" module aliasses
Date: Sun, 20 Apr 2025 20:15:40 +0100
Message-ID: <20250420191540.2313754-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

The nf_log_syslog and nfnetlink_log modules define module aliasses of the form:

    nf-logger-${family}-${type}

The family arguments passed to the `MODULE_ALIAS_NF_LOGGER` macro are a mixture
of `AF_*` constants for families where these exist and integer literals for the
rest.  In some of the latter cases, there are comments containing the related
`NFPROTO_*` constants.

Since there are `NFPROTO_*` for all families, use them throughout.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nf_log_syslog.c | 10 +++++-----
 net/netfilter/nfnetlink_log.c | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 86d5fc5d28e3..b2463e5013b6 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -1078,8 +1078,8 @@ MODULE_ALIAS("nf_log_bridge");
 MODULE_ALIAS("nf_log_ipv4");
 MODULE_ALIAS("nf_log_ipv6");
 MODULE_ALIAS("nf_log_netdev");
-MODULE_ALIAS_NF_LOGGER(AF_BRIDGE, 0);
-MODULE_ALIAS_NF_LOGGER(AF_INET, 0);
-MODULE_ALIAS_NF_LOGGER(3, 0);
-MODULE_ALIAS_NF_LOGGER(5, 0); /* NFPROTO_NETDEV */
-MODULE_ALIAS_NF_LOGGER(AF_INET6, 0);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_BRIDGE, 0);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_IPV4, 0);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_ARP, 0);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_NETDEV, 0);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_IPV6, 0);
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 134e05d31061..03e3560eaa51 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1207,11 +1207,11 @@ MODULE_DESCRIPTION("netfilter userspace logging");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_ULOG);
-MODULE_ALIAS_NF_LOGGER(AF_INET, 1);
-MODULE_ALIAS_NF_LOGGER(AF_INET6, 1);
-MODULE_ALIAS_NF_LOGGER(AF_BRIDGE, 1);
-MODULE_ALIAS_NF_LOGGER(3, 1); /* NFPROTO_ARP */
-MODULE_ALIAS_NF_LOGGER(5, 1); /* NFPROTO_NETDEV */
+MODULE_ALIAS_NF_LOGGER(NFPROTO_IPV4, 1);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_IPV6, 1);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_BRIDGE, 1);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_ARP, 1);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_NETDEV, 1);
 
 module_init(nfnetlink_log_init);
 module_exit(nfnetlink_log_fini);
-- 
2.47.2

