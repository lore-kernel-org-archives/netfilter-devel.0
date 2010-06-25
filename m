From: Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH V4 2/2] netfilter: Complete the deprecation of CONFIG_NF_CT_ACCT
Date: Fri, 25 Jun 2010 06:59:50 -0600
Message-ID: <4C24A846.7060400@canonical.com>
References: <1277469092-6247-1-git-send-email-tim.gardner@canonical.com> <1277469092-6247-3-git-send-email-tim.gardner@canonical.com> <4C24A342.2020609@trash.net>
Reply-To: tim.gardner@canonical.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2012 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab0FYNAA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:00:00 -0400
In-Reply-To: <4C24A342.2020609@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/25/2010 06:38 AM, Patrick McHardy wrote:
> Tim Gardner wrote:
>> CONFIG_NF_CT_ACCT has been deprecated for awhile and
>> was originally scheduled for removal by 2.6.29.
>
> Thanks, looks fine.
>> [ 61.669627] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
>> [ 61.669850] CONFIG_NF_CT_ACCT is deprecated and will be removed soon.
>> Please use
>> [ 61.669852] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack
>> module option or
>> [ 61.669853] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
>>
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -1597,8 +1597,7 @@ and is between 256 and 4096 characters. It is
>> defined in the file
>> [NETFILTER] Enable connection tracking flow accounting
>> 0 to disable accounting
>> 1 to enable accounting
>> - Default value depends on CONFIG_NF_CT_ACCT that is
>> - going to be removed in 2.6.29.
>> + Default value is 1
> The default should be off though, that was the point of the warning
> message,
> people using it are supposed to manually enable it. No need to resend, I'll
> manually change this when applying the patches.
> --

Works for me. Thanks.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
