From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF [PATCH 3/4] xt_TCPOPTSTRIP
Date: Tue, 27 Nov 2007 16:25:40 +0100
Message-ID: <474C36F4.7000904@trash.net>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711252006330.9477@fbirervta.pbzchgretzou.qr> <474A74C5.8050609@trash.net> <Pine.LNX.4.64.0711261718440.22369@fbirervta.pbzchgretzou.qr> <474AF214.4090301@trash.net> <Pine.LNX.4.64.0711261724100.22369@fbirervta.pbzchgretzou.qr> <474C0F79.6050105@trash.net> <Pine.LNX.4.64.0711271549260.20371@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Sven Schnelle <svens@bitebene.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64832 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbXK0PZt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:25:49 -0500
In-Reply-To: <Pine.LNX.4.64.0711271549260.20371@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 27 2007 13:37, Patrick McHardy wrote:
>>>>     
>>>>> If you quilt/stgit, just replace the patch.
>>>>>       
>>>> What are the changes?
>>>>     
>>> The name unification thing is one thing for sure. A diff would tell.
>> I merged the parts that make sense. This is the patch I have queued now.
>>
> Looks fine, thanks.
> BTW, what are the criteria that cause the tcpoptstrip_tg6 to be wrapped
> into a #ifdef CONFIG_IP6_NF_TABLES?


Dependency on IPv6 functions. CONFIG_IP6_NF_TABLES implies CONFIG_IPV6.

