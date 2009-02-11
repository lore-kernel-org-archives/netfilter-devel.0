From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: define xtables_free_opts()
Date: Wed, 11 Feb 2009 16:17:10 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902111615590.20223@fbirervta.pbzchgretzou.qr>
References: <1234213287.20903.19.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48638 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbZBKPRL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:17:11 -0500
In-Reply-To: <1234213287.20903.19.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2009-02-09 22:01, jamal wrote:

>
>A user of the structure xtables_globals. Next goal is to attack
>exit_error() so i can compile that basic program..
>
>cheers,
>jamal
>

>+void xtables_free_opts(int reset_offset, struct option *original_opts)
>+{
>+	if (xt_params->opts != original_opts) {
>+		if (original_opts) 
>+			free(xt_params->opts);
>+		xt_params->opts = original_opts;
>+		if (reset_offset)
>+			xt_params->option_offset = 0;
>+	}
>+}
>+

While this may have been just moved from iptables.c or so
(where? I do not see any deletions or conversions of code
that is supposed to make use of xtables_free_opts!)
this function needs some comments to explain just why
it is supposed to be doing this.
