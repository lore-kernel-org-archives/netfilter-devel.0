From: Crazy AMD K7 <snort2004@mail.ru>
Subject: DoS on kernel 2.4.27+ -j LOG
Date: Fri, 26 Nov 2004 03:06:01 +0300
Message-ID: <6428830866.20041126030601@mail.ru>
Reply-To: Crazy AMD K7 <snort2004@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Has any one know about the bug in 2.4.27 kernel?
When you use logging in iptables (-j LOG) and a certain bad packet
come (with illegal flags set) then a DoS occurs.(kernel panic)

My system was droped(or fall down by it self) two times.

Unable to handle kernel paging request ar virtual address 5d5f2739
printing eip:
c022dcdc
*pde=00000000
Oops: 0000
CPU: 0
EIP: 0010:[<c022dcdc>] Not tained
EFLAGS: 00010246
 then
eax: .... ebx:.....
esi, edi, ebp esp
ds es ss
Process snort (pid: 687, stackpage=deae3000)
Stack: deae38a8 c02edb78 00000000 c01ebbc3 00000003 deae38e8 00000000 dfa0b004
c01f7500 df596078 dfa0b004 00000003 c01f7500 and so on...

Call Trace: [<c01ebbc3>][<c01f7500>] and so on
Code: 66 83 79 10 08 75 1d a1 2c 33 28 c0 85 c0 74 14 8b 0d 20 33
<0>Kernel panic: Aiee, killing interrrupt handler!
In interrupt handler - not syncing 

Last messages before kernel panic were:
SYN/FIN: IN=bridge0 OUT-bridge0 PHYSIN=eth0 PHYSOUT=eth1
SRC=203.122.51.187 DST=local_net_address LEN=40 TOS 0x10 PREC=0x00
TTL=23 ID=39426 PROTO=TCP SPT=21 DPT=21 WINDOW=1028 RES=0x00 SYN FIN URGP=0 

Some one tried to scan my network.


After a few weeks kernel panic occures again.
The problem is that I cant reproduce it.

One man said that it is a bug in 2.4.27 kernel with logging.
And now I am asking you info about it.

P.S.
I use the following log rules.

iptables -A FORWARD -p tcp -d $OUR_NET --tcp-flags ALL FIN,URG,PSH -m limit --limit 5/minute -j LOG --log-level notice --log-prefix "NMAP-XMAS: "
iptables -A FORWARD -p tcp -d $OUR_NET --tcp-flags SYN,FIN SYN,FIN -m limit --limit 5/minute -j LOG --log-level notice --log-prefix "SYN/FIN: "
iptables -A FORWARD -p tcp -d $OUR_NET --tcp-flags SYN,RST SYN,RST -m limit --limit 5/minute -j LOG --log-level notice --log-prefix "SYN/RST: "
iptables -A INPUT -p tcp -d $SERVER_IP --tcp-flags ALL FIN,URG,PSH -m limit --limit 5/minute -j LOG --log-level notice --log-prefix "NMAP-XMAS: "
iptables -A INPUT -p tcp -d $SERVER_IP --tcp-flags SYN,FIN SYN,FIN -m limit --limit 5/minute -j LOG --log-level notice --log-prefix "SYN/FIN: "
iptables -A INPUT -p tcp -d $SERVER_IP --tcp-flags SYN,RST SYN,RST -m limit --limit 5/minute -j LOG --log-level notice --log-prefix "SYN/RST: "
iptables -A FORWARD -p tcp -d $OUR_NET --tcp-flags RST RST,ACK -m limit --limit 5/minute -j LOG --log-level notice --log-prefix "SYN/RST: "
iptables -A INPUT -p tcp -d $SERVER_IP --tcp-flags RST RST,ACK -m limit --limit 5/minute -j LOG --log-level notice --log-prefix "SYN/RST: " 
