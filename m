From: James Morris <jmorris@namei.org>
Subject: iptables static build bug (fwd)
Date: Mon, 18 Dec 2006 09:17:53 -0500 (EST)
Message-ID: <XMMS.LNX.4.64.0612180917460.7779@d.namei>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed;
	BOUNDARY="----=_Part_9481_16282572.1166434150087"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

------=_Part_9481_16282572.1166434150087
Content-Type: TEXT/PLAIN; charset=US-ASCII

---------- Forwarded message ----------
Date: Mon, 18 Dec 2006 11:29:10 +0200
From: Tux P <gentuu@gmail.com>
To: marc@mbsi.ca
Cc: laforge@gnumonks.org, jmorris@intercode.com.au
Subject: iptables static build bug

Hi *,

I found subj. Static iptables tries to load kernel modules
(modprobe fails and shows pesky message about every iptables run)
regardless their static present in the kernel.

and created a simple patch to fix this.
Please look (also attached):

--- iptables-1.3.7/iptables.c.orig      2006-12-04 03:15:20.000000000 -0800
+++ iptables-1.3.7/iptables.c   2006-12-18 00:50:51.000000000 -0800
@@ -774,7 +774,7 @@
        }
 #else
        if (ptr && !ptr->loaded) {
-               if (tryload != DONT_LOAD)
+               if (tryload != DONT_LOAD && tryload != DURING_LOAD)
                        ptr->loaded = 1;
                else
                        ptr = NULL;
@@ -1093,7 +1093,7 @@
        }
 #else
        if (ptr && !ptr->loaded) {
-               if (tryload != DONT_LOAD)
+               if (tryload != DONT_LOAD && tryload != DURING_LOAD)
                        ptr->loaded = 1;
                else
                        ptr = NULL;



Thanks

Nick
------=_Part_9481_16282572.1166434150087
Content-Type: APPLICATION/OCTET-STREAM; NAME=static_iptables_modprobe.patch
Content-Transfer-Encoding: BASE64
Content-ID: <XMMS.LNX.4.64.0612180917461.7779@d.namei>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=static_iptables_modprobe.patch

LS0tIGlwdGFibGVzLTEuMy43L2lwdGFibGVzLmMub3JpZwkyMDA2LTEyLTA0IDAzOjE1OjIwLjAw
MDAwMDAwMCAtMDgwMAorKysgaXB0YWJsZXMtMS4zLjcvaXB0YWJsZXMuYwkyMDA2LTEyLTE4IDAw
OjUwOjUxLjAwMDAwMDAwMCAtMDgwMApAQCAtNzc0LDcgKzc3NCw3IEBACiAJfQogI2Vsc2UKIAlp
ZiAocHRyICYmICFwdHItPmxvYWRlZCkgewotCQlpZiAodHJ5bG9hZCAhPSBET05UX0xPQUQpCisJ
CWlmICh0cnlsb2FkICE9IERPTlRfTE9BRCAmJiB0cnlsb2FkICE9IERVUklOR19MT0FEKQogCQkJ
cHRyLT5sb2FkZWQgPSAxOwogCQllbHNlCiAJCQlwdHIgPSBOVUxMOwpAQCAtMTA5Myw3ICsxMDkz
LDcgQEAKIAl9CiAjZWxzZQogCWlmIChwdHIgJiYgIXB0ci0+bG9hZGVkKSB7Ci0JCWlmICh0cnls
b2FkICE9IERPTlRfTE9BRCkKKwkJaWYgKHRyeWxvYWQgIT0gRE9OVF9MT0FEICYmIHRyeWxvYWQg
IT0gRFVSSU5HX0xPQUQpCiAJCQlwdHItPmxvYWRlZCA9IDE7CiAJCWVsc2UKIAkJCXB0ciA9IE5V
TEw7Cg==
------=_Part_9481_16282572.1166434150087--
