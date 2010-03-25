From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf-next: cleanups, err reporting (rd.2)
Date: Thu, 25 Mar 2010 13:48:36 +0100
Message-ID: <4BAB5BA4.3090007@trash.net>
References: <1269285486-22653-1-git-send-email-jengelh@medozas.de> <alpine.LSU.2.01.1003231734040.19672@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51161 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab0CYMsh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:48:37 -0400
In-Reply-To: <alpine.LSU.2.01.1003231734040.19672@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2010-03-22 20:17, Jan Engelhardt wrote:
>> Jan Engelhardt (9):
>>      netfilter: xtables: make use of caller family rather than target family
>>      netfilter: xt extensions: use pr_<level> (2)
>>      netfilter: xtables: make use of xt_request_find_target
>>      netfilter: xtables: consolidate code into xt_request_find_match
>>      netfilter: xt_recent: allow changing ip_list_[ug]id at runtime
> 
> I have incorporated your comments; as I'm still on with the error reporting
> pieces, here is the batch of five instead:
> Please merge.
> 
> 
> The following changes since commit 2c46cd8163b25bf6f38e612e9f1d162f0357c8f1:
>   Zhitong Wang (1):
>         netfilter: remove unused headers in net/ipv4/netfilter/nf_nat_h323.c
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/linux master
> 
> Jan Engelhardt (5):
>       netfilter: xtables: make use of caller family rather than target family
>       netfilter: xt extensions: use pr_<level> (2)
>       netfilter: xtables: make use of xt_request_find_target
>       netfilter: xtables: consolidate code into xt_request_find_match
>       netfilter: xt_recent: allow changing ip_list_[ug]id at runtime

Please repost these patches, I have a few more comments but I'd like
to make sure they're still relevant for the latest patchset.
