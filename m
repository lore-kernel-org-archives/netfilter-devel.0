From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: Add exit_error cb to xtables_globals
Date: Wed, 11 Feb 2009 16:19:53 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902111618170.20223@fbirervta.pbzchgretzou.qr>
References: <1234236584.20903.31.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48646 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZBKPTy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:19:54 -0500
In-Reply-To: <1234236584.20903.31.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-02-10 04:29, jamal wrote:

>-struct xtables_globals
>-{
>-	unsigned int option_offset;
>-	char *program_version;
>-	char *program_name;
>-	struct option *opts;
>-};
>-
> /* Include file for additions: new matches and targets. */
> struct xtables_match
> {
>@@ -191,6 +183,15 @@ enum xtables_exittype {
> 	XTF_ONE_ACTION,
> };
> 
>+struct xtables_globals
>+{
>+	unsigned int option_offset;
>+	char *program_version;
>+	char *program_name;
>+	struct option *opts;
>+	void (*exit_error)(enum xtables_exittype status, const char *msg, ...);
>+};
>+

Why move the struct now.. makes it harder to figure out what changed.
So right, exit_error.

> #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
> #endif
> 
>-struct xtables_globals *xt_params;
>+struct xtables_globals *xt_params = NULL;

Do not initialize static members - this takes up extra space
and adds no benefit. (zeroed anyway even in .bss)

>+void basic_exit_error(enum xtables_exittype status, const char *msg, ...)
>+{
>+	va_list args;
>+
>+	va_start(args, msg);
>+	fprintf(stderr, "%s v%s: ", xt_params->program_name, xt_params->program_version);
>+	vfprintf(stderr, msg, args);
>+	va_end(args);
>+	fprintf(stderr, "\n");
>+	exit(status);
>+}
>+
> /**
>  * xtables_set_params - set the global parameters used by xtables
>  * @xtp:	input xtables_globals structure
>@@ -65,6 +78,10 @@ int xtables_set_params(struct xtables_globals *xtp)
> 	}
> 
> 	xt_params = xtp;
>+
>+	if (!xt_params->exit_error)
>+		xt_params->exit_error = basic_exit_error;
>+
> 	return 0;
> }
> 

When is basic_exit_error invoked? In this patch alone, the users
are missing (or the #define).
