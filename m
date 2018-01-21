From: Jeff <jmk@wagsky.com>
Subject: Re: Error: interval overlaps with previous one (with previously valid
 configuration)
Date: Sat, 20 Jan 2018 16:36:15 -0800
Message-ID: <30d704fa-5ff1-b63c-7907-fef8aae2e98f@wagsky.com>
References: <d3d8d2fe-aebb-73ad-8162-44a0a184a7d2@wagsky.com>
 <20180120091140.25jlj6tmgf6rwzan@salvia>
 <ecff5d36-8d7c-53da-dbb8-32f8c4848580@allycomm.com>
 <d9cdd6a9-dd72-81f5-5d2b-1e07eebdd977@trackivity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: James <vger_tracker@trackivity.com>
To: Netfilter Users Mailing list <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <d9cdd6a9-dd72-81f5-5d2b-1e07eebdd977@trackivity.com>
Content-Language: en-US
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 1/20/18 11:15 AM, James wrote:
>> On 1/20/18 1:11 AM, Pablo Neira Ayuso wrote:
>>> On Fri, Jan 19, 2018 at 08:42:52PM -0800, Jeff Kletsky wrote:
>>>> With a previously valid configuration, which "includes" files into 
>>>> the main
>>>> configuration, I get error messages with the HEAD of master on 
>>>> January 16,
>>>> 2018 9afd72a883e391e366a1d75bb4e1705357e078e9
>>>>
>>>> systemd[1]: Starting nftables...
>>>> apu.allycomm.com nft[31431]: In file included from 
>>>> nftables.conf:396:6-34:
>>>> apu.allycomm.com nft[31431]: ./dnat_targets.nft:45:9-23: Error: 
>>>> interval
>>>> overlaps with previous one
>>>> apu.allycomm.com nft[31431]:         ^^^^^^^^^^^^^^^
>>>>
>>>> Unfortunately, the error message both fails to identify what interval
>>>> overlaps as well as failing to identify the location of the conflict.
>>>> dnat_targets only has 23 lines. This feels like a similar problem 
>>>> to the
>>>> "wrong-file" issues that were previously resolved.
>>>>
>>>> Guessing that the problem was caused by
>>>>
>>>> commit 9a4b513014cfdeaad6d247b72a7924b3a536cfe9
>>>> Author: Phil Sutter <phil@nwl.cc>
>>>> Date:   Wed Jan 10 21:32:04 2018 +0100
>>>>
>>>>      src: Don't merge adjacent/overlapping ranges
>>>>
>>>>      [...]
>>>>
>>>>
>>>> I have reverted back to the previous commit
>>>>
>>>> commit 0b3ccd27e12d1df442aa3eac40a2ccb63d6c6407
>>>> Author: Phil Sutter <phil@nwl.cc>
>>>> Date:   Wed Jan 10 13:43:21 2018 +0100
>>>>
>>>>      build: Restore per object CFLAGS
>>>>
>>>> and at least have an operational system again.
>>>>
>>>>
>>>> I don't see any commits in today's master branch after the 9a4b51 
>>>> commit
>>>> that seem to relate either to the interval regression, or to the 
>>>> problem
>>>> with logging.
>>>>
>>>>
>>>> How can I trace down this problem?
>>> So we have two bugs here.
>>>
>>> 1) Could you make an example for us to reproduce the misleading error
>>> reporting? Something that we can simply run here to reproduce the
>>> issue would be great.
>>>
>>> 2) Is there really any overlap in the set that is defined in
>>> dnat_targets, in those 23 lines, or this error is bogus?
>>>
>>> Thanks!
>>> -- 
>>
>> Relatively trivial examples to replicate posted at 
>> https://bugzilla.netfilter.org/show_bug.cgi?id=1216
>>
>> Yes, there is overlap, as ::1/128 is a subset of ::/96
>> That set is declared in blackhole_ipv6.nft with the overlapping 
>> elements on lines 13 and 14 of the file.
>>
>>
>> Related to this symptom, I'm puzzled by the apparent design behavior 
>> of prohibiting overlapping ranges at all. By doing so, it seems to 
>> prevent or hamper some of the use cases for which not merging ranges 
>> has benefit.
>>
>> For me, I see the benefits of not merging ranges to be two-fold:
>> * The ranges reported by nft match those in configuration files
>> * Dynamically modified sets
>>
>> The first is illustrated in the test case. Clearly seeing that the 
>> loopback address is blocked has benefit, even if it is a subset of 
>> the mapped-IPv4 block.
>>
>> In the second case, a firewall that adjusts its rules may want to 
>> deal with a sub-range, or even a specific host within an existing 
>> sub-range, without having to query the current rule set, and 
>> potentially need to unwind merged sets. If a program needs to deal 
>> with host A.B.C.D, it should be able to create a set entry for that 
>> single host (and later remove it), without needing to know that there 
>> is already an entry for A.B.C.0/24. An example of this is a 
>> behavior-based firewall, where both the net block and the host have 
>> action taken, but that action will be reversed on a different time 
>> scale for the host than for the net block.
>>
>> I don't argue that a "set" should be a "set" in the mathematical 
>> sense; each element itself unique. What is limiting is that the 
>> relative meaning of the elements of the set ("overlapping interval") 
>> impacts their validity. If I have a good reason to have overlapping 
>> ranges, I can see no reason to prohibit them. Even performance is an 
>> unconvincing argument for me, as it is a conscious decision on my 
>> part, for example, to wish to include both ::1/128 and ::/96 and be 
>> able to see their presence and manage them independently.
>>
>> Think about the wide swaths of unallocated IPv6 address space. I'd 
>> prefer to deal with them line-by-line, in the same form as the lists 
>> are delivered, without having to worry about overlap, merging, or, 
>> worse, un-merging.
>>
>>
>> Jeff
>>
>
> +1 in support of both not-merging and allowing overlapping intervals, 
> specifically in support of behaviour-based firewalls.
>
> I do that and after a couple of weeks of not flushing things I do 
> start to encounter (rare) instances of interval collisions as the real 
> world changes day-by-day and alters the results of the higher-level 
> logic.
>
> ***
>
> And I'm hoping that moving to a don't-molest-intervals approach will 
> allow timeouts for intervals to happen (I do see that someone has 
> opened a bug for that... thank you).
>
> I'm interested in timeouts on all elements types in support of getting 
> my higher-level logic to achieve the goal of "everyone gets a second 
> chance".  Single-address timeouts are great where applicable but when 
> someone uses some large distributed hosted service provider to flood 
> me with traffic then a single-address-at-time logic is simply 
> inadequate. So, today, I simply (automatically) bang in intervals 
> (without timeouts) and then review logs and "nft list ruleset" daily.
[James]


After adding printing of the conflicting intervals, I was able to find 
and resolve several of them as they were "permanent" subsets of 
"blackhole" net blocks.

Unfortunately, the last of the occurrences I located breaks the logic of 
the configuration files

I define, in one file, the IP addresses associated with various 
interfaces, attached networks, and "interesting" hosts. The intent is 
that if network numbering or topology changes, I modify *one* file and 
the changes flow through.

In particular, at one point in the rule set, I drop all packets that are 
not destined for one of:
* Addresses of a specific interface
* A directly attached network
* A specific service host

     ip daddr != {$interface_addresses, $attached_network_addresses, 
$service_host_address} drop

Clear, concise, easy to maintain -- or was

It now fails if the service host happens to be on the directly attached 
network, which it won't always be.

Removing $service_host_address breaks the one-point-configuration paradigm.


At least as presently implemented and unless overlapping ranges are 
permitted, sets, both implicit and explicit, have become an 
"anti-feature" for me.

Jeff


