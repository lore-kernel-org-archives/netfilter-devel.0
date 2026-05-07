Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FD232FA18
	for <netfilter-devel@vger.kernel.org>; Thu,  7 May 2026 20:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778186322; cv=none; b=EMkoEhUsjaleqTW8vBeANlvn64FmwqO+Fugeb88h0IvySVz0JX3dwmyJUfEAJLGoPvBLgJkIhTcxfVylMpeLKZbaW4uRjBfVTam2xAed8SbmoU3SdKd8mvGTRhxiv3rUh3XiaGNpM6XfhwxC6xhPT68oB6Jmnck7LwDHGBr3l5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778186322; c=relaxed/simple;
	bh=7xbj/wXCyzzR6h+FTH7ggyh1r/ljbFO8kOVdlPS1nsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m0UW/oPwPf9ddXaU6p+OG/upoDEW/v6IqQem5CXr4yEvc9aOTHfe9nMRHAnL+C5yfBcWLCMXuFh3vOmh/LeORXL5DiIB9zUYxq1Nc2/DqG/bvzCdpiSw0SOdG1h3/QBtFHhCZC1FaUvm3jdDJiQvfob6KD09llBbTN3dd1J5wXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nBGkKcy4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nBGkKcy4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TGJ9nUcozsdmE4u6SNmcJ5odvJCgUHnX0OOUBLciV6U=; b=nBGkKcy4tQyuROfcf8LwdzsA4o
	Yzj2ijEoISVrgQTTCiFIQvpzbtY4ZuB9tETncRvZpmILvt9b3TGXt8uUzjtAE2ShLe9sPKou8DGr0
	Xmq+CfLnP0CAGMAiyxc6Uc6Fi3H+2960wFqYDQRpZQiSAVODKeaFPJMAB4RAGiEggiJPIb1l8hpIc
	tuus+aW5hP3qDofNbHjZa/sjYiTMA8HpxkCOxKIybbjA/tMnEEMzxPEtpYAHu0qGn9cJhXUplv+bp
	gSniuoJS2TcF76G5LFx5inw/N2Ns9EDb/0xdv39bMJTSlRf5XZ1FZaxNZ7tMt8RbIlCw82nAxckv4
	iRESrn5A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wL5UL-000000006IU-1FBj;
	Thu, 07 May 2026 22:38:29 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH] scanner: Accept all statements' first words in all scopes
Date: Thu,  7 May 2026 22:38:24 +0200
Message-ID: <20260507203824.3560155-1-phil@nwl.cc>
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
 src/scanner.l | 188 +++++++++++++++++++++++++-------------------------
 1 file changed, 94 insertions(+), 94 deletions(-)

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
-- 
2.54.0

