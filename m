From: Henrik Gram <hawk@freechess.org>
Subject: netfilter wont forget old rule
Date: Wed, 18 Dec 2002 03:50:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.1.0.14.2.20021218033741.0299e840@66.92.0.116>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
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

I have a rule like this:

iptables -t nat -A PREROUTING -i ! eth0 -p udp --dport 500 -j DNAT --to a.b.c.d

Which worked fine sending isakmp messages coming in from our two ISP's 
(eth1 and eth2) to our VPN gateway.  However, I was wanting to make another 
machine the VPN gateway and changed the above line with the updated 
ip.  The list of rules was flushed first and in the iptables -L, only the 
new rule shows up.  However, tcpdump reveals that the box is still 
forwarding those packets to the old address.  I cannot figure out why.. I 
tried adding a LOG target as the first rule but that wasn't matched 
either.  For some reason it keeps insisting on using the old rule which is 
not listed anywhere.

The box is running 2.4.19-rc1 and iptables v1.2.6a.

--
Henrik Gram
