From: Dmitry <dg@ipcb.net>
Subject: Symmetric NAT for udp
Date: Thu, 17 Nov 2005 18:37:09 +0300
Message-ID: <437CA3A5.8030802@ipcb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,  hidden@balabit.hu
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


kernel 2.4.31

here is the example -

there are 2 subnets - 192.168.100.* and 192.168.101.*

there are 3 hosts  - host A - has ips - 192.168.100.56,192.168.100.92
host B - 192.168.100.59, 192.168.101,59 - (NAT box)
host C - 192.168.101.146/147

host B - has ruleset for masquerading of host A

by nmap i send 3 packets from host A to C via B

nmap -P0 -sU 192.168.101.146 -p 1232 --max_rtt_timeout 6 -g 10000 -S 
192.168.100.56                                                                           

nmap -P0 -sU 192.168.101.147 -p 1231 --max_rtt_timeout 6 -g 10000 -S 
192.168.100.56                                                                           

nmap -P0 -sU 192.168.101.146 -p 1232 --max_rtt_timeout 6 -g 10000 -S 
192.168.100.92                                                                           



on host B on different interfeaces i see this picture


BEFORE NAT

[root@nist root]# tcpdump -n -i eth0  dst port 1232 or dst port 1231
tcpdump: listening on eth0                                         
                                                                   
18:11:12.951342 192.168.100.56.10000 > 192.168.101.146.1232: udp 0 
18:11:13.460999 192.168.100.56.10000 > 192.168.101.147.1231: udp 0 
18:11:13.970699 192.168.100.92.10000 > 192.168.101.146.1232: udp 0 


AFTER NAT

[root@nist NIST_TEST]# tcpdump -n -i eth1 dst port 1231 or dst port 1232
tcpdump: listening on eth1                                              
18:11:12.951461 192.168.101.59.10000 > 192.168.101.146.1232: udp 0      
18:11:13.461121 192.168.101.59.10000 > 192.168.101.147.1231: udp 0      
18:11:13.970777 192.168.101.59.1025 > 192.168.101.146.1232: udp 0       
                                                                        
source port was changed to 1025 only for packet - which src differed 
from first one.

ie in case for udp - it allows to bind on same PUBLIC src port 
connections with different hosts if src the same - this is so called 
"cone nat"


actually i mistaken  about tcp connection - they didnt show symmetric 
nat - but anyway they show different behaviour

instead UDP packets i sent tcp SYN

BEFORE NAT
18:29:26.276521 192.168.100.56.10000 > 192.168.101.146.1232: S 
3995259052:399525
9052(0) win 
4096                                                               
18:29:26.284750 192.168.100.56.10000 > 192.168.101.147.1231: S 
3044654256:304465
4256(0) win 
4096                                                               
18:29:26.292757 192.168.100.92.10000 > 192.168.101.146.1232: S 
705399252:7053992
52(0) win 
4096                                                                 

AFTER NAT

18:29:26.276582 192.168.101.59.10000 > 192.168.101.146.1232: S 
3995259052:399525
9052(0) win 
4096                                                               
18:29:26.284824 192.168.101.59.10000 > 192.168.101.147.1231: S 
3044654256:304465
4256(0) win 
4096                                                               
18:29:26.292811 192.168.101.59.10000 > 192.168.101.146.1232: S 
705399252:7053992
52(0) win 
4096                                                                 



in all cases src port  was preserved

///////////////////////////////////////////////////////////
Its not an issue but i need to test simmetric nat

so what i need from udp is to get this picture after nat


18:11:12.951461 192.168.101.59.10000 > 192.168.101.146.1232: udp 0      
18:11:13.461121 192.168.101.59.1025 > 192.168.101.147.1231: udp 0      
18:11:13.970777 192.168.101.59.1026 > 192.168.101.146.1232: udp 0  

////////////////////////////////////////////////////////

Actually - the question is - does somebody tried to make something 
similar or
 just have an idea on making it.
 Currently im stuck on __ip_conntrack_find function .
 Just cant understand why for second udp packet it says that tuple isnt 
taken - although its must be taken by first packet

       

-- 

Sincerely,
Dmitry Gritsenko
DG@IPCB.net 
