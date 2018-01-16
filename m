From: Thierry Du Tre <thierry@dtsystems.be>
Subject: [PATCH] extensions : multiple to-dst/to-src arguments for
 ip6t_DNAT/SNAT not reported
Date: Tue, 16 Jan 2018 13:44:37 +0100
Message-ID: <65034694-62fb-3e6a-b15c-1176e65eae65@dtsystems.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33966 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbeAPMoj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 07:44:39 -0500
Received: by mail-wm0-f66.google.com with SMTP id 81so17026660wmb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 04:44:39 -0800 (PST)
Content-Language: nl
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is fixing the detection of multiple '--to-destination' in a DNAT rule and '--to-source' in SNAT rule for IPv6.
Currently, when defining multiple values for these, only the last will be used and others ignored silently.

The checks for (cb->xflags & F_X_TO_[DEST/SRC]) always fails because the flags are never set before.
It seems to be a copy-paste artefact since introduction of the IPv6 DNAT/SNAT extensions based on IPv4 code.

I also removed the kernel_version checks because they seem useless. Extensions for IPv6 DNAT/SNAT are using xt_target with revision 1.
That seems only added since kernel version 3.7-rc1 and therefore the check for > v2.6.10 will always return true.
The check is probably also coming from the IPv4 copy-paste.

Signed-off-by: Thierry Du Tre <thierry@dtsystems.be>

---
 extensions/libip6t_DNAT.c | 12 +++++-------
 extensions/libip6t_SNAT.c |  8 +++-----
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/extensions/libip6t_DNAT.c b/extensions/libip6t_DNAT.c
index 08d920d..c3ba621 100644
--- a/extensions/libip6t_DNAT.c
+++ b/extensions/libip6t_DNAT.c
@@ -163,13 +163,11 @@ static void DNAT_parse(struct xt_option_call *cb)
 	switch (cb->entry->id) {
 	case O_TO_DEST:
 		if (cb->xflags & F_X_TO_DEST) {
-			if (!kernel_version)
-				get_kernel_version();
-			if (kernel_version > LINUX_VERSION(2, 6, 10))
-				xtables_error(PARAMETER_PROBLEM,
-					   "DNAT: Multiple --to-destination not supported");
+		  xtables_error(PARAMETER_PROBLEM,
+				   "DNAT: Multiple --to-destination not supported");
 		}
 		parse_to(cb->arg, portok, range);
+		cb->xflags |= F_X_TO_DEST;
 		break;
 	case O_PERSISTENT:
 		range->flags |= NF_NAT_RANGE_PERSISTENT;
@@ -281,7 +279,7 @@ static int DNAT_xlate(struct xt_xlate *xl,
 	return 1;
 }
 
-static struct xtables_target snat_tg_reg = {
+static struct xtables_target dnat_tg_reg = {
 	.name		= "DNAT",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV6,
@@ -299,5 +297,5 @@ static struct xtables_target snat_tg_reg = {
 
 void _init(void)
 {
-	xtables_register_target(&snat_tg_reg);
+	xtables_register_target(&dnat_tg_reg);
 }
diff --git a/extensions/libip6t_SNAT.c b/extensions/libip6t_SNAT.c
index 671ac61..8eeadc1 100644
--- a/extensions/libip6t_SNAT.c
+++ b/extensions/libip6t_SNAT.c
@@ -166,13 +166,11 @@ static void SNAT_parse(struct xt_option_call *cb)
 	switch (cb->entry->id) {
 	case O_TO_SRC:
 		if (cb->xflags & F_X_TO_SRC) {
-			if (!kernel_version)
-				get_kernel_version();
-			if (kernel_version > LINUX_VERSION(2, 6, 10))
-				xtables_error(PARAMETER_PROBLEM,
-					   "SNAT: Multiple --to-source not supported");
+			xtables_error(PARAMETER_PROBLEM,
+				   "SNAT: Multiple --to-source not supported");
 		}
 		parse_to(cb->arg, portok, range);
+		cb->xflags |= F_X_TO_SRC;
 		break;
 	case O_PERSISTENT:
 		range->flags |= NF_NAT_RANGE_PERSISTENT;
-- 
2.7.4
