From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/4] netfilter: xtables: merge registration structure to
 NFPROTO_UNSPEC
Date: Wed, 31 Mar 2010 10:37:58 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1003311036110.4527@obet.zrqbmnf.qr>
References: <1270022629-2494-1-git-send-email-jengelh@medozas.de> <1270022629-2494-5-git-send-email-jengelh@medozas.de> <4BB30861.3060101@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35648 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932704Ab0CaIh7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:37:59 -0400
In-Reply-To: <4BB30861.3060101@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-31 10:31, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> +static struct xt_match state_mt_reg __read_mostly = {
>> +	.name       = "state",
>> +	.family     = NFPROTO_UNSPEC,
>> +	.checkentry = state_mt_check,
>> +	.match      = state_mt,
>> +	.destroy    = state_mt_destroy,
>> +	.matchsize  = sizeof(struct xt_state_info),
>> +	.me         = THIS_MODULE,
>>  };
>
>This is the one I actually wanted to see since the subject didn't
>state which module is changes.
>
>The patch looks fine, however I'd prefer if in the future you'd add
>a changelog entry for these conversions stating why this will work
>properly in all cases even with arptables and ebtables using the
>xtables infrastructure.

This will work because x_tables scans for NFPROTO_UNSPEC,
and arp/ebtables just using x_tables :-)
