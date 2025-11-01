Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C551DF258;
	Sat,  1 Nov 2025 19:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762024843; cv=none; b=H8m3D+67IWD3vj4EYGS/Xpkj57sCRtuWKtiOrNO0HBzYAKpTXyIfIMlPO68y/wmFXt2nRDlUay6qBEjnbETSDWAEPmOWGb2BM3h4tWV0XqciG0QWMU/HaJ5xadnMugpBJ/0pxKMOZgci76Yvxr+AnPi823n0kVn+XoZ4feToj8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762024843; c=relaxed/simple;
	bh=EbBplVH/jp/WQDFITyHV/kOjC8DhNug4NV/9A+tLHUA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PUtGA9ZcTPfWderzG/If2hiJxQ3364adZSCpLxmKrKzdHMnHxBFTdUMIAupLdr3AYp9Q36igyp7XrRsc/mvHza4skOiM2cGzG52un58ItnUq4K5T+6LLwQqQfT0lfCX3Iob+gn3yE905nvroihUkV1SVNaqOWbJE7cI+5HIIMhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2yNm860m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2yNm860m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=UiYKIoB/RAwW7vaxisQKhlQflM4KDYIBpvhlC5sFr+8=; b=2yNm860mEjlSCQMKTz9g5yEwrG
	KrigR+w7TZkiKZmpgQmIOfZmaoPIb3QEQEtZFz5WCs4pWW32KasygahkwqKvtl7jLZMuz1iO8OIht
	X2YycorV0foi8nPskaD1T4K6bvNF0xyY5mzG1XFQvqjBLT+ldWO+gSGtLym29t2PbBW6Yp1zPKk6x
	wRueWh1q3flOdOSHwNtqwSDwOu6lnSraypfORWVgOP7dpeyh6oF852FCmz2lc0Hv4PNyliCaKd+wd
	KWcu0Hb7yIxNz0OhlYMW+TmL47pzEAoQpeueU+n3OOFHQoIjuTjFnttxRBwRSUyJWM40Zy/5l3f7/
	oRfnGobQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vFH9T-000000082cw-065k;
	Sat, 01 Nov 2025 19:20:39 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH net-next] netfilter: nf_tables: improve UAPI kernel-doc comments
Date: Sat,  1 Nov 2025 12:20:38 -0700
Message-ID: <20251101192038.2005374-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
---
 include/uapi/linux/netfilter/nf_tables.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux-next-20251031.orig/include/uapi/linux/netfilter/nf_tables.h
+++ linux-next-20251031/include/uapi/linux/netfilter/nf_tables.h
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
