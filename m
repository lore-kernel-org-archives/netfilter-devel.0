From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH][RESEND] libip6t_hl.c
Date: Wed, 7 May 2003 21:03:43 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0305072102490.18682@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="-23717851-615095886-1051099532=:4360"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-ID: <Pine.LNX.4.51.0305072102491.18682@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---23717851-615095886-1051099532=:4360
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.51.0305072102492.18682@dns.toxicfilms.tv>

[there was no response on this]

Hello,

Stephane Ouellette has sent me a patch to the libip6t_hl.c module
to make some cleanups. Here's the list of changes:
1- help() now indicates that the reverse match is supported.
2- final_check() was missing a single-quote.
3- C99 initializers
4- Simplify print() and save() to reduce the number of calls to printf().

Please apply.

Regards,
Maciej Soltysiak


--- netfilter.orig/userspace/extensions/libip6t_hl.c	2003-04-08 21:49:15.000000000 +0200
+++ netfilter/userspace/extensions/libip6t_hl.c	2003-04-23 13:52:30.000000000 +0200
@@ -3,6 +3,7 @@
  * Maciej Soltysiak <solt@dns.toxicfilms.tv>
  * Based on HW's ttl match
  * This program is released under the terms of GNU GPL
+ * Cleanups by Stephane Ouellette <ouellettes@videotron.ca>
  */

 #include <stdio.h>
@@ -18,7 +19,7 @@
 {
 	printf(
 "HL match v%s options:\n"
-"  --hl-eq value	Match hop limit value\n"
+"  --hl-eq [!] value	Match hop limit value\n"
 "  --hl-lt value	Match HL < value\n"
 "  --hl-gt value	Match HL > value\n"
 , IPTABLES_VERSION);
@@ -81,7 +82,6 @@
 			break;
 		default:
 			return 0;
-
 	}

 	return 1;
@@ -92,82 +92,61 @@
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
 			"HL match: You must specify one of "
-			"`--hl-eq', `--hl-lt', `--hl-gt");
+			"`--hl-eq', `--hl-lt', `--hl-gt'");
 }

 static void print(const struct ip6t_ip6 *ip,
 		const struct ip6t_entry_match *match,
 		int numeric)
 {
+	static const char *op[] = {
+		[IP6T_HL_EQ] = "==",
+		[IP6T_HL_NE] = "!=",
+		[IP6T_HL_LT] = "<",
+		[IP6T_HL_GT] = ">" };
+
 	const struct ip6t_hl_info *info =
 		(struct ip6t_hl_info *) match->data;

-	printf("HL match ");
-	switch (info->mode) {
-		case IP6T_HL_EQ:
-			printf("HL == ");
-			break;
-		case IP6T_HL_NE:
-			printf("HL != ");
-			break;
-		case IP6T_HL_LT:
-			printf("HL < ");
-			break;
-		case IP6T_HL_GT:
-			printf("HL > ");
-			break;
-	}
-	printf("%u ", info->hop_limit);
+	printf("HL match HL %s %u ", op[info->mode], info->hop_limit);
 }

 static void save(const struct ip6t_ip6 *ip,
 		const struct ip6t_entry_match *match)
 {
+	static const char *op[] = {
+		[IP6T_HL_EQ] = "eq",
+		[IP6T_HL_NE] = "eq !",
+		[IP6T_HL_LT] = "lt",
+		[IP6T_HL_GT] = "gt" };
+
 	const struct ip6t_hl_info *info =
 		(struct ip6t_hl_info *) match->data;

-	switch (info->mode) {
-		case IP6T_HL_EQ:
-			printf("--hl-eq ");
-			break;
-		case IP6T_HL_NE:
-			printf("! --hl-eq ");
-			break;
-		case IP6T_HL_LT:
-			printf("--hl-lt ");
-			break;
-		case IP6T_HL_GT:
-			printf("--hl-gt ");
-			break;
-		default:
-			/* error */
-			break;
-	}
-	printf("%u ", info->hop_limit);
+	printf("--hl-%s %u ", op[info->mode], info->hop_limit);
 }

 static struct option opts[] = {
-	{ "hl", 1, 0, '2' },
-	{ "hl-eq", 1, 0, '2'},
-	{ "hl-lt", 1, 0, '3'},
-	{ "hl-gt", 1, 0, '4'},
+	{ .name = "hl",    .has_arg = 1, .flag = 0, .val = '2' },
+	{ .name = "hl-eq", .has_arg = 1, .flag = 0, .val = '2' },
+	{ .name = "hl-lt", .has_arg = 1, .flag = 0, .val = '3' },
+	{ .name = "hl-gt", .has_arg = 1, .flag = 0, .val = '4' },
 	{ 0 }
 };

 static
 struct ip6tables_match hl = {
-	NULL,
-	"hl",
-	IPTABLES_VERSION,
-	IP6T_ALIGN(sizeof(struct ip6t_hl_info)),
-	IP6T_ALIGN(sizeof(struct ip6t_hl_info)),
-	&help,
-	&init,
-	&parse,
-	&final_check,
-	&print,
-	&save,
-	opts
+	.name          = "hl",
+	.version       = IPTABLES_VERSION,
+	.size          = IP6T_ALIGN(sizeof(struct ip6t_hl_info)),
+	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_hl_info)),
+	.help          = &help,
+	.init          = &init,
+	.parse         = &parse,
+	.final_check   = &final_check,
+	.print         = &print,
+	.save          = &save,
+	.extra_opts    = opts
 };

