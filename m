From: Domen Puncer <domen.puncer@samsung.com>
Subject: Re: [PATCH iptables] libxtables: fix getaddrinfo return value usage
Date: Thu, 12 Jun 2014 08:01:29 +0100
Message-ID: <53995049.4040304@samsung.com>
References: <5397084D.8020703@samsung.com> <20140611093758.GA5427@localhost>
 <539825E3.6020000@samsung.com> <20140611175550.GA17981@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64113 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbaFLHCf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:02:35 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N7100CR3NJUP220@mailout2.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Thu, 12 Jun 2014 08:02:18 +0100 (BST)
In-reply-to: <20140611175550.GA17981@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/06/14 18:55, Pablo Neira Ayuso wrote:
> On Wed, Jun 11, 2014 at 10:48:19AM +0100, Domen Puncer wrote:
>> On 11/06/14 10:37, Pablo Neira Ayuso wrote:
>>> On Tue, Jun 10, 2014 at 02:29:49PM +0100, Domen Puncer wrote:
>>>> getaddrinfo return value on error can also be positive.
>>>
>>> At quick glance, all EAI_* that I see are negative.
>>
>> You don't see all of them :-)
>> On Android they're positive, e.g.:
>> 	android-ndk-r9d/platforms/android-19/arch-arm/usr/include/netdb.h
>> 	147 #define EAI_NONAME       8      /* hostname nor servname provided,
>> or not known */
> 
> I suspected something like this..
> 
> Please, next time include this in the patch description since the
> beginning, thanks.

OK. Will do so.

> 
>> And as a plus, it's not bad to conform to specs.
> 
> It sounds like a reasonable assumption to me.
> 
> Do you have more patches like this in your queue?

Sorry, this was just a one-off.


Best regards,
  Domen
