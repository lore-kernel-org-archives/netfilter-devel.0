From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 13/13: fix string extension for case insensitive pattern matching
Date: Mon,  7 Jul 2008 14:05:32 +0200 (MEST)
Message-ID: <20080707120531.4975.5662.sendpatchset@localhost.localdomain>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58407 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbYGGMFe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:05:34 -0400
In-Reply-To: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: fix string extension for case insensitive pattern matching

The flag XT_STRING_FLAG_IGNORECASE indicates case insensitive string
matching. netfilter can find cmd.exe, Cmd.exe, cMd.exe and etc easily.

A new revision 1 was added, in the meantime invert of xt_string_info
was moved into flags as a flag. If revision is 1, The flag
XT_STRING_FLAG_INVERT indicates invert matching.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c18236f6c1161e4a95daac6162754e90d363610d
tree cc5b5aec980ec1c85b4a845d626029d7974b3753
parent 1dca522180f8a6f882cdef795f49595c05467bb2
author Joonwoo Park <joonwpark81@gmail.com> Mon, 07 Jul 2008 13:26:48 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:26:48 +0200

 include/linux/netfilter/xt_string.h |   15 +++++++++++++-
 net/netfilter/xt_string.c           |   38 +++++++++++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/xt_string.h b/include/linux/netfilter/xt_string.h
index bb21dd1..8a6ba7b 100644
--- a/include/linux/netfilter/xt_string.h
+++ b/include/linux/netfilter/xt_string.h
@@ -4,6 +4,11 @@
 #define XT_STRING_MAX_PATTERN_SIZE 128
 #define XT_STRING_MAX_ALGO_NAME_SIZE 16
 
+enum {
+	XT_STRING_FLAG_INVERT		= 0x01,
+	XT_STRING_FLAG_IGNORECASE	= 0x02
+};
+
 struct xt_string_info
 {
 	u_int16_t from_offset;
@@ -11,7 +16,15 @@ struct xt_string_info
 	char	  algo[XT_STRING_MAX_ALGO_NAME_SIZE];
 	char 	  pattern[XT_STRING_MAX_PATTERN_SIZE];
 	u_int8_t  patlen;
-	u_int8_t  invert;
+	union {
+		struct {
+			u_int8_t  invert;
+		} v0;
+
+		struct {
+			u_int8_t  flags;
+		} v1;
+	} u;
 
 	/* Used internally by the kernel */
 	struct ts_config __attribute__((aligned(8))) *config;
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 72f694d..4903182 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -29,12 +29,16 @@ string_mt(const struct sk_buff *skb, const struct net_device *in,
 {
 	const struct xt_string_info *conf = matchinfo;
 	struct ts_state state;
+	int invert;
 
 	memset(&state, 0, sizeof(struct ts_state));
 
+	invert = (match->revision == 0 ? conf->u.v0.invert :
+				    conf->u.v1.flags & XT_STRING_FLAG_INVERT);
+
 	return (skb_find_text((struct sk_buff *)skb, conf->from_offset,
 			     conf->to_offset, conf->config, &state)
-			     != UINT_MAX) ^ conf->invert;
+			     != UINT_MAX) ^ invert;
 }
 
 #define STRING_TEXT_PRIV(m) ((struct xt_string_info *)(m))
@@ -46,6 +50,7 @@ string_mt_check(const char *tablename, const void *ip,
 {
 	struct xt_string_info *conf = matchinfo;
 	struct ts_config *ts_conf;
+	int flags = TS_AUTOLOAD;
 
 	/* Damn, can't handle this case properly with iptables... */
 	if (conf->from_offset > conf->to_offset)
@@ -54,8 +59,15 @@ string_mt_check(const char *tablename, const void *ip,
 		return false;
 	if (conf->patlen > XT_STRING_MAX_PATTERN_SIZE)
 		return false;
+	if (match->revision == 1) {
+		if (conf->u.v1.flags &
+		    ~(XT_STRING_FLAG_IGNORECASE | XT_STRING_FLAG_INVERT))
+			return false;
+		if (conf->u.v1.flags & XT_STRING_FLAG_IGNORECASE)
+			flags |= TS_IGNORECASE;
+	}
 	ts_conf = textsearch_prepare(conf->algo, conf->pattern, conf->patlen,
-				     GFP_KERNEL, TS_AUTOLOAD);
+				     GFP_KERNEL, flags);
 	if (IS_ERR(ts_conf))
 		return false;
 
@@ -72,6 +84,17 @@ static void string_mt_destroy(const struct xt_match *match, void *matchinfo)
 static struct xt_match string_mt_reg[] __read_mostly = {
 	{
 		.name 		= "string",
+		.revision	= 0,
+		.family		= AF_INET,
+		.checkentry	= string_mt_check,
+		.match 		= string_mt,
+		.destroy 	= string_mt_destroy,
+		.matchsize	= sizeof(struct xt_string_info),
+		.me 		= THIS_MODULE
+	},
+	{
+		.name 		= "string",
+		.revision	= 1,
 		.family		= AF_INET,
 		.checkentry	= string_mt_check,
 		.match 		= string_mt,
@@ -81,6 +104,17 @@ static struct xt_match string_mt_reg[] __read_mostly = {
 	},
 	{
 		.name 		= "string",
+		.revision	= 0,
+		.family		= AF_INET6,
+		.checkentry	= string_mt_check,
+		.match 		= string_mt,
+		.destroy 	= string_mt_destroy,
+		.matchsize	= sizeof(struct xt_string_info),
+		.me 		= THIS_MODULE
+	},
+	{
+		.name 		= "string",
+		.revision	= 1,
 		.family		= AF_INET6,
 		.checkentry	= string_mt_check,
 		.match 		= string_mt,