---23717851-615095886-1051099532=:4360
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME="hl.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0304231405320.4360@dns.toxicfilms.tv>
Content-Description: libip6t_hl.c
Content-Disposition: ATTACHMENT; FILENAME="hl.patch"

LS0tIG5ldGZpbHRlci5vcmlnL3VzZXJzcGFjZS9leHRlbnNpb25zL2xpYmlw
NnRfaGwuYwkyMDAzLTA0LTA4IDIxOjQ5OjE1LjAwMDAwMDAwMCArMDIwMA0K
KysrIG5ldGZpbHRlci91c2Vyc3BhY2UvZXh0ZW5zaW9ucy9saWJpcDZ0X2hs
LmMJMjAwMy0wNC0yMyAxMzo1MjozMC4wMDAwMDAwMDAgKzAyMDANCkBAIC0z
LDYgKzMsNyBAQA0KICAqIE1hY2llaiBTb2x0eXNpYWsgPHNvbHRAZG5zLnRv
eGljZmlsbXMudHY+DQogICogQmFzZWQgb24gSFcncyB0dGwgbWF0Y2gNCiAg
KiBUaGlzIHByb2dyYW0gaXMgcmVsZWFzZWQgdW5kZXIgdGhlIHRlcm1zIG9m
IEdOVSBHUEwNCisgKiBDbGVhbnVwcyBieSBTdGVwaGFuZSBPdWVsbGV0dGUg
PG91ZWxsZXR0ZXNAdmlkZW90cm9uLmNhPg0KICAqLw0KIA0KICNpbmNsdWRl
IDxzdGRpby5oPg0KQEAgLTE4LDcgKzE5LDcgQEANCiB7DQogCXByaW50ZigN
CiAiSEwgbWF0Y2ggdiVzIG9wdGlvbnM6XG4iDQotIiAgLS1obC1lcSB2YWx1
ZQlNYXRjaCBob3AgbGltaXQgdmFsdWVcbiINCisiICAtLWhsLWVxIFshXSB2
YWx1ZQlNYXRjaCBob3AgbGltaXQgdmFsdWVcbiINCiAiICAtLWhsLWx0IHZh
bHVlCU1hdGNoIEhMIDwgdmFsdWVcbiINCiAiICAtLWhsLWd0IHZhbHVlCU1h
dGNoIEhMID4gdmFsdWVcbiINCiAsIElQVEFCTEVTX1ZFUlNJT04pOw0KQEAg
LTgxLDcgKzgyLDYgQEANCiAJCQlicmVhazsNCiAJCWRlZmF1bHQ6DQogCQkJ
cmV0dXJuIDA7DQotDQogCX0NCiANCiAJcmV0dXJuIDE7DQpAQCAtOTIsODIg
KzkyLDYxIEBADQogCWlmICghZmxhZ3MpIA0KIAkJZXhpdF9lcnJvcihQQVJB
TUVURVJfUFJPQkxFTSwNCiAJCQkiSEwgbWF0Y2g6IFlvdSBtdXN0IHNwZWNp
Znkgb25lIG9mICINCi0JCQkiYC0taGwtZXEnLCBgLS1obC1sdCcsIGAtLWhs
LWd0Iik7DQorCQkJImAtLWhsLWVxJywgYC0taGwtbHQnLCBgLS1obC1ndCci
KTsNCiB9DQogDQogc3RhdGljIHZvaWQgcHJpbnQoY29uc3Qgc3RydWN0IGlw
NnRfaXA2ICppcCwgDQogCQljb25zdCBzdHJ1Y3QgaXA2dF9lbnRyeV9tYXRj
aCAqbWF0Y2gsDQogCQlpbnQgbnVtZXJpYykNCiB7DQorCXN0YXRpYyBjb25z
dCBjaGFyICpvcFtdID0gew0KKwkJW0lQNlRfSExfRVFdID0gIj09IiwNCisJ
CVtJUDZUX0hMX05FXSA9ICIhPSIsDQorCQlbSVA2VF9ITF9MVF0gPSAiPCIs
DQorCQlbSVA2VF9ITF9HVF0gPSAiPiIgfTsNCisNCiAJY29uc3Qgc3RydWN0
IGlwNnRfaGxfaW5mbyAqaW5mbyA9IA0KIAkJKHN0cnVjdCBpcDZ0X2hsX2lu
Zm8gKikgbWF0Y2gtPmRhdGE7DQogDQotCXByaW50ZigiSEwgbWF0Y2ggIik7
DQotCXN3aXRjaCAoaW5mby0+bW9kZSkgew0KLQkJY2FzZSBJUDZUX0hMX0VR
Og0KLQkJCXByaW50ZigiSEwgPT0gIik7DQotCQkJYnJlYWs7DQotCQljYXNl
IElQNlRfSExfTkU6DQotCQkJcHJpbnRmKCJITCAhPSAiKTsNCi0JCQlicmVh
azsNCi0JCWNhc2UgSVA2VF9ITF9MVDoNCi0JCQlwcmludGYoIkhMIDwgIik7
DQotCQkJYnJlYWs7DQotCQljYXNlIElQNlRfSExfR1Q6DQotCQkJcHJpbnRm
KCJITCA+ICIpOw0KLQkJCWJyZWFrOw0KLQl9DQotCXByaW50ZigiJXUgIiwg
aW5mby0+aG9wX2xpbWl0KTsNCisJcHJpbnRmKCJITCBtYXRjaCBITCAlcyAl
dSAiLCBvcFtpbmZvLT5tb2RlXSwgaW5mby0+aG9wX2xpbWl0KTsNCiB9DQog
DQogc3RhdGljIHZvaWQgc2F2ZShjb25zdCBzdHJ1Y3QgaXA2dF9pcDYgKmlw
LCANCiAJCWNvbnN0IHN0cnVjdCBpcDZ0X2VudHJ5X21hdGNoICptYXRjaCkN
CiB7DQorCXN0YXRpYyBjb25zdCBjaGFyICpvcFtdID0gew0KKwkJW0lQNlRf
SExfRVFdID0gImVxIiwNCisJCVtJUDZUX0hMX05FXSA9ICJlcSAhIiwNCisJ
CVtJUDZUX0hMX0xUXSA9ICJsdCIsDQorCQlbSVA2VF9ITF9HVF0gPSAiZ3Qi
IH07DQorDQogCWNvbnN0IHN0cnVjdCBpcDZ0X2hsX2luZm8gKmluZm8gPQ0K
IAkJKHN0cnVjdCBpcDZ0X2hsX2luZm8gKikgbWF0Y2gtPmRhdGE7DQogDQot
CXN3aXRjaCAoaW5mby0+bW9kZSkgew0KLQkJY2FzZSBJUDZUX0hMX0VROg0K
LQkJCXByaW50ZigiLS1obC1lcSAiKTsNCi0JCQlicmVhazsNCi0JCWNhc2Ug
SVA2VF9ITF9ORToNCi0JCQlwcmludGYoIiEgLS1obC1lcSAiKTsNCi0JCQli
cmVhazsNCi0JCWNhc2UgSVA2VF9ITF9MVDoNCi0JCQlwcmludGYoIi0taGwt
bHQgIik7DQotCQkJYnJlYWs7DQotCQljYXNlIElQNlRfSExfR1Q6DQotCQkJ
cHJpbnRmKCItLWhsLWd0ICIpOw0KLQkJCWJyZWFrOw0KLQkJZGVmYXVsdDoN
Ci0JCQkvKiBlcnJvciAqLw0KLQkJCWJyZWFrOw0KLQl9DQotCXByaW50Zigi
JXUgIiwgaW5mby0+aG9wX2xpbWl0KTsNCisJcHJpbnRmKCItLWhsLSVzICV1
ICIsIG9wW2luZm8tPm1vZGVdLCBpbmZvLT5ob3BfbGltaXQpOw0KIH0NCiAN
CiBzdGF0aWMgc3RydWN0IG9wdGlvbiBvcHRzW10gPSB7DQotCXsgImhsIiwg
MSwgMCwgJzInIH0sDQotCXsgImhsLWVxIiwgMSwgMCwgJzInfSwNCi0JeyAi
aGwtbHQiLCAxLCAwLCAnMyd9LA0KLQl7ICJobC1ndCIsIDEsIDAsICc0J30s
DQorCXsgLm5hbWUgPSAiaGwiLCAgICAuaGFzX2FyZyA9IDEsIC5mbGFnID0g
MCwgLnZhbCA9ICcyJyB9LA0KKwl7IC5uYW1lID0gImhsLWVxIiwgLmhhc19h
cmcgPSAxLCAuZmxhZyA9IDAsIC52YWwgPSAnMicgfSwNCisJeyAubmFtZSA9
ICJobC1sdCIsIC5oYXNfYXJnID0gMSwgLmZsYWcgPSAwLCAudmFsID0gJzMn
IH0sDQorCXsgLm5hbWUgPSAiaGwtZ3QiLCAuaGFzX2FyZyA9IDEsIC5mbGFn
ID0gMCwgLnZhbCA9ICc0JyB9LA0KIAl7IDAgfQ0KIH07DQogDQogc3RhdGlj
DQogc3RydWN0IGlwNnRhYmxlc19tYXRjaCBobCA9IHsNCi0JTlVMTCwNCi0J
ImhsIiwNCi0JSVBUQUJMRVNfVkVSU0lPTiwNCi0JSVA2VF9BTElHTihzaXpl
b2Yoc3RydWN0IGlwNnRfaGxfaW5mbykpLA0KLQlJUDZUX0FMSUdOKHNpemVv
ZihzdHJ1Y3QgaXA2dF9obF9pbmZvKSksDQotCSZoZWxwLA0KLQkmaW5pdCwN
Ci0JJnBhcnNlLA0KLQkmZmluYWxfY2hlY2ssDQotCSZwcmludCwNCi0JJnNh
dmUsDQotCW9wdHMNCisJLm5hbWUgICAgICAgICAgPSAiaGwiLA0KKwkudmVy
c2lvbiAgICAgICA9IElQVEFCTEVTX1ZFUlNJT04sDQorCS5zaXplICAgICAg
ICAgID0gSVA2VF9BTElHTihzaXplb2Yoc3RydWN0IGlwNnRfaGxfaW5mbykp
LA0KKwkudXNlcnNwYWNlc2l6ZSA9IElQNlRfQUxJR04oc2l6ZW9mKHN0cnVj
dCBpcDZ0X2hsX2luZm8pKSwNCisJLmhlbHAgICAgICAgICAgPSAmaGVscCwN
CisJLmluaXQgICAgICAgICAgPSAmaW5pdCwNCisJLnBhcnNlICAgICAgICAg
PSAmcGFyc2UsDQorCS5maW5hbF9jaGVjayAgID0gJmZpbmFsX2NoZWNrLA0K
KwkucHJpbnQgICAgICAgICA9ICZwcmludCwNCisJLnNhdmUgICAgICAgICAg
PSAmc2F2ZSwNCisJLmV4dHJhX29wdHMgICAgPSBvcHRzDQogfTsNCiANCiAN
Cg==

---23717851-615095886-1051099532=:4360--
