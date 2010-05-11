From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf-next: a mixed bag, try#2
Date: Tue, 11 May 2010 19:02:13 +0200
Message-ID: <4BE98D95.7020409@trash.net>
References: <1273596452-27011-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43789 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab0EKRCR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 May 2010 13:02:17 -0400
In-Reply-To: <1273596452-27011-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
>> My suggestions would be for me to merge patches 01-08 and you
>> include the remaining ones in a series that actually need that
>> change. If you manage to submit that series in time for 2.6.35,
>> even better. How does that sound?
> 
> 
> How do these eight look? :)
> 
> 
> The following changes since commit e772c349a11de448f194d0c9f2e7eb23800e1a13:
>   Patrick McHardy (1):
>         netfilter: nf_ct_h323: switch "incomplete TPKT" message to pr_debug()
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/linux master
> 
> Jan Engelhardt (8):
>       netfilter: ip_tables: fix compilation when debug is enabled
>       netfilter: xtables: fix incorrect return code
>       netfilter: xtables: dissolve do_match function
>       netfilter: xtables: combine struct xt_match_param and xt_target_param
>       netfilter: xtables: substitute temporary defines by final name
>       netfilter: xtables: deconstify struct xt_action_param for matches
>       netfilter: xtables: change hotdrop pointer to direct modification
>       netfilter: xtables: combine built-in extension structs
> 

Pulled, thanks Jan.
