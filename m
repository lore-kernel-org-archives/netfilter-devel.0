From: Patrick McHardy <kaber@trash.net>
Subject: Re: guided option parser, run 5
Date: Mon, 09 May 2011 20:24:41 +0200
Message-ID: <4DC83169.3050606@trash.net>
References: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57604 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab1EISYp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 14:24:45 -0400
In-Reply-To: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 09.05.2011 11:36, schrieb Jan Engelhardt:
> The following changes since commit edc2b1adf32d2b11e126174f525293b3bca6e7bc:
> 
>   Merge branch 'opts' of git://dev.medozas.de/iptables (2011-05-09 11:26:32 +0200)
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/iptables opts
> 
> Jan Engelhardt (13):
>       libxt_tos: add inversion support back again
>       libxtables: fix assignment in wrong offset (XTTYPE_UINT*RC)
>       libxt_u32: add missing call to xtables_option_parse
>       extensions: remove bogus use of XT_GETOPT_TABLEEND
>       libxt_owner: remove ifdef IPT_COMM_OWNER
>       libxtables: output name of extension on rev detect failure
>       extensions: const annotations
>       libxt_statistic: streamline and document possible placement of negation
>       libxt_statistic: increase precision on create and dump
>       libxtables: XTTYPE_DOUBLE support
>       libxt_statistic: use guided option parser
>       libxt_IDLETIMER: use guided option parser
>       libxt_NFLOG: use guided option parser


Pulled, thanks Jan.
