Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E46371D14
	for <netfilter-devel@vger.kernel.org>; Fri,  8 May 2026 11:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778238950; cv=none; b=FYU3OmdYVvK0hvH+no1tOGWx0JtY2BmerMVIeEbkgGR5Ha6qYRVud0AghFLImQhGzR/yQCZpAe+yH2LXTXlNmfViSfqJe5YHwsigmOVpZpSldd5sOihfITH3wl3ksLgH7PXolopUSMvjA9xQqB8sFvuU+0Q+mlbIlHl8AVEV6Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778238950; c=relaxed/simple;
	bh=mK6aL2lbQlkhjfkQ0/ZH53bfHRAlXzBTksA73XM5tPM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bT1CNKGBKgikhA/XLw/n/HwRAJnZCBP4C/LKeyHqSRvrvrHOjJHFk7sGAcsQy+k06ihCXWPlbUyXdoQJ9jtxbCfI2mrd43q4fBqnI0PJMdS7yr8WaNOAZDBxf0yQmT2yXZ9xT7tj0oYZYBRURDCNSTu7/wwaynLyTJ8SKlfcdkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HX+Ql5Lk; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HX+Ql5Lk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=R6PgSJCQ3xL80QWvyfFM6MgB34jQ4wxZEfhNdm0eMxc=; b=HX+Ql5Lkb5enIRnu8EtDV9eVoi
	hDawydHCtNwOr5pVFWmM8kXy2AOghjUnGvisk3KvVKflSNh0aMkRBnkJuSLzZOlu1B7dMQwVtAQMj
	IYBZQdONrA1Ve8HISMS6dmoE15thgRmWRrlCcReFQ9FPWAIpkMGm+aXh8zBcm4l4CpQTvMaV/FKLh
	V6KWVijlrxO2DrWRPzETpgvAoieUPRYamVguE0xc1IdXeKFj4AkUM6pjkzbw8v2+2rFat/xVjhFm8
	iyDgUABLvBV2VobKFDZXl/oQOTreXaprrG7jUUv/aPb8pJcavb/q1MFXMYaHnicY/sPevYogxNFg1
	6DcyQHPQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wLJBH-0000000053R-2Hof;
	Fri, 08 May 2026 13:15:43 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH v2] scanner: Accept all statements' first words in all scopes
Date: Fri,  8 May 2026 13:15:02 +0200
Message-ID: <20260508111538.3783172-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To fix for token lookahead with exclusive start conditions, we must
accept all keywords which may immediately follow the exclusive scope in
that scope as well. This affects basically the first word of every
statement which may follow a limit statement.

Add a test case to make sure things stay that way. A few quirks exist
though:
- xt statement would need special testing since having it in a rule is
  supposed to fail the command
- The parser formally accepts nonsensical things like strings, numbers
  and variable references on LHS, but these seem to be needed for the
  data part in map elements only

Suggested-by: Florian Westphal <fw@strlen.de>
Fixes: 9d105581b5f1b ("scanner: Introduce SCANSTATE_RATE")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Add the promised test case
---
 src/scanner.l                                 | 188 +++++++++---------
 .../testcases/parsing/exclusive_start_cond    | 168 ++++++++++++++++
 2 files changed, 262 insertions(+), 94 deletions(-)
 create mode 100755 tests/shell/testcases/parsing/exclusive_start_cond

diff --git a/src/scanner.l b/src/scanner.l
index 1b4eb1cf13a47..353e2ca3b3f89 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -301,7 +301,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <*>"/"			{ return SLASH; }
 "-"			{ return DASH; }
 "*"			{ return ASTERISK; }
-"@"			{ scanner_push_start_cond(yyscanner, SCANSTATE_AT); return AT; }
+<*>"@"			{ scanner_push_start_cond(yyscanner, SCANSTATE_AT); return AT; }
 "$"			{ return '$'; }
 "="			{ return '='; }
 "vmap"			{ return VMAP; }
