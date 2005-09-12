From: "Giacomo" <delleceste@gmail.com>
Subject: thanks a lot jozsef
Date: Mon, 12 Sep 2005 20:15:48 +0200
Message-ID: <006d01c5b7c6$0297d640$0300a8c0@giacomino>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter devel" <netfilter-devel@lists.netfilter.org>
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

Thanks a lot Jozsef  for your answer to the news about my question about a 
conntrack
comment on tcp window.

The precious hint you gave me is that i don't need to play with seq/ack!

So, if i understood well, i don't need to worry about window sizes as well,
to do simple nat...

I was quite sure about those things, but the problem is that my nat works
fine if i call an Internet Service Provider,
but if I call another one, web sites and images are corrupted and things
don't work well...

i tried to lower mtu, and tried with the rule "clamp-tcpmss-to-pmtu", but
did not solve.
Then i tried to see if packets arrived fragmented and so lost in nat, but a
printk put in netfilter code,
wher defrag takes place, revealed that packets were not fragmented.

Now i'm quite desperate, cause i don't know where to look for an answer!
Could it be that i use bad functions to recalculate checksum? But why with
an ISP that works
while with the other not?
I use ip_fast_csum() for ip, and

tcp_v4_check(transport_header, skb->len-4*iph->ihl, saddr, daddr,
csum_partial( transp_header, skb->len-4*iph->ihl, 0) )

for tcp/udp chacksum.

tcpdump always says it's correct.

Thanks for your help and any other suggestions!
best regards,

Giacomo S, Italy
