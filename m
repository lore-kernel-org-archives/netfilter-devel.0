From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.11 released
Date: Fri, 20 Jan 2012 16:45:44 +0000
Message-ID: <4F199A38.5070702@googlemail.com>
References: <alpine.DEB.2.00.1201141542490.26282@blackhole.kfki.hu> <4F130A03.7080208@googlemail.com> <alpine.DEB.2.00.1201151825570.29134@blackhole.kfki.hu> <4F131551.2090608@googlemail.com> <alpine.DEB.2.00.1201152100050.29766@blackhole.kfki.hu> <4F135552.4070804@googlemail.com> <alpine.DEB.2.00.1201160914550.30763@blackhole.kfki.hu> <4F175B94.60001@googlemail.com> <alpine.DEB.2.00.1201191154330.7547@blackhole.kfki.hu> <4F189283.4000401@googlemail.com> <alpine.DEB.2.00.1201201342400.11124@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46323 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab2ATQpw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:45:52 -0500
In-Reply-To: <alpine.DEB.2.00.1201201342400.11124@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Doable, but needs time and would involve adding the logic to auto-merge 
> smaller subnets into larger ones and to make possible to delete subnets 
> from larger networks.
>   
Merging of ip ranges would be very difficult - I am having the same 
problem here as well. I use PostgreSQL as part of my setup and even 
though it has some nice capabilities to deal with "common" ip/range/net 
address operations, it is still very difficult, nigh-impossible to deal 
with ip range merges, simply because there are so many possible 
scenarios: any two ranges could be partially overlapping - like [ (] ), 
one range completely overlapping another - like [ () ], or two ranges 
"touching" one another - like [ ]( ) - that last one is very difficult 
to spot for merging and can't see it done very easily.

Just for testing ip range matches though, things could be a bit easier 
(pun intended).

If we assume that the whole ip address space (0.0.0.0-255.255.255.255, 
similar for ipv6 as well) occupies X number of bits (0...X-1), then each 
ip range (including a single ip address) could be represented by a 
starting bit number, length (in bits) and an end bit number (the latter 
is optional, but would ease ip range matching, if included). These 3 
components would have roughly the same memory footprint no matter what 
is the size of the actual ip range.

When adding such ip range in a set, I assume you just store their hash 
(to find them quickly when searching for exact set members). If you 
could add the above 3 elements, then matching ip ranges should be fairly 
easy: you take the starting bit from the ip range which needs to be 
tested and then isolate all those elements in the set which have their 
starting bit and ending bit in-between the starting bit of the testing 
range, i.e. test_start_bit between set_member_start_bit and 
set_member_end_bit, *or*, having their ending bit also between those 
ranges (i.e. test_end_bit between set_member_start_bit and 
srt_member_end_bit). You also need to discard duplicates, so that you 
don't test more than once.

Once you've isolated those potential matches, you can then construct a 
"partial" bitmap of these potential matches by using the 3 stored set 
member attributes - starting bit, length and end bit.

Then a simple bitwise "or" ("|") operation against each "partial" set 
member bitmap matched would suffice. By "partial" I mean applying the 
"or" only on the bit-range value we are interested in. This needs to be 
done recursively, whereby the result of the previous bitwise "or" 
operation should be applied to the partial bitmap of the next set 
member, so that you get partial matches accounted for.

If the end result after this leaves you with the exact bitmap of the ip 
range being tested, then there is a complete match. If you end up with 
something different, then there is either no or incomplete match. I hope 
I am making sense.

One very simple (and very crude) example to illustrate this: suppose the 
ip range we are interested in testing has a start bit value of 10 and 
its length is 16 (therefore the end bit = 25). Now, suppose we have 4 
set members with the following values stored in the set:

1. start-> 2, length-> 6
2. start-> 13, length-> 7
3. start-> 8, length-> 8
4. start-> 20, length-> 6

The "partial" bitmap of the ip range to be tested (stat bit = 10, end 
bit = 25) could be presented like this, after being "normalised" 
(position indicates bit number, starting from 0):

.........1111111111111111

Therefore, after initial scanning, we discard element 1 as it doesn't 
have its either start or end bit in the range we are interested in (10 - 
25) and that leaves us with the following set members:

.........0001111111000000
.......111111110000000000
.........0000000000111111

When we apply bitwise or ("|") on the range we are interested in (bits 
10-25) - recursively for each member left in the pot - we are left with 
a value of all 1's for the range of bits we are interested in (bits 
10-25), which is exactly the same as the ip range we are testing, so 
there is a complete match, otherwise there would either be no or 
incomplete match.

> I'm sure you are aware, this is a free time project.
>   
I am! I am also trying to help you with this as I would benefit from 
this bug being resolved.

> Sorry, for a while you have to use workarounds like you described.
>   
Pity that!

