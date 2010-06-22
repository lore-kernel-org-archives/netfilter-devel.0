From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] net-next-2.6, Complete deprecation of CONFIG_NF_CT_ACCT
Date: Tue, 22 Jun 2010 14:43:25 +0200
Message-ID: <4C20AFED.2050501@trash.net>
References: <20100618175206.2E1CBF88CE@sepang.rtg.net> <4C20545A.90405@trash.net> <4C20AF58.1070900@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, ole@ans.pl
To: timg@tpi.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48283 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab0FVMn2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 08:43:28 -0400
In-Reply-To: <4C20AF58.1070900@tpi.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tim Gardner wrote:
> On 06/22/2010 12:12 AM, Patrick McHardy wrote:
>> Tim Gardner wrote:
>>> Hi,
>>>
>>> I noticed some noise in my server log, so I thought it might be time to
>>> finish this deprecation. One concern I have is about xt_connbytes. The
>>> Kconfig for NETFILTER_XT_MATCH_CONNBYTES used to 'SELECT NF_CT_ACCT'
>>> which forced nf_conntrack.acct=1. As long as the value of
>>> NF_CT_ACCT_DEFAULT
>>> remains 1, then xt_connbytes should be OK.
>>
>> Yeah, but we need to take care of the other case anyways. As I've
>> repeatedly stated, connbytes needs to enable accounting when the
>> first rule using it is added.
>>
>
> I thought you might say that. Lemme see what I can come up with. 

It should be quite easy, we have the namespace available in current
kernels in xt_mtchk_param->net, so basically all you need to do is
move the nf_ct_acct parameter to the per-namespace data and enable
it once a rule is added.

Let me know if you have any questions.
