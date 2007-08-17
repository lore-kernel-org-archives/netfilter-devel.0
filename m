From: Sven Wegener <sven.wegener@stealer.net>
Subject: Re: [RFC] [PATCH] ipset: New set type fullipmap
Date: Fri, 17 Aug 2007 14:53:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708171338310.14154@titan.stealer.net>
References: <Pine.LNX.4.64.0708160857080.13455@titan.stealer.net>
	<Pine.LNX.4.64.0708171306430.5492@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708171306430.5492@fbirervta.pbzchgretzou.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 17 Aug 2007, Jan Engelhardt wrote:

>> The fullipmap type uses dynamically allocated bitmaps to represent 
>> every single IPv4 address as a bit. Matching speed has O(1) performance 
>> and worst case memory usage is 512 MiB for all bitmaps, not accounting 
>> the overhead of slab coloring, and a constant amount of memory for the 
>> index table. It represents single IP addresses, but has a way to add 
>> and delete a range of addresses at once. Currently an add or delete 
>> operation of a range of two or more addresses doesn't check if the 
>> complete range is already present or not present in the set.
>
> 512 MB, I am a little choking on that. What will you do when IPv6 is 
> commonplace? I do not think you'd be wanting to try creating a machine 
> with 36893488147419103232 EB.

512 MiB is the worst case and this set type, in its current form, is 
probably only good for IPv4. The main problem for IPv6 is the size of the 
index table for the bitmaps. The code already handles the two special 
cases (no bits and all bits set) by reusing two bitmaps that get allocated 
on module load. There is also a kind of garbage collector that checks 
whether a bitmap can be replaced by one of the two bitmaps. So a set that 
only contains bitmaps with all or no bits set does not use any additional 
memory for the bitmaps, just the memory for the index table and the dirty 
bitmap.

> Here is an improvement: use a dynamically allocated 4-level digital
> trie, that way, unused subnets do not take any memory. Once allocated,
> a lookup is O(1) too.

For IPv4 the default size of the index table is 8 MiB (2097152 slots * 4 
byte pointer on x86) with bitmaps of 256 bytes. The dirty bitmap is 
2097152 / 8 byte = 256 KiB. We can decrease the size of the index table 
and the dirty bitmap by increasing the size of the bitmaps. But for todays 
hardware I consider 8 MiB not too much memory to justify much work to 
lower it, because for the worst case we will then take more memory than 
just a single table to store the 2097152 pointers.

True, for IPv6 all is different, because this one single index table 
approach does not scale.

Sven
