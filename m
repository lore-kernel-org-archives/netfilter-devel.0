From: Jon Webb <jon_webb@binary-one.com>
Subject: Re: Routing Questions - Netfilter Hooks
Date: Wed, 16 Apr 2003 20:48:27 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E9E240B.5090204@binary-one.com>
References: <3E9B5DCA.6010103@binary-one.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <3E9B5DCA.6010103@binary-one.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ok. We've decided to either install a ficticious default route through 
the loopback device, or restict our routing protocol to operation on one 
subnet to which we will have a media route that will match anything of 
interest. But I still have the problem of addressing routes from within 
the kernel. Specifically, when I catch a packet on IP_LOCAL_OUT, I need 
to check it's route with ip_route_output_key() to see if it needs 
routing. Any packet which does not have a static route (ie, any packet 
which used the default route) needs additional routing done to it. The 
best way to do with would be to inspect the rt_flags field that is 
returned in the rtable structure by ip_route_output_key() except that 
they don't contain useful (if any) information. Is there another way 
that I could establish which route a packet has from inside a kernel 
module? Anything that distinguishes it as a default or "media" (ie 
subnet) route would do the trick.

Thanks,
Jon Webb
jon_webb@binary-one.com

--------
Jon Webb
Computer Communications Research Group
University of California, Santa Cruz

Jon Webb wrote:

> Hello everyone... I am writing a new routing system. It uses a kernel 
> module and a userspace daemon. Essentially the kernel module 
> intercepts packets on NF_IP_PREROUTING and NF_IP_LOCAL_OUT and checks 
> for existing routes. If the routes do not exist, the packets are 
> bumped up to userspace so that routes can be established (by other 
> means). I am having a problem for which I hope someone has a solution.
>
> To start, the documentation is unclear about when packets go to the 
> kernel routing system on the outbound path. The docs indicate that 
> IP_LOCAL_OUT is called before the routing code, but then there is a 
> sentence that states the routing code is called "first" to determine 
> source IP, etc. This has grave implications for my code because I need 
> to capture all packets before they are rejected due to lack of routes! 
> Right now I have verified that if I do not have a route to a host, and 
> I try to ping that host, I get network unreachable messages without 
> the IP_LOCAL_OUT hook ever getting called. Is there a way around this? 
> Or am I just doing something wrong?
>
> My second question is more of a routing question in general, but 
> perhaps someone has a suggestion. On the IP_PRE_ROUTING side, my code 
> to check routes and bump them into userspace is working fine except 
> that it would be really useful to know what kind of routes they are 
> (ie, what flags they have). The problem with obtaining this 
> information is that the rtable structure returned by the route lookup 
> operation is not displaying any flags (the rt_flags field is always 
> 0). This means I can't decipher whether the route it returns is a host 
> route or a gateway route or whatever..
>
> Thanks,
> Jon Webb
> jon_webb@binary-one.com
>
> -----------------
> Jon Webb
> Computer Communications Research Group
> University of California, Santa Cruz
>
>