@@ -332,42 +332,42 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "table"			{ return TABLE; }
 "chain"			{ return CHAIN; }
 "rule"			{ return RULE; }
-"set"			{ return SET; }
+<*>"set"		{ return SET; }
 "element"		{ return ELEMENT; }
 "map"			{ return MAP; }
 "flowtable"		{ return FLOWTABLE; }
 "handle"		{ return HANDLE; }
 "ruleset"		{ return RULESET; }
 
-"socket"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_SOCKET); return SOCKET; }
+<*>"socket"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_SOCKET); return SOCKET; }
 <SCANSTATE_EXPR_SOCKET>{
 	"transparent"		{ return TRANSPARENT; }
 	"wildcard"		{ return WILDCARD; }
 	"cgroupv2"		{ return CGROUPV2; }
 	"level"			{ return LEVEL; }
 }
-"tproxy"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_TPROXY); return TPROXY; }
+<*>"tproxy"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_TPROXY); return TPROXY; }
 
-"accept"		{ return ACCEPT; }
-"drop"			{ return DROP; }
-"continue"		{ return CONTINUE; }
-"jump"			{ return JUMP; }
-"goto"			{ return GOTO; }
-"return"		{ return RETURN; }
-<SCANSTATE_EXPR_QUEUE,SCANSTATE_STMT_DUP,SCANSTATE_STMT_FWD,SCANSTATE_STMT_NAT,SCANSTATE_STMT_TPROXY,SCANSTATE_IP,SCANSTATE_IP6>"to"			{ return TO; } /* XXX: SCANSTATE_IP is a workaround */
+<*>"accept"		{ return ACCEPT; }
+<*>"drop"		{ return DROP; }
+<*>"continue"		{ return CONTINUE; }
+<*>"jump"		{ return JUMP; }
+<*>"goto"		{ return GOTO; }
+<*>"return"		{ return RETURN; }
+<SCANSTATE_EXPR_QUEUE,SCANSTATE_STMT_DUP,SCANSTATE_STMT_FWD,SCANSTATE_STMT_NAT,SCANSTATE_STMT_TPROXY,SCANSTATE_IP,SCANSTATE_IP6>"to"			{ return TO; } /* XXX: SCANSTATE_IP(6) is a workaround (lookahead after nf_key_proto) */
 
 "inet"			{ return INET; }
 "netdev"		{ return NETDEV; }
 
-"add"			{ return ADD; }
+<*>"add"		{ return ADD; }
 "replace"		{ return REPLACE; }
-"update"		{ return UPDATE; }
+<*>"update"		{ return UPDATE; }
 "create"		{ return CREATE; }
 "insert"		{ return INSERT; }
-"delete"		{ return DELETE; }
+<*>"delete"		{ return DELETE; }
 "get"			{ return GET; }
 "list"			{ scanner_push_start_cond(yyscanner, SCANSTATE_CMD_LIST); return LIST; }
-"reset"			{ scanner_push_start_cond(yyscanner, SCANSTATE_CMD_RESET); return RESET; }
+<*>"reset"		{ scanner_push_start_cond(yyscanner, SCANSTATE_CMD_RESET); return RESET; }
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
 "import"                { scanner_push_start_cond(yyscanner, SCANSTATE_CMD_IMPORT); return IMPORT; }
@@ -396,9 +396,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"memory"		{ return MEMORY; }
 }
 
-"flow"			{ return FLOW; }
+<*>"flow"		{ return FLOW; }
 "offload"		{ return OFFLOAD; }
-"meter"			{ return METER; }
+<*>"meter"		{ return METER; }
 
 <SCANSTATE_CMD_LIST>{
 	"meters"		{ return METERS; }
@@ -418,7 +418,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_RATE>"kbytes"	{ return KBYTES; }
 <SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_RATE>"mbytes"	{ return MBYTES; }
 
-"last"				{ scanner_push_start_cond(yyscanner, SCANSTATE_LAST); return LAST; }
+<*>"last"		{ scanner_push_start_cond(yyscanner, SCANSTATE_LAST); return LAST; }
 <SCANSTATE_LAST>{
 	"never"			{ return NEVER; }
 }
@@ -429,7 +429,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"rules"			{ return RULES; }
 }
 
