From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 03/14] Delete empty ->final_check() functions
Date: Thu, 4 Oct 2007 12:11:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041209380.7253@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58021 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622AbXJDKLg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:11:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 7579A1C07DF86
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 12:11:34 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Deletes empty ->final_check() functions, and makes ip[6]tables
checks for NULL on these.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libip6t_LOG.c       |    6 ------
 extensions/libip6t_REJECT.c    |    6 ------
 extensions/libip6t_ah.c        |    7 -------
 extensions/libip6t_dst.c       |    7 -------
 extensions/libip6t_eui64.c     |    6 ------
 extensions/libip6t_frag.c      |    7 -------
 extensions/libip6t_hbh.c       |    7 -------
 extensions/libip6t_mh.c        |    6 ------
 extensions/libip6t_rt.c        |    7 -------
 extensions/libipt_LOG.c        |    6 ------
 extensions/libipt_MASQUERADE.c |    6 ------
 extensions/libipt_MIRROR.c     |    6 ------
 extensions/libipt_REDIRECT.c   |    6 ------
 extensions/libipt_REJECT.c     |    6 ------
 extensions/libipt_ULOG.c       |    6 ------
 extensions/libipt_ah.c         |    7 -------
 extensions/libipt_icmp.c       |    6 ------
 extensions/libipt_unclean.c    |    6 ------
 extensions/libxt_NFLOG.c       |    7 -------
 extensions/libxt_NFQUEUE.c     |    7 -------
 extensions/libxt_NOTRACK.c     |    7 -------
 extensions/libxt_TRACE.c       |    7 -------
 extensions/libxt_dccp.c        |    7 -------
 extensions/libxt_esp.c         |    8 --------
 extensions/libxt_limit.c       |    7 -------
 extensions/libxt_quota.c       |    8 --------
 extensions/libxt_sctp.c        |    7 -------
 extensions/libxt_standard.c    |    7 -------
 extensions/libxt_tcp.c         |    8 --------
 extensions/libxt_time.c        |    6 ------
 extensions/libxt_u32.c         |    6 ------
 extensions/libxt_udp.c         |    8 --------
 ip6tables.c                    |    5 +++--
 iptables.c                     |    5 +++--
 34 files changed, 6 insertions(+), 218 deletions(-)

