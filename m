From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] Netfilter: Accounting rework: ct_extend + 64bit counters
 (v3)
Date: Wed, 02 Jul 2008 15:21:57 +0200
Message-ID: <486B80F5.7050801@trash.net>
References: <485a3c49.C0A/tC0/U7AaZp3V%ole@ans.pl> <486114E9.9000809@trash.net> <Pine.LNX.4.64.0806241804340.24680@bizon.gios.gov.pl> <Pine.LNX.4.64.0807021358370.4958@bizon.gios.gov.pl> <486B7D9C.4070501@trash.net> <Pine.LNX.4.64.0807021519330.4958@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37486 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYGBNWA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:22:00 -0400
In-Reply-To: <Pine.LNX.4.64.0807021519330.4958@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
> 
> 
> On Wed, 2 Jul 2008, Patrick McHardy wrote:
> 
>> Krzysztof Oledzki wrote:
>>>
>>>
>>> On Tue, 24 Jun 2008, Krzysztof Oledzki wrote:
>>>
>>> <CUT>
>>>
>>>>>> +static unsigned int nf_ct_acct __read_mostly = NF_CT_ACCT_DEFAULT;
>>>>>
>>>>> Perhaps this should be bool instead?
>>>>
>>>> Yep.
>>>
>>> It seems that it has to stay as unsigned int - if I change it to bool 
>>> I get:
>>>  net/netfilter/nf_conntrack_acct.c: In function '__check_acct':
>>>  net/netfilter/nf_conntrack_acct.c:27: warning: return from 
>>> incompatible pointer type
>>
>> You also need to use the proper module_param type.
> 
> Other than:
>  module_param_named(acct, nf_ct_acct, bool, 0644);

That and changing the type of nf_ct_acct of course. But without
seeing the line thats causing the warning I can't tell you more.
