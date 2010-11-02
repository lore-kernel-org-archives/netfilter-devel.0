From: DuanZhenzhong <zhenzhong.duan@oracle.com>
Subject: [PATCH]extensions/tos_values.c mask value not accurate in certain
 condition
Date: Tue, 02 Nov 2010 13:26:41 +0800
Message-ID: <4CCFA111.8090001@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: Joe Jin <joe.jin@oracle.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:20189 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956Ab0KBF1o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 01:27:44 -0400
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.2) with ESMTP id oA25ReBI008585
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Tue, 2 Nov 2010 05:27:42 GMT
Received: from acsmt354.oracle.com (acsmt354.oracle.com [141.146.40.154])
	by acsinet15.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id oA25RcUl006117
	for <netfilter-devel@vger.kernel.org>; Tue, 2 Nov 2010 05:27:39 GMT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

scene:
# iptables -V
iptables v1.4.10
# iptables -v -t mangle -A MANGLE_OUTPUT -p tcp --dport 20 -j TOS
--set-tos 8
TOS tcp opt -- in * out * 0.0.0.0/0 -> 0.0.0.0/0 tcp dpt:20 TOS set
0x08/0xff
# iptables -v -t mangle -A MANGLE_OUTPUT -p tcp --dport 20 -j TOS
--set-tos Maximize-Throughput
TOS tcp opt -- in * out * 0.0.0.0/0 -> 0.0.0.0/0 tcp dpt:20 TOS set
0x08/0x3f

mask value is different for the same tos value. This is because below
code piece:
static bool tos_parse_numeric(const char *str, struct tos_value_mask *tvm,
unsigned int bits)
{
const unsigned int max = (1 << bits) - 1;
......
tvm->mask = max;
......
static bool tos_parse_symbolic(const char *str, struct tos_value_mask *tvm,
unsigned int def_mask)
{
const unsigned int max = UINT8_MAX;
const struct tos_symbol_info *symbol;
char *tmp;

if (xtables_strtoui(str, &tmp, NULL, 0, max))
return tos_parse_numeric(str, tvm, max);

/* Do not consider ECN bits */
tvm->mask = def_mask;
.......
For tos value 8, bits shift lead to a overflow and trim, so the mask is
0xff no matter what the def_mask is.
For tos symbol Maximize-Throughput, tvm->mask got def_mask 0x3f.

PATCH:
diff -up iptables-1.4.10/extensions/tos_values.c.org
iptables-1.4.10/extensions/tos_values.c
--- iptables-1.4.10/extensions/tos_values.c.org 2010-11-02
13:08:32.000000000 +0800
+++ iptables-1.4.10/extensions/tos_values.c 2010-11-02
13:09:00.000000000 +0800
@@ -34,7 +34,7 @@ static const struct tos_symbol_info {
static bool tos_parse_numeric(const char *str, struct tos_value_mask *tvm,
unsigned int bits)
{
- const unsigned int max = (1 << bits) - 1;
+ const unsigned int max = bits;
unsigned int value;
char *end;

@@ -59,7 +59,7 @@ static bool tos_parse_numeric(const char
static bool tos_parse_symbolic(const char *str, struct tos_value_mask *tvm,
unsigned int def_mask)
{
- const unsigned int max = UINT8_MAX;
+ const unsigned int max = def_mask;
const struct tos_symbol_info *symbol;
char *tmp;

--------------------------------------------------------------------------
