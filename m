From: Patrick McHardy <kaber@trash.net>
Subject: Re: Doc/Option parser fixes
Date: Wed, 25 May 2011 05:35:31 +0200
Message-ID: <4DDC7903.9020706@trash.net>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33563 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab1EYDgH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 23:36:07 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.05.2011 01:08, Jan Engelhardt wrote:
> Notes:
>  - libxt_time's --localtz remains being recognized, albeit with a warning
>  - no changes to libxt_rateest parser
> 
> With this applied, I have cleared my stash of fixes, and release can
> proceed.
> 
> =-=-=
> The following changes since commit 17f7937f79af4d260c60cb800e56fc0df0a48b37:
> 
>   libxt_devgroup: actually set XT_DEVGROUP_OPT_???GROUP flags (2011-05-23 16:28:25 +0200)
> 
> are available in the git repository at:
>   git://dev.medozas.de/iptables master
> 
> JP Abgrall (1):
>       libxt_quota: make sure uint64 is not truncated
> 
> Jan Engelhardt (22):
>       libxtables: retract _NE types and use a flag instead
>       libxt_quota: readd missing XTOPT_PUT request
>       libxtables: check for negative numbers in xtables_strtou*
>       libxt_rateest: streamline case display of units
>       doc: add some coded option examples to libxt_hashlimit
>       doc: make usage of libxt_rateest more obvious
>       doc: clarify that -p all is a special keyword only
>       doc: use .IP list for TCPMSS
>       doc: remove redundant .IP calls in libxt_time
>       libxt_ipvs: restore network-byte order
>       libxt_u32: --u32 option is required
>       libip6t_rt: restore --rt-type storing
>       libxtables: more detailed error message on multi-int parsing
>       libxtables: use uintmax for xtables_strtoul
>       libxtables: make multiint parser have greater range
>       libxtables: unclutter xtopt_parse_mint
>       libxtables: have xtopt_parse_mint interpret partially-spec'd ranges
>       libxt_NFQUEUE: avoid double attempt at parsing
>       libxt_NFQUEUE: add mutual exclusion between qnum and qbal
>       libxt_time: always ignore libc timezone
>       libxt_time: --utc and --localtz are mutually exclusive
>       libxt_time: deprecate --localtz option, document kernel TZ caveats
> 
> Lutz Jaenicke (1):
>       libipt_REDIRECT: "--to-ports" is not mandatory

Pulled, thanks Jan.
