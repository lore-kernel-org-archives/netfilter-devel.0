From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack.acct has no effect
Date: Tue, 17 Mar 2009 14:57:43 +0100
Message-ID: <49BFAC57.1060702@trash.net>
References: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr> <49BE84D4.7050804@trash.net> <20090317082425.GA25491@mail.eitzenberger.org> <49BF9F7E.3090208@trash.net> <alpine.LNX.1.10.0903171411560.17354@bizon.gios.gov.pl> <49BFA633.4010306@trash.net> <alpine.LNX.1.10.0903171444060.14581@bizon.gios.gov.pl> <49BFAADF.9000008@trash.net> <alpine.LNX.1.10.0903171452570.14581@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48068 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZCQN5q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:57:46 -0400
In-Reply-To: <alpine.LNX.1.10.0903171452570.14581@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
> 
> 
> On Tue, 17 Mar 2009, Patrick McHardy wrote:
> 
>> Krzysztof Oledzki wrote:
>>>> I'd say it has been long enough, but Jan raised a valid point.
>>>> We can't use the Kconfig selection anymore once we remove that
>>>> option, so we need a replacement to automatically enable counters.
>>>
>>> So loading connbytes should enable accounting automatically. Fine, it 
>>> is doable. But how we want to handle it WRT to NS? Should it be 
>>> enabled in all NameSpaces or...?
>>
>> Just the ones it is actually used in I'd say (i.e. in the checkentry
>> function for the current namespace).
> 
> OK, but AFAIK modules are not namespace dependly, so why only in 
> actually used one? This bugs me a little.

But using them is namespace dependant.