-<*>"log"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_LOG); return LOG; }
+<*>"log"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_LOG); return LOG; }
 <SCANSTATE_STMT_LOG,SCANSTATE_STMT_NAT,SCANSTATE_IP,SCANSTATE_IP6>"prefix"		{ return PREFIX; }
 <SCANSTATE_STMT_LOG>{
 	"snaplen"		{ return SNAPLEN; }
@@ -447,13 +447,13 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"audit"			{ return AUDIT; }
 }
 
-"queue"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_QUEUE); return QUEUE;}
+<*>"queue"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_QUEUE); return QUEUE;}
 <SCANSTATE_EXPR_QUEUE>{
 	"num"		{ return QUEUENUM;}
 	"bypass"	{ return BYPASS;}
 	"fanout"	{ return FANOUT;}
 }
-"limit"			{ scanner_push_start_cond(yyscanner, SCANSTATE_LIMIT); return LIMIT; }
+<*>"limit"		{ scanner_push_start_cond(yyscanner, SCANSTATE_LIMIT); return LIMIT; }
 <SCANSTATE_LIMIT,SCANSTATE_RATE>{
 	"rate"			{ scanner_push_start_cond(yyscanner, SCANSTATE_RATE); return RATE; }
 	"burst"			{ return BURST; }
@@ -465,7 +465,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 <SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_RATE>"over"		{ return OVER; }
 
-"quota"			{ scanner_push_start_cond(yyscanner, SCANSTATE_QUOTA); return QUOTA; }
+<*>"quota"		{ scanner_push_start_cond(yyscanner, SCANSTATE_QUOTA); return QUOTA; }
 <SCANSTATE_QUOTA,SCANSTATE_RATE>{
 	"until"		{ return UNTIL; }
 }
@@ -475,16 +475,16 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <*>"hour"		{ return HOUR; }
 <*>"day"		{ return DAY; }
 
-"reject"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_REJECT); return _REJECT; }
+<*>"reject"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_REJECT); return _REJECT; }
 <SCANSTATE_STMT_REJECT>{
 	"with"			{ return WITH; }
 	"icmpx"			{ return ICMPX; }
 }
 
-"snat"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return SNAT; }
-"dnat"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return DNAT; }
-"masquerade"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return MASQUERADE; }
-"redirect"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return REDIRECT; }
+<*>"snat"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return SNAT; }
+<*>"dnat"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return DNAT; }
+<*>"masquerade"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return MASQUERADE; }
+<*>"redirect"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return REDIRECT; }
 "random"		{ return RANDOM; }
 <SCANSTATE_STMT_NAT>{
 	"fully-random"		{ return FULLY_RANDOM; }
@@ -496,11 +496,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"ll"			{ return LL_HDR; }
 	"nh"			{ return NETWORK_HDR; }
 }
-"th"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_TH); return TRANSPORT_HDR; }
+<*>"th"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_TH); return TRANSPORT_HDR; }
 
 "bridge"		{ return BRIDGE; }
 
-"ether"			{ scanner_push_start_cond(yyscanner, SCANSTATE_ETH); return ETHER; }
+<*>"ether"		{ scanner_push_start_cond(yyscanner, SCANSTATE_ETH); return ETHER; }
 <SCANSTATE_ARP,SCANSTATE_CT,SCANSTATE_ETH,SCANSTATE_IP,SCANSTATE_IP6,SCANSTATE_EXPR_FIB,SCANSTATE_EXPR_IPSEC>{
 	"saddr"			{ return SADDR; }
 	"daddr"			{ return DADDR; }
@@ -508,7 +508,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "type"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TYPE); return TYPE; }
 "typeof"		{ return TYPEOF; }
 
