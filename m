From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] make happy cracking message more verbose
Date: Thu, 6 Nov 2003 21:04:50 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0311062049040.953@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-1392498801-1068149090=:953"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

---23717851-1392498801-1068149090=:953
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi,

there are places in netfilter where it prints:
ipt_hoop: happy cracking.

Which doesn't explain a thing to non-netfilter hackers.
I decided to make those a bit more verbose to the user.

It writes information what was wrong.
Effects of this patch:
- if the sk_buff->len was to short, print it out
- if header lenght was to short, print it out also
- Write what where the lengths expected.
- Additional debug information as to in which file, which function did
  it occur.
- Add a similar check to ip6 (it was ifdef'd)

I have one question about it.

If we have:

	int len = (*pskb)->nh.iph->ihl * 4;

Is it possible to have a NULL pointer dereference here with (*pskb)->nh
being NULL in:
ip_conntrack_local()
ipt_local_out_hook()
ipt_local_hook()
ip6t_local_out_hook()
ip6t_local_hook()

Should we check for nh, nh.iph first here, or are we okay to rely on
other functions to initialize it correctly, or disallowing for a code path
with these being NULL?


Please comment this patch.

I am also attaching the patch mime'd just in case.

Regards,
Maciej

diff -u linux.orig/net/ipv4/netfilter/ip_conntrack_standalone.c linux/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-11-06 20:36:25.000000000 +0100
+++ linux/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-11-06 19:38:48.000000000 +0100
@@ -215,14 +215,35 @@
 				       const struct net_device *out,
 				       int (*okfn)(struct sk_buff *))
 {
+	/* More verbosity to happy cracking by Maciej Soltysiak
+	 * <solt@dns.toxicfilms.tv> */
+	int len = (*pskb)->nh.iph->ihl * 4;
+	int hdrlen = sizeof(struct iphdr);
+	int bad = 0;
+
 	/* root is playing with raw sockets. */
-	if ((*pskb)->len < sizeof(struct iphdr)
-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
+	if ((*pskb)->len < hdrlen) {
 		if (net_ratelimit())
-			printk("ipt_hook: happy cracking.\n");
-		return NF_ACCEPT;
+			printk("ipt_hook: happy cracking at %s in %s."
+				" sk_buff too short: %u. Expected: %u\n",
+				__FUNCTION__, __FILE__,
+				(*pskb)->len, hdrlen);
+		bad = 1;
 	}
-	return ip_conntrack_in(hooknum, pskb, in, out, okfn);
+
+	if (len < hdrlen) {
+		if (net_ratelimit())
+			printk("ipt_hook: happy cracking at %s in %s."
+				" IPv4 header too short: %u. Expected: %u\n",
+				__FUNCTION__, __FILE__,
+				len, hdrlen);
+		bad = 1;
+	}
+
+	if (bad == 1)
+		return NF_ACCEPT;
+	else
+		return ip_conntrack_in(hooknum, pskb, in, out, okfn);
 }

 /* Connection tracking may drop packets, but never alters them, so
diff -u linux.orig/net/ipv4/netfilter/iptable_filter.c linux/net/ipv4/netfilter/iptable_filter.c
--- linux.orig/net/ipv4/netfilter/iptable_filter.c	2003-09-08 21:50:01.000000000 +0200
+++ linux/net/ipv4/netfilter/iptable_filter.c	2003-11-06 19:38:57.000000000 +0100
@@ -111,15 +111,35 @@
 		   const struct net_device *out,
 		   int (*okfn)(struct sk_buff *))
 {
+	/* More verbosity to happy cracking by Maciej Soltysiak
+	 * <solt@dns.toxicfilms.tv> */
+	int len = (*pskb)->nh.iph->ihl * 4;
+	int hdrlen = sizeof(struct iphdr);
+	int bad = 0;
+
 	/* root is playing with raw sockets. */
-	if ((*pskb)->len < sizeof(struct iphdr)
-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
+	if ((*pskb)->len < hdrlen) {
 		if (net_ratelimit())
-			printk("ipt_hook: happy cracking.\n");
-		return NF_ACCEPT;
+			printk("ipt_hook: happy cracking at %s in %s."
+				" sk_buff too short: %u. Expected: %u\n",
+				__FUNCTION__, __FILE__,
+				(*pskb)->len, hdrlen);
+		bad = 1;
+	}
+
+	if (len < hdrlen) {
+		if (net_ratelimit())
+			printk("ipt_hook: happy cracking at %s in %s."
+				" IPv4 header too short: %u. Expected: %u\n",
+				__FUNCTION__, __FILE__,
+				len, hdrlen);
+		bad = 1;
 	}

-	return ipt_do_table(pskb, hook, in, out, &packet_filter, NULL);
+	if (bad == 1)
+		return NF_ACCEPT;
+	else
+		return ipt_do_table(pskb, hook, in, out, &packet_filter, NULL);
 }

 static struct nf_hook_ops ipt_ops[] = {
diff -u linux.orig/net/ipv4/netfilter/iptable_mangle.c linux/net/ipv4/netfilter/iptable_mangle.c
--- linux.orig/net/ipv4/netfilter/iptable_mangle.c	2003-09-08 21:50:22.000000000 +0200
+++ linux/net/ipv4/netfilter/iptable_mangle.c	2003-11-06 19:39:06.000000000 +0100
@@ -149,14 +149,34 @@
 	u_int32_t saddr, daddr;
 	unsigned long nfmark;

+	/* More verbosity to happy cracking by Maciej Soltysiak
+	 * <solt@dns.toxicfilms.tv> */
+	int len = (*pskb)->nh.iph->ihl * 4;
+	int hdrlen = sizeof(struct iphdr);
+	int bad = 0;
+
 	/* root is playing with raw sockets. */
-	if ((*pskb)->len < sizeof(struct iphdr)
-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
+	if ((*pskb)->len < hdrlen) {
 		if (net_ratelimit())
-			printk("ipt_hook: happy cracking.\n");
-		return NF_ACCEPT;
+			printk("ipt_hook: happy cracking at %s in %s."
+				" sk_buff too short: %u. Expected: %u\n",
+				__FUNCTION__, __FILE__,
+				(*pskb)->len, hdrlen);
+		bad = 1;
 	}

+	if (len < hdrlen) {
+		if (net_ratelimit())
+			printk("ipt_hook: happy cracking at %s in %s."
+				" IPv4 header too short: %u. Expected: %u\n",
+				__FUNCTION__, __FILE__,
+				len, hdrlen);
+		bad = 1;
+	}
+
+	if (bad == 1)
+		return NF_ACCEPT;
+
 	/* Save things which could affect route */
 	nfmark = (*pskb)->nfmark;
 	saddr = (*pskb)->nh.iph->saddr;
diff -u linux.orig/net/ipv6/netfilter/ip6table_filter.c linux/net/ipv6/netfilter/ip6table_filter.c
--- linux.orig/net/ipv6/netfilter/ip6table_filter.c	2003-09-08 21:49:52.000000000 +0200
+++ linux/net/ipv6/netfilter/ip6table_filter.c	2003-11-06 19:40:12.000000000 +0100
@@ -111,15 +111,19 @@
 		   const struct net_device *out,
 		   int (*okfn)(struct sk_buff *))
 {
-#if 0
+	/* More verbosity to happy cracking by Maciej Soltysiak
+	 * <solt@dns.toxicfilms.tv> */
+	int hdrlen = sizeof(struct ipv6hdr);
+
 	/* root is playing with raw sockets. */
-	if ((*pskb)->len < sizeof(struct iphdr)
-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
+	if ((*pskb)->len < hdrlen) {
 		if (net_ratelimit())
-			printk("ip6t_hook: happy cracking.\n");
+			printk("ip6t_hook: happy cracking at %s in %s."
+				" sk_buff too short: %u. Expected: %u\n",
+				__FUNCTION__, __FILE__,
+				(*pskb)->len, hdrlen);
 		return NF_ACCEPT;
 	}
-#endif

 	return ip6t_do_table(pskb, hook, in, out, &packet_filter, NULL);
 }
diff -u linux.orig/net/ipv6/netfilter/ip6table_mangle.c linux/net/ipv6/netfilter/ip6table_mangle.c
--- linux.orig/net/ipv6/netfilter/ip6table_mangle.c	2003-09-08 21:50:02.000000000 +0200
+++ linux/net/ipv6/netfilter/ip6table_mangle.c	2003-11-06 19:40:17.000000000 +0100
@@ -148,15 +148,19 @@
 	u_int8_t hop_limit;
 	u_int32_t flowlabel;

-#if 0
+	/* More verbosity to happy cracking by Maciej Soltysiak
+	 * <solt@dns.toxicfilms.tv> */
+	int hdrlen = sizeof(struct ipv6hdr);
+
 	/* root is playing with raw sockets. */
-	if ((*pskb)->len < sizeof(struct iphdr)
-	    || (*pskb)->nh.iph->ihl * 4 < sizeof(struct iphdr)) {
+	if ((*pskb)->len < hdrlen) {
 		if (net_ratelimit())
-			printk("ip6t_hook: happy cracking.\n");
+			printk("ip6t_hook: happy cracking at %s in %s."
+				" sk_buff too short: %u. Expected: %u\n",
+				__FUNCTION__, __FILE__,
+				(*pskb)->len, hdrlen);
 		return NF_ACCEPT;
 	}
-#endif

 	/* FIXME: Push down to extensions --RR */
 	if (skb_is_nonlinear(*pskb) && skb_linearize(*pskb, GFP_ATOMIC) != 0)
---23717851-1392498801-1068149090=:953
Content-Type: TEXT/plain; name="happy_cracking.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0311062104500.953@dns.toxicfilms.tv>
Content-Description: happy_cracking.diff
Content-Disposition: attachment; filename="happy_cracking.diff"

ZGlmZiAtdSBsaW51eC5vcmlnL25ldC9pcHY0L25ldGZpbHRlci9pcF9jb25u
dHJhY2tfc3RhbmRhbG9uZS5jIGxpbnV4L25ldC9pcHY0L25ldGZpbHRlci9p
cF9jb25udHJhY2tfc3RhbmRhbG9uZS5jDQotLS0gbGludXgub3JpZy9uZXQv
aXB2NC9uZXRmaWx0ZXIvaXBfY29ubnRyYWNrX3N0YW5kYWxvbmUuYwkyMDAz
LTExLTA2IDIwOjM2OjI1LjAwMDAwMDAwMCArMDEwMA0KKysrIGxpbnV4L25l
dC9pcHY0L25ldGZpbHRlci9pcF9jb25udHJhY2tfc3RhbmRhbG9uZS5jCTIw
MDMtMTEtMDYgMTk6Mzg6NDguMDAwMDAwMDAwICswMTAwDQpAQCAtMjE1LDE0
ICsyMTUsMzUgQEANCiAJCQkJICAgICAgIGNvbnN0IHN0cnVjdCBuZXRfZGV2
aWNlICpvdXQsDQogCQkJCSAgICAgICBpbnQgKCpva2ZuKShzdHJ1Y3Qgc2tf
YnVmZiAqKSkNCiB7DQorCS8qIE1vcmUgdmVyYm9zaXR5IHRvIGhhcHB5IGNy
YWNraW5nIGJ5IE1hY2llaiBTb2x0eXNpYWsNCisJICogPHNvbHRAZG5zLnRv
eGljZmlsbXMudHY+ICovDQorCWludCBsZW4gPSAoKnBza2IpLT5uaC5pcGgt
PmlobCAqIDQ7DQorCWludCBoZHJsZW4gPSBzaXplb2Yoc3RydWN0IGlwaGRy
KTsNCisJaW50IGJhZCA9IDA7DQorDQogCS8qIHJvb3QgaXMgcGxheWluZyB3
aXRoIHJhdyBzb2NrZXRzLiAqLw0KLQlpZiAoKCpwc2tiKS0+bGVuIDwgc2l6
ZW9mKHN0cnVjdCBpcGhkcikNCi0JICAgIHx8ICgqcHNrYiktPm5oLmlwaC0+
aWhsICogNCA8IHNpemVvZihzdHJ1Y3QgaXBoZHIpKSB7DQorCWlmICgoKnBz
a2IpLT5sZW4gPCBoZHJsZW4pIHsNCiAJCWlmIChuZXRfcmF0ZWxpbWl0KCkp
DQotCQkJcHJpbnRrKCJpcHRfaG9vazogaGFwcHkgY3JhY2tpbmcuXG4iKTsN
Ci0JCXJldHVybiBORl9BQ0NFUFQ7DQorCQkJcHJpbnRrKCJpcHRfaG9vazog
aGFwcHkgY3JhY2tpbmcgYXQgJXMgaW4gJXMuIg0KKwkJCQkiIHNrX2J1ZmYg
dG9vIHNob3J0OiAldS4gRXhwZWN0ZWQ6ICV1XG4iLA0KKwkJCQlfX0ZVTkNU
SU9OX18sIF9fRklMRV9fLA0KKwkJCQkoKnBza2IpLT5sZW4sIGhkcmxlbik7
DQorCQliYWQgPSAxOw0KIAl9DQotCXJldHVybiBpcF9jb25udHJhY2tfaW4o
aG9va251bSwgcHNrYiwgaW4sIG91dCwgb2tmbik7DQorDQorCWlmIChsZW4g
PCBoZHJsZW4pIHsNCisJCWlmIChuZXRfcmF0ZWxpbWl0KCkpDQorCQkJcHJp
bnRrKCJpcHRfaG9vazogaGFwcHkgY3JhY2tpbmcgYXQgJXMgaW4gJXMuIg0K
KwkJCQkiIElQdjQgaGVhZGVyIHRvbyBzaG9ydDogJXUuIEV4cGVjdGVkOiAl
dVxuIiwNCisJCQkJX19GVU5DVElPTl9fLCBfX0ZJTEVfXywNCisJCQkJbGVu
LCBoZHJsZW4pOw0KKwkJYmFkID0gMTsNCisJfQ0KKw0KKwlpZiAoYmFkID09
IDEpDQorCQlyZXR1cm4gTkZfQUNDRVBUOw0KKwllbHNlDQorCQlyZXR1cm4g
aXBfY29ubnRyYWNrX2luKGhvb2tudW0sIHBza2IsIGluLCBvdXQsIG9rZm4p
Ow0KIH0NCiANCiAvKiBDb25uZWN0aW9uIHRyYWNraW5nIG1heSBkcm9wIHBh
Y2tldHMsIGJ1dCBuZXZlciBhbHRlcnMgdGhlbSwgc28NCmRpZmYgLXUgbGlu
dXgub3JpZy9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0YWJsZV9maWx0ZXIuYyBs
aW51eC9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0YWJsZV9maWx0ZXIuYw0KLS0t
IGxpbnV4Lm9yaWcvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwdGFibGVfZmlsdGVy
LmMJMjAwMy0wOS0wOCAyMTo1MDowMS4wMDAwMDAwMDAgKzAyMDANCisrKyBs
aW51eC9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0YWJsZV9maWx0ZXIuYwkyMDAz
LTExLTA2IDE5OjM4OjU3LjAwMDAwMDAwMCArMDEwMA0KQEAgLTExMSwxNSAr
MTExLDM1IEBADQogCQkgICBjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAqb3V0
LA0KIAkJICAgaW50ICgqb2tmbikoc3RydWN0IHNrX2J1ZmYgKikpDQogew0K
KwkvKiBNb3JlIHZlcmJvc2l0eSB0byBoYXBweSBjcmFja2luZyBieSBNYWNp
ZWogU29sdHlzaWFrDQorCSAqIDxzb2x0QGRucy50b3hpY2ZpbG1zLnR2PiAq
Lw0KKwlpbnQgbGVuID0gKCpwc2tiKS0+bmguaXBoLT5paGwgKiA0Ow0KKwlp
bnQgaGRybGVuID0gc2l6ZW9mKHN0cnVjdCBpcGhkcik7DQorCWludCBiYWQg
PSAwOw0KKw0KIAkvKiByb290IGlzIHBsYXlpbmcgd2l0aCByYXcgc29ja2V0
cy4gKi8NCi0JaWYgKCgqcHNrYiktPmxlbiA8IHNpemVvZihzdHJ1Y3QgaXBo
ZHIpDQotCSAgICB8fCAoKnBza2IpLT5uaC5pcGgtPmlobCAqIDQgPCBzaXpl
b2Yoc3RydWN0IGlwaGRyKSkgew0KKwlpZiAoKCpwc2tiKS0+bGVuIDwgaGRy
bGVuKSB7DQogCQlpZiAobmV0X3JhdGVsaW1pdCgpKQ0KLQkJCXByaW50aygi
aXB0X2hvb2s6IGhhcHB5IGNyYWNraW5nLlxuIik7DQotCQlyZXR1cm4gTkZf
QUNDRVBUOw0KKwkJCXByaW50aygiaXB0X2hvb2s6IGhhcHB5IGNyYWNraW5n
IGF0ICVzIGluICVzLiINCisJCQkJIiBza19idWZmIHRvbyBzaG9ydDogJXUu
IEV4cGVjdGVkOiAldVxuIiwNCisJCQkJX19GVU5DVElPTl9fLCBfX0ZJTEVf
XywNCisJCQkJKCpwc2tiKS0+bGVuLCBoZHJsZW4pOw0KKwkJYmFkID0gMTsN
CisJfQ0KKw0KKwlpZiAobGVuIDwgaGRybGVuKSB7DQorCQlpZiAobmV0X3Jh
dGVsaW1pdCgpKQ0KKwkJCXByaW50aygiaXB0X2hvb2s6IGhhcHB5IGNyYWNr
aW5nIGF0ICVzIGluICVzLiINCisJCQkJIiBJUHY0IGhlYWRlciB0b28gc2hv
cnQ6ICV1LiBFeHBlY3RlZDogJXVcbiIsDQorCQkJCV9fRlVOQ1RJT05fXywg
X19GSUxFX18sDQorCQkJCWxlbiwgaGRybGVuKTsNCisJCWJhZCA9IDE7DQog
CX0NCiANCi0JcmV0dXJuIGlwdF9kb190YWJsZShwc2tiLCBob29rLCBpbiwg
b3V0LCAmcGFja2V0X2ZpbHRlciwgTlVMTCk7DQorCWlmIChiYWQgPT0gMSkN
CisJCXJldHVybiBORl9BQ0NFUFQ7DQorCWVsc2UNCisJCXJldHVybiBpcHRf
ZG9fdGFibGUocHNrYiwgaG9vaywgaW4sIG91dCwgJnBhY2tldF9maWx0ZXIs
IE5VTEwpOw0KIH0NCiANCiBzdGF0aWMgc3RydWN0IG5mX2hvb2tfb3BzIGlw
dF9vcHNbXSA9IHsNCmRpZmYgLXUgbGludXgub3JpZy9uZXQvaXB2NC9uZXRm
aWx0ZXIvaXB0YWJsZV9tYW5nbGUuYyBsaW51eC9uZXQvaXB2NC9uZXRmaWx0
ZXIvaXB0YWJsZV9tYW5nbGUuYw0KLS0tIGxpbnV4Lm9yaWcvbmV0L2lwdjQv
bmV0ZmlsdGVyL2lwdGFibGVfbWFuZ2xlLmMJMjAwMy0wOS0wOCAyMTo1MDoy
Mi4wMDAwMDAwMDAgKzAyMDANCisrKyBsaW51eC9uZXQvaXB2NC9uZXRmaWx0
ZXIvaXB0YWJsZV9tYW5nbGUuYwkyMDAzLTExLTA2IDE5OjM5OjA2LjAwMDAw
MDAwMCArMDEwMA0KQEAgLTE0OSwxNCArMTQ5LDM0IEBADQogCXVfaW50MzJf
dCBzYWRkciwgZGFkZHI7DQogCXVuc2lnbmVkIGxvbmcgbmZtYXJrOw0KIA0K
KwkvKiBNb3JlIHZlcmJvc2l0eSB0byBoYXBweSBjcmFja2luZyBieSBNYWNp
ZWogU29sdHlzaWFrDQorCSAqIDxzb2x0QGRucy50b3hpY2ZpbG1zLnR2PiAq
Lw0KKwlpbnQgbGVuID0gKCpwc2tiKS0+bmguaXBoLT5paGwgKiA0Ow0KKwlp
bnQgaGRybGVuID0gc2l6ZW9mKHN0cnVjdCBpcGhkcik7DQorCWludCBiYWQg
PSAwOw0KKw0KIAkvKiByb290IGlzIHBsYXlpbmcgd2l0aCByYXcgc29ja2V0
cy4gKi8NCi0JaWYgKCgqcHNrYiktPmxlbiA8IHNpemVvZihzdHJ1Y3QgaXBo
ZHIpDQotCSAgICB8fCAoKnBza2IpLT5uaC5pcGgtPmlobCAqIDQgPCBzaXpl
b2Yoc3RydWN0IGlwaGRyKSkgew0KKwlpZiAoKCpwc2tiKS0+bGVuIDwgaGRy
bGVuKSB7DQogCQlpZiAobmV0X3JhdGVsaW1pdCgpKQ0KLQkJCXByaW50aygi
aXB0X2hvb2s6IGhhcHB5IGNyYWNraW5nLlxuIik7DQotCQlyZXR1cm4gTkZf
QUNDRVBUOw0KKwkJCXByaW50aygiaXB0X2hvb2s6IGhhcHB5IGNyYWNraW5n
IGF0ICVzIGluICVzLiINCisJCQkJIiBza19idWZmIHRvbyBzaG9ydDogJXUu
IEV4cGVjdGVkOiAldVxuIiwNCisJCQkJX19GVU5DVElPTl9fLCBfX0ZJTEVf
XywNCisJCQkJKCpwc2tiKS0+bGVuLCBoZHJsZW4pOw0KKwkJYmFkID0gMTsN
CiAJfQ0KIA0KKwlpZiAobGVuIDwgaGRybGVuKSB7DQorCQlpZiAobmV0X3Jh
dGVsaW1pdCgpKQ0KKwkJCXByaW50aygiaXB0X2hvb2s6IGhhcHB5IGNyYWNr
aW5nIGF0ICVzIGluICVzLiINCisJCQkJIiBJUHY0IGhlYWRlciB0b28gc2hv
cnQ6ICV1LiBFeHBlY3RlZDogJXVcbiIsDQorCQkJCV9fRlVOQ1RJT05fXywg
X19GSUxFX18sDQorCQkJCWxlbiwgaGRybGVuKTsNCisJCWJhZCA9IDE7DQor
CX0NCisNCisJaWYgKGJhZCA9PSAxKQ0KKwkJcmV0dXJuIE5GX0FDQ0VQVDsN
CisNCiAJLyogU2F2ZSB0aGluZ3Mgd2hpY2ggY291bGQgYWZmZWN0IHJvdXRl
ICovDQogCW5mbWFyayA9ICgqcHNrYiktPm5mbWFyazsNCiAJc2FkZHIgPSAo
KnBza2IpLT5uaC5pcGgtPnNhZGRyOw0KZGlmZiAtdSBsaW51eC5vcmlnL25l
dC9pcHY2L25ldGZpbHRlci9pcDZ0YWJsZV9maWx0ZXIuYyBsaW51eC9uZXQv
aXB2Ni9uZXRmaWx0ZXIvaXA2dGFibGVfZmlsdGVyLmMNCi0tLSBsaW51eC5v
cmlnL25ldC9pcHY2L25ldGZpbHRlci9pcDZ0YWJsZV9maWx0ZXIuYwkyMDAz
LTA5LTA4IDIxOjQ5OjUyLjAwMDAwMDAwMCArMDIwMA0KKysrIGxpbnV4L25l
dC9pcHY2L25ldGZpbHRlci9pcDZ0YWJsZV9maWx0ZXIuYwkyMDAzLTExLTA2
IDE5OjQwOjEyLjAwMDAwMDAwMCArMDEwMA0KQEAgLTExMSwxNSArMTExLDE5
IEBADQogCQkgICBjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAqb3V0LA0KIAkJ
ICAgaW50ICgqb2tmbikoc3RydWN0IHNrX2J1ZmYgKikpDQogew0KLSNpZiAw
DQorCS8qIE1vcmUgdmVyYm9zaXR5IHRvIGhhcHB5IGNyYWNraW5nIGJ5IE1h
Y2llaiBTb2x0eXNpYWsNCisJICogPHNvbHRAZG5zLnRveGljZmlsbXMudHY+
ICovDQorCWludCBoZHJsZW4gPSBzaXplb2Yoc3RydWN0IGlwdjZoZHIpOw0K
Kw0KIAkvKiByb290IGlzIHBsYXlpbmcgd2l0aCByYXcgc29ja2V0cy4gKi8N
Ci0JaWYgKCgqcHNrYiktPmxlbiA8IHNpemVvZihzdHJ1Y3QgaXBoZHIpDQot
CSAgICB8fCAoKnBza2IpLT5uaC5pcGgtPmlobCAqIDQgPCBzaXplb2Yoc3Ry
dWN0IGlwaGRyKSkgew0KKwlpZiAoKCpwc2tiKS0+bGVuIDwgaGRybGVuKSB7
DQogCQlpZiAobmV0X3JhdGVsaW1pdCgpKQ0KLQkJCXByaW50aygiaXA2dF9o
b29rOiBoYXBweSBjcmFja2luZy5cbiIpOw0KKwkJCXByaW50aygiaXA2dF9o
b29rOiBoYXBweSBjcmFja2luZyBhdCAlcyBpbiAlcy4iDQorCQkJCSIgc2tf
YnVmZiB0b28gc2hvcnQ6ICV1LiBFeHBlY3RlZDogJXVcbiIsDQorCQkJCV9f
RlVOQ1RJT05fXywgX19GSUxFX18sDQorCQkJCSgqcHNrYiktPmxlbiwgaGRy
bGVuKTsNCiAJCXJldHVybiBORl9BQ0NFUFQ7DQogCX0NCi0jZW5kaWYNCiAN
CiAJcmV0dXJuIGlwNnRfZG9fdGFibGUocHNrYiwgaG9vaywgaW4sIG91dCwg
JnBhY2tldF9maWx0ZXIsIE5VTEwpOw0KIH0NCmRpZmYgLXUgbGludXgub3Jp
Zy9uZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2dGFibGVfbWFuZ2xlLmMgbGludXgv
bmV0L2lwdjYvbmV0ZmlsdGVyL2lwNnRhYmxlX21hbmdsZS5jDQotLS0gbGlu
dXgub3JpZy9uZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2dGFibGVfbWFuZ2xlLmMJ
MjAwMy0wOS0wOCAyMTo1MDowMi4wMDAwMDAwMDAgKzAyMDANCisrKyBsaW51
eC9uZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2dGFibGVfbWFuZ2xlLmMJMjAwMy0x
MS0wNiAxOTo0MDoxNy4wMDAwMDAwMDAgKzAxMDANCkBAIC0xNDgsMTUgKzE0
OCwxOSBAQA0KIAl1X2ludDhfdCBob3BfbGltaXQ7DQogCXVfaW50MzJfdCBm
bG93bGFiZWw7DQogDQotI2lmIDANCisJLyogTW9yZSB2ZXJib3NpdHkgdG8g
aGFwcHkgY3JhY2tpbmcgYnkgTWFjaWVqIFNvbHR5c2lhaw0KKwkgKiA8c29s
dEBkbnMudG94aWNmaWxtcy50dj4gKi8NCisJaW50IGhkcmxlbiA9IHNpemVv
ZihzdHJ1Y3QgaXB2Nmhkcik7DQorDQogCS8qIHJvb3QgaXMgcGxheWluZyB3
aXRoIHJhdyBzb2NrZXRzLiAqLw0KLQlpZiAoKCpwc2tiKS0+bGVuIDwgc2l6
ZW9mKHN0cnVjdCBpcGhkcikNCi0JICAgIHx8ICgqcHNrYiktPm5oLmlwaC0+
aWhsICogNCA8IHNpemVvZihzdHJ1Y3QgaXBoZHIpKSB7DQorCWlmICgoKnBz
a2IpLT5sZW4gPCBoZHJsZW4pIHsNCiAJCWlmIChuZXRfcmF0ZWxpbWl0KCkp
DQotCQkJcHJpbnRrKCJpcDZ0X2hvb2s6IGhhcHB5IGNyYWNraW5nLlxuIik7
DQorCQkJcHJpbnRrKCJpcDZ0X2hvb2s6IGhhcHB5IGNyYWNraW5nIGF0ICVz
IGluICVzLiINCisJCQkJIiBza19idWZmIHRvbyBzaG9ydDogJXUuIEV4cGVj
dGVkOiAldVxuIiwNCisJCQkJX19GVU5DVElPTl9fLCBfX0ZJTEVfXywNCisJ
CQkJKCpwc2tiKS0+bGVuLCBoZHJsZW4pOw0KIAkJcmV0dXJuIE5GX0FDQ0VQ
VDsNCiAJfQ0KLSNlbmRpZg0KIA0KIAkvKiBGSVhNRTogUHVzaCBkb3duIHRv
IGV4dGVuc2lvbnMgLS1SUiAqLw0KIAlpZiAoc2tiX2lzX25vbmxpbmVhcigq
cHNrYikgJiYgc2tiX2xpbmVhcml6ZSgqcHNrYiwgR0ZQX0FUT01JQykgIT0g
MCkNCg==

---23717851-1392498801-1068149090=:953--
