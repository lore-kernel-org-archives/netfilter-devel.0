From: gan hawk <ganhawk@gmail.com>
Subject: RFC: nfcache
Date: Mon, 21 Feb 2005 23:42:07 -0600
Message-ID: <3305af12050221214270478e50@mail.gmail.com>
Reply-To: gan hawk <ganhawk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

I started using Netfilter/Iptables some time back. I am wondering why
a caching system for Netfilter which Rusty and Harald envisioned was
never developed ? If the caching system is no longer required, can
someone please enlighten me on why. I had posted a message regarding
this some months earlier, but I did not receive any responses :( and
hence dropped the idea.

My interest in this picked up few weeks ago and I have developed this
crude 'prototype' for testing.

net/core/netfilter.c 
(http://p2pbridge.sourceforge.net/nfcache/netfilter.c)
include/linux/nfcache
(http://p2pbridge.sourceforge.net/nfcache/nfcache.h)
include/linux/avltree.h
(http://p2pbridge.sourceforge.net/nfcache/avltree.h)

(I know I have put the code in netfilter.c. But I plan to clean up
everything if this turns out into a project :)

This currently caches only packets destined for the local machine.

1) The basic idea is to store the packet information (whatever is
present in the SKB) in a AVL tree.

2) Check incoming packet before all the hooks for cache match and if
so, set a flag in nfcache. A match is said to be present if the values
for all the flags in the stored nfcache of any node match the incoming
packet's values.

3) If the packet is destined for the local machine and the cache flag
is set, don't pass through the IP Tables rules only (the whole chain)
(Right now it skips the whole NF_IP_LOCAL_IN hook! )

4) Check the packet that passed through the firewall after all the
rules and add it to the cache.

My plan is to have few base trees such as based on source address,
based on destination port etc.

The incoming source address is first searched on source address, then
based on destination port and so on. If there is no rule in the
iptables that uses any of the parameters, then a dummy rule is
inserted in the chain, so that the packets can be cached in one of the
trees. Right now, I add a dummy rule to check one of the known source
address at the end, so that it will be cached in the source address
tree.

Please send me your comments regarding the idea. Also point out if I
had made wrong assumptions.

I am not sure how to check (and match) what values of SKB, if these
flags are present:

NFC_IP_IF_IN
NFC_IP_TOS
NFC_IP_OPTIONS
NFC_IP_FRAG
NFC_IP_IF_OUT

I am interested in pursuing this and adding this functionality, if I
am on the right track.

thanks,
ganhawk
