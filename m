From: Hellwolf Misty <hellwolf@seu.edu.cn>
Subject: Why the behavior of LOCAL OUTPUT DNAT changes?
Date: Fri, 17 Jun 2005 16:42:03 +0800
Message-ID: <1118997723.7428.2.camel@cocteau.hellwolf-misty.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

My System is Fedora Core 3.
When I use two different kernel, things happend like this:


#iptables --version
iptables v1.3.0

*******************************************************************************
#uname -r
2.6.9-1.667
#iptables -F
#iptables -t nat -F
#iptables -t nat -I OUTPUT -j DNAT -p tcp --to-destination
127.0.0.1:10000

#	
[1] 3487
#listening on [any] 10000 ...

#nc 1.2.3.4 5678&
connect to [127.0.0.1] from cocteau.hellwolf-misty.org [127.0.0.1] 32774

#netstat -tn
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address               Foreign Address
State
tcp        0      0 172.16.7.93:32777           1.2.3.4:5678
ESTABLISHED
tcp        0      0 127.0.0.1:10000             127.0.0.1:32777
ESTABLISHED

*******************************************************************************
#uname -r
2.6.11-1.27_FC3
#iptables -F
#iptables -t nat -F
#iptables -t nat -I OUTPUT -j DNAT -p tcp --to-destination
127.0.0.1:10000
#nc -lvvvv -p 10000&
[2] 4661
#listening on [any] 10000 ...

#nc 1.2.3.4 5678&
[3] 4662
#
[3]+  Exit 1                  nc 1.2.3.4 5678

And why?
