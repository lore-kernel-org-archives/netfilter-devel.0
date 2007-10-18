From: Patrick McHardy <kaber@trash.net>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Thu, 18 Oct 2007 10:43:34 +0200
Message-ID: <47171CB6.30500@trash.net>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl> <47047DF3.5030305@trash.net> <Pine.LNX.4.64.0710172210380.8216@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63993 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbXJRIn5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 04:43:57 -0400
In-Reply-To: <Pine.LNX.4.64.0710172210380.8216@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Krzysztof Oledzki wrote:
> 
> 
> On Thu, 4 Oct 2007, Patrick McHardy wrote:
> 
>> Krzysztof Oledzki wrote:
>>> [NETFILTER]: Trivial fix for "nf_ct_tcp: invalid SYN"
>>>
>>> This nf_log_packet needs a space char. Trivial fix
>>>
>>> Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
>>
>> Applied, thanks.
> 
> With latest fixes from Jozsef this patch should be dropped as this code 
> was removed and now there is nothing to fix. ;)


I already dropped it when I applied the first fix since it
included that part :)
