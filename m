From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: The latest nf_conntrack
Date: Mon, 01 Nov 2004 17:27:18 +0900 (JST)
Message-ID: <200411010827.iA18RJGT024881@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi, all,

I finished synchronizing nf_conntrack with ip_conntrack in linux 2.6.10-rc1.
I need to cleanup and do more tests, anyway, I committed it to pom-ng.

>From the discussion at Netfilter developer workshop, I deleted the very complex
code reallocating conntrack from the basic slab cache when destroying the slab
cache for conntrack which has "help" part. Instead, all slab caches are
destroyed when unloading nf_conntrack.ko .

And I re-implemented handling fragmented IPv6 packets. This code is what
I imagined after workshop, but I recently found that my idea is different
with the results of discussion at workshop. Then I may change some parts.

The summary of handling IPv6 packets is as follows.

- at the hook NF_IP6_PRE_ROUTING, priority NF_IP6_CONNTRACK_DEFRAG,
	- The fragments are cloned and queued. clone skb has the pointer
	  to original skb.
	- When all fragments are gathered, cloned skb are reassembled.
	- All original skbs keep the pointer to reassembled skb in new member
	  of sk_buff "nfct_reasm".
	- The following hooks of NF_IP6_PRE_ROUTING are called. Please note
	  that reassembled skb isn't passed to hooks but original fragments are
	  passed.
	- NF_STOLEN is returned.

- at the hook NF_IP6_PRE_ROUTING, priority NF_IP6_CONNTRACK,
	- If skb has reassembled skb, that is, packet is fragmented,
		- If reassembled skb is already parsed, fragmented skb
		  reserves the pointer to the conntrack bound with reassembled
		  skb. Otherwise, reassembled skb is parsed.
	  Otherwise, skb is ordinarily parsed.
	- The original fragments are passed to next hooks and IPv6 core
	  processing.

By this processing,
	1. We can prevent disturbing IPv6 stack. If we introduce
	   ip_conntrack style, and when large fragmented packets came in,
	   "Too big" isn't sent. Instead, resized fragmented packets are
	   forwarded. That isn't natural.

	2. Packet filter can re-use reassembled packet. For example,
	   udp_match() can evaluate ports even though packet isn't 1st fragment
	   and doesn't include UDP header.

comments ?

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
