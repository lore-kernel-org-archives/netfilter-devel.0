From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] libnetfilter_conntrack: bump version to 1.0.7
Date: Sun, 30 Jul 2017 01:11:48 +0200
Message-ID: <f5539cfd-68af-182b-abc8-a659704df6d6@nod.at>
References: <20170710203350.29166-1-richard@nod.at>
 <20170717154014.GA32112@salvia> <2f1aae18-6706-dd67-654d-1146c035c0d5@nod.at>
 <20170717160316.GA573@salvia>
 <nycvar.YFH.7.76.1707171808410.32562@n3.vanv.qr>
 <20170717172155.GA2434@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44723 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751661AbdG2XLx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Jul 2017 19:11:53 -0400
In-Reply-To: <20170717172155.GA2434@salvia>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

Am 17.07.2017 um 19:21 schrieb Pablo Neira Ayuso:
> On Mon, Jul 17, 2017 at 06:28:48PM +0200, Jan Engelhardt wrote:
>>
>> On Monday 2017-07-17 18:03, Pablo Neira Ayuso wrote:
>>>
>>> IIRC, we should always bump current and version even if no changes
>>> happen. Rules are here:
>>>
>>> http://git.netfilter.org/libmnl/tree/Make_global.am
>>
>> If I read those rules correctly -
>>
>>  "If any interfaces have been added"
>>
>> - then, since no interface was added, removed, or otherwise modified, no bump
>> is the right thing.
> 
> Right, after another read, it seems bump is unnecessary.
> 
> So I'm taking Richard's patch as is.

Is it on purpose that there is still no 1.0.7 release?
Same question for libnetfilter_queue 1.0.3.

Thanks,
//richard
