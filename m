From: Eddy Kvetny <eddy_kvetny@yahoo.com>
Subject: Huge impact of the conntrack mechanism on routing performance (30%
	with a single conntrack entry)
Date: Wed, 5 Apr 2006 07:03:05 -0700 (PDT)
Message-ID: <20060405140305.9637.qmail@web33801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
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

Netfilter gurus,

Could someone shed light on pretty strange problem of
a huge impact of the conntrack mechanism on routing
performance ?

The configuration is as follows: 
- the ARM9E-based (500Mhz) board with Linux 2.6.12
- 2 GbE interfaces connected to the traffic generator
tool (Smartbit)
- Smartbit injects UDP packets to the device via 1st
network interface, then the devices routes these
packets back to Smartbit via the 2nd interface

When only plain routing without any netfilter stuff
(conntrack, NAT, filter modules) is done, 40K packets
per second are processed and returned to Smartbit
giving about 485Mbps througput (40000 packets x 8 bit
x 1518 byte/packet) 

Right after "insmod ip_conntrack.ko" the throughput
drastically falls to 28 kpps (-12 kpps or -30% !!!). I
know that "conntrack" mechanism has some overhead but
30% is still seems to be too much, especially when in
my case there is only 1 connection in the conntrack
table and as far as I know most of the  "conntrack"
processing is done for the 1st packet of each
connection only. Then this connection is put in the
"conntrack" hash table and it is supposed to be very
quickly found for successive packets belonging to the
same connection

 After "insmod iptable_filter.ko" throughput is 25
kpps (-3 kpps) and after "insmod iptable_nat.ko" (NAT
mechanism) throughput is 23 kpps (-2 kpps). Insertion
of additional modules (like ipt_state.ko,
ip_conntrack_ftp.ko etc.) and configuring rules for
firewall/NAT (not talking about hundreds or more
rules) has no significant impact on throughput
So, I am wondering whether there is some logic
explanation for this huge impact of the conntrack
mechanism on routing performance. 

I would appreciate any information in this regard
Thanks in advance

Eddy


P.S. I found a couple of similar observations in
Internet

>From http://lwn.net/Articles/103858/
.......

13.3. Netfilter benchmarking  by HW 
.....
Lose 30% of performance (850kpps to 500kpps) 
... 
Initial rate (forwarding only) 800kpps 
insmod ip_conntrack -200 kpps 
load IPtable (even empty) 25% 
oprofile (non-halted) everything in ip_tables (3%) 
static compiling makes 5% difference 
full test (nat, mangle, filter, ip_conntrack): down to
350kpps 
....................
 
================================================
 
>From http://lkml.org/lkml/2004/9/8/235
................................................. 
I'm sure others here have far better examples, but one
post to the  netfilter-devel list last December
provided an example of a firewall that
 could process 580kpps with netfilter/conntrack turned
off.  Granted, the post noted that adding netfilter
brought that down to 450kpps, and adding conntrack on
top of that brought it down to 295kpps,but all three
of those numbers are well over the claimed 100kpps.
..................................................



__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
