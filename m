From: Patrick Turley <pturley@rocksteady.com>
Subject: Limit on Primary Addresses?
Date: Fri, 17 Sep 2004 13:21:13 -0500
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414B2B19.8010302@rocksteady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This may not be a netfilter-specific issue, but I can't afford to leave 
any stone unturned...

I am trying to configure a Linux box with all possible VLANs (4094 of 
them), and a subnet on each VLAN. Creating the VLANs isn't a problem. 
But, when I try to use "ip addr add ..." commands to assign an IP 
address to each VLAN interface, I get to do about 280 of them before all 
the interfaces on the box become unresponsive. I've also tried to assign 
the same IP addresses all to eth0, and I get the same result.

The problem seems to hinge on the distinction between primary and 
secondary addresses.

If you're reading this mailing list, then you've probably had the need 
(e.g., load testing) to assign thousands of IP addresses to a single 
interface. However, it's usually the case that one is assigning multiple 
addresses that all belong to the same subnet. In that case, the first 
such IP address is "primary" and all the additional addresses that 
belong to the same subnet are "secondary". My investigations tell me 
that "secondary" addresses are much lighter-weight. On the other hand, I 
don't seem to be able to assign more than about 280 "primary" addresses 
in the entire system before all the interfaces become unresponsive.

For additional information about "primary" vs. "secondary" addresses, 
take a look at:

http://www.linux-ip.net/html/linux-ip.html#tools-ip-address-add
http://www.linux-ip.net/gl/ip-cref/node33.html
