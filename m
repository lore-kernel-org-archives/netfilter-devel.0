From: Javier Valencia <jvalencia@log01.org>
Subject: random match on linux-2.6
Date: Sat, 16 Apr 2005 21:55:10 +0100
Message-ID: <42617BAE.2040805@log01.org>
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
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I've seen that it's not available on 2.6, but it's just the same in both 
kernels, copied contents of ...random/linux to ...random/linux-2.6, and 
worked fine. I don't know if you already know that.

enigma ~ # uname -a
Linux enigma 2.6.11-gentoo-r4 #2 Tue Mar 29 23:30:54 WEST 2005 i686 
Intel(R) Pentium(R) 4 CPU 2.80GHz GenuineIntel GNU/Linux

enigma ~ # iptables -A INPUT -p icmp -m random --average 30 -j DROP
enigma ~ # iptables --list -v -n
Chain INPUT (policy ACCEPT 190K packets, 77M bytes)
 pkts bytes target     prot opt in     out     source               
destination        
    0     0 DROP       icmp --  *      *       0.0.0.0/0            
0.0.0.0/0            random 30%
