From: "A Weasel" <a__weasel@hotmail.com>
Subject: "NAT/ICMP code information leak" still present?
Date: Mon, 21 Jul 2003 01:14:32 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Law9-F930Qq5ldnekJf000146fb@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

Would I be correct in assuming that the issue discussed here still exists in 
the 2.4.21 kernel?

http://www.iptables.org/security/2002-04-02-icmp-dnat.html

I can reproduce the "information leak" using the example steps provided. The 
hping'ing host gets back internal IP addresses in the ICMP TTL Exceeded 
packets (according to tcpdump and tethereal).

The last mention of the bug I could find was 3 months ago in this thread:

http://lists.netfilter.org/pipermail/netfilter-devel/2003-April/011215.html

where it was said that it should be fixed. But that doesn't seem to be the 
case...

Thanks,
-Steve

_________________________________________________________________
The new MSN 8: smart spam protection and 2 months FREE*  
http://join.msn.com/?page=features/junkmail