-"vlan"			{ scanner_push_start_cond(yyscanner, SCANSTATE_VLAN); return VLAN; }
+<*>"vlan"		{ scanner_push_start_cond(yyscanner, SCANSTATE_VLAN); return VLAN; }
 <SCANSTATE_CT,SCANSTATE_EXPR_FRAG,SCANSTATE_VLAN,SCANSTATE_IP,SCANSTATE_ICMP>"id"			{ return ID; }
 <SCANSTATE_VLAN>{
 	"cfi"		{ return CFI; }
@@ -518,7 +518,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "8021ad"		{ yylval->string = xstrdup(yytext); return STRING; }
 "8021q"			{ yylval->string = xstrdup(yytext); return STRING; }
 
-"arp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_ARP); return ARP; }
+<*>"arp"		{ scanner_push_start_cond(yyscanner, SCANSTATE_ARP); return ARP; }
 <SCANSTATE_ARP>{
 	"htype"			{ return HTYPE; }
 	"ptype"			{ return PTYPE; }
@@ -527,7 +527,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"operation"		{ return OPERATION; }
 }
 
-"ip"			{ scanner_push_start_cond(yyscanner, SCANSTATE_IP); return IP; }
+<*>"ip"			{ scanner_push_start_cond(yyscanner, SCANSTATE_IP); return IP; }
 <SCANSTATE_IP,SCANSTATE_IP6,SCANSTATE_EXPR_OSF,SCANSTATE_GRE>{
 	"version"		{ return HDRVERSION; }
 }
@@ -606,10 +606,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"options"		{ return OPTIONS; }
 	"option"		{ return OPTION; }
 }
-"time"			{ return TIME; }
+<*>"time"		{ return TIME; }
 
-"icmp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_ICMP); return ICMP; }
-"icmpv6"		{ scanner_push_start_cond(yyscanner, SCANSTATE_ICMP); return ICMP6; }
+<*>"icmp"		{ scanner_push_start_cond(yyscanner, SCANSTATE_ICMP); return ICMP; }
+<*>"icmpv6"		{ scanner_push_start_cond(yyscanner, SCANSTATE_ICMP); return ICMP6; }
 <SCANSTATE_ICMP>{
 	"gateway"		{ return GATEWAY; }
 	"code"			{ return CODE; }
@@ -623,13 +623,13 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"sequence"		{ return SEQUENCE; }
 }
 
-"igmp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_IGMP); return IGMP; }
+<*>"igmp"		{ scanner_push_start_cond(yyscanner, SCANSTATE_IGMP); return IGMP; }
 <SCANSTATE_IGMP>{
 	"mrt"			{ return MRT; }
 	"group"			{ return GROUP; }
 }
 
-"ip6"			{ scanner_push_start_cond(yyscanner, SCANSTATE_IP6); return IP6; }
+<*>"ip6"		{ scanner_push_start_cond(yyscanner, SCANSTATE_IP6); return IP6; }
 "priority"		{ return PRIORITY; }
 <SCANSTATE_IP6>{
 	"flowlabel"		{ return FLOWLABEL; }
@@ -639,22 +639,22 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"nexthdr"		{ return NEXTHDR; }
 }
 
-"ah"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_AH); return AH; }
+<*>"ah"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_AH); return AH; }
 <SCANSTATE_EXPR_AH,SCANSTATE_EXPR_FRAG,SCANSTATE_EXPR_MH,SCANSTATE_TCP>{
 	"reserved"		{ return RESERVED; }
 }
 <SCANSTATE_EXPR_AH,SCANSTATE_EXPR_ESP,SCANSTATE_EXPR_IPSEC>"spi"			{ return SPI; }
 
-"esp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_ESP); return ESP; }
+<*>"esp"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_ESP); return ESP; }
 
-"comp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_COMP); return COMP; }
+<*>"comp"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_COMP); return COMP; }
 <SCANSTATE_EXPR_COMP>{
 	"cpi"			{ return CPI; }
 }
 "flags"			{ return FLAGS; }
 
