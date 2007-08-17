From: Sven Wegener <sven.wegener@stealer.net>
Subject: Re: [RFC] [PATCH] ipset: New set type fullipmap
Date: Fri, 17 Aug 2007 15:36:04 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708171510130.14154@titan.stealer.net>
References: <Pine.LNX.4.64.0708160857080.13455@titan.stealer.net>
	<Pine.LNX.4.64.0708171306430.5492@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0708171338310.14154@titan.stealer.net>
	<Pine.LNX.4.64.0708171458380.30502@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708171458380.30502@fbirervta.pbzchgretzou.qr>
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

>
> On Aug 17 2007 14:53, Sven Wegener wrote:
>>
>>> Here is an improvement: use a dynamically allocated 4-level digital
>>> trie, that way, unused subnets do not take any memory. Once allocated,
>>> a lookup is O(1) too.
>>
>> For IPv4 the default size of the index table is 8 MiB (2097152
>> slots * 4 byte pointer on x86) with bitmaps of 256 bytes.
>
> Why 2097152 (256*8192) slots? With a 4-level you have 256 slots at each level.
>
> [...]
>
> So in the worst case that only one single IP address is set, you take
> up 256 pointers + 256 pointers + 256 pointers + 256 bits = 6176 bytes
> on x86_64.

Uhm, yeah, like that we would slightly increase the worst case memory 
usage for the worst case I was thinking of, a lot of single IPs in 
different bitmaps, but would lower the memory we need for an empty set. 
Worst case would be 576 MiB on x86 and 640 MiB on x86_64 for the whole 
thing, compared to 520 MiB and 528 MiB for my approach. Your approach is 
the iptree set type moved to bitmaps, something like iptreemap. I'll think 
about it.

Sven
