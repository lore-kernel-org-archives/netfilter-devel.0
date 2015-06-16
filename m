From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,next-4.2,v2] src: add netdev family support
Date: Tue, 16 Jun 2015 18:25:06 +0200
Message-ID: <1434471906-8583-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34695 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbbFPQTu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 12:19:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for the new 'netdev' table. So far, this table allows
you to create filter chains from ingress.

The following example shows a very simple base configuration with one table that
contains a basechain that is attached to the 'eth0':

 # nft list table netdev filter
 table netdev filter {
        chain eth0-ingress {
                type filter hook ingress device eth0 priority 0; policy accept;
        }
 }

You can test that this works by adding a simple rule with counters:

 # nft add rule netdev filter eth0-ingress counter

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.xml               |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/netfilter.h |    8 ++++++++
 include/rule.h            |    2 ++
 src/evaluate.c            |    4 ++++
 src/netlink.c             |    7 +++++++
 src/parser_bison.y        |   34 ++++++++++++++++++++++++++++++++++
 src/payload.c             |    1 +
 src/proto.c               |    1 +
 src/rule.c                |   25 +++++++++++++++++++++----
 src/scanner.l             |    2 ++
 10 files changed, 122 insertions(+), 4 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 8d79016..d51876c 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -267,6 +267,14 @@ filter input iif $int_ifs accept
 						</para>
 					</listitem>
 				</varlistentry>
+				<varlistentry>
+					<term><option>netdev</option></term>
+					<listitem>
+						<para>
+							Netdev address family, handling packets from ingress.
+						</para>
+					</listitem>
+				</varlistentry>
 			</variablelist>
 		</para>
 		<para>
@@ -373,6 +381,38 @@ filter input iif $int_ifs accept
 				The bridge address family handles ethernet packets traversing bridge devices.
 			</para>
 		</refsect2>
+		<refsect2>
+			<title>Netdev address family</title>
+			<para>
+				The Netdev address family handles packets from ingress.
+			</para>
+			<para>
+				<table frame="all">
+					<title>Netdev address family hooks</title>
+					<tgroup cols='2' align='left' colsep='1' rowsep='1' pgwide="1">
+						<colspec colname='c1' colwidth="1*"/>
+						<colspec colname='c2' colwidth="5*"/>
+						<thead>
+							<row>
+								<entry>Hook</entry>
+								<entry>Description</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>ingress</entry>
+								<entry>
+									All packets entering the system are processed by this hook. It is invoked
+									before layer 3 protocol handlers and it can be used for early filtering and
+									policing.
+								</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+		</refsect2>
+
 	</refsect1>
 
 	<refsect1>
@@ -401,6 +441,7 @@ filter input iif $int_ifs accept
 				<member><literal>inet</literal></member>
 				<member><literal>arp</literal></member>
 				<member><literal>bridge</literal></member>
+				<member><literal>netdev</literal></member>
 			</simplelist>.
 
 			The <literal>inet</literal> address family is a dummy family which is used to create
@@ -457,6 +498,7 @@ filter input iif $int_ifs accept
 				<arg choice="req"><replaceable>hook</replaceable></arg>
 				<arg choice="req"><replaceable>priority</replaceable></arg>
 				<arg choice="req"><replaceable>policy</replaceable></arg>
+				<arg choice="req"><replaceable>device</replaceable></arg>
 			</cmdsynopsis>
 			<cmdsynopsis>
 				<group choice="req">
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index be0bc18..18075f9 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -32,6 +32,7 @@
 #define NF_DROP_ERR(x) (((-x) << 16) | NF_DROP)
 
 /* only for userspace compatibility */
+#ifndef __KERNEL__
 /* Generic cache responses from hook functions.
    <= 0x2000 is used for protocol-flags. */
 #define NFC_UNKNOWN 0x4000
@@ -39,6 +40,7 @@
 
 /* NF_VERDICT_BITS should be 8 now, but userspace might break if this changes */
 #define NF_VERDICT_BITS 16
