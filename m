From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: collecting netfilter bugfixes for 2.6.37
Date: Sun, 09 Jan 2011 22:48:18 +0100
Message-ID: <4D2A2D22.909@netfilter.org>
References: <4D2A2ACC.6010906@netfilter.org> <alpine.LNX.2.01.1101092244040.30460@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44894 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab1AIVsW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:48:22 -0500
In-Reply-To: <alpine.LNX.2.01.1101092244040.30460@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On 09/01/11 22:45, Jan Engelhardt wrote:
> On Sunday 2011-01-09 22:38, Pablo Neira Ayuso wrote:
> 
>> Hi,
>>
>> While Patrick is not available, I have set up a tree to collect
>> netfilter bugfixes that need to get into 2.6.37 asap. You can find them at:
>>
>> http://1984.lsi.us.es/git/?p=net-2.6/.git;a=summary
>>
>> I have iterated over the emails pending in the list since Dec 16th
>> (which is when Patrick replied for last time), and I found two patches,
>> one from Eric and another from Stephen.
>>
>> Please, if you have more patches for -stable, post them to the list.
>> I'll pass them to davem by this week.
> 
> The NLM_F_DUMP patch maybe - Dave has not replied yet either on whether 
> he took care of the single patch.

That patch is not netfilter related, the common proceeding is that David
(the netdev maintainer) accepts that himself.
