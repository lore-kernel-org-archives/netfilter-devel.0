From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: Make ip6tables, iptables and iptables-xml
 use xtables_globals
Date: Wed, 11 Feb 2009 16:22:06 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902111620080.20223@fbirervta.pbzchgretzou.qr>
References: <1234236724.20903.34.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38681 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbZBKPWJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:22:09 -0500
In-Reply-To: <1234236724.20903.34.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2009-02-10 04:32, jamal wrote:

>+++ b/Makefile.am
>@@ -21,6 +21,7 @@ iptables_SOURCES          = iptables-standalone.c iptables.c
> iptables_LDFLAGS          = -rdynamic
> iptables_LDADD            = -ldl -lm libiptc/libiptc.a extensions/libext4.a libxtables.la
> 
>+iptables_xml_LDADD        = -ldl libxtables.la
> iptables_multi_SOURCES    = iptables-multi.c iptables-save.c \
>                             iptables-restore.c iptables-xml.c \
>                             iptables-standalone.c iptables.c


-ldl does not belong to iptables_xml, this must be added
to libxtables_la_LIBADD instead (see 5c3e076 in my tree)

>+struct xtables_globals ip6tables_globals = {
>+	.option_offset = 0,
>+	.program_version = IPTABLES_VERSION,
>+	.program_name = "ip6tables",
>+	.opts = original_opts,
>+	.exit_error = exit_error,
>+};
> 
> /* Table of legal combinations of commands and options.  If any of the
>  * given commands make an option legal, that option is legal (applies to
>@@ -1371,6 +1378,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
>            demand-load a protocol. */
> 	opterr = 0;
> 
>+	xtables_set_params(&ip6tables_globals);

This looks like it would print "ip6tables" even when you
run ip6tables-restore, which is not what is wanted.

That said, libxtables does not even make use of _globals->program_name,
so I am terribly confused.

>+struct xtables_globals iptables_xml_globals = {
>+	.option_offset = 0,
>+	.program_version = IPTABLES_VERSION,
>+	.program_name = "iptables-xml",
>+	.exit_error = exit_error,
>+};
> 
> #ifdef IPTABLES_MULTI
> int
>@@ -646,6 +653,7 @@ main(int argc, char *argv[])
> 	program_version = IPTABLES_VERSION;
> 	line = 0;
> 
>+	xtables_set_params(&iptables_xml_globals);
> 	while ((c = getopt_long(argc, argv, "cvh", options, NULL)) != -1) {
> 		switch (c) {
> 		case 'c':
>diff --git a/iptables.c b/iptables.c
>index f1a5d33..e8bed87 100644
>--- a/iptables.c
>+++ b/iptables.c
>@@ -145,6 +145,14 @@ int line = -1;
> static struct option *opts = original_opts;
> static unsigned int global_option_offset = 0;
> 
>+struct xtables_globals iptables_globals = {
>+	.option_offset = 0,
>+	.program_version = IPTABLES_VERSION,
>+	.program_name = "iptables",
>+	.opts = original_opts,
>+	.exit_error = exit_error,
>+};
>+
> /* Table of legal combinations of commands and options.  If any of the
>  * given commands make an option legal, that option is legal (applies to
>  * CMD_LIST and CMD_ZERO only).
>@@ -1393,6 +1401,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
>            demand-load a protocol. */
> 	opterr = 0;
> 
>+	xtables_set_params(&iptables_globals);
> 	while ((c = getopt_long(argc, argv,
> 	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
> 					   opts, NULL)) != -1) {
