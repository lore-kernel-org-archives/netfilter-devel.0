From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH v2] iptables: libxt_recent: Add support for --reap
 option
Date: Fri, 2 Dec 2011 16:30:20 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112021628190.5296@frira.zrqbmnf.qr>
References: <1322789373-30474-1-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Tim Gardner <tim.gardner@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:56835 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1LBPaW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Dec 2011 10:30:22 -0500
In-Reply-To: <1322789373-30474-1-git-send-email-tim.gardner@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2011-12-02 02:29, Tim Gardner wrote:
>@@ -34,6 +36,8 @@ static const struct xt_option_entry recent_opts[] = {
> 	 .excl = F_ANY_OP, .flags = XTOPT_INVERT},
> 	{.name = "seconds", .id = O_SECONDS, .type = XTTYPE_UINT32,
> 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, seconds)},
>+	{.name = "reap", .id = O_REAP, .type = XTTYPE_NONE,
>+	 .also = F_SECONDS },
> 	{.name = "hitcount", .id = O_HITCOUNT, .type = XTTYPE_UINT32,
> 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, hit_count)},
> 	{.name = "rttl", .id = O_RTTL, .type = XTTYPE_NONE,

>+
>+	if ((info->check_set & XT_RECENT_REAP) && !info->seconds)
>+		xtables_error(PARAMETER_PROBLEM,
>+			"recent: you must specify `--seconds' with `--reap'");
> }

Well, I did mean that .also = F_SECONDS makes the extra
"info->check_set & XT_RECENT_REAP) && !info->seconds" test
redundant. Or, the error message is wrong, because you are
actually testing for seconds==0 rather than "reap was specified
without seconds".
Is seconds=0 even useful for non-reap cases?
If not, we should probably consider using .min=1 on the --seconds
parameter, in which case the test is also redundant.

