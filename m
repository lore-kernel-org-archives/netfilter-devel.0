From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libmnl: misc code updates
Date: Mon, 25 Oct 2010 00:45:33 +0200
Message-ID: <4CC4B70D.2000502@netfilter.org>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de> <4CC2F6AD.7070603@netfilter.org> <alpine.LNX.2.01.1010232052330.8540@obet.zrqbmnf.qr> <alpine.DEB.2.00.1010242222450.22824@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45223 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab0JXWpm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 18:45:42 -0400
In-Reply-To: <alpine.DEB.2.00.1010242222450.22824@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24/10/10 22:33, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> On Sat, 23 Oct 2010, Jan Engelhardt wrote:
> 
>> On Saturday 2010-10-23 16:52, Pablo Neira Ayuso wrote:
>>
>>> On 23/10/10 07:44, Jan Engelhardt wrote:
>>>> The following changes since commit a8956ff09c06869b6c5bc5f525944d8c228e64e9:
>>>>
>>>>   doc: git tree update (now at netfilter.org) and fix listing in doxygen (2010-10-21 13:32:42 +0200)
>>>>
>>>> are available in the git repository at:
>>>>   git://dev.medozas.de/libmnl master
>>>
>>> Thanks Jan, I have pulled patches from 1 to 11. Patches 12 and 13 change
>>> the API/ABI and I'd like to hear from Jozsef first.
>>>
>>> @Jozsef, since I haven't released first version libmnl yet, we're still
>>> in time to make those change, or would they be annoying for ipset5? If
>>> so, I won't apply them.
>>
>> I compile-tested it with ipset5, and there are no new errors or warnings 
>> popping up.
> 
> Yes, the changes are OK for ipset5, no problem for me.

OK, I have applied patches 12 and 13. Thanks!
