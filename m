From: Ansis Atteka <aatteka@nicira.com>
Subject: Re: [PATCH] conntrackd: make conntrackd namespace aware
Date: Thu, 6 Sep 2012 13:33:18 -0700
Message-ID: <CAA=3OqkXKNEsh_YnM8WvL4iYWvjN1jg3TdWn7rv5HnqAau9j8Q@mail.gmail.com>
References: <1346461915-6309-1-git-send-email-aatteka@nicira.com>
	<CAA=3Oq=8mzQYeRnZkbk-bHmMPh2q58JM93EvnBOkiMa9oZJnuA@mail.gmail.com>
	<20120906171709.GB17317@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:56290 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759736Ab2IFUdV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:33:21 -0400
Received: by eekc1 with SMTP id c1so2376011eek.1
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Sep 2012 13:33:18 -0700 (PDT)
In-Reply-To: <20120906171709.GB17317@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 6, 2012 at 10:17 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi,
>
> On Wed, Sep 05, 2012 at 06:36:29PM -0700, Ansis Atteka wrote:
>> On Fri, Aug 31, 2012 at 6:11 PM, Ansis Atteka <aatteka@nicira.com> wrote:
>> > This patch allows conntrackd to open CT Netlink sockets into a given
>> > network namespace. Channel sockets (e.g. UDP) would still be opened into
>> > the same namespace where conntrackd was started.
>> >
>> > The only binary this patch affects is conntrackd. All other binaries (e.g.
>> > conntrack, nfct) would still operate in the same namespace where they were
>> > started.
>> >
>> > To make use of this patch:
>> > 1. create a network namespace: "ip netns add the_ns"
>> > 2. add "NetlinkNamespace /var/run/netns/the_ns" line to the conntrackd.conf
>> > file inside General {...} section.
>>
>> Wanted to provide more details about this patch and also bump it up
>> for attention.
>>
>> Basically, what it does is allows conntrackd to open Conntrack Netlink
>> sockets into a different namespace than where Channel Sockets were
>> opened.
>
> I see.
>
>> This isolation brings benefits to:
>> 1. security, because the channel socket (and management interface) will
>> reside in a different namespace. They won't be exposed to the traffic
>> that traverses the namespace;
>> 2. flexibility, because arbitrary IP addresses could be used inside that
>> namespace for Connection Tracking purposes. No need to worry that
>> there might be overlapping IP addresses with the Management interface;
>
> I don't understand this second benefit, could you develop the idea a
> bit more?
My point was that network administrator could assign arbitrary IP
addresses and routing rules inside the namespace, without worrying
that they might conflict with management IP address and/or routes.

I guess this is not that important in static setup where IP addresses
are configured only once and left the way they are.

>
>> 3. scalability w.r.t. namespaces, because all the namespaces would
>> end up using a single management interface and IP address in the root
>> namespace. There wouldn't be need to maintain a dedicated
>> management interface and IP address inside every namespace.
>>
>> Also this patch would prepare soil for my next patches, that would
>> ease connection state synchronization for virtualized networks even more:
>> 1. allow single conntrackd instance to synchronize multiple namespaces;
>> 2. add configuration dynamically to conntrackd (without restarting
>> the daemon).
>
> Those seem interesting to have, definitely.

>
> My plan is to release conntrack-tools 1.4.0 by the time Linux kernel
> 3.6 is released since it contains a major milestone (user-space
> helper support), that will be quite soon.
>
> We can schedule this for some 1.6.0 release. So I can keep these
> namespace changes in some branch until they are merged to master.
>
> I'd start by point 2 then go back to the namespace support, but it's
> up to you.

Yes, that seems to be the right sequence to do that.

Thanks,
Ansis
