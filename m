From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [Nftables RFC] High level library proposal
Date: Tue, 23 Apr 2013 13:15:10 +0300
Message-ID: <51765F2E.9000909@linux.intel.com>
References: <516EA684.9040209@linux.intel.com> <20130419100531.GA3481@localhost> <517129D8.8000006@linux.intel.com> <20130419121127.GA29452@localhost> <1366671791.15660.36.camel@tiger2> <20130422235012.GA4875@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@regit.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Julien Vehent <julien@linuxwall.info>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17576 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab3DWKPN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:15:13 -0400
In-Reply-To: <20130422235012.GA4875@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric and Pablo,
>>> I don't get why you may need something different than libmnl or libnl.
>> I don't think Tomasz need it but future application developers will
>> really love to avoid to learn how netlink messages are build.

I actually need this flexibility. But indeed, it's thought to hide 
netlink IOs anyway.

> I was referring to the driver switch that he wants to introduce to
> select libnl or libmnl in runtime, it makes no sense to me.

It's easy to support it. Moreover that it won't affect all devs:
most will just initiate the library to use libnl or libmnl, and won't 
have to provide their own driver implementation.
They will just call nft_init() with NULL as the nl driver and that's it.

If it does not make sense to you to bring this little flexibility then 
ok, let's use libnl.
But then no need to use limnl/libnftables: let's use instead 
libnl-nftables which already does everything on this level, afaik.

My point of using libmnl/libnftables was especially to bring this 
possibility of using something else than
libmnl/libnl to discuss with netlink: since libnftables it dedicated on 
parsing/building nftables nlh (it's perfect for that),
and since libnftables has a dependency over libmnl, let's use libmnl as 
the default one for netlink conversation.

We could solve it another way, like exposing core functions, the fds and 
so on, like libdbus does but I don't like it much.
Instead, providing a structure which tells what subset of functions and 
their signatures is required is nicer. As I said, I tried
a quick PoC on that.

And you can see that feature as being part of a lower level access in 
the API.

>> We definitely need different level of abstractions.
> Nobody said here that we don't need high level abstractions.
>
> My point is that the library should provide different level of
> abstractions, so you can switch to the level you want. Think of it as
> an elevator that takes you to the 1st floor or 9th floor. Depending
> where you get, you see more or less details. If designed carefully,
> that should be possible.

I am not against such different levels, but indeed it requires to be 
careful: if we propose too much things
without good reasons, many devs will just miss-use the API for sure. I 
guess we should provide this different levels
during the lib implementation. It is easier to solve this from top level 
to bottom, incrementally.


Br,

Tomasz
