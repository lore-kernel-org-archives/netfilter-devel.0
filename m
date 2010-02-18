From: Douglas Diniz <dgdiniz@gmail.com>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l' count
Date: Thu, 18 Feb 2010 16:35:36 -0200
Message-ID: <5415ae081002181035h7d971cbbl63299f02b5cd778@mail.gmail.com>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
	 <48ceaa831002151308y5bb2606n2058599f3ec4b82@mail.gmail.com>
	 <1266270757.2859.27.camel@edumazet-laptop>
	 <48ceaa831002151400q4178d121h28887cfdf6625499@mail.gmail.com>
	 <1266271377.2859.28.camel@edumazet-laptop>
	 <48ceaa831002151410j1dbdfce3tcbdb5ceaa86b0e2b@mail.gmail.com>
	 <48ceaa831002180940y65af65b4p5d887f2f1a50b4b@mail.gmail.com>
	 <1266515463.2877.10.camel@edumazet-laptop>
	 <5415ae081002181012x4f7c95a4ncec563f69ae3562e@mail.gmail.com>
	 <4B7D8567.2060301@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Afi Gjermund <afigjermund@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:55763 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab0BRSfh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:35:37 -0500
Received: by pzk32 with SMTP id 32so389047pzk.4
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2010 10:35:37 -0800 (PST)
In-Reply-To: <4B7D8567.2060301@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I did some tests removing all nat modules, leaving only the conntrack
core module and the problem still occurs.

I'm working in this problem for more than a week I stiil didnt found the cause.

On Thu, Feb 18, 2010 at 4:22 PM, Patrick McHardy <kaber@trash.net> wrote:
> Douglas Diniz wrote:
>> I'm facing the same problem. I'm working in a embedded system with
>> kernel 2.6.20-6. When I send a ping (or any other protocol) through
>> eth0 to eth1 (or vice versa) the conntrack count isn't decremented. If
>> I send the ping through any other interface (eth0 to wifi, eth1 to
>> wifi, wifi to eth0 and wifi to eth1) I have no problem.
>> The problem seems to be only between the ethernet interfaces.
>> I debug the netfilter and I saw that when the problem occurs the "use"
>> variable inside conntract structure in > 1, so this variable is only
>> decremented by 1, not reaching in 0, and then the destroy_conntrack
>> function is not called.
>>
>> So I think that the problem is more low level, and some events aren't
>> reaching netfilter, and the "use"variable isn't decremented properly.
>>
>> This could be a problem with the ethernet driver?
>
> Yes, although you'd likely notice other effects like running
> out of memory if it was leaking the packets.
>
