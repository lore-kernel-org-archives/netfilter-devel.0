From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] libnetfilter_conntrack: bump version to 1.0.7
Date: Mon, 17 Jul 2017 18:13:06 +0200
Message-ID: <eb8bbcf6-7acf-5f82-2afd-8f688c75b7ac@nod.at>
References: <20170710203350.29166-1-richard@nod.at>
 <20170717154014.GA32112@salvia> <2f1aae18-6706-dd67-654d-1146c035c0d5@nod.at>
 <20170717160316.GA573@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44723 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751286AbdGQQNI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 12:13:08 -0400
In-Reply-To: <20170717160316.GA573@salvia>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

Am 17.07.2017 um 18:03 schrieb Pablo Neira Ayuso:
> On Mon, Jul 17, 2017 at 05:57:58PM +0200, Richard Weinberger wrote:
>> Pablo,
>>
>> Am 17.07.2017 um 17:40 schrieb Pablo Neira Ayuso:
>>> On Mon, Jul 10, 2017 at 10:33:50PM +0200, Richard Weinberger wrote:
>>>> This is a maintenance release, so the version is just bumped to 1.0.7.
>>>
>>> Applied, thanks.
>>>
>>> P.S: I have also updated libversion, so I have mangled this patch.
>>
>> I thought about this but didn't since the version change to 1.0.5 also
>> didn't not and AFAICT the interface didn't change.
>>
>> In order to avoid future overhead for you, what are the rules regarding
>> libversion updates?
> 
> IIRC, we should always bump current and version even if no changes
> happen. Rules are here:
> 
> http://git.netfilter.org/libmnl/tree/Make_global.am

Good to know!

Thanks,
//richard
