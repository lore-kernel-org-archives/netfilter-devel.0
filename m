From: Maik Hentsche <netfilter@mm-double.de>
Subject: Re: bugreport ipt_CLUSTERIP
Date: Thu, 03 Aug 2006 15:59:35 +0200
Message-ID: <1154613575.44d201478b3d9@www.domainfactory-webmail.de>
References: <20060725082618.8zdzyrc36s0ksgsk@mail.tu-chemnitz.de>
	<44C8CB58.60709@trash.net>
	<1154078751.44c9d81ff2c50@www.domainfactory-webmail.de>
	<44CABEBC.9050101@trash.net>
	<20060802201212.3089b23b@zeus.subnet.mm-double.de>
	<44D1C66E.1080307@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44D1C66E.1080307@trash.net>
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

Zitat von Patrick McHardy <kaber@trash.net>:

> Thanks anyway. I'll try some more to reproduce it ..

It happened again and now I have a clue, what _might_ trigger it. I did
a few (around 15) inserting/deleting/inserting/flushing-cycles. All the
time, a ping to the virtual IP was running. Most important, another
programm held the virtual IP when it crashed (twice), once keepalived
and once heartbeatd. Without them, the error did not occur. I appended
a console log. Note, that, even though, there is a "hash=1 ct_hash=1
responsible", which seems to come from CLUSTERIP, I do not get an arp
response (and as far as I understood, CLUSTERIP is supposed to send
one).

HTH & so long
Maik


hash=1 ct_hash=1 responsible
hash=1 ct_hash=1 responsible
IPVS: Registered protocols (TCP, UDP, AH, ESP)
IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
IPVS: ipvs loaded.
Unable to handle kernel NULL pointer dereference at 0000000000000000
RIP:
<ffffffff88135022>{:ipt_CLUSTERIP:__clusterip_config_find+34}
PGD 798d2067 PUD 7c090067 PMD 0
Oops: 0000 [1] PREEMPT SMP
CPU 1
Modules linked in: ip_vs ipt_CLUSTERIP ipt_REJECT xt_state ip_conntrack
nfnetlink xt_tcpudp iptable_filter ip_tables ipt_ULOG x_tables ipv3Pid:
0, comm: swapper Not tainted 2.6.17.3 #1
RIP: 0010:[<ffffffff88135022>]
<ffffffff88135022>{:ipt_CLUSTERIP:__clusterip_config_find+34}
RSP: 0018:ffff810001377d60  EFLAGS: 00010a16
RAX: 0000000000000000 RBX: 0000000016fb14ac RCX: ffff81007cb50000
RDX: 0000000000000000 RSI: ffff810001377e48 RDI: 0000000016fb14ac
RBP: ffff81007d2e3410 R08: ffffffff803aadc0 R09: 0000000000000205
R10: ffff81007cb50168 R11: 0000000000000001 R12: ffff81007cb50000
R13: ffff81007d2e3418 R14: 0000000000000000 R15: 0000000000000001
FS:  00002b8f4febc6d0(0000) GS:ffff81007e3afa40(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000007d3d4000 CR4: 00000000000006e0
Process swapper (pid: 0, threadinfo ffff810001370000, task
ffff810001344080)
Stack: ffffffff881357a4 ffff81000132bac0 ffff810001377df8
ffffffff8052b6f0
       0000000080000000 ffff81007cb50000 ffffffff803bce1e
ffff810001377e48
       0000000000000001 ffff810001377e48
Call Trace: <IRQ> <ffffffff881357a4>{:ipt_CLUSTERIP:arp_mangle+116}
       <ffffffff803bce1e>{nf_iterate+94}
<ffffffff803aadc0>{dev_queue_xmit+0}
       <ffffffff803bcee7>{nf_hook_slow+135}
<ffffffff803aadc0>{dev_queue_xmit+0}
       <ffffffff803e690e>{arp_xmit+62}
<ffffffff803e628c>{arp_solicit+396}
       <ffffffff803b040e>{neigh_timer_handler+654}
<ffffffff802454d6>{hrtimer_run_queues+214}
       <ffffffff803b0180>{neigh_timer_handler+0}
<ffffffff80237777>{run_timer_softirq+375}
       <ffffffff8023301b>{__do_softirq+91}
<ffffffff80207ae0>{default_idle+0}
       <ffffffff8020ade2>{call_softirq+30}
<ffffffff8020cc51>{do_softirq+49}
       <ffffffff8023317f>{irq_exit+63}
<ffffffff80207ae0>{default_idle+0}
       <ffffffff8020a786>{apic_timer_interrupt+98} <EOI>
<ffffffff80412105>{_spin_unlock_irq+21}
       <ffffffff8041021a>{thread_return+186}
<ffffffff80207b0f>{default_idle+47}
       <ffffffff80207d08>{cpu_idle+104}

Code: 48 8b 00 0f 18 08 48 81 fa 00 75 13 88 75 e5 31 c0 c3 66 66
RIP <ffffffff88135022>{:ipt_CLUSTERIP:__clusterip_config_find+34} RSP
<ffff810001377d60>
CR2: 0000000000000000
 <0>Kernel panic - not syncing: Aiee, killing interrupt handler!
