From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: add -C to check for existing rules
Date: Tue, 8 Mar 2011 19:57:16 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1103081955520.2391@obet.zrqbmnf.qr>
References: <20110308115639.GA30013@zirkel.wertarbyte.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Stefan Tomanek <stefan.tomanek@wertarbyte.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35413 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab1CHS5R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:57:17 -0500
In-Reply-To: <20110308115639.GA30013@zirkel.wertarbyte.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2011-03-08 12:56, Stefan Tomanek wrote:
>@@ -165,7 +167,8 @@ static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
> /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
> /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' ','x'},
> /*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'},
>-/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x'}
>+/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
>+/*CHECK*/     {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x',' '}

This would make it impossible to check for a rule that used the fragment
test.

Does --lin even make sense with -C?

> };
> 
> static const int inverse_for_options[NUMBER_OF_OPT] =
>@@ -221,7 +224,7 @@ static void
> exit_printhelp(const struct xtables_rule_match *matches)
> {
> 	printf("%s v%s\n\n"
>-"Usage: %s -[AD] chain rule-specification [options]\n"
>+"Usage: %s -[ACD] chain rule-specification [options]\n"
> "       %s -I chain [rulenum] rule-specification [options]\n"
> "       %s -R chain rulenum rule-specification [options]\n"
> "       %s -D chain rulenum [options]\n"

The manpage is not updated.


Where is ip6tables support?
