From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] netfilter: xt_connbytes: Force CT accounting to be
 enabled
Date: Fri, 25 Jun 2010 10:44:53 +0200
Message-ID: <4C246C85.1040704@trash.net>
References: <1277393257-15281-1-git-send-email-tim.gardner@canonical.com> <1277393257-15281-3-git-send-email-tim.gardner@canonical.com> <alpine.LSU.2.01.1006241915040.324@obet.zrqbmnf.qr> <4C23A8C1.2070506@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: tim.gardner@canonical.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53442 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab0FYIo7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jun 2010 04:44:59 -0400
In-Reply-To: <4C23A8C1.2070506@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tim Gardner wrote:
> On 06/24/2010 11:15 AM, Jan Engelhardt wrote:
>>
>> On Thursday 2010-06-24 17:27, Tim Gardner wrote:
>>> diff --git a/net/netfilter/xt_connbytes.c 
>>> b/net/netfilter/xt_connbytes.c
>>> index 7351783..b0cda8c 100644
>>> --- a/net/netfilter/xt_connbytes.c
>>> +++ b/net/netfilter/xt_connbytes.c
>>> @@ -112,6 +112,16 @@ static int connbytes_mt_check(const struct 
>>> xt_mtchk_param *par)
>>>     if (ret<  0)
>>>         pr_info("cannot load conntrack support for proto=%u\n",
>>>             par->family);
>>> +
>>> +    /*
>>> +     * This filter cannot function correctly unless connection 
>>> tracking
>>> +     * accounting is enabled, so complain in the hope that someone 
>>> notices.
>>> +     */
>>> +    if (nf_ct_acct_enabled(par) == false) {
>>
>>     if (!nfct_acct_enabled(par)) {
>>
>>> +        pr_warning("Forcing CT accounting to be enabled\n");
>>> +        nf_ct_set_acct(par, true);
>>> +    }
>>> +
>>>     return ret;
>>> }
>> -- 
>
> meh, I suppose portability isn't the issue it once was with respect to 
> boolean and signed integers. Here is the combined 1 and 2 patches. If 
> its sufficient I'll resend the pull request as a V4.
>

Looks fine to me.