-"udp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_UDP); return UDP; }
-"udplite"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_UDPLITE); return UDPLITE; }
+<*>"udp"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_UDP); return UDP; }
+<*>"udplite"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_UDPLITE); return UDPLITE; }
 <SCANSTATE_EXPR_UDPLITE>{
 	"csumcov"	{ return CSUMCOV; }
 }
@@ -668,19 +668,19 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"option"		{ return OPTION; }
 }
 
-"vxlan"			{ return VXLAN; }
+<*>"vxlan"		{ return VXLAN; }
 "vni"			{ return VNI; }
 
-"geneve"		{ return GENEVE; }
+<*>"geneve"		{ return GENEVE; }
 
-"gre"			{ scanner_push_start_cond(yyscanner, SCANSTATE_GRE); return GRE; }
-"gretap"		{ scanner_push_start_cond(yyscanner, SCANSTATE_GRE); return GRETAP; }
+<*>"gre"		{ scanner_push_start_cond(yyscanner, SCANSTATE_GRE); return GRE; }
+<*>"gretap"		{ scanner_push_start_cond(yyscanner, SCANSTATE_GRE); return GRETAP; }
 
-"tcp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TCP); return TCP; }
+<*>"tcp"		{ scanner_push_start_cond(yyscanner, SCANSTATE_TCP); return TCP; }
 
-"dccp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_DCCP); return DCCP; }
+<*>"dccp"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_DCCP); return DCCP; }
 
-"sctp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_SCTP); return SCTP; }
+<*>"sctp"		{ scanner_push_start_cond(yyscanner, SCANSTATE_SCTP); return SCTP; }
 
 <SCANSTATE_SCTP>{
 	"chunk"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_SCTP_CHUNK); return CHUNK; }
@@ -724,45 +724,45 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"new-cum-tsn"		{ return NEW_CUM_TSN; }
 }
 
-"rt"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT; }
-"rt0"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT0; }
-"rt2"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT2; }
-"srh"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT4; }
+<*>"rt"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT; }
+<*>"rt0"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT0; }
+<*>"rt2"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT2; }
+<*>"srh"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT4; }
 <SCANSTATE_EXPR_RT,SCANSTATE_STMT_NAT,SCANSTATE_IP,SCANSTATE_IP6>"addr"			{ return ADDR; }
 
-"hbh"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_HBH); return HBH; }
+<*>"hbh"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_HBH); return HBH; }
 
-"frag"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_FRAG); return FRAG; }
+<*>"frag"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_FRAG); return FRAG; }
 <SCANSTATE_EXPR_FRAG>{
 	"reserved2"		{ return RESERVED2; }
 	"more-fragments"	{ return MORE_FRAGMENTS; }
 }
 