Index: iptables/extensions/libip6t_LOG.c
===================================================================
--- iptables.orig/extensions/libip6t_LOG.c
+++ iptables/extensions/libip6t_LOG.c
@@ -199,11 +199,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-/* Final check; nothing. */
-static void final_check(unsigned int flags)
-{
-}
-
 /* Prints out the targinfo. */
 static void
 print(const void *ip,
@@ -278,7 +273,6 @@ struct ip6tables_target log
     .help          = &help,
     .init          = &init,
     .parse         = &parse,
-    .final_check   = &final_check,
     .print         = &print,
     .save          = &save,
     .extra_opts    = opts
Index: iptables/extensions/libip6t_REJECT.c
===================================================================
--- iptables.orig/extensions/libip6t_REJECT.c
+++ iptables/extensions/libip6t_REJECT.c
@@ -113,11 +113,6 @@ parse(int c, char **argv, int invert, un
 	return 0;
 }
 
-/* Final check; nothing. */
-static void final_check(unsigned int flags)
-{
-}
-
 /* Prints out ipt_reject_info. */
 static void
 print(const void *ip,
@@ -158,7 +153,6 @@ struct ip6tables_target reject = {
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts,
Index: iptables/extensions/libip6t_ah.c
===================================================================
--- iptables.orig/extensions/libip6t_ah.c
+++ iptables/extensions/libip6t_ah.c
@@ -125,12 +125,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-/* Final check; we don't care. */
-static void
-final_check(unsigned int flags)
-{
-}
-
 static void
 print_spis(const char *name, u_int32_t min, u_int32_t max,
 	    int invert)
@@ -213,7 +207,6 @@ struct ip6tables_match ah = {
 	.help          = &help,
 	.init          = &init,
 	.parse         = &parse,
-	.final_check   = &final_check,
 	.print         = &print,
 	.save          = &save,
 	.extra_opts    = opts
Index: iptables/extensions/libip6t_dst.c
===================================================================
--- iptables.orig/extensions/libip6t_dst.c
+++ iptables/extensions/libip6t_dst.c
@@ -179,12 +179,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-/* Final check; we don't care. */
-static void
-final_check(unsigned int flags)
-{
-}
-
 static void
 print_options(int optsnr, u_int16_t *optsp)
 {
@@ -255,7 +249,6 @@ struct ip6tables_match optstruct = {
 	.help          = &help,
 	.init          = &init,
 	.parse         = &parse,
-	.final_check   = &final_check,
 	.print         = &print,
 	.save          = &save,
 	.extra_opts    = opts
Index: iptables/extensions/libip6t_eui64.c
===================================================================
--- iptables.orig/extensions/libip6t_eui64.c
+++ iptables/extensions/libip6t_eui64.c
@@ -32,11 +32,6 @@ parse(int c, char **argv, int invert, un
 	return 0;
 }
 
-/* Final check */
-static void final_check(unsigned int flags)
-{
-}
-
 /* Prints out the matchinfo. */
 static void
 print(const void *ip,
@@ -59,7 +54,6 @@ static struct ip6tables_match eui64 = {
 	.userspacesize	= IP6T_ALIGN(sizeof(int)),
 	.help		= &help,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 };
Index: iptables/extensions/libip6t_frag.c
===================================================================
--- iptables.orig/extensions/libip6t_frag.c
+++ iptables/extensions/libip6t_frag.c
@@ -156,12 +156,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-/* Final check; we don't care. */
-static void
-final_check(unsigned int flags)
-{
-}
-
 static void
 print_ids(const char *name, u_int32_t min, u_int32_t max,
 	    int invert)
@@ -258,7 +252,6 @@ struct ip6tables_match frag = {
 	.help          = &help,
 	.init          = &init,
 	.parse         = &parse,
-	.final_check   = &final_check,
 	.print         = &print,
 	.save          = &save,
 	.extra_opts    = opts
Index: iptables/extensions/libip6t_hbh.c
===================================================================
--- iptables.orig/extensions/libip6t_hbh.c
+++ iptables/extensions/libip6t_hbh.c
@@ -177,12 +177,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-/* Final check; we don't care. */
-static void
-final_check(unsigned int flags)
-{
-}
-
 static void
 print_options(int optsnr, u_int16_t *optsp)
 {
@@ -248,7 +242,6 @@ static struct ip6tables_match optstruct 
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts,
Index: iptables/extensions/libip6t_mh.c
===================================================================
--- iptables.orig/extensions/libip6t_mh.c
+++ iptables/extensions/libip6t_mh.c
@@ -150,11 +150,6 @@ static int parse(int c, char **argv, int
 	return 1;
 }
 
-/* Final check; we don't care. */
-static void final_check(unsigned int flags)
-{
-}
-
 static const char *type_to_name(u_int8_t type)
 {
 	unsigned int i;
@@ -238,7 +233,6 @@ static struct ip6tables_match mh = {
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts,
Index: iptables/extensions/libip6t_rt.c
===================================================================
--- iptables.orig/extensions/libip6t_rt.c
+++ iptables/extensions/libip6t_rt.c
@@ -237,12 +237,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-/* Final check; we don't care. */
-static void
-final_check(unsigned int flags)
-{
-}
-
 static void
 print_nums(const char *name, u_int32_t min, u_int32_t max,
 	    int invert)
@@ -348,7 +342,6 @@ static struct ip6tables_match rt = {
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts,
Index: iptables/extensions/libipt_LOG.c
===================================================================
--- iptables.orig/extensions/libipt_LOG.c
+++ iptables/extensions/libipt_LOG.c
@@ -199,11 +199,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-/* Final check; nothing. */
-static void final_check(unsigned int flags)
-{
-}
-
 /* Prints out the targinfo. */
 static void
 print(const void *ip,
@@ -278,7 +273,6 @@ struct iptables_target log
     .help          = &help,
     .init          = &init,
     .parse         = &parse,
-    .final_check   = &final_check,
     .print         = &print,
     .save          = &save,
     .extra_opts    = opts
Index: iptables/extensions/libipt_MASQUERADE.c
===================================================================
--- iptables.orig/extensions/libipt_MASQUERADE.c
+++ iptables/extensions/libipt_MASQUERADE.c
@@ -115,11 +115,6 @@ parse(int c, char **argv, int invert, un
 	}
 }
 
-/* Final check; don't care. */
-static void final_check(unsigned int flags)
-{
-}
-
 /* Prints out the targinfo. */
 static void
 print(const void *ip,
@@ -169,7 +164,6 @@ static struct iptables_target masq = {
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
Index: iptables/extensions/libipt_MIRROR.c
===================================================================
--- iptables.orig/extensions/libipt_MIRROR.c
+++ iptables/extensions/libipt_MIRROR.c
@@ -26,11 +26,6 @@ parse(int c, char **argv, int invert, un
 	return 0;
 }
 
-static void
-final_check(unsigned int flags)
-{
-}
-
 static struct iptables_target mirror = {
 	.name		= "MIRROR",
 	.version	= IPTABLES_VERSION,
@@ -38,7 +33,6 @@ static struct iptables_target mirror = {
 	.userspacesize	= IPT_ALIGN(0),
  	.help		= &help,
  	.parse		= &parse,
-	.final_check 	= &final_check,
 	.print		= NULL,
 	.save		= NULL,
 };
Index: iptables/extensions/libipt_REDIRECT.c
===================================================================
--- iptables.orig/extensions/libipt_REDIRECT.c
+++ iptables/extensions/libipt_REDIRECT.c
@@ -124,11 +124,6 @@ parse(int c, char **argv, int invert, un
 	}
 }
 
-/* Final check; don't care. */
-static void final_check(unsigned int flags)
-{
-}
-
 /* Prints out the targinfo. */
 static void
 print(const void *ip,
@@ -177,7 +172,6 @@ static struct iptables_target redir = { 
 	.help		= &help,
 	.init		= &init,
  	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
Index: iptables/extensions/libipt_REJECT.c
===================================================================
--- iptables.orig/extensions/libipt_REJECT.c
+++ iptables/extensions/libipt_REJECT.c
@@ -132,11 +132,6 @@ parse(int c, char **argv, int invert, un
 	return 0;
 }
 
-/* Final check; nothing. */
-static void final_check(unsigned int flags)
-{
-}
-
 /* Prints out ipt_reject_info. */
 static void
 print(const void *ip,
@@ -176,7 +171,6 @@ static struct iptables_target reject = {
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
Index: iptables/extensions/libipt_ULOG.c
===================================================================
--- iptables.orig/extensions/libipt_ULOG.c
+++ iptables/extensions/libipt_ULOG.c
@@ -150,11 +150,6 @@ static int parse(int c, char **argv, int
 	return 1;
 }
 
-/* Final check; nothing. */
-static void final_check(unsigned int flags)
-{
-}
-
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void save(const void *ip,
 		 const struct xt_entry_target *target)
@@ -200,7 +195,6 @@ static struct iptables_target ulog = {
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
Index: iptables/extensions/libipt_ah.c
===================================================================
--- iptables.orig/extensions/libipt_ah.c
+++ iptables/extensions/libipt_ah.c
@@ -104,12 +104,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-/* Final check; we don't care. */
-static void
-final_check(unsigned int flags)
-{
-}
-
 static void
 print_spis(const char *name, u_int32_t min, u_int32_t max,
 	    int invert)
@@ -175,7 +169,6 @@ static struct iptables_match ah = { 
 	.help 		= &help,
 	.init 		= &init,
 	.parse 		= &parse,
-	.final_check 	= &final_check,
 	.print 		= &print,
 	.save 		= &save,
 	.extra_opts 	= opts
Index: iptables/extensions/libipt_icmp.c
===================================================================
--- iptables.orig/extensions/libipt_icmp.c
+++ iptables/extensions/libipt_icmp.c
@@ -280,11 +280,6 @@ static void save(const void *ip, const s
 	}
 }
 
-/* Final check; we don't care. We can pass 0xFF to match any type */
-static void final_check(unsigned int flags)
-{
-}
-
 static struct iptables_match icmp = { 
 	.name		= "icmp",
 	.version	= IPTABLES_VERSION,
@@ -293,7 +288,6 @@ static struct iptables_match icmp = { 
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
Index: iptables/extensions/libipt_unclean.c
===================================================================
--- iptables.orig/extensions/libipt_unclean.c
+++ iptables/extensions/libipt_unclean.c
@@ -23,11 +23,6 @@ parse(int c, char **argv, int invert, un
 	return 0;
 }
 
-/* Final check; must have specified --mac. */
-static void final_check(unsigned int flags)
-{
-}
-
 static
 struct iptables_match unclean = { 
 	.name		= "unclean",
@@ -36,7 +31,6 @@ struct iptables_match unclean = { 
 	.userspacesize	= IPT_ALIGN(0),
 	.help		= &help,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= NULL,
 	.save		= NULL,
 };
Index: iptables/extensions/libxt_NFLOG.c
===================================================================
--- iptables.orig/extensions/libxt_NFLOG.c
+++ iptables/extensions/libxt_NFLOG.c
@@ -110,11 +110,6 @@ static int parse(int c, char **argv, int
 	return 1;
 }
 
-static void final_check(unsigned int flags)
-{
-	return;
-}
-
 static void nflog_print(const struct xt_nflog_info *info, char *prefix)
 {
 	if (info->prefix[0] != '\0')
@@ -151,7 +146,6 @@ static struct xtables_target nflog = {
 	.help		= help,
 	.init		= init,
 	.parse		= parse,
-	.final_check	= final_check,
 	.print		= print,
 	.save		= save,
 	.extra_opts	= opts,
@@ -166,7 +160,6 @@ static struct xtables_target nflog6 = {
 	.help		= help,
 	.init		= init,
 	.parse		= parse,
-	.final_check	= final_check,
 	.print		= print,
 	.save		= save,
 	.extra_opts	= opts,
Index: iptables/extensions/libxt_NFQUEUE.c
===================================================================
--- iptables.orig/extensions/libxt_NFQUEUE.c
+++ iptables/extensions/libxt_NFQUEUE.c
@@ -63,11 +63,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-static void
-final_check(unsigned int flags)
-{
-}
-
 /* Prints out the targinfo. */
 static void
 print(const void *ip,
@@ -97,7 +92,6 @@ static struct xtables_target nfqueue = {
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info)),
 	.help		= &help,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
@@ -111,7 +105,6 @@ static struct xtables_target nfqueue6 = 
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info)),
 	.help		= &help,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
Index: iptables/extensions/libxt_NOTRACK.c
===================================================================
--- iptables.orig/extensions/libxt_NOTRACK.c
+++ iptables/extensions/libxt_NOTRACK.c
@@ -26,11 +26,6 @@ parse(int c, char **argv, int invert, un
 	return 0;
 }
 
-static void
-final_check(unsigned int flags)
-{
-}
-
 static
 struct xtables_target notrack =
 {
@@ -41,7 +36,6 @@ struct xtables_target notrack =
 	.userspacesize	= XT_ALIGN(0),
 	.help		= &help,
 	.parse		= &parse,
-	.final_check	= &final_check,
 };
 
 static
@@ -54,7 +48,6 @@ struct xtables_target notrack6 =
 	.userspacesize	= XT_ALIGN(0),
 	.help		= &help,
 	.parse		= &parse,
-	.final_check	= &final_check,
 };
 
 void _init(void)
Index: iptables/extensions/libxt_TRACE.c
===================================================================
--- iptables.orig/extensions/libxt_TRACE.c
+++ iptables/extensions/libxt_TRACE.c
@@ -26,11 +26,6 @@ parse(int c, char **argv, int invert, un
 	return 0;
 }
 
-static void
-final_check(unsigned int flags)
-{
-}
-
 static struct xtables_target trace = {
 	.family		= AF_INET,
 	.name		= "TRACE",
@@ -39,7 +34,6 @@ static struct xtables_target trace = {
 	.userspacesize	= XT_ALIGN(0),
 	.help		= &help,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= NULL, /* print */
 	.save		= NULL, /* save */
 };
@@ -52,7 +46,6 @@ static struct xtables_target trace6 = {
 	.userspacesize	= XT_ALIGN(0),
 	.help		= &help,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= NULL, /* print */
 	.save		= NULL, /* save */
 };
Index: iptables/extensions/libxt_dccp.c
===================================================================
--- iptables.orig/extensions/libxt_dccp.c
+++ iptables/extensions/libxt_dccp.c
@@ -193,11 +193,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-static void
-final_check(unsigned int flags)
-{
-}
-
 static char *
 port_to_service(int port)
 {
@@ -360,7 +355,6 @@ static struct xtables_match dccp =
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
@@ -376,7 +370,6 @@ static struct xtables_match dccp6 =
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
Index: iptables/extensions/libxt_esp.c
===================================================================
--- iptables.orig/extensions/libxt_esp.c
+++ iptables/extensions/libxt_esp.c
@@ -107,12 +107,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-/* Final check; we don't care. */
-static void
-final_check(unsigned int flags)
-{
-}
-
 static void
 print_spis(const char *name, u_int32_t min, u_int32_t max,
 	    int invert)
@@ -172,7 +166,6 @@ static struct xtables_match esp = { 
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
@@ -187,7 +180,6 @@ static struct xtables_match esp6 = { 
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
Index: iptables/extensions/libxt_limit.c
===================================================================
--- iptables.orig/extensions/libxt_limit.c
+++ iptables/extensions/libxt_limit.c
@@ -126,11 +126,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-/* Final check; nothing. */
-static void final_check(unsigned int flags)
-{
-}
-
 static struct rates
 {
 	const char *name;
@@ -183,7 +178,6 @@ static struct xtables_match limit = { 
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
@@ -198,7 +192,6 @@ static struct xtables_match limit6 = { 
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
Index: iptables/extensions/libxt_quota.c
===================================================================
--- iptables.orig/extensions/libxt_quota.c
+++ iptables/extensions/libxt_quota.c
@@ -79,12 +79,6 @@ parse(int c, char **argv, int invert, un
         return 1;
 }
 
-/* no final check */
-static void
-final_check(unsigned int flags)
-{
-}
-
 struct xtables_match quota = { 
 	.family		= AF_INET,
 	.name		= "quota",
@@ -93,7 +87,6 @@ struct xtables_match quota = { 
 	.userspacesize	= offsetof(struct xt_quota_info, quota),
 	.help		= &help,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
@@ -107,7 +100,6 @@ struct xtables_match quota6 = { 
 	.userspacesize	= offsetof(struct xt_quota_info, quota),
 	.help		= &help,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
Index: iptables/extensions/libxt_sctp.c
===================================================================
--- iptables.orig/extensions/libxt_sctp.c
+++ iptables/extensions/libxt_sctp.c
@@ -317,11 +317,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-static void
-final_check(unsigned int flags)
-{
-}
-
 static char *
 port_to_service(int port)
 {
@@ -534,7 +529,6 @@ static struct xtables_match sctp = {
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
@@ -549,7 +543,6 @@ static struct xtables_match sctp6 = {
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
Index: iptables/extensions/libxt_standard.c
===================================================================
--- iptables.orig/extensions/libxt_standard.c
+++ iptables/extensions/libxt_standard.c
@@ -26,11 +26,6 @@ parse(int c, char **argv, int invert, un
 	return 0;
 }
 
-/* Final check; don't care. */
-static void final_check(unsigned int flags)
-{
-}
-
 /* Saves the targinfo in parsable form to stdout. */
 static void
 save(const void *ip, const struct xt_entry_target *target)
@@ -46,7 +41,6 @@ struct xtables_target standard = { 
 	.userspacesize	= XT_ALIGN(sizeof(int)),
 	.help		= &help,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= NULL,
 	.save		= &save,
 };
@@ -60,7 +54,6 @@ struct xtables_target standard6 = { 
 	.userspacesize	= XT_ALIGN(sizeof(int)),
 	.help		= &help,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= NULL,
 	.save		= &save,
 };
Index: iptables/extensions/libxt_tcp.c
===================================================================
--- iptables.orig/extensions/libxt_tcp.c
+++ iptables/extensions/libxt_tcp.c
@@ -220,12 +220,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-/* Final check; we don't care. */
-static void
-final_check(unsigned int flags)
-{
-}
-
 static char *
 port_to_service(int port)
 {
@@ -402,7 +396,6 @@ static struct xtables_match tcp = { 
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts,
@@ -417,7 +410,6 @@ static struct xtables_match tcp6 = { 
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts,
Index: iptables/extensions/libxt_time.c
===================================================================
--- iptables.orig/extensions/libxt_time.c
+++ iptables/extensions/libxt_time.c
@@ -326,10 +326,6 @@ static int time_parse(int c, char **argv
 	return 0;
 }
 
-static void time_check(unsigned int flags)
-{
-}
-
 static void time_print_date(time_t date, const char *command)
 {
 	struct tm *t;
@@ -476,7 +472,6 @@ static struct xtables_match time_reg = {
 	.help          = time_help,
 	.init          = time_init,
 	.parse         = time_parse,
-	.final_check   = time_check,
 	.print         = time_print,
 	.save          = time_save,
 	.extra_opts    = time_opts,
@@ -491,7 +486,6 @@ static struct xtables_match time6_reg = 
 	.help          = time_help,
 	.init          = time_init,
 	.parse         = time_parse,
-	.final_check   = time_check,
 	.print         = time_print,
 	.save          = time_save,
 	.extra_opts    = time_opts,
Index: iptables/extensions/libxt_u32.c
===================================================================
--- iptables.orig/extensions/libxt_u32.c
+++ iptables/extensions/libxt_u32.c
@@ -247,10 +247,6 @@ static int u32_parse(int c, char **argv,
 	}
 }
 
-static void u32_check(unsigned int flags)
-{
-}
-
 static void u32_print(const void *ip, const struct xt_entry_match *match,
                       int numeric)
 {
@@ -280,7 +276,6 @@ static struct xtables_match u32_reg = {
 	.userspacesize = XT_ALIGN(sizeof(struct xt_u32)),
 	.help          = u32_help,
 	.parse         = u32_parse,
-	.final_check   = u32_check,
 	.print         = u32_print,
 	.save          = u32_save,
 	.extra_opts    = u32_opts,
@@ -294,7 +289,6 @@ static struct xtables_match u32_reg6 = {
 	.userspacesize = XT_ALIGN(sizeof(struct xt_u32)),
 	.help          = u32_help,
 	.parse         = u32_parse,
-	.final_check   = u32_check,
 	.print         = u32_print,
 	.save          = u32_save,
 	.extra_opts    = u32_opts,
Index: iptables/extensions/libxt_udp.c
===================================================================
--- iptables.orig/extensions/libxt_udp.c
+++ iptables/extensions/libxt_udp.c
@@ -104,12 +104,6 @@ parse(int c, char **argv, int invert, un
 	return 1;
 }
 
-/* Final check; we don't care. */
-static void
-final_check(unsigned int flags)
-{
-}
-
 static char *
 port_to_service(int port)
 {
@@ -216,7 +210,6 @@ struct xtables_match udp = { 
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
@@ -232,7 +225,6 @@ struct xtables_match udp6 = { 
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
-	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
 	.extra_opts	= opts
Index: iptables/ip6tables.c
===================================================================
--- iptables.orig/ip6tables.c
+++ iptables/ip6tables.c
@@ -1840,9 +1840,10 @@ int do_command6(int argc, char *argv[], 
 	}
 
 	for (matchp = matches; matchp; matchp = matchp->next)
-		matchp->match->final_check(matchp->match->mflags);
+		if (matchp->match->final_check != NULL)
+			matchp->match->final_check(matchp->match->mflags);
 
-	if (target)
+	if (target != NULL && target->final_check != NULL)
 		target->final_check(target->tflags);
 
 	/* Fix me: must put inverse options checking here --MN */
Index: iptables/iptables.c
===================================================================
--- iptables.orig/iptables.c
+++ iptables/iptables.c
@@ -1906,9 +1906,10 @@ int do_command(int argc, char *argv[], c
 	}
 
 	for (matchp = matches; matchp; matchp = matchp->next)
-		matchp->match->final_check(matchp->match->mflags);
+		if (matchp->match->final_check != NULL)
+			matchp->match->final_check(matchp->match->mflags);
 
-	if (target)
+	if (target != NULL && target->final_check != NULL)
 		target->final_check(target->tflags);
 
 	/* Fix me: must put inverse options checking here --MN */
