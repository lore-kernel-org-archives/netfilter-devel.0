From: Karsten Desler <kdesler@soohrt.org>
Subject: Re: Questions about your dual Opteron packetfiltering tests
Date: Mon, 6 Sep 2004 22:56:53 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040906205653.GA4626@soohrt.org>
References: <20040716015152.GA29337@soohrt.org>
	<20040716131829.GC2214@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20040716131829.GC2214@obroa-skai.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

again referring to your Weblog about the Sun V20z boxes for high-speed
packet filtering:
After spending a few days googling and trying to recreate results that
are at least somewhere around your numbers, I'm out of ideas.

quoting from http://gnumonks.org/~laforge/weblog/2004/04/21
        * ip_tables performance sucks, even if the ruleset is empty ?!?
        [...]
        * You can route up to 1mpps at 64bytes packet size
        * ip_conntrack and iptable_filter at suck at least 300kpps,
          giving 700kpps as a result

Just two quick questions:
        a) How? :), or
        b) is that the expected 'ip_tables performance sucks'-performance?

I'm using two Opteron 244 on a Tyan S2882 mainboard with 2gb of RAM
and a vanilla 64bit 2.6.9-rc1-bk11 kernel.
I'm pushing 50mbit/s with 60kpps, about 100 iptables rules and both
CPUs are about 65% idle.
- interrupt 201 (e1000 eth0) is bound to cpu0, and 209 (e1000 eth1) is
  bound to cpu1.
- e1000 is compiled with NAPI.
- tso is activated for both cards
- I've increased ip_conntrack_htable_size to 65536.
- My traffic is largely udp traffic (around 90%) with a distribution of:
    20%  0  -   75 bytes,
    60% 76  -  150 bytes,
    10% 151 -  225 bytes and
    10% 226 - 1500 bytes

Thanks in advance,
 Karsten

eth0 is:
0000:01:01.0 Ethernet controller: Intel Corp. 82545EM Gigabit Ethernet Controller (Fiber) (rev 01)
        Subsystem: Intel Corp. PRO/1000 MF Server Adapter
        Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 201
        Memory at fc7e0000 (64-bit, non-prefetchable) [size=128K]
        I/O ports at 9c00 [size=64]
        Capabilities: [dc] Power Management version 2
        Capabilities: [e4] PCI-X non-bridge device.
        Capabilities: [f0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-

eth1 is:
0000:01:03.0 Ethernet controller: Intel Corp. 82546GB Gigabit Ethernet Controller (rev 03)
        Subsystem: Intel Corp. PRO/1000 MT Dual Port Network Connection
        Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 209
        Memory at fc720000 (64-bit, non-prefetchable) [size=128K]
        Memory at fc6c0000 (64-bit, non-prefetchable) [size=256K]
        I/O ports at 9400 [size=64]
        Expansion ROM at fc680000 [disabled] [size=256K]
        Capabilities: [dc] Power Management version 2
        Capabilities: [e4] 

/proc/interrupts:
           CPU0       CPU1
  0:   67093304          0    IO-APIC-edge  timer
  8:          4          0    IO-APIC-edge  rtc
  9:          0          0   IO-APIC-level  acpi
169:     117226          0   IO-APIC-level  libata
201:  213918484          0   IO-APIC-level  eth0
209:         11  211891491   IO-APIC-level  eth1
NMI:      10377      11910 
LOC:   67085557   67085955
ERR:          0
MIS:          0

/etc/sysctl.conf:
net/ipv4/icmp_ignore_bogus_error_responses=1
net/ipv4/conf/all/accept_redirects=0
net/ipv4/conf/all/rp_filter=1
net/ipv4/route/gc_elasticity=4
net/ipv4/neigh/default/gc_thresh1=1024
net/ipv4/neigh/default/gc_thresh2=2048
net/ipv4/neigh/default/gc_thresh3=4096
net/core/wmem_max=262144
net/core/rmem_max=262144
vm/min_free_kbytes=16000
net/ipv4/ip_forward=1

wc -l /proc/net/ip_conntrack
54243 /proc/net/ip_conntrack

rtstat -i 10
 size   IN: hit     tot    mc no_rt bcast madst masrc  OUT: hit     tot    mc GC: tot ignored goal_miss ovrf HASH: in_search out_search
36723     84998    1435     0     0     1     0     0       172       2     0    1438    1436         0    0          328787        232
41192     84884    1147     0     0     0     0     0       125       2     0    1149    1147         0    0          375680        261
44635     85263    1186     0     0     1     0     0        80       2     0    1189    1187         0    0          406300         63
47397     86269    1032     0     0     0     0     0        72       3     0    1035    1033         0    0          433299         80
42786     86713    1287     0     0     0     0     0        53       1     0    1288    1286         0    0          428865         81
