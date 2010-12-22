From: Reuben Martin <reuben.m@gmail.com>
Subject: Re: ipsets: examples?
Date: Wed, 22 Dec 2010 10:21:52 -0600
Message-ID: <AANLkTi=L7JFoJQFpRD7VF8=+f-cKJC3A9Zk44r4pFu+Y@mail.gmail.com>
References: <201012192237.43878.reuben.m@gmail.com>
	<alpine.DEB.2.00.1012201622001.14191@blackhole.kfki.hu>
	<201012201418.14281.reuben.m@gmail.com>
	<alpine.DEB.2.00.1012211032420.15250@blackhole.kfki.hu>
	<AANLkTi=9HYAAhbj4eauqzYm07OJeS+jmNVY=rtgad6Fd@mail.gmail.com>
	<alpine.DEB.2.00.1012221125040.3482@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:43792 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab0LVQVy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:21:54 -0500
Received: by bwz16 with SMTP id 16so5890531bwz.4
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Dec 2010 08:21:53 -0800 (PST)
In-Reply-To: <alpine.DEB.2.00.1012221125040.3482@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 22, 2010 at 4:45 AM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Tue, 21 Dec 2010, Reuben Martin wrote:
>
>> I want to be able to do:
>>
>> ... -j MY_TARGET --ipset foo
>>
>> where MY_TARGET would iterate over the members of foo, and for each
>> member of foo the original packet is duplicated, the duplicate's
>> destination is changed to the address value of the member, checksums
>> recalculated, and sent on it's way.
>>
>> My intent is to be able to take RTP media stream packets, and
>> transparently forward them to a dynamically changing group of
>> destination addresses.in a network where multicast is not an option.
>> I'm sure there might be other uses for it, but that's all I'm
>> concerned about at the moment.
>
> I see. Sorry, it's not possible to use ipset for this purpose: there are
> no iterators which'd return the members of a set (listing is not similar
> or applicable). To design such an interface is not trivial. Maybe instead
> of iterating, passing your function to ipset is more feasible: ipset would
> call your function for every member of the given set.

In that case, maybe all that ipset would have to do is duplicate the
packet, and then use RAWDNAT to change the destination addresses for
the duplicates.

-Reuben