+#endif
 
 enum nf_inet_hooks {
 	NF_INET_PRE_ROUTING,
@@ -49,11 +51,17 @@ enum nf_inet_hooks {
 	NF_INET_NUMHOOKS
 };
 
+enum nf_dev_hooks {
+	NF_NETDEV_INGRESS,
+	NF_NETDEV_NUMHOOKS
+};
+
 enum {
 	NFPROTO_UNSPEC =  0,
 	NFPROTO_INET   =  1,
 	NFPROTO_IPV4   =  2,
 	NFPROTO_ARP    =  3,
+	NFPROTO_NETDEV =  5,
 	NFPROTO_BRIDGE =  7,
 	NFPROTO_IPV6   = 10,
 	NFPROTO_DECNET = 12,
diff --git a/include/rule.h b/include/rule.h
index 5d44599..604de14 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -113,6 +113,7 @@ enum chain_flags {
  * @priority:	hook priority (base chains)
  * @policy:	default chain policy (base chains)
  * @type:	chain type
+ * @dev:	device (if any)
  * @rules:	rules contained in the chain
  */
 struct chain {
@@ -125,6 +126,7 @@ struct chain {
 	int			priority;
 	int			policy;
 	const char		*type;
+	const char		*dev;
 	struct scope		scope;
 	struct list_head	rules;
 };
diff --git a/src/evaluate.c b/src/evaluate.c
index d99b38f..0bf4fec 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1847,6 +1847,10 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 		else if (!strcmp(hook, "output"))
 			return NF_ARP_OUT;
 		break;
+	case NFPROTO_NETDEV:
+		if (!strcmp(hook, "ingress"))
+			return NF_NETDEV_INGRESS;
+		break;
 	default:
 		break;
 	}
diff --git a/src/netlink.c b/src/netlink.c
index 1167c95..bef33a1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -555,6 +555,9 @@ static int netlink_add_chain_batch(struct netlink_ctx *ctx,
 		if (chain->policy != -1)
 			nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_POLICY,
 					       chain->policy);
+		if (chain->dev != NULL)
+			nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_DEV,
+					       chain->dev);
 	}
 
 	netlink_dump_chain(nlc);
@@ -697,6 +700,10 @@ static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 			xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TYPE));
 		chain->policy          =
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_POLICY);
+		if (nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_DEV)) {
+			chain->dev	=
+				xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_DEV));
+		}
 		chain->flags        |= CHAIN_F_BASECHAIN;
 	}
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index eac3fcb..fab4c52 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -165,6 +165,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token DEFINE			"define"
 
 %token HOOK			"hook"
+%token DEVICE			"device"
 %token TABLE			"table"
 %token TABLES			"tables"
 %token CHAIN			"chain"
@@ -179,6 +180,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token RULESET			"ruleset"
 
 %token INET			"inet"
+%token NETDEV			"netdev"
 
 %token ADD			"add"
 %token UPDATE			"update"
@@ -1090,6 +1092,37 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
 				$<chain>0->priority	= -$7;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 			}
+			|	TYPE		STRING		HOOK		STRING		DEVICE	STRING	PRIORITY	NUM
+			{
+				$<chain>0->type		= chain_type_name_lookup($2);
+				if ($<chain>0->type == NULL) {
+					erec_queue(error(&@2, "unknown chain type %s", $2),
+						   state->msgs);
+					YYERROR;
+				}
+				$<chain>0->hookstr	= chain_hookname_lookup($4);
+				if ($<chain>0->hookstr == NULL) {
+					erec_queue(error(&@4, "unknown chain hook %s", $4),
+						   state->msgs);
+					YYERROR;
+				}
+				$<chain>0->dev		= $6;
+				$<chain>0->priority	= $8;
+				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
+			}
+			|	TYPE		STRING		HOOK		STRING		DEVICE	STRING	PRIORITY	DASH	NUM
+			{
+				$<chain>0->type		= chain_type_name_lookup($2);
+				if ($<chain>0->type == NULL) {
+					erec_queue(error(&@2, "unknown type name %s", $2),
+						   state->msgs);
+					YYERROR;
+				}
+				$<chain>0->hookstr	= chain_hookname_lookup($4);
+				$<chain>0->dev		= $6;
+				$<chain>0->priority	= -$9;
+				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
+			}
 			;
 
 policy_spec		:	POLICY		chain_policy
