From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] patch-o-matic/base/HL.patch.ipv6.makefile typo
Date: Sat, 5 Apr 2003 16:53:24 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0304051651410.2780@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-23717851-2141118742-1049554404=:2780"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
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

---23717851-2141118742-1049554404=:2780
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi,

there's a typo that prevents the module from actually being built after
we patch the kernel.

Regards,
Maciej

diff -Nru netfilter.orig/patch-o-matic/base/HL.patch.ipv6.makefile netfilter/patch-o-matic/base/HL.patch.ipv6.makefile
--- netfilter.orig/patch-o-matic/base/HL.patch.ipv6.makefile	2003-04-05 16:26:20.000000000 +0200
+++ netfilter/patch-o-matic/base/HL.patch.ipv6.makefile	2003-04-05 16:27:13.000000000 +0200
@@ -1,2 +1,2 @@
 obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
-obj-$(CONFIG_IP_NF_TARGET_HL) += ipt_HL.o
+obj-$(CONFIG_IP6_NF_TARGET_HL) += ip6t_HL.o

---23717851-2141118742-1049554404=:2780
Content-Type: TEXT/plain; name="HL.patch.ipv6.makefile.diff"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.51.0304051653240.2780@dns.toxicfilms.tv>
Content-Description: 
Content-Disposition: attachment; filename="HL.patch.ipv6.makefile.diff"

ZGlmZiAtTnJ1IG5ldGZpbHRlci5vcmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9I
TC5wYXRjaC5pcHY2Lm1ha2VmaWxlIG5ldGZpbHRlci9wYXRjaC1vLW1hdGlj
L2Jhc2UvSEwucGF0Y2guaXB2Ni5tYWtlZmlsZQ0KLS0tIG5ldGZpbHRlci5v
cmlnL3BhdGNoLW8tbWF0aWMvYmFzZS9ITC5wYXRjaC5pcHY2Lm1ha2VmaWxl
CTIwMDMtMDQtMDUgMTY6MjY6MjAuMDAwMDAwMDAwICswMjAwDQorKysgbmV0
ZmlsdGVyL3BhdGNoLW8tbWF0aWMvYmFzZS9ITC5wYXRjaC5pcHY2Lm1ha2Vm
aWxlCTIwMDMtMDQtMDUgMTY6Mjc6MTMuMDAwMDAwMDAwICswMjAwDQpAQCAt
MSwyICsxLDIgQEANCiBvYmotJChDT05GSUdfSVA2X05GX1RBUkdFVF9MT0cp
ICs9IGlwNnRfTE9HLm8NCi1vYmotJChDT05GSUdfSVBfTkZfVEFSR0VUX0hM
KSArPSBpcHRfSEwubw0KK29iai0kKENPTkZJR19JUDZfTkZfVEFSR0VUX0hM
KSArPSBpcDZ0X0hMLm8NCg==

---23717851-2141118742-1049554404=:2780--
