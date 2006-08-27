From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: ipt_LOG and friends. Question
Date: Sun, 27 Aug 2006 17:04:56 +0200
Message-ID: <20060827150456.GA9190@kriss.csbnet.se>
References: <20060824140320.GJ31235@kriss.csbnet.se>
	<20060824151923.GK31235@kriss.csbnet.se>
	<44EDD07D.1020805@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44EDD07D.1020805@trash.net>
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

I am currently half way writing this up. However i'm modifying it after my
needs primarily. I think they might meet the netfilters general taste as
well. I am currently fixing the following:

1. Instead of calling printk() very here and there, it prints to a global
buffer (using a spinlock). To finally calling printk once. This works fine.
Its coded and tested.

2. I have merged ipt_LOG and ip6t_LOG into xt_LOG. With common
dump_tcp()/udp() and some other small code. This also works good. 

--
The first two doesn't break anything or changes anything in compability with
former ip(6)t_LOG.

However the next things will change slightly. The question is, how much can
i change. Using -j LOG and the ringbuffer is for debugging purpose? Or does
it actually exists people that parse this buffer for some need? (It surly
does, but can we kindly ignore them and point them to ULOG?).

3. The prefix is missing a space between the prefix and IN=interface. Very
annoying to always have to use -j LOG --log-prefix "one two three ". Notice
the last space. Will this break anything if i just add a space in between of
"%sIN=%s OUT..." for the prefix?

4. Using an ethernet interface is _very_ common. Can i if (skb->dev->type ==
ARPHRD_ETHER) just dump an ETHSRC and an ETHDST instead of MAC, or will
this break things for people? Again a matter of someone having scripts
parsing this debug log. I can add this as an extra flag and have LOG revison
1 use it.

--
The last suggestions are involving a revision 1 of LOG.

5. I my self have a good need for treating the prefix as a sulfix instead.
Much easier to read with the packet dump better aligned up, and an ending
reason. Can i add this as a flag? Having userspace revision 1 honoring it
with --log-sulfix (it will ofcouse not be allowed to have both --log-prefix and
--log-sulfix).

6. I am in the need to alter the prefix length to somewhat below 128 (so the
kernel space info-struct totally is 128 bytes would be good). Is it okey if
i add this in a revison 1? The packet dumping code doesn't depend on a
length. Only the target itself.

7. It would be very nice if we had a -m log. This is very easy todo in
kernel-space. Only that we have to call it -m LOG (uppercase) for userspace
to load the correct library and kernel module. Its just a matter of the
module registering both as a match and a target. Bad idea? It would be very
convinent. The match would just log the packet and always return true
(match). Compare this to the comment module that doesn't actually do any
match-work.

7. Currently i always use my LOGing with a limiter to not flood the
ringbuffer. I guess most people are. There would be very nice with a
--log-limit 5, meaning we will only log 5 packets per second. Also an
inverter for that so --log-limit ! 6 means to log everypacket hiting the
rule above 6 packet per second. This will go very well with LOG being a
match as well. As it simply selects which packets to log and always matches
them to continue in the firewall rules. Again this is a revison 1 thing. The
code for this in kernel is very simple. 

Comments wanted. I do not want to write anything that will be rejected.

Ulitmaly i am thinking of doing the same work for ip(6)t_ULOG to a xt_ULOG.

--
Joakim Axelsson
