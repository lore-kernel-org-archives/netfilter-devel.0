From: Roberto Nibali <ratz@tac.ch>
Subject: Re: rp_filter
Date: Wed, 08 Jan 2003 13:38:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1C1BCD.7030504@tac.ch>
References: <20021227211113.GK677@ns> <20021228091730.GC440@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>>  Can we *please* move the rp_filter cruft into the firewalling code
>>  proper?

I agree with Patrick on that it is not an intelligent idea to touch core network 
stuff in the netfilter code. Especially I seem to see more and more routing 
related POM patches for netfilter while I wonder what issues people really have 
with the current routing code which is where rp_filter belongs to?

> Upon thinking a bit more about your request, there is one thing
> that annoys me about rp_filter, and where iptables may eventually
> help: there was (and probably is) the idea of a DROP table, where
> you can LOG packets coming from all kinds of drop sites within
> the network stack. It would be great if I had a way to LOG packets

I've once started it but due to the network core's diversity in handling such 
cases I've stopped doing it. You get everything from silent drop via kfree over 
skb_free over return EINVAL over goto drop and so on ...

> rejected by rp_filter. IMHO the big problem to the unwary end-user,
> is the _invisibility_ of the drops caused by rp_filter.

That is a general nuisance and setting verbose_route_log and log_martians 
already helps a bit but most of the FIB related errors don't get logged. I know 
what you're talking about, I've even once started to debug tcpdump because of a 
badly set rp_filter value while doing asymmetric routing in a load balanced 
environment. It sucks rocks!!

> A simple net_ratelimit()ed printk() in the appropriate place, would
> already help a lot. If you walk your request over to linux-net, maybe
> you could make that your fallback position :-)

netdev or linux-net might be the best place to discuss it, yes. As a start you 
could patch ../linux/net/ipv4/fib_frontend.c:fib_validate_source(). Check for 
the rpf variable and follow it's invariants.

I don't agree with putting a net_ratelimit() on every network related place for 
logging. I took them out in my kernels because I rather have a system that can 
filter less packets but log the most packets than having a packet filter that 
can filter a lot but where syslogd doesn't get enough computing time anymore to 
read the printk ringbuffer.

Best regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
