From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 01/13] Remove stray NULLs
Date: Thu, 4 Oct 2007 12:11:05 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58018 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbXJDKLG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:11:06 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 70E911C070210
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 12:11:05 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Mixing member accessors (non-named vs named) is not good.
Remove stray NULL.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libip6t_HL.c        |    2 +-
 extensions/libipt_MASQUERADE.c |    2 +-
 extensions/libipt_realm.c      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: iptables/extensions/libip6t_HL.c
===================================================================
--- iptables.orig/extensions/libip6t_HL.c
+++ iptables/extensions/libip6t_HL.c
@@ -146,7 +146,7 @@ static const struct option opts[] = {
 };
 
 static
-struct ip6tables_target HL = { NULL, 
+struct ip6tables_target HL = {
 	.name 		= "HL",
 	.version	= IPTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
Index: iptables/extensions/libipt_MASQUERADE.c
===================================================================
--- iptables.orig/extensions/libipt_MASQUERADE.c
+++ iptables/extensions/libipt_MASQUERADE.c
@@ -161,7 +161,7 @@ save(const void *ip, const struct xt_ent
 		printf("--random ");
 }
 
-static struct iptables_target masq = { NULL,
+static struct iptables_target masq = {
 	.name		= "MASQUERADE",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
Index: iptables/extensions/libipt_realm.c
===================================================================
--- iptables.orig/extensions/libipt_realm.c
+++ iptables/extensions/libipt_realm.c
@@ -250,7 +250,7 @@ final_check(unsigned int flags)
 			   "realm match: You must specify `--realm'");
 }
 
-static struct iptables_match realm = { NULL,
+static struct iptables_match realm = {
 	.name		= "realm",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_realm_info)),

