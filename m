From: Jon Webb <jon_webb@binary-one.com>
Subject: Routing Questions - Netfilter Hooks
Date: Mon, 14 Apr 2003 18:18:02 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E9B5DCA.6010103@binary-one.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello everyone... I am writing a new routing system. It uses a kernel 
module and a userspace daemon. Essentially the kernel module intercepts 
packets on NF_IP_PREROUTING and NF_IP_LOCAL_OUT and checks for existing 
routes. If the routes do not exist, the packets are bumped up to 
userspace so that routes can be established (by other means). I am 
having a problem for which I hope someone has a solution.

To start, the documentation is unclear about when packets go to the 
kernel routing system on the outbound path. The docs indicate that 
IP_LOCAL_OUT is called before the routing code, but then there is a 
sentence that states the routing code is called "first" to determine 
source IP, etc. This has grave implications for my code because I need 
to capture all packets before they are rejected due to lack of routes! 
Right now I have verified that if I do not have a route to a host, and I 
try to ping that host, I get network unreachable messages without the 
IP_LOCAL_OUT hook ever getting called. Is there a way around this? Or am 
I just doing something wrong?

My second question is more of a routing question in general, but perhaps 
someone has a suggestion. On the IP_PRE_ROUTING side, my code to check 
routes and bump them into userspace is working fine except that it would 
be really useful to know what kind of routes they are (ie, what flags 
they have). The problem with obtaining this information is that the 
rtable structure returned by the route lookup operation is not 
displaying any flags (the rt_flags field is always 0). This means I 
can't decipher whether the route it returns is a host route or a gateway 
route or whatever..

Thanks,
Jon Webb
jon_webb@binary-one.com

-----------------
Jon Webb
Computer Communications Research Group
University of California, Santa Cruz
