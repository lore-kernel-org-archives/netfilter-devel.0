From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libipt_SNAT: Add translation to nft
Date: Mon, 28 Dec 2015 20:32:47 +0530
Message-ID: <CAKHNQQF6j=u7qsUyP3TUhFbBLLqf++r+rqs9FM1LaPQ8GZ_EcQ@mail.gmail.com>
References: <20151225171659.GA11250@gmail.com> <20151228122035.GB19188@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38568 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbbL1PDI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Dec 2015 10:03:08 -0500
Received: by mail-wm0-f52.google.com with SMTP id l126so271901720wml.1
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 07:03:07 -0800 (PST)
In-Reply-To: <20151228122035.GB19188@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 28, 2015 at 5:50 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Dec 25, 2015 at 10:46:59PM +0530, Shivani Bhardwaj wrote:
>> Add translation for target SNAT to nftables.
>>
>> Examples:
>>
>> $ sudo iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4
>> nft add rule ip nat postrouting oifname eth0 counter snat 1.2.3.4
>>
>> $ sudo iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4-1.2.3.6
>> nft add rule ip nat postrouting oifname eth0 counter snat 1.2.3.4-1.2.3.6
>>
>> $ sudo iptables-translate -t nat -A postrouting -p tcp -o eth0 -j SNAT --to 1.2.3.4:1-1023
>> nft add rule ip nat postrouting oifname eth0 ip protocol tcp counter snat 1.2.3.4:1-1023
>>
>> $ sudo iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4 --random
>> nft add rule ip nat postrouting oifname eth0 counter snat 1.2.3.4 random
>>
>> $ sudo iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4 --random-fully
>> nft add rule ip nat postrouting oifname eth0 counter snat 1.2.3.4 fully-random
>
> If two flags are specified, then this should look like:
>
> ... postrouting oifname eth0 counter snat 1.2.3.4 fully-random,persistent
>                                                               ^
>
> In nft, we always represents flags as command separated values.
>
> Same applied to NFQUEUE translation and its flags; BTW you sent a
> patch for this:
>
> http://patchwork.ozlabs.org/patch/559554/
>
> It would be good if you can send a v2:
>

I'm sending v2 for this and DNAT. NFQUEUE and MARK is going to take
some time. I'm having some trouble with their options. I'll send it
soon. Thanks for your patience.

> Thanks.
