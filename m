Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA50346795;
	Wed, 26 Nov 2025 20:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764190603; cv=none; b=PCHPVgqDKhalmonTcYNjEVYDZk3FB0zAjBtzTD2fGv09OD2yuXtH2Os8NjkoKf7cOyWiy3YxeHukH+L3aBqOgO7Vj/iIlD0R/nZzs7uGuvj1/029fedgck9eQTITYfR0eCdkS6JMva2OyNwLCsbm5Pyzu82aaJGWCTJgcGSdbII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764190603; c=relaxed/simple;
	bh=dN/TnNPylo9A9QSP94vr9a6n9mwd7vHCVPpFiUiKl68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMBaEsiku1PDPI6GEFOx1t0+z0ko9XOOjcOSXIPxuTj9khhQdx+rh0zt3bW5LTA0/R8N507yn5SyZKY1dKiw+vPgcDCG9CY9v1towuYZT6+YFOyBIlE+h4mXNq/Xqc3rWBUyndYLb6Om3c9MB1oMxnuVWHXLIR5oAlERYrqGRHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JWXB4x17; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JWXB4x17"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BB9D160272;
	Wed, 26 Nov 2025 21:56:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764190600;
	bh=KEIyZlBt5ANXgCIg1tIMzlRcOXaKZNTQ+/VibBB3J48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWXB4x17IZvYl/5t2ju5rl1qbfG3tFjk/zvRdtkSea5bvkbtB3hr7yg8TnXV/SkyQ
	 5rS/ZS4WpGRMLyPjHQJwoAZuE5KmVjBWUG9OrU8zSe8Cl2Ea87Vrl9SiAggVuBKJHY
	 32bzaTnhxDuOaZEEGM2PBNtL19JmCR4OIuJeDwlGQdRP610MkAzdFbGcm7+BJbgICg
	 T8r1b64OEPD/o9/QpKeQsjoWiGPr40/r3KMlpslfOZsvwxxB5tv6wK/926otQq9+mW
	 4kkwQ4jjgdVQ8dgookjHu4a6ZQaIa2jp82W3iKzxlbPpXAWLqLO87RNR372IBg1lpF
	 xzZlp+oip8OfA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 16/16] netfilter: nf_tables: improve UAPI kernel-doc comments
Date: Wed, 26 Nov 2025 20:56:11 +0000
Message-ID: <20251126205611.1284486-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251126205611.1284486-1-pablo@netfilter.org>
References: <20251126205611.1284486-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

In include/uapi/linux/netfilter/nf_tables.h,
correct the kernel-doc comments for mistyped enum names and enum values to
avoid these kernel-doc warnings and improve the documentation:

nf_tables.h:896: warning: Enum value 'NFT_EXTHDR_OP_TCPOPT' not described
 in enum 'nft_exthdr_op'
nf_tables.h:896: warning: Excess enum value 'NFT_EXTHDR_OP_TCP' description
 in 'nft_exthdr_op'

nf_tables.h:1210: warning: expecting prototype for enum
 nft_flow_attributes. Prototype was for enum nft_offload_attributes instead

nf_tables.h:1428: warning: expecting prototype for enum nft_reject_code.
 Prototype was for enum nft_reject_inet_code instead

(add beginning '@' to each enum value description:)
nf_tables.h:1493: warning: Enum value 'NFTA_TPROXY_FAMILY' not described
 in enum 'nft_tproxy_attributes'
nf_tables.h:1493: warning: Enum value 'NFTA_TPROXY_REG_ADDR' not described
 in enum 'nft_tproxy_attributes'
nf_tables.h:1493: warning: Enum value 'NFTA_TPROXY_REG_PORT' not described
 in enum 'nft_tproxy_attributes'

nf_tables.h:1796: warning: expecting prototype for enum
 nft_device_attributes. Prototype was for enum
 nft_devices_attributes instead

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 7c0c915f0306..45c71f7d21c2 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -881,7 +881,7 @@ enum nft_exthdr_flags {
  * enum nft_exthdr_op - nf_tables match options
  *
  * @NFT_EXTHDR_OP_IPV6: match against ipv6 extension headers
- * @NFT_EXTHDR_OP_TCP: match against tcp options
+ * @NFT_EXTHDR_OP_TCPOPT: match against tcp options
  * @NFT_EXTHDR_OP_IPV4: match against ipv4 options
  * @NFT_EXTHDR_OP_SCTP: match against sctp chunks
  * @NFT_EXTHDR_OP_DCCP: match against dccp otions
@@ -1200,7 +1200,7 @@ enum nft_ct_attributes {
 #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
 
 /**
- * enum nft_flow_attributes - ct offload expression attributes
+ * enum nft_offload_attributes - ct offload expression attributes
  * @NFTA_FLOW_TABLE_NAME: flow table name (NLA_STRING)
  */
 enum nft_offload_attributes {
@@ -1410,7 +1410,7 @@ enum nft_reject_types {
 };
 
 /**
- * enum nft_reject_code - Generic reject codes for IPv4/IPv6
+ * enum nft_reject_inet_code - Generic reject codes for IPv4/IPv6
  *
  * @NFT_REJECT_ICMPX_NO_ROUTE: no route to host / network unreachable
  * @NFT_REJECT_ICMPX_PORT_UNREACH: port unreachable
@@ -1480,9 +1480,9 @@ enum nft_nat_attributes {
 /**
  * enum nft_tproxy_attributes - nf_tables tproxy expression netlink attributes
  *
- * NFTA_TPROXY_FAMILY: Target address family (NLA_U32: nft_registers)
- * NFTA_TPROXY_REG_ADDR: Target address register (NLA_U32: nft_registers)
- * NFTA_TPROXY_REG_PORT: Target port register (NLA_U32: nft_registers)
+ * @NFTA_TPROXY_FAMILY: Target address family (NLA_U32: nft_registers)
+ * @NFTA_TPROXY_REG_ADDR: Target address register (NLA_U32: nft_registers)
+ * @NFTA_TPROXY_REG_PORT: Target port register (NLA_U32: nft_registers)
  */
 enum nft_tproxy_attributes {
 	NFTA_TPROXY_UNSPEC,
@@ -1783,7 +1783,7 @@ enum nft_synproxy_attributes {
 #define NFTA_SYNPROXY_MAX (__NFTA_SYNPROXY_MAX - 1)
 
 /**
- * enum nft_device_attributes - nf_tables device netlink attributes
+ * enum nft_devices_attributes - nf_tables device netlink attributes
  *
  * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
  * @NFTA_DEVICE_PREFIX: device name prefix, a simple wildcard (NLA_STRING)
-- 
2.47.3

