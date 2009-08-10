From: Patrick McHardy <kaber@trash.net>
Subject: Re: Pull request for cleanups
Date: Mon, 10 Aug 2009 14:46:40 +0200
Message-ID: <4A8016B0.6020002@trash.net>
References: <alpine.LSU.2.00.0908101339590.2986@fbirervta.pbzchgretzou.qr> <4A8012D5.2000707@trash.net> <alpine.LSU.2.00.0908101442320.7478@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65198 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbZHJMqm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:46:42 -0400
In-Reply-To: <alpine.LSU.2.00.0908101442320.7478@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-08-10 14:30, Patrick McHardy wrote:
>   
>>> Jan Engelhardt (18):
>>>       netfilter: xtables: remove xt_TOS v0
>>>       netfilter: xtables: remove xt_CONNMARK v0
>>>       netfilter: xtables: remove xt_MARK v0, v1
>>>       netfilter: xtables: remove xt_connmark v0
>>>       netfilter: xtables: remove xt_conntrack v0
>>>       
>> Sorry, I didn't notice before how recently the (broken) revision 1
>> got added.
>>     
>
> Hm? All of the new revisions were added for v2.6.25 (April 16 2008),
> which is 1.33 years from now.

Right, I misread the year, sorry. I'll double check the remaining
ones and will pull it in if the others are also fine.