@@ -1137,6 +1170,7 @@ family_spec_explicit	:	IP		{ $$ = NFPROTO_IPV4; }
 			|	INET		{ $$ = NFPROTO_INET; }
 			|	ARP		{ $$ = NFPROTO_ARP; }
 			|	BRIDGE		{ $$ = NFPROTO_BRIDGE; }
+			|	NETDEV		{ $$ = NFPROTO_NETDEV; }
 			;
 
 table_spec		:	family_spec	identifier
diff --git a/src/payload.c b/src/payload.c
index 08578fd..1a9d491 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -215,6 +215,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 			}
 			break;
 		case NFPROTO_BRIDGE:
+		case NFPROTO_NETDEV:
 			switch (expr->payload.base) {
 			case PROTO_BASE_LL_HDR:
 				desc = &proto_eth;
diff --git a/src/proto.c b/src/proto.c
index 6302016..d40caeb 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -123,6 +123,7 @@ const struct proto_desc *proto_dev_desc(uint16_t type)
 
 const struct hook_proto_desc hook_proto_desc[] = {
 	[NFPROTO_BRIDGE]	= HOOK_PROTO_DESC(PROTO_BASE_LL_HDR,	  &proto_eth),
+	[NFPROTO_NETDEV]	= HOOK_PROTO_DESC(PROTO_BASE_LL_HDR,	  &proto_eth),
 	[NFPROTO_INET]		= HOOK_PROTO_DESC(PROTO_BASE_LL_HDR,	  &proto_inet),
 	[NFPROTO_IPV4]		= HOOK_PROTO_DESC(PROTO_BASE_NETWORK_HDR, &proto_ip),
 	[NFPROTO_IPV6]		= HOOK_PROTO_DESC(PROTO_BASE_NETWORK_HDR, &proto_ip6),
diff --git a/src/rule.c b/src/rule.c
index b2090dd..f930a37 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -333,6 +333,7 @@ static const char *chain_hookname_str_array[] = {
 	"forward",
 	"postrouting",
 	"output",
+	"ingress",
 	NULL,
 };
 
@@ -398,6 +399,8 @@ const char *family2str(unsigned int family)
 			return "ip6";
 		case NFPROTO_INET:
 			return "inet";
+		case NFPROTO_NETDEV:
+			return "netdev";
 		case NFPROTO_ARP:
 			return "arp";
 		case NFPROTO_BRIDGE:
@@ -441,6 +444,13 @@ static const char *hooknum2str(unsigned int family, unsigned int hooknum)
 		default:
 			break;
 		}
+		break;
+	case NFPROTO_NETDEV:
+		switch (hooknum) {
+		case NF_NETDEV_INGRESS:
+			return "ingress";
+		}
+		break;
 	default:
 		break;
 	};
@@ -465,10 +475,17 @@ static void chain_print(const struct chain *chain)
 
 	printf("\tchain %s {\n", chain->handle.chain);
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		printf("\t\ttype %s hook %s priority %d; policy %s;\n",
-		       chain->type,
-		       hooknum2str(chain->handle.family, chain->hooknum),
-		       chain->priority, chain_policy2str(chain->policy));
+		if (chain->dev != NULL) {
+			printf("\t\ttype %s hook %s device %s priority %d;\n",
+			       chain->type,
+			       hooknum2str(chain->handle.family, chain->hooknum),
+			       chain->dev, chain->priority);
+		} else {
+			printf("\t\ttype %s hook %s priority %d;\n",
+			       chain->type,
+			       hooknum2str(chain->handle.family, chain->hooknum),
+			       chain->priority);
+		}
 	}
 	list_for_each_entry(rule, &chain->rules, list) {
 		printf("\t\t");
diff --git a/src/scanner.l b/src/scanner.l
index 985ea2a..2d9871d 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -233,6 +233,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "describe"		{ return DESCRIBE; }
 
 "hook"			{ return HOOK; }
+"device"		{ return DEVICE; }
 "table"			{ return TABLE; }
 "tables"		{ return TABLES; }
 "chain"			{ return CHAIN; }
@@ -255,6 +256,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "to"			{ return TO; }
 
 "inet"			{ return INET; }
+"netdev"		{ return NETDEV; }
 
 "add"			{ return ADD; }
 "update"		{ return UPDATE; }
-- 
1.7.10.4

