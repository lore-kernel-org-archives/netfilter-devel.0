From: Jon Jensen <jon@endpoint.com>
Subject: Re: [PATCH] Correct manpage description of -n / --numeric option
Date: Fri, 28 Oct 2016 22:16:52 -0600 (MDT)
Message-ID: <alpine.LFD.2.20.1610282207570.2185@cevzz>
References: <1477707863-19649-1-git-send-email-jon@endpoint.com> <20161029024740.GC30951@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.endcrypt.com ([50.97.100.2]:56704 "EHLO mail.endcrypt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750830AbcJ2EQy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Oct 2016 00:16:54 -0400
In-Reply-To: <20161029024740.GC30951@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 29 Oct 2016, Florian Westphal wrote:

> Jon Jensen <jon@endpoint.com> wrote:
>> "When used twice" was used twice. :) Make it match the description in
>> main.c instead.
>
>>  						Numeric output: Addresses and other information
>>  						that might need network traffic to resolve to symbolic names
>> -						are shown numerically (default behaviour). When used twice,
>> +						are shown numerically (default behaviour). When used once,
>>  						internet services are translated. When used twice, internet
>>  						services and UIDs/GIDs are also shown numerically. When used
>>  						three times, protocol numbers are also shown numerically.
>
> That paragraph doesn't match what nft is doing:
>
> nft list table filter
> ip saddr 127.0.0.1 tcp dport ssh skuid "root"
> nft -n list table filter
> ip saddr 127.0.0.1 tcp dport ssh skuid "root"
> nft -nn list table filter
> ip saddr 127.0.0.1 tcp dport 22 skuid "root" // doc says this would be 'skuid 0'
> src/nft -nnn list table filter
> ip saddr 127.0.0.1 tcp dport 22 skuid 0
>
> So I suggest a rewrite of that section, e.g.
>
> Numeric output: Addresses and other information
> that might need network traffic to resolve to symbolic names
> are shown numerically (default behaviour).  When used twice, internet
> services (port numbers) are shown numerically. When used
> three times, protocol numbers and UIDs/GIDs are also shown numerically.

Ah, very good point.

I reviewed the program source and see there is no "and other information": 
A single -n option just prevents IPv4 & IPv6 address lookup. So that can 
be simplified.

> (I don't like the repeated use of 'shown numerically', but I don't have 
> a better idea at the moment, and also don't care that much about this 
> ..)

Agreed, but I failed to find a better way to say it.

I'll send a revised patch separately.

By the way, what environment are most developers building the manpage in? 
I'm using Fedora 24, and ran into a couple of snags.

First, I had package docbook-utils installed, which provides a docbook2man 
program, but it does not have the --xinclude option the Makefile tries to 
use.

Then I installed package docbook2X, which provides db2x_docbook2man, but 
configure prefers the other docbook2man if it exists.

So I uninstalled docbook-utils, and then configure chose db2x_docbook2man. 
But by default it does not allow any network access, and nft.xml requires 
an XML DTD that isn't locally available and must be fetched over the 
network. So this error happens:

make[2]: Entering directory '/misc/repos/git/nftables/doc'
   GEN      nft.8
I/O error : Attempt to load network entity http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd
nft.xml:3: warning: failed to load external entity "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd"
"http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd">
                                                          ^
nft.xml:3079: parser error : Entity 'copy' not defined
Copyright &copy; 2008-2014 Patrick McHardy <email>kaber@trash.net</email>
                 ^

If I run manually with the -N option to allow network download of the 
DTDs, it then works:

db2x_docbook2man -N --xinclude nft.xml

So I just wonder if I'm missing some package of local DTDs or if other 
developers are just building somewhere else and the Fedora environment 
just isn't getting used.

Thanks,
Jon
