From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] [PATCH] ipset: New set type fullipmap
Date: Fri, 17 Aug 2007 15:07:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708171458380.30502@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708160857080.13455@titan.stealer.net>
	<Pine.LNX.4.64.0708171306430.5492@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0708171338310.14154@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Sven Wegener <sven.wegener@stealer.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708171338310.14154@titan.stealer.net>
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


On Aug 17 2007 14:53, Sven Wegener wrote:
>
>> Here is an improvement: use a dynamically allocated 4-level digital
>> trie, that way, unused subnets do not take any memory. Once allocated,
>> a lookup is O(1) too.
>
> For IPv4 the default size of the index table is 8 MiB (2097152
> slots * 4 byte pointer on x86) with bitmaps of 256 bytes.

Why 2097152 (256*8192) slots? With a 4-level you have 256 slots at each level.

union ipv4addr {
	uint32_t fullthing;
	struct {
		uint8_t octet0, octet1, octet2, octet3;
	};
};
lookup(union ipv4addr addr)
{
	const char ****level1 = global_l1_map;
	const char ***level2;
	const char **level3;
	const char *level4;

	level2 = level1[addr.octet0];
	if (level2 == NULL)
		return false;
	level3 = level2[addr.octet1];
	if (level3 == NULL)
		return false;
	level4 = level3[addr.octet2];
	if (level4 == NULL)
		return false;

	return test_bit(level4, addr.octet3);
}

So in the worst case that only one single IP address is set, you take
up 256 pointers + 256 pointers + 256 pointers + 256 bits = 6176 bytes
on x86_64.

> The dirty bitmap is 2097152 / 8 byte = 256 KiB. We can decrease the
> size of the index table and the dirty bitmap by increasing the size
> of the bitmaps. But for todays hardware I consider 8 MiB not too
> much memory to justify much work to lower it, because for the worst
> case we will then take more memory than just a single table to
> store the 2097152 pointers.

	Jan
-- 
