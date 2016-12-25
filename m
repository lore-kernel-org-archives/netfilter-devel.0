From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] ct: add average bytes per packet counter support
Date: Sun, 25 Dec 2016 20:12:55 +0800
Message-ID: <1482667975-736-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:60368 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752798AbcLYMNl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Dec 2016 07:13:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Similar to connbytes extension in iptables, now you can use it to match
average bytes per packet a connection has transferred so far.

For example, match avgpkt in "BOTH" diretion:
  # nft add rule x y ct avgpkt \> 100

Match avgpkt in reply direction:
  # nft add rule x y ct reply avgpkt \< 900

Or match avgpkt in original direction:
  # nft add rule x y ct original avgpkt \> 200

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 doc/nft.xml                         | 13 ++++++++++---
 include/linux/netfilter/nf_tables.h |  5 +++++
 src/ct.c                            |  2 ++
 src/parser_bison.y                  |  2 ++
 src/scanner.l                       |  1 +
 tests/py/any/ct.t                   |  3 +++
 tests/py/any/ct.t.payload           | 12 ++++++++++++
 7 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 8026d85..a421278 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2112,9 +2112,9 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 			</para>
 			<para>
 				There are three types of conntrack expressions. Some conntrack expressions require the flow
-				direction before the conntrack key, others must be used directly because they are
-				direction agnostic.  The <command>packets<command> and </command>bytes</command> keywords can be used
-				with or without a direction.  If the direction is omitted, the sum of the original and the reply
+				direction before the conntrack key, others must be used directly because they are direction agnostic.
+				The <command>packets</command>, <command>bytes</command> and <command>avgpkt</command> keywords can be
+				used with or without a direction. If the direction is omitted, the sum of the original and the reply
 				direction is returned.
 			</para>
 			<para>
@@ -2132,6 +2132,7 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 						<arg>protocol</arg>
 						<arg>bytes</arg>
 						<arg>packets</arg>
+						<arg>avgpkt</arg>
 					</group>
 				</cmdsynopsis>
 				<cmdsynopsis>
@@ -2149,6 +2150,7 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 						<arg>proto-dst</arg>
 						<arg>bytes</arg>
 						<arg>packets</arg>
+						<arg>avgpkt</arg>
 					</group>
 				</cmdsynopsis>
 			</para>
@@ -2242,6 +2244,11 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 								<entry>bytecount seen, see description for <command>packets</command> keyword</entry>
 								<entry>integer (64 bit)</entry>
 							</row>
+							<row>
+								<entry>avgpkt</entry>
+								<entry>average bytes per packet, see description for <command>packets</command> keyword</entry>
+								<entry>integer (64 bit)</entry>
+							</row>
 						</tbody>
 					</tgroup>
 				</table>
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index f030e59..031c119 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -845,6 +845,10 @@ enum nft_rt_attributes {
  * @NFT_CT_PROTOCOL: conntrack layer 4 protocol
  * @NFT_CT_PROTO_SRC: conntrack layer 4 protocol source
  * @NFT_CT_PROTO_DST: conntrack layer 4 protocol destination
+ * @NFT_CT_LABELS: conntrack labels
+ * @NFT_CT_PKTS: conntrack packets
+ * @NFT_CT_BYTES: conntrack bytes
+ * @NFT_CT_AVGPKT: conntrack average bytes per packet
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -863,6 +867,7 @@ enum nft_ct_keys {
 	NFT_CT_LABELS,
 	NFT_CT_PKTS,
 	NFT_CT_BYTES,
+	NFT_CT_AVGPKT,
 };
 
 /**
diff --git a/src/ct.c b/src/ct.c
index d079289..31c7a4b 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -232,6 +232,8 @@ static const struct ct_template ct_templates[] = {
 					      BYTEORDER_HOST_ENDIAN, 64),
 	[NFT_CT_PKTS]		= CT_TEMPLATE("packets", &integer_type,
 					      BYTEORDER_HOST_ENDIAN, 64),
+	[NFT_CT_AVGPKT]		= CT_TEMPLATE("avgpkt", &integer_type,
+					      BYTEORDER_HOST_ENDIAN, 64),
 };
 
 static void ct_expr_print(const struct expr *expr)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index deaaf06..d2e6c17 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -363,6 +363,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token COUNTER			"counter"
 %token PACKETS			"packets"
 %token BYTES			"bytes"
+%token AVGPKT			"avgpkt"
 
 %token LOG			"log"
 %token PREFIX			"prefix"
@@ -2700,6 +2701,7 @@ ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
 
 ct_key_counters		:	BYTES		{ $$ = NFT_CT_BYTES; }
 			|	PACKETS		{ $$ = NFT_CT_PKTS; }
+			|	AVGPKT		{ $$ = NFT_CT_AVGPKT; }
 			;
 
 ct_stmt			:	CT	ct_key		SET	expr
diff --git a/src/scanner.l b/src/scanner.l
index 625023f..4aaf2bb 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -292,6 +292,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "counter"		{ return COUNTER; }
 "packets"		{ return PACKETS; }
 "bytes"			{ return BYTES; }
+"avgpkt"		{ return AVGPKT; }
 
 "log"			{ return LOG; }
 "prefix"		{ return PREFIX; }
diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 76be185..2cfbfe1 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -80,6 +80,9 @@ ct original bytes \> 100000;ok;ct original bytes > 100000
 ct reply packets \< 100;ok;ct reply packets < 100
 ct bytes \> 100000;ok;ct bytes > 100000
 
+ct avgpkt \> 200;ok;ct avgpkt > 200
+ct original avgpkt \< 500;ok;ct original avgpkt < 500
+
 # bogus direction
 ct both bytes gt 1;fail
 # nonsensical
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 90fce9f..3370bca 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -361,6 +361,18 @@ ip test-ip4 output
   [ byteorder reg 1 = hton(reg 1, 8, 8) ]
   [ cmp gt reg 1 0x00000000 0xa0860100 ]
 
+# ct avgpkt \> 200
+ip test-ip4 output
+  [ ct load avgpkt => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 8, 8) ]
+  [ cmp gt reg 1 0x00000000 0xc8000000 ]
+
+# ct original avgpkt \< 500
+ip test-ip4 output
+  [ ct load avgpkt => reg 1 , dir original ]
+  [ byteorder reg 1 = hton(reg 1, 8, 8) ]
+  [ cmp lt reg 1 0x00000000 0xf4010000 ]
+
 # ct status expected,seen-reply,assured,confirmed,snat,dnat,dying
 ip test-ip4 output
   [ ct load status => reg 1 ]
-- 
2.5.5


