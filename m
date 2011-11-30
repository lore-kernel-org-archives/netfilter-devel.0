From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: libxt_recent: Add support for --reap option
Date: Wed, 30 Nov 2011 21:52:09 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1111302148150.21609@frira.zrqbmnf.qr>
References: <1322678694-23472-1-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Tim Gardner <tim.gardner@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:42620 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab1K3UwL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Nov 2011 15:52:11 -0500
In-Reply-To: <1322678694-23472-1-git-send-email-tim.gardner@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2011-11-30 19:44, Tim Gardner wrote:
>@@ -34,6 +35,7 @@ static const struct xt_option_entry recent_opts[] = {
> 	 .excl = F_ANY_OP, .flags = XTOPT_INVERT},
> 	{.name = "seconds", .id = O_SECONDS, .type = XTTYPE_UINT32,
> 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, seconds)},
>+	{.name = "reap", .id = O_REAP, .type = XTTYPE_NONE},
> 	{.name = "hitcount", .id = O_HITCOUNT, .type = XTTYPE_UINT32,
> 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, hit_count)},
> 	{.name = "rttl", .id = O_RTTL, .type = XTTYPE_NONE,
> static void recent_check(struct xt_fcheck_call *cb)
> {
>+	struct xt_recent_mtinfo *info = cb->data;
>+
> 	if (!(cb->xflags & F_ANY_OP))
> 		xtables_error(PARAMETER_PROBLEM,
> 			"recent: you must specify one of `--set', `--rcheck' "
> 			"`--update' or `--remove'");
>+
>+	if ((info->check_set & XT_RECENT_REAP) && !info->seconds)
>+		xtables_error(PARAMETER_PROBLEM,
>+			"recent: you must specify `--seconds' with `--reap'");
> }

Actually you can do {.also = F_SECONDS} near {.name = "reap"}.

>@@ -146,6 +159,7 @@ static void recent_print(const void *ip, const struct xt_entry_match *match,
>+	if(info->check_set & XT_RECENT_REAP) printf(" reap");
>
>+	if(info->check_set & XT_RECENT_REAP) printf(" --reap");

A newline would seem in order.

>+++ b/extensions/libxt_recent.man
>@@ -41,6 +41,10 @@ This option must be used in conjunction with one of \fB\-\-rcheck\fP or
> \fB\-\-update\fP. When used, this will narrow the match to only happen when the
> address is in the list and was seen within the last given number of seconds.
> .TP
>+\fB\-\-reap\fP \fIreap\fP
>+This option can only be used in conjunction with \fB\-\-seconds\fP.
>+When used, this will cause entries older then 'seconds' to be purged.

toot. s{'seconds'}{\fIreap\fP} and s{then}{than}g.
