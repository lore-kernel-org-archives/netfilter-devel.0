From: Dirk Morris <dmorris@metavize.com>
Subject: ip_conntrack CLOSE_WAIT issue.
Date: Tue, 27 Jan 2004 13:23:42 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4016D6DE.4040801@metavize.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

my conntrack table on machines are building up with tons of connections 
in the CLOSE_WAIT state.
Because the timeout is so long, they stick around until the table fills up.

Why are these connections not transitioning to the full closed state?
tcpdump shows that the full Fin/Fin-Ack/Ack takes place at the end of 
these connections, but they still stick around.


In the following example, timmy is running an echo server on port 7000.


~ # cat /proc/net/ip_conntrack| grep 7000                     [dmorris @ 
timmy]
<nothing>

~ # s tcpdump "host bebe"                                  [dmorris @ timmy]
...
13:10:15.436354 bebe.43035 > timmy.7000: . ack 10 win 5840 
<nop,nop,timestamp 164347449 1498713> (DF)
13:10:17.702593 bebe.43035 > timmy.7000: F 10:10(0) ack 10 win 5840 
<nop,nop,timestamp 164347675 1498713> (DF)
13:10:17.702841 timmy.7000 > bebe.43035: F 10:10(0) ack 11 win 5792 
<nop,nop,timestamp 1500980 164347675> (DF)
13:10:17.703086 bebe.43035 > timmy.7000: . ack 11 win 5840 
<nop,nop,timestamp 164347675 1500980> (DF)

now on bebe I did:

~ # netcat timmy 7000                                          [dmorris 
@ bebe]
aoesutnh
aoesutnh

Ctrl-C
~#

This causes the connection opening (not shown) and closing you see in 
the tcpdump above.

But the connection never leaves the conntrack table.

~ # cat /proc/net/ip_conntrack| grep 7000                     [dmorris @ 
timmy]
tcp      6 257147 CLOSE_WAIT src=10.0.0.44 dst=10.0.0.187 sport=43035 
dport=7000 src=10.0.0.187 dst=10.0.0.44 sport=7000 dport=43035 [ASSURED] 
use=1


I realize I could just turn 
/proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_close_wait, is 
that the fix or is this not supposed to happen?
This happens on two similar machines, in both 2.4.18 and 2.6.0-test8



info on timmy:

~ 
#                                                                                         
[dmorris @ timmy]
~ # uname 
-a                                                                                
[dmorris @ timmy]
Linux timmy 2.6.0-test8 #4 SMP Tue Dec 16 15:55:23 PST 2003 i686 unknown
~ # ifconfig 
eth0                                                                           
[dmorris @ timmy]
eth0      Link encap:Ethernet  HWaddr 00:40:05:A0:20:07 
          inet addr:10.0.0.187  Bcast:10.0.0.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:6487 errors:1 dropped:0 overruns:0 frame:0
          TX packets:5717 errors:24 dropped:0 overruns:0 carrier:24
          collisions:0 txqueuelen:1000
          RX bytes:793932 (775.3 KiB)  TX bytes:1599858 (1.5 MiB)
          Interrupt:11 Base address:0xac00

~ # netstat 
-rn                                                                             
[dmorris @ timmy]
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt 
Iface
10.0.0.0        0.0.0.0         255.255.255.0   U         0 0          0 
eth0
0.0.0.0         10.0.0.1        0.0.0.0         UG        0 0          0 
eth0
~ # netstat | grep CLOSE_WAIT | wc 
-l                                                       [dmorris @ timmy]
      0
~ # cat /proc/net/ip_conntrack| grep CLOSE_WAIT | wc 
-l                                     [dmorris @ timmy]
     10


Thanks,
-Dirk
