From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: [PATCH] trivial patches for patch-o-matic-ng ipp2p, tproxy, TPROXY
	and comment
Date: Sun, 13 Feb 2005 17:52:43 +0100
Message-ID: <1108313563.3505.22.camel@murdegern.luettgert.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-tuKUtnsBz54ck4Wju5IW"
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


--=-tuKUtnsBz54ck4Wju5IW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

afaics, it is vital to use the ".field =3D value" syntax in
iptables_match definitions now. There's this new field
"u_int8_t revision" which gets in the way for some old
matches.

ipp2p, tproxy, TPROXY and comment from pom-ng don't do this
yet, so iptables won't compile if they are inserted.

Attached are the (trivial) patches to make them work again.

Thanks,
Torsten L=C3=BCttgert <t.luettgert@pressestimmen.de>


--=-tuKUtnsBz54ck4Wju5IW
Content-Disposition: attachment; filename=ipp2p.patch
Content-Type: text/x-patch; name=ipp2p.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- ipp2p/iptables/extensions/libipt_ipp2p.c	(revision 3667)
+++ ipp2p/iptables/extensions/libipt_ipp2p.c	(working copy)
@@ -431,18 +431,19 @@
 
 static
 struct iptables_match ipp2p
-= { NULL,
-    "ipp2p",
-    IPTABLES_VERSION, 
-    IPT_ALIGN(sizeof(struct ipt_p2p_info)),
-    IPT_ALIGN(sizeof(struct ipt_p2p_info)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+= {
+   .next          = NULL,
+   .name          = "ipp2p",
+   .version       = IPTABLES_VERSION, 
+   .size          = IPT_ALIGN(sizeof(struct ipt_p2p_info)),
+   .userspacesize = IPT_ALIGN(sizeof(struct ipt_p2p_info)),
+   .help          = &help,
+   .init          = &init,
+   .parse         = &parse,
+   .final_check   = &final_check,
+   .print         = &print,
+   .save          = &save,
+   .extra_opts    = opts
 };
 					    
 

--=-tuKUtnsBz54ck4Wju5IW
Content-Disposition: attachment; filename=tproxy.patch
Content-Type: text/x-patch; name=tproxy.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- tproxy/iptables/extensions/libipt_tproxy.c	(revision 3667)
+++ tproxy/iptables/extensions/libipt_tproxy.c	(working copy)
@@ -57,18 +57,18 @@
 
 static
 struct iptables_match tproxy
-= { NULL,
-    "tproxy",
-    IPTABLES_VERSION,
-    0, 
-    0, 
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+= { .next            = NULL,
+    .name            = "tproxy",
+    .version         = IPTABLES_VERSION,
+    .size            = 0, 
+    .userspacesize   = 0, 
+    .help            = &help,
+    .init            = &init,
+    .parse           = &parse,
+    .final_check     = &final_check,
+    .print           = &print,
+    .save            = &save,
+    .extra_opts      = opts
 };
 
 void _init(void)

--=-tuKUtnsBz54ck4Wju5IW
Content-Disposition: attachment; filename=TPROXY.patch
Content-Type: text/x-patch; name=TPROXY.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- tproxy/iptables/extensions/libipt_TPROXY.c	(revision 3667)
+++ tproxy/iptables/extensions/libipt_TPROXY.c	(working copy)
@@ -118,18 +118,19 @@
 }
 
 struct iptables_target tproxy
-= { NULL,
-    "TPROXY",
-    IPTABLES_VERSION,
-    IPT_ALIGN(sizeof(struct ipt_tproxy_target_info)),
-    IPT_ALIGN(sizeof(struct ipt_tproxy_target_info)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+= {
+   .next            = NULL,
+   .name            = "TPROXY",
+   .version         = IPTABLES_VERSION,
+   .size            = IPT_ALIGN(sizeof(struct ipt_tproxy_target_info)),
+   .userspacesize   = IPT_ALIGN(sizeof(struct ipt_tproxy_target_info)),
+   .help            = &help,
+   .init            = &init,
+   .parse           = &parse,
+   .final_check     = &final_check,
+   .print           = &print,
+   .save            = &save,
+   .extra_opts      = opts
 };
 
 void _init(void)

--=-tuKUtnsBz54ck4Wju5IW
Content-Disposition: attachment; filename=comment.patch
Content-Type: text/x-patch; name=comment.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- comment/iptables/extensions/libipt_comment.c	(revision 3667)
+++ comment/iptables/extensions/libipt_comment.c	(working copy)
@@ -105,18 +105,18 @@
 
 static
 struct iptables_match comment
-= { NULL,
-    "comment",
-    IPTABLES_VERSION,
-    IPT_ALIGN(sizeof(struct ipt_comment_info)),
-    IPT_ALIGN(sizeof(struct ipt_comment_info)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+= { .next            = NULL,
+    .name            = "comment",
+    .version         = IPTABLES_VERSION,
+    .size            = IPT_ALIGN(sizeof(struct ipt_comment_info)),
+    .userspacesize   = IPT_ALIGN(sizeof(struct ipt_comment_info)),
+    .help            = &help,
+    .init            = &init,
+    .parse           = &parse,
+    .final_check     = &final_check,
+    .print           = &print,
+    .save            = &save,
+    .extra_opts      = opts
 };
 
 void _init(void)

--=-tuKUtnsBz54ck4Wju5IW--
