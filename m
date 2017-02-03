From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 6/9] src: add conntrack zone support
Date: Fri,  3 Feb 2017 13:35:53 +0100
Message-ID: <20170203123556.17357-7-fw@strlen.de>
References: <20170203123556.17357-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41976 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752700AbdBCMf7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 07:35:59 -0500
In-Reply-To: <20170203123556.17357-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This enables zone get/set support.

As the zone can be optionally tied to a direction as well we need a new
token for this (unless we turn reply/original into tokens in which case
we could handle zone via STRING).

There was some discussion on how zone set support should be handled,
especially 'zone set 1'.

There are several issues to consider:

1. its not possible to change a zone 'later on', any given
conntrack flow has exactly one zone for its entire lifetime.

2. to create conntracks in a given zone, the zone therefore has to be
assigned *before* the packet gets picked up by conntrack (so that lookup
finds the correct existing flow or the flow is created with the desired
zone id).  In iptables, this is enforced because zones are assigned with
CT target and this is restricted to the 'raw' table in iptables, which
runs after defragmentation but before connection tracking.

3. Thus, in nftables the 'ct zone set' rule needs to hook before
conntrack too, e.g. via

 table raw {
  chain pre {
   type filter hook prerouting priority -300;
   iif eth3 ct zone set 23
  }
  chain out {
   type filter hook output priority -300;
   oif eth3 ct zone set 23
  }
 }

... but this is not enforced.

There were two alternatives to better document this.
One was to use an explicit 'template' keyword:
  nft ... template zone set 23

... but 'connection tracking templates' are a kernel detail
that users should not and need not know about.

The other one was to use the meta keyword instead since
we're (from a practical point of view) assigning the zone to
the packet, not the conntrack:

 nft ... meta zone set 23

However, next patch also supports 'directional' zones, and

 nft ... meta original zone 23

makes no sense because 'direction' refers to a direction as understood
by the connection tracker.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml                         | 10 +++++++++-
 include/linux/netfilter/nf_tables.h |  1 +
 src/ct.c                            |  2 ++
 src/parser_bison.y                  | 10 ++++++----
 src/scanner.l                       |  1 +
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 78e112f3974b..0a81728789bf 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2126,7 +2126,8 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 				direction before the conntrack key, others must be used directly because they are direction agnostic.
 				The <command>packets</command>, <command>bytes</command> and <command>avgpkt</command> keywords can be
 				used with or without a direction. If the direction is omitted, the sum of the original and the reply
-				direction is returned.
+				direction is returned.  The same is true for the <command>zone</command>, if a direction is given, the zone
+				is only matched if the zone id is tied to the given direction.
 			</para>
 			<para>
 				<cmdsynopsis>
@@ -2144,6 +2145,7 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 						<arg>bytes</arg>
 						<arg>packets</arg>
 						<arg>avgpkt</arg>
+						<arg>zone</arg>
 					</group>
 				</cmdsynopsis>
 				<cmdsynopsis>
@@ -2162,6 +2164,7 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 						<arg>bytes</arg>
 						<arg>packets</arg>
 						<arg>avgpkt</arg>
+						<arg>zone</arg>
 					</group>
 				</cmdsynopsis>
 			</para>
@@ -2260,6 +2263,11 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 								<entry>average bytes per packet, see description for <command>packets</command> keyword</entry>
 								<entry>integer (64 bit)</entry>
 							</row>
+							<row>
+								<entry>zone</entry>
+								<entry>conntrack zone</entry>
+								<entry>integer (16 bit)</entry>
+							</row>
 						</tbody>
 					</tgroup>
 				</table>
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b00a05d1ee56..fc0ed47d974d 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -883,6 +883,7 @@ enum nft_ct_keys {
 	NFT_CT_PKTS,
 	NFT_CT_BYTES,
 	NFT_CT_AVGPKT,
+	NFT_CT_ZONE,
 };
 
 /**
diff --git a/src/ct.c b/src/ct.c
index 31c7a4b1beda..dffa0e5fa44a 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -234,6 +234,8 @@ static const struct ct_template ct_templates[] = {
 					      BYTEORDER_HOST_ENDIAN, 64),
 	[NFT_CT_AVGPKT]		= CT_TEMPLATE("avgpkt", &integer_type,
 					      BYTEORDER_HOST_ENDIAN, 64),
+	[NFT_CT_ZONE]		= CT_TEMPLATE("zone", &u32_type,
+					      BYTEORDER_HOST_ENDIAN, 16),
 };
 
 static void ct_expr_print(const struct expr *expr)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index d543e3ea2515..14d924810f9a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -357,6 +357,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token L3PROTOCOL		"l3proto"
 %token PROTO_SRC		"proto-src"
 %token PROTO_DST		"proto-dst"
+%token ZONE			"zone"
 
 %token COUNTER			"counter"
 %token NAME			"name"
@@ -610,7 +611,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <expr>			ct_expr
 %destructor { expr_free($$); }	ct_expr
-%type <val>			ct_key		ct_key_dir	ct_key_counters
+%type <val>			ct_key		ct_key_dir	ct_key_dir_optional
 
 %type <expr>			fib_expr
 %destructor { expr_free($$); }	fib_expr
@@ -2949,7 +2950,7 @@ ct_expr			: 	CT	ct_key
 ct_key			:	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
 			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
 			|	MARK		{ $$ = NFT_CT_MARK; }
-			|	ct_key_counters
+			|	ct_key_dir_optional
 			;
 ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
 			|	DADDR		{ $$ = NFT_CT_DST; }
@@ -2957,12 +2958,13 @@ ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
 			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
 			|	PROTO_SRC	{ $$ = NFT_CT_PROTO_SRC; }
 			|	PROTO_DST	{ $$ = NFT_CT_PROTO_DST; }
-			|	ct_key_counters
+			|	ct_key_dir_optional
 			;
 
-ct_key_counters		:	BYTES		{ $$ = NFT_CT_BYTES; }
+ct_key_dir_optional	:	BYTES		{ $$ = NFT_CT_BYTES; }
 			|	PACKETS		{ $$ = NFT_CT_PKTS; }
 			|	AVGPKT		{ $$ = NFT_CT_AVGPKT; }
+			|	ZONE		{ $$ = NFT_CT_ZONE; }
 			;
 
 ct_stmt			:	CT	ct_key		SET	expr
diff --git a/src/scanner.l b/src/scanner.l
index d0d25ea94600..bb7e83c3cfd7 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -460,6 +460,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "l3proto"		{ return L3PROTOCOL; }
 "proto-src"		{ return PROTO_SRC; }
 "proto-dst"		{ return PROTO_DST; }
+"zone"			{ return ZONE; }
 
 "numgen"		{ return NUMGEN; }
 "inc"			{ return INC; }
-- 
2.10.2