-"dst"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_DST); return DST; }
-
-"mh"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_MH); return MH; }
-
-"meta"			{ scanner_push_start_cond(yyscanner, SCANSTATE_META); return META; }
-"mark"			{ return MARK; }
-"iif"			{ return IIF; }
-"iifname"		{ return IIFNAME; }
-"iiftype"		{ return IIFTYPE; }
-"oif"			{ return OIF; }
-"oifname"		{ return OIFNAME; }
-"oiftype"		{ return OIFTYPE; }
-"skuid"			{ return SKUID; }
-"skgid"			{ return SKGID; }
-"nftrace"		{ return NFTRACE; }
-"rtclassid"		{ return RTCLASSID; }
-"ibriport"		{ return IBRIDGENAME; } /* backwards compat */
-"ibrname"		{ return IBRIDGENAME; }
-"obriport"		{ return OBRIDGENAME; }	/* backwards compat */
-"obrname"		{ return OBRIDGENAME; }
-"pkttype"		{ return PKTTYPE; }
-"cpu"			{ return CPU; }
-"iifgroup"		{ return IIFGROUP; }
-"oifgroup"		{ return OIFGROUP; }
-"cgroup"		{ return CGROUP; }
+<*>"dst"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_DST); return DST; }
+
+<*>"mh"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_MH); return MH; }
+
+<*>"meta"		{ scanner_push_start_cond(yyscanner, SCANSTATE_META); return META; }
+<*>"mark"		{ return MARK; }
+<*>"iif"		{ return IIF; }
+<*>"iifname"		{ return IIFNAME; }
+<*>"iiftype"		{ return IIFTYPE; }
+<*>"oif"		{ return OIF; }
+<*>"oifname"		{ return OIFNAME; }
+<*>"oiftype"		{ return OIFTYPE; }
+<*>"skuid"		{ return SKUID; }
+<*>"skgid"		{ return SKGID; }
+<*>"nftrace"		{ return NFTRACE; }
+<*>"rtclassid"		{ return RTCLASSID; }
+<*>"ibriport"		{ return IBRIDGENAME; } /* backwards compat */
+<*>"ibrname"		{ return IBRIDGENAME; }
+<*>"obriport"		{ return OBRIDGENAME; }	/* backwards compat */
+<*>"obrname"		{ return OBRIDGENAME; }
+<*>"pkttype"		{ return PKTTYPE; }
+<*>"cpu"		{ return CPU; }
+<*>"iifgroup"		{ return IIFGROUP; }
+<*>"oifgroup"		{ return OIFGROUP; }
+<*>"cgroup"		{ return CGROUP; }
 <SCANSTATE_META>{
 	"nfproto"	{ return NFPROTO; }
 	"l4proto"	{ return L4PROTO; }
@@ -791,7 +791,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"classid"		{ return CLASSID; }
 }
 
-"ct"			{ scanner_push_start_cond(yyscanner, SCANSTATE_CT); return CT; }
+<*>"ct"			{ scanner_push_start_cond(yyscanner, SCANSTATE_CT); return CT; }
 <SCANSTATE_CT>{
 	"avgpkt"		{ return AVGPKT; }
 	"l3proto"		{ return L3PROTOCOL; }
@@ -812,13 +812,13 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"count"			{ return COUNT; }
 }
 
-"numgen"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_NUMGEN); return NUMGEN; }
+<*>"numgen"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_NUMGEN); return NUMGEN; }
 <SCANSTATE_EXPR_NUMGEN>{
 	"inc"		{ return INC; }
 }
 
-"jhash"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_HASH); return JHASH; }
-"symhash"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_HASH); return SYMHASH; }
+<*>"jhash"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_HASH); return JHASH; }
+<*>"symhash"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_HASH); return SYMHASH; }
 
 <SCANSTATE_EXPR_HASH>{
 	"seed"		{ return SEED; }
@@ -827,18 +827,18 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"mod"		{ return MOD; }
 	"offset"	{ return OFFSET; }
 }
-"dup"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_DUP); return DUP; }
-"fwd"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_FWD); return FWD; }
+<*>"dup"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_DUP); return DUP; }
+<*>"fwd"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_FWD); return FWD; }
 
-"fib"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_FIB); return FIB; }
+<*>"fib"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_FIB); return FIB; }
 
 <SCANSTATE_EXPR_FIB>{
 	"check"		{ return CHECK; }
 }
 
-"osf"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_OSF); return OSF; }
+<*>"osf"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_OSF); return OSF; }
 
-"synproxy"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_SYNPROXY); return SYNPROXY; }
+<*>"synproxy"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_SYNPROXY); return SYNPROXY; }
 <SCANSTATE_STMT_SYNPROXY>{
 	"wscale"		{ return WSCALE; }
 	"maxseg"		{ return MSS; }
@@ -848,7 +848,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"sack-perm"		{ return SACK_PERM; }
 }
 
-"tunnel"		{ scanner_push_start_cond(yyscanner, SCANSTATE_TUNNEL); return TUNNEL; }
+<*>"tunnel"		{ scanner_push_start_cond(yyscanner, SCANSTATE_TUNNEL); return TUNNEL; }
 <SCANSTATE_TUNNEL>{
 	"id"			{ return ID; }
 	"sport"			{ return SPORT; }
@@ -867,7 +867,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"data"			{ return DATA; }
 }
 
