From: Sven Wegener <Sven.Wegener@STEALER.net>
Subject: [RFC] [PATCH] ipset: New set type fullipmap
Date: Thu, 16 Aug 2007 09:22:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708160857080.13455@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

I'd like to get your initial feedback on a new set type called fullipmap.

The fullipmap type uses dynamically allocated bitmaps to represent every 
single IPv4 address as a bit. Matching speed has O(1) performance and 
worst case memory usage is 512 MiB for all bitmaps, not accounting the 
overhead of slab coloring, and a constant amount of memory for the index 
table. It represents single IP addresses, but has a way to add and delete 
a range of addresses at once. Currently an add or delete operation of a 
range of two or more addresses doesn't check if the complete range is 
already present or not present in the set.

This set type has been written, because we need to match against lists 
that contain both single addresses and networks. With 6 million single 
addresses the iphash set type with a low probe value has a quite high 
memory usage of a couple of hundred MiB, while the fullipmap needs a 
couple of ten MiB. The nethash set type with many different CIDR sized 
networks uses quite a high amount of CPU for matching, especially for the 
hashing part of it.

I'm responding with two patches, one for the kernel part and one for the 
userspace part, containing the code in its current state. The code has 
grown over time and probably needs some cleanup and comments.

Sven
