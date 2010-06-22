From: Tim Gardner <timg@tpi.com>
Subject: Re: [PATCH] net-next-2.6, Complete deprecation of CONFIG_NF_CT_ACCT
Date: Tue, 22 Jun 2010 06:40:56 -0600
Message-ID: <4C20AF58.1070900@tpi.com>
References: <20100618175206.2E1CBF88CE@sepang.rtg.net> <4C20545A.90405@trash.net>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, ole@ans.pl
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:3045 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756595Ab0FVMlH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 08:41:07 -0400
In-Reply-To: <4C20545A.90405@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/22/2010 12:12 AM, Patrick McHardy wrote:
> Tim Gardner wrote:
>> Hi,
>>
>> I noticed some noise in my server log, so I thought it might be time to
>> finish this deprecation. One concern I have is about xt_connbytes. The
>> Kconfig for NETFILTER_XT_MATCH_CONNBYTES used to 'SELECT NF_CT_ACCT'
>> which forced nf_conntrack.acct=1. As long as the value of
>> NF_CT_ACCT_DEFAULT
>> remains 1, then xt_connbytes should be OK.
>
> Yeah, but we need to take care of the other case anyways. As I've
> repeatedly stated, connbytes needs to enable accounting when the
> first rule using it is added.
>

I thought you might say that. Lemme see what I can come up with.

> You also don't need to update the defconfigs, architecture maintainers
> can take care of that.

ack

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
