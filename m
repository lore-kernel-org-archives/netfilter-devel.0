From: Karl Juchen <karl.juchen@gmx.de>
Subject: icmp state problem
Date: Sat, 12 Oct 2002 19:21:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DA85A29.5050101@gmx.de>
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

Hello!

I posted this problem on the netfilter user mailinglist already, but it 
seems as if I did something wrong... :-(

The problem is concerning locally generated icmp error messages 
(time-exceeded in this case) which have the state INVALID instead of 
RELATED.

My firewall uses iptables 1.2.6a, kernel 2.4.18, but I've just checked 
it with version 1.2.7a, kernel 2.4.19.
It is a simple scenario, connecting a local network to the internet 
using masquerading and do some filtering.


I tried to permit traceroute out of my lan and came to this point:

  1  * * *
  ...
  9  scratchy.onlinekosten.de (217.172.162.11)  66 ms  66 ms  66 ms

Cause I did not understand the first line, I manually added certain 
logging rules to check what happens:

  Oct  9 20:10:31 mg1000-2 kernel: ***PREROUTING*** IN=eth2 OUT= MAC= 
SRC=192.168.0.2 DST=62.153.159.89 LEN=40 TOS=0x00 PREC=0x00 TTL=1 
ID=24178 PROTO=UDP SPT=33883 DPT=33435 LEN=20
  Oct  9 20:10:31 mg1000-2 kernel: out-INTERN REJECT IN= OUT=eth2 
SRC=192.168.0.1 DST=192.168.0.2 LEN=68 TOS=0x00 PREC=0xC0 TTL=255 
ID=50358 PROTO=ICMP TYPE=11 CODE=0 [SRC=192.168.0.2 DST=62.153.159.89 
LEN=40 TOS=0x00 PREC=0x00 TTL=1 ID=24178 PROTO=UDP SPT=33883 DPT=33435 
LEN=20 ]
  ...
  Oct  9 20:10:40 mg1000-2 kernel: ***PREROUTING*** IN=eth2 OUT= MAC= 
SRC=192.168.0.2 DST=62.153.159.89 LEN=40 TOS=0x00 PREC=0x00 TTL=2 
ID=24181 PROTO=UDP SPT=33883 DPT=33438 LEN=20
  Oct  9 20:10:40 mg1000-2 kernel: INTERN-EXTERN ACCEPT IN=eth2 OUT=ppp0 
SRC=192.168.0.2 DST=62.153.159.89 LEN=40 TOS=0x00 PREC=0x00 TTL=1 
ID=24181 PROTO=UDP SPT=33883 DPT=33438 LEN=20
  Oct  9 20:10:40 mg1000-2 kernel: ***POSTROUTING*** IN= OUT=ppp0 
SRC=192.168.0.2 DST=62.153.159.89 LEN=40 TOS=0x00 PREC=0x00 TTL=1 
ID=24181 PROTO=UDP SPT=33883 DPT=33438 LEN=20
  Oct  9 20:10:40 mg1000-2 kernel: EXTERN-INTERN RELATE IN=ppp0 OUT=eth2 
SRC=217.5.98.70 DST=192.168.0.2 LEN=56 TOS=0x00 PREC=0x00 TTL=59 ID=0 
PROTO=ICMP TYPE=11 CODE=0 [SRC=80.135.184.250 DST=62.153.159.89 LEN=40 
TOS=0x00 PREC=0x00 TTL=1 ID=24181 PROTO=UDP SPT=33883 DPT=33438 LEN=20 ]


The first line shows, that the request goes through the nat PREROUTING 
chain and seems to be dropped directly afterwards because of TTL=1.
The time-exceeded message from the firewall box is REJECTED by my rules 
because the packet is not recognized as RELATED but INVALID, altough 
iptables seems to remember the original request.
However, corresponding packets from other hops are treated correctly as 
RELATED.
Of course all involved chains accept RELATED and ESTABLISHED tcp, udp 
and icmp connections...


A traceroute to the firewall itself looks like this:

  1  192.168.0.1 (192.168.0.1)  0 ms  0 ms  0 ms

This time the destination-unreachable answer is treated correctly as 
RELATED.

So why does the time-exceeded answer originating from the firewall 
itself have the state INVALID when sending a traceroute out of my lan to 
an external host, though it should be RELATED as far as i can see it?
Am I doing something wrong or is it even an iptables bug?


Thanks for any ideas,
Karl
