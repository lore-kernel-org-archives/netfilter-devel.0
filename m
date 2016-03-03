From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: extensions: libxt_multiport: Multiport translations
Date: Thu, 3 Mar 2016 18:02:41 +0000
Message-ID: <CAKrM2X=PyBuF=ZrNkBFoTB4m+7pr15WUC_AahYn+x9wwf5Eibg@mail.gmail.com>
Reply-To: ppang@linux.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:35526 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbcCCSCm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Mar 2016 13:02:42 -0500
Received: by mail-vk0-f46.google.com with SMTP id e6so29634789vkh.2
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Mar 2016 10:02:42 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added multiport translations for ipv4 only .
It's for review pupose only , it definitely needs changes .

example :
iptables-translate -A INPUT -p tcp -m multiport --dports 22,http,ssh -j ACCEPT
nft add rule ip filter INPUT ip protocol tcp dport  { 22,80,22 } counter accept

diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 03af5a9..6b46f93 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -468,6 +468,67 @@ static void multiport_save6_v1(const void *ip_void,
     __multiport_save_v1(match, ip->proto);
 }

+static int multiport_xlate(const struct xt_entry_match *match, struct
xt_xlate *xl,
+             int numeric)
+{
+    const struct xt_multiport_v1 *multiinfo
+        = (const struct xt_multiport_v1 *)match->data;
+    unsigned int i;
+
+    switch (multiinfo->flags) {
+    case XT_MULTIPORT_SOURCE:
+        xt_xlate_add(xl,"sport ");
+        break;
+
+    case XT_MULTIPORT_DESTINATION:
+        xt_xlate_add(xl,"dport ");
+        break;
+
+    default:
+        return 1;
+    }
+    xt_xlate_add(xl," { ");
+    for (i=0; i < multiinfo->count; i++) {
+        xt_xlate_add(xl,"%u%s", multiinfo->ports[i],
+                (i+1) != multiinfo->count ? "," : "");
+    }
+    xt_xlate_add(xl," } ");
+    return 1;
+}
+
+static int multiport_xlate_v1(const struct xt_entry_match *match,
struct xt_xlate *xl,
+             int numeric)
+{
+    const struct xt_multiport_v1 *multiinfo
+        = (const struct xt_multiport_v1 *)match->data;
+    unsigned int i;
+
+    switch (multiinfo->flags) {
+    case XT_MULTIPORT_SOURCE:
+        xt_xlate_add(xl,"sport ");
+        break;
+
+    case XT_MULTIPORT_DESTINATION:
+        xt_xlate_add(xl,"dport ");
+        break;
+
+    default:
+        return 1;
+    }
+    xt_xlate_add(xl," { ");
+    for (i=0; i < multiinfo->count; i++) {
+        xt_xlate_add(xl,"%u%s", multiinfo->ports[i],
+                (i+1) != multiinfo->count ? "," : "");
+        if (multiinfo->pflags[i]) {
+            i++;
+            xt_xlate_add(xl,"%u%s", multiinfo->ports[i],
+                (i) != multiinfo->count ? "," : "");
+        }
+    }
+    xt_xlate_add(xl," } ");
+    return 1;
+}
+
 static struct xtables_match multiport_mt_reg[] = {
     {
         .family        = NFPROTO_IPV4,
@@ -482,6 +543,7 @@ static struct xtables_match multiport_mt_reg[] = {
         .print         = multiport_print,
         .save          = multiport_save,
         .x6_options    = multiport_opts,
+        .xlate         = multiport_xlate,
     },
     {
         .family        = NFPROTO_IPV6,
@@ -510,6 +572,7 @@ static struct xtables_match multiport_mt_reg[] = {
         .print         = multiport_print_v1,
         .save          = multiport_save_v1,
         .x6_options    = multiport_opts,
+        .xlate           = multiport_xlate_v1,
     },
     {
         .family        = NFPROTO_IPV6,
