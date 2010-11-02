From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH]extensions/tos_values.c mask value not accurate in certain
 condition
Date: Tue, 2 Nov 2010 09:20:25 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011020845470.6543@obet.zrqbmnf.qr>
References: <4CCFA111.8090001@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, Joe Jin <joe.jin@oracle.com>,
	DuanZhenzhong <zhenzhong.duan@oracle.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44894 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab0KBIU1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 04:20:27 -0400
In-Reply-To: <4CCFA111.8090001@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-11-02 06:26, DuanZhenzhong wrote:

>scene:
># iptables -V
>iptables v1.4.10
># iptables -v -t mangle -A MANGLE_OUTPUT -p tcp --dport 20 -j TOS
>--set-tos 8
>TOS tcp opt -- in * out * 0.0.0.0/0 -> 0.0.0.0/0 tcp dpt:20 TOS set
>0x08/0xff
># iptables -v -t mangle -A MANGLE_OUTPUT -p tcp --dport 20 -j TOS
>--set-tos Maximize-Throughput
>TOS tcp opt -- in * out * 0.0.0.0/0 -> 0.0.0.0/0 tcp dpt:20 TOS set
>0x08/0x3f
>
>mask value is different for the same tos value. This is because below
>code piece:
>static bool tos_parse_numeric(const char *str, struct tos_value_mask *tvm,
>unsigned int bits)
>{
>const unsigned int max = (1 << bits) - 1;
>......
>tvm->mask = max;
>......
>static bool tos_parse_symbolic(const char *str, struct tos_value_mask *tvm,
>unsigned int def_mask)
>{
>const unsigned int max = UINT8_MAX;
>const struct tos_symbol_info *symbol;
>char *tmp;
>
>if (xtables_strtoui(str, &tmp, NULL, 0, max))
>return tos_parse_numeric(str, tvm, max);
>
>/* Do not consider ECN bits */
>tvm->mask = def_mask;
>.......
>For tos value 8, bits shift lead to a overflow and trim, so the mask is
>0xff no matter what the def_mask is.

>For tos symbol Maximize-Throughput, tvm->mask got def_mask 0x3f.

This at least is intended.



Patrick, please grab from
	git://dev.medozas.de/iptables master

parent 600f38db82548a683775fd89b6e136673e924097 (v1.4.9-24-g600f38d)
commit 648fd1ad68ae2ec675ac07efee80783912535404
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Nov 2 09:10:34 2010 +0100

libxt_TOS: avoid an undesired overflowing computation

The @bits parameter was wrongly labeled and should have been @max
already. This makes the - overflowing - 1<<bits redundant of course.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/tos_values.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/extensions/tos_values.c b/extensions/tos_values.c
index 10add19..a65ef25 100644
--- a/extensions/tos_values.c
+++ b/extensions/tos_values.c
@@ -26,15 +26,13 @@ static const struct tos_symbol_info {
 /*
  * tos_parse_numeric - parse sth. like "15/255"
  *
- * @s:		input string
- * @info:	accompanying structure
- * @bits:	number of bits that are allowed
- *		(8 for IPv4 TOS field, 4 for IPv6 Priority Field)
+ * @str:	input string
+ * @tvm:	(value/mask) tuple
+ * @max:	maximum allowed value (must be pow(2,some_int)-1)
  */
 static bool tos_parse_numeric(const char *str, struct tos_value_mask *tvm,
-                              unsigned int bits)
+                              unsigned int max)
 {
-	const unsigned int max = (1 << bits) - 1;
 	unsigned int value;
 	char *end;
 
@@ -56,17 +54,22 @@ static bool tos_parse_numeric(const char *str, struct tos_value_mask *tvm,
 	return true;
 }
 
+/**
+ * @str:	input string
+ * @tvm:	(value/mask) tuple
+ * @def_mask:	mask to force when a symbolic name is used
+ */
 static bool tos_parse_symbolic(const char *str, struct tos_value_mask *tvm,
     unsigned int def_mask)
 {
-	const unsigned int max = UINT8_MAX;
+	static const unsigned int max = UINT8_MAX;
 	const struct tos_symbol_info *symbol;
 	char *tmp;
 
 	if (xtables_strtoui(str, &tmp, NULL, 0, max))
 		return tos_parse_numeric(str, tvm, max);
 
-	/* Do not consider ECN bits */
+	/* Do not consider ECN bits when using preset names */
 	tvm->mask = def_mask;
 	for (symbol = tos_symbol_names; symbol->name != NULL; ++symbol)
 		if (strcasecmp(str, symbol->name) == 0) {
-- 
# Created with git-export-patch
