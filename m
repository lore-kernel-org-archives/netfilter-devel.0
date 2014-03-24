From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: Re: [iptables 0/3] ebtables patchset
Date: Mon, 24 Mar 2014 16:26:50 +0100
Message-ID: <CAFpD06SzGS2Gty0ycuJzzsH7aBHAYu+tRuXPsMSxUxj1hU3=DA@mail.gmail.com>
References: <1394220805-18021-1-git-send-email-giuseppelng@gmail.com>
	<531D98DF.5070507@linux.intel.com>
	<20140324150956.GA32546@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:39499 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbaCXP0w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Mar 2014 11:26:52 -0400
Received: by mail-we0-f171.google.com with SMTP id t61so3536609wes.16
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Mar 2014 08:26:51 -0700 (PDT)
In-Reply-To: <20140324150956.GA32546@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2014-03-24 16:09 GMT+01:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Mon, Mar 10, 2014 at 12:50:07PM +0200, Tomasz Bursztyka wrote:
>> Hi Pablo and Giuseppe,
>>
>> >As you can see, a minor issue have to be fixed when printing rules.
>> >I have no idea how to handle --logical-in/out interfaces currently,
>> >so please let me know if you have an idea or an advice.
>>
>> As far as I know, there is nothing in nftables's side to differentiate
>> between interfaces origin, right? (like a proper hw tight 'eth0' vs
>> a bridge 'br0')
>> Unless I miss something, it has no real meaning in nftables to
>> support such differentiation,
>> but for the sake of ebtables compat layer we might need a solution here.
>>
>> Any idea how this issue could be fixed?
>
> I think you have to extend nft_meta to support that. See
> ebt_basic_match(), the net_bridge_port information is obtained via
> br_port_get_rcu(dev) given that dev != NULL.
>
> Beware that you have to make sure that the new meta types IIFBRNAME
> and OIFBRNAME can only be used from the bridge family.  I think you
> have to do something similar to what Patrick did with nft_reject, by
> adding a specific flavour of nft_meta for the bridge family.
>
> Giuseppe, what other remaining issues you have with the ebtables
> compat layer? Could you summarize them, please? Thanks.

Hi Pablo,
minor issues to fix:

- when printing rules, the mask is printed when it shouldn't be, see below:
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
-s 11:22:33:44:55:66/0:0:0:0:0:0 -j ACCEPT

- nft_bridge_is_same not works properly
- a rule can be deleted only if the number is specified (caused by point above)

There are no other issues currently