-"notrack"		{ return NOTRACK; }
+<*>"notrack"		{ return NOTRACK; }
 
 "all"			{ return ALL; }
 
@@ -880,9 +880,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "exists"		{ return EXISTS; }
 "missing"		{ return MISSING; }
 
-"exthdr"		{ return EXTHDR; }
+<*>"exthdr"		{ return EXTHDR; }
 
-"ipsec"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_IPSEC); return IPSEC; }
+<*>"ipsec"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_IPSEC); return IPSEC; }
 <SCANSTATE_EXPR_IPSEC>{
 	"reqid"			{ return REQID; }
 	"spnum"			{ return SPNUM; }
@@ -899,7 +899,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "secmark"		{ scanner_push_start_cond(yyscanner, SCANSTATE_SECMARK); return SECMARK; }
 
-"xt"			{ scanner_push_start_cond(yyscanner, SCANSTATE_XT); return XT; }
+<*>"xt"			{ scanner_push_start_cond(yyscanner, SCANSTATE_XT); return XT; }
 
 {addrstring}		{
 				yylval->string = xstrdup(yytext);
diff --git a/tests/shell/testcases/parsing/exclusive_start_cond b/tests/shell/testcases/parsing/exclusive_start_cond
new file mode 100755
index 0000000000000..12375af4603ba
--- /dev/null
+++ b/tests/shell/testcases/parsing/exclusive_start_cond
@@ -0,0 +1,168 @@
+#!/bin/bash
+
+stmts=()
+tcp_stmts=()
+udp_stmts=()
+ip6_stmts=()
+arp_stmts=()
+br_stmts=()
+netdev_stmts=()
+
+# verdict_stmt
+stmts+=(accept drop continue "jump c2" "goto c2" return)
+# verdict_map_stmt starts with concat_expr which eventually starts with primary_expr which starts with expr
+# match_stmt starts with relational_expr
+# meter_stmt
+stmts+=("meter foo { ip saddr counter }")
+# payload_stmt starts with payload_expr
+# stateful_stmt
+stmts+=(counter "limit rate 1/day" "quota 1bytes" "ct count 1" "last used 1d")
+# meta_stmt, defer to meta_expr with meta_key and meta_key_unqualified
+stmts+=(notrack "flow offload @ft" "nftrace set 1")
+# log_stmt
+stmts+=(log)
+# reject_stmt
+stmts+=(reject)
+# nat_stmt
+stmts+=("snat to 1" "dnat to 1")
+# tproxy_stmt
+tcp_stmts+=("tproxy to 1")
+# queue_stmt
+stmts+=("queue to 1")
+# ct_stmt
+stmts+=("ct mark set 1")
+# masq_stmt
+stmts+=(masquerade)
+# redir_stmt
+stmts+=(redirect)
+# dup_stmt
+netdev_stmts+=('dup to "lo"')
+# fwd_stmt
+netdev_stmts+=('fwd to "lo"')
+# set_stmt / map_stmt
+stmts+=("set add ip saddr @foo" "add @foo { ip saddr }" "update @foo { ip saddr }" "delete @foo { ip saddr }")
+# synproxy_stmt
+stmts+=(synproxy)
+# chain_stmt starts with jump/goto, covered by verdict_stmt above
+# optstrip_stmt
+stmts+=("reset tcp option echo")
+# XXX: xt_stmt is special, have to expect failure
+#stmts+=("xt foo bar")
+# objref_stmt is mostly covered by stateful_stmt above
+netdev_stmts+=("tunnel id 0")
+
+# primary_expr
+# XXX: parser_bison.y formally accepts string, integer_expr and variable_expr
+#      (via primary_expr/symbol_expr) on LHS, but it is relevant for map
+#      elements (data part) only it seems
+
+# selector_expr:
+# payload_expr
+stmts+=("@nh,0,4 0" "ether saddr 0" "vlan id 0")
+arp_stmts+=("arp htype 0")
+stmts+=("ip saddr 0" "icmp type 0" "igmp type 0")
+ip6_stmts+=("ip6 saddr ::")
+stmts+=("icmpv6 type 0" "ah spi 0" "esp spi 0" "comp cpi 0")
+stmts+=("udp sport 0" "udplite sport 0" "tcp sport 0" "dccp sport 0")
+stmts+=("sctp sport 0" "th sport 0")
+udp_stmts+=("vxlan vni 0" "geneve vni 0")
+stmts+=("gre flags 0" "gretap ip saddr 0")
+# exthdr_expr
+ip6_stmts+=("hbh nexthdr 0" "rt nexthdr 0" "rt0 addr[0] 0")
+ip6_stmts+=("rt2 addr ::" "srh tag 0" "frag nexthdr 0")
+ip6_stmts+=("dst nexthdr 0" "mh nexthdr 0" "exthdr hbh 0")
+# meta_expr
+stmts+=("meta length 0" "mark 0" "iif 0" "iifname foo" "iiftype 0")
+stmts+=("oif 0" "oifname foo" "oiftype 0" "skuid 0" "skgid 0" "rtclassid 0")
+stmts+=("pkttype 0" "cpu 0" "iifgroup 0" "oifgroup 0" "cgroup 0" "ipsec 0")
+stmts+=("time 0" "day 0" "hour 0")
+br_stmts+=("ibriport foo" "ibrname foo" "obriport foo" "obrname foo")
+# tunnel_expr covered by objref_stmt above
+# socket_expr
+stmts+=("socket mark 0")
+# rt_expr covered by exthdr_expr above
+# ct_expr covered by ct_stmt above
+# numgen_expr
+stmts+=("numgen inc mod 3 0")
+# hash_expr
+stmts+=("jhash ip saddr mod 3 seed 1 0" "symhash mod 3 0")
+# fib_expr
+stmts+=("fib daddr . iif check exists")
+# osf_expr
+stmts+=("osf name foo")
+# xfrm_expr
+stmts+=("ipsec in spi 0")
+
+$NFT -f - <<EOF
+table t {
+	flowtable ft {
+		hook ingress priority 0;
+	}
+	chain c {
+	}
+	chain c2 {
+	}
+}
+table ip6 t {
+	chain c {
+	}
+}
+table arp t {
+	chain c {
+	}
+}
+table bridge t {
+	chain c {
+	}
+}
+table netdev t {
+	chain c {
+	}
+}
+EOF
+
+RC=0
+for stmt in "${stmts[@]}"; do
+	$NFT add rule t c "limit rate 1/second $stmt" || {
+		echo "appending $stmt failed"
+		RC=1
+	}
+done
+for stmt in "${tcp_stmts[@]}"; do
+	$NFT add rule t c "meta l4proto tcp limit rate 1/second $stmt" || {
+		echo "appending $stmt failed"
+		RC=1
+	}
+done
+for stmt in "${udp_stmts[@]}"; do
+	$NFT add rule t c "meta l4proto udp limit rate 1/second $stmt" || {
+		echo "appending $stmt failed"
+		RC=1
+	}
+done
+for stmt in "${ip6_stmts[@]}"; do
+	$NFT add rule ip6 t c "meta l4proto tcp limit rate 1/second $stmt" || {
+		echo "appending $stmt failed"
+		RC=1
+	}
+done
+for stmt in "${arp_stmts[@]}"; do
+	$NFT add rule arp t c "meta l4proto tcp limit rate 1/second $stmt" || {
+		echo "appending $stmt failed"
+		RC=1
+	}
+done
+for stmt in "${br_stmts[@]}"; do
+	$NFT add rule bridge t c "meta l4proto tcp limit rate 1/second $stmt" || {
+		echo "appending $stmt failed"
+		RC=1
+	}
+done
+for stmt in "${netdev_stmts[@]}"; do
+	$NFT add rule netdev t c "meta l4proto tcp limit rate 1/second $stmt" || {
+		echo "appending $stmt failed"
+		RC=1
+	}
+done
+exit $RC
+
-- 
2.54.0

