From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: iptables compilation (or user :) error
Date: Wed, 10 Sep 2003 16:02:51 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0309101554140.6867@dns.toxicfilms.tv>
References: <Pine.LNX.4.44.0309101645580.2834-100000@mx.nextra.ro>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-115057683-1063202571=:6867"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Gergely Imre <gimre@nextra.ro>
In-Reply-To: <Pine.LNX.4.44.0309101645580.2834-100000@mx.nextra.ro>
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

---23717851-115057683-1063202571=:6867
Content-Type: TEXT/PLAIN; charset=US-ASCII

> [root@imi userspace]# make
> Making dependencies: please wait...
> Something wrong... deleting dependencies.
> make: *** [/usr/src/linux/include/linux/netfilter_ipv4/ipt_CLASSIFY.h]
> Error 1
There is a bug in the build system, apply this patch over the
netfilter tree.

Harald, or anyone, can you apply this, it breaks all builds that did
not choose CLASSIFY target to be patched from pom.

ipt_CLASSIFY does not have a check and it is in the Makefile, although it
is not a standard kernel module.

 .CLASSIFY-test |    2 ++
 Makefile       |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

Please use the attached (mime) patch in case you fail to apply this below.

Regards,
Maciej Soltysiak

diff -Nru netfilter.orig/userspace/extensions/.CLASSIFY-test netfilter/userspace/extensions/.CLASSIFY-test
--- netfilter.orig/userspace/extensions/.CLASSIFY-test	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/.CLASSIFY-test	2003-09-10 15:43:24.000000000 +0200
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_CLASSIFY.c ] && echo CLASSIFY
diff -Nru netfilter.orig/userspace/extensions/Makefile netfilter/userspace/extensions/Makefile
--- netfilter.orig/userspace/extensions/Makefile	2003-09-10 15:57:48.000000000 +0200
+++ netfilter/userspace/extensions/Makefile	2003-09-10 15:44:09.000000000 +0200
@@ -5,7 +5,7 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah connlimit conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TTL ULOG
+PF_EXT_SLIB:=ah connlimit conntrack dscp ecn esp helper icmp iprange length limit mac mark multiport owner physdev pkttype realm rpc standard state tcp tcpmss tos ttl udp unclean CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TTL ULOG
 PF6_EXT_SLIB:=eui64 hl icmpv6 length limit mac mark multiport owner standard tcp udp HL LOG MARK

 # Optionals
---23717851-115057683-1063202571=:6867
Content-Type: TEXT/plain; name="classify_fix.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0309101602510.6867@dns.toxicfilms.tv>
Content-Description: classify_fix.diff
Content-Disposition: attachment; filename="classify_fix.diff"

ZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3VzZXJzcGFjZS9leHRlbnNpb25z
Ly5DTEFTU0lGWS10ZXN0IG5ldGZpbHRlci91c2Vyc3BhY2UvZXh0ZW5zaW9u
cy8uQ0xBU1NJRlktdGVzdA0KLS0tIG5ldGZpbHRlci5vcmlnL3VzZXJzcGFj
ZS9leHRlbnNpb25zLy5DTEFTU0lGWS10ZXN0CTE5NzAtMDEtMDEgMDE6MDA6
MDAuMDAwMDAwMDAwICswMTAwDQorKysgbmV0ZmlsdGVyL3VzZXJzcGFjZS9l
eHRlbnNpb25zLy5DTEFTU0lGWS10ZXN0CTIwMDMtMDktMTAgMTU6NDM6MjQu
MDAwMDAwMDAwICswMjAwDQpAQCAtMCwwICsxLDIgQEANCisjISAvYmluL3No
DQorWyAtZiAkS0VSTkVMX0RJUi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXB0X0NM
QVNTSUZZLmMgXSAmJiBlY2hvIENMQVNTSUZZDQpkaWZmIC1OcnUgbmV0Zmls
dGVyLm9yaWcvdXNlcnNwYWNlL2V4dGVuc2lvbnMvTWFrZWZpbGUgbmV0Zmls
dGVyL3VzZXJzcGFjZS9leHRlbnNpb25zL01ha2VmaWxlDQotLS0gbmV0Zmls
dGVyLm9yaWcvdXNlcnNwYWNlL2V4dGVuc2lvbnMvTWFrZWZpbGUJMjAwMy0w
OS0xMCAxNTo1Nzo0OC4wMDAwMDAwMDAgKzAyMDANCisrKyBuZXRmaWx0ZXIv
dXNlcnNwYWNlL2V4dGVuc2lvbnMvTWFrZWZpbGUJMjAwMy0wOS0xMCAxNTo0
NDowOS4wMDAwMDAwMDAgKzAyMDANCkBAIC01LDcgKzUsNyBAQA0KICMgaGVh
ZGVyIGZpbGVzIGFyZSBwcmVzZW50IGluIHRoZSBpbmNsdWRlL2xpbnV4IGRp
cmVjdG9yeSBvZiB0aGlzIGlwdGFibGVzDQogIyBwYWNrYWdlIChIVykNCiAj
DQotUEZfRVhUX1NMSUI6PWFoIGNvbm5saW1pdCBjb25udHJhY2sgZHNjcCBl
Y24gZXNwIGhlbHBlciBpY21wIGlwcmFuZ2UgbGVuZ3RoIGxpbWl0IG1hYyBt
YXJrIG11bHRpcG9ydCBvd25lciBwaHlzZGV2IHBrdHR5cGUgcmVhbG0gcnBj
IHN0YW5kYXJkIHN0YXRlIHRjcCB0Y3Btc3MgdG9zIHR0bCB1ZHAgdW5jbGVh
biBDTEFTU0lGWSBDT05OTUFSSyBETkFUIERTQ1AgRUNOIExPRyBNQVJLIE1B
U1FVRVJBREUgTUlSUk9SIE5FVE1BUCBSRURJUkVDVCBSRUpFQ1QgU0FNRSBT
TkFUIFRBUlBJVCBUQ1BNU1MgVE9TIFRUTCBVTE9HDQorUEZfRVhUX1NMSUI6
PWFoIGNvbm5saW1pdCBjb25udHJhY2sgZHNjcCBlY24gZXNwIGhlbHBlciBp
Y21wIGlwcmFuZ2UgbGVuZ3RoIGxpbWl0IG1hYyBtYXJrIG11bHRpcG9ydCBv
d25lciBwaHlzZGV2IHBrdHR5cGUgcmVhbG0gcnBjIHN0YW5kYXJkIHN0YXRl
IHRjcCB0Y3Btc3MgdG9zIHR0bCB1ZHAgdW5jbGVhbiBDT05OTUFSSyBETkFU
IERTQ1AgRUNOIExPRyBNQVJLIE1BU1FVRVJBREUgTUlSUk9SIE5FVE1BUCBS
RURJUkVDVCBSRUpFQ1QgU0FNRSBTTkFUIFRBUlBJVCBUQ1BNU1MgVE9TIFRU
TCBVTE9HDQogUEY2X0VYVF9TTElCOj1ldWk2NCBobCBpY21wdjYgbGVuZ3Ro
IGxpbWl0IG1hYyBtYXJrIG11bHRpcG9ydCBvd25lciBzdGFuZGFyZCB0Y3Ag
dWRwIEhMIExPRyBNQVJLDQogDQogIyBPcHRpb25hbHMNCg==

---23717851-115057683-1063202571=:6867--
