From: Karsten Desler <kdesler@soohrt.org>
Subject: Re: Questions about your dual Opteron packetfiltering tests
Date: Wed, 13 Oct 2004 13:16:41 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041013111641.GA23488@soohrt.org>
References: <20040716015152.GA29337@soohrt.org>
	<20040716131829.GC2214@obroa-skai.de.gnumonks.org>
	<20040906205653.GA4626@soohrt.org>
	<20040907084151.GG16651@obroa-skai.de.gnumonks.org>
	<20040910140617.GA4314@soohrt.org>
	<20040911212703.GB19871@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20040911212703.GB19871@obroa-skai.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

* Harald Welte wrote:
> Any possibility you could test it with single-flow udp performance in
> order to make sure that we both actually get similar performance, and
> the slowdown really only results from the 50k concurrent flows, and not
> from some other configuration/setup/... issue.

I've tested the single flow performance now.

|test1|-----|eth1 - router - eth0|-----|test2|

test1 was sending 1000byte udp packets at a rate of 70mbit/s from port
10000 to test2:10000.
In a second test, i've reversed the roles of test1 and test2, which made
no difference.

The router is still a 64bit 2.6.9-rc2, I haven't had time to test 2.6.9-rc4
yet.

Watching top during the flood, almost all additional systime was accounted
on the receiving cpu (eth0 bound to cpu0 and eth1 is bound to cpu1)

vmstat on the router (in is zero, because it's a 32bit vmstat and a couple
of numbers in /proc/interrupts are bigger than 2^32):
procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 1  0      0 1715628 110740 155888    0    0     0     0    0     7  0  8 92  0
 0  0      0 1715628 110740 155888    0    0     0     0    0     5  0  7 93  0
 0  0      0 1715652 110740 155888    0    0     0   392    0    35  0  8 93  0
 0  0      0 1715652 110740 155888    0    0     0     0    0     3  0 15 85  0 <- flood is starting
 0  0      0 1715652 110740 155888    0    0     0     0    0     7  0 18 82  0
 0  0      0 1715652 110740 155888    0    0     0     0    0     3  0 18 82  0
 0  0      0 1715652 110740 155888    0    0     0     0    0     9  0 19 81  0
 0  0      0 1715652 110740 155888    0    0     0     0    0     5  0 19 81  0
 0  0      0 1715652 110740 155888    0    0     0     0    0     9  0 19 81  0
 0  0      0 1715652 110740 155888    0    0     0     0    0     3  0 19 82  0
 0  0      0 1715716 110740 155888    0    0     0     0    0     7  0 18 82  0
 0  0      0 1715716 110740 155888    0    0     0     0    0     5  0 19 81  0
 0  0      0 1715716 110740 155888    0    0     0     0    0     9  0 19 81  0
 0  0      0 1715716 110740 155888    0    0     0     0    0     3  0 19 81  0
 0  0      0 1715716 110740 155888    0    0     0     0    0     7  0 12 89  0
 0  0      0 1715716 110740 155888    0    0     0     0    0     3  0  8 93  0 <- stop
 0  0      0 1715716 110740 155888    0    0     0     0    0     9  0  7 93  0
 0  0      0 1715716 110740 155888    0    0     0     0    0     5  0  7 93  0
 0  0      0 1715716 110740 155888    0    0     0     0    0    11  0  6 94  0

rtstat:
 size   IN: hit     tot    mc no_rt bcast madst masrc  OUT: hit     tot     mc GC: tot ignored goal_miss ovrf HASH: in_search out_search
46630     30092     344     0     0     0     0     0        12       1      0     345     343         0    0          152963         19
46840     30021     403     0     0     0     0     0        70       1      0     405     403         0    0          152929         39
47138     30495     424     0     0     0     0     0       101       2      0     426     424         0    0          153787        128
47432     30739     516     0     0     0     0     0        10       2      0     518     516         0    0          153909         24
47723     34964     594     0     0     0     0     0         5       1      0     596     594         0    0          156555         32
48044     90336     676     0     0     0     0     0        44       1      0     677     675         0    0          155515         28 <- start
48322     89834     567     0     0     0     0     0         6       1      0     568     566         0    0          166415         22
48536     89941     499     0     0     0     0     0        72       2      0     501     499         0    0          215003         39
48804     89973     562     0     0     0     0     0        51       2      0     564     562         0    0          216194         28
49021     89315     545     0     0     0     0     0        22       2      0     547     545         0    0          215410         52
41444     91284     691     0     0     0     0     0         5       1      0     692     690         0    0          203104         24
41795     90726     554     0     0     0     0     0         6       1      0     555     553         0    0          197768         32
42060     63387     373     0     0     0     0     0         5       0      0     373     371         0    0          172197         27 <- stop
42394     31652     470     0     0     0     0     0         4       1      0     471     469         0    0          142762         23
41466     30315     438     0     0     0     0     0         7       2      0     440     438         0    0          139246         36
41915     30735     605     0     0     0     0     0         5       1      0     606     604         0    0          140605         29

diffprofile from before and during the flood:
       205   168.0% e1000_clean
       198   291.2% _spin_lock
       133   391.2% _write_trylock
       127    77.9% ip_append_data
       115   132.2% __kfree_skb
        93   197.9% memset
        82   256.2% skb_release_data
        71   263.0% alloc_skb
        66   169.2% _spin_lock_irq
        62   144.2% e1000_irq_enable
        50   172.4% _write_unlock
        49   140.0% _write_lock
        44    89.8% tcp_setsockopt
        43   116.2% kfree
        39   121.9% eth_type_trans
        37   336.4% local_bh_enable
        36   105.9% e1000_intr
        35   500.0% kmem_cache_free
        32   290.9% __kmalloc
        30   176.5% dev_queue_xmit
        27   270.0% kmem_cache_alloc
        24   171.4% _spin_unlock_irqrestore
        20   153.8% _read_lock
        20    71.4% tcp_sendmsg
        19   118.8% netif_receive_skb
        17   141.7% e1000_xmit_frame
        15    68.2% e1000_alloc_rx_buffers
        15   166.7% tcp_sendpage
        14   350.0% eth_header_parse
        14   140.0% tcp_listen_start
        13   216.7% __do_softirq
        13   433.3% ip_options_compile
        12   200.0% dma_unmap_single
        11   122.2% tcp_disconnect
      -348    -1.8% total
     -2258   -12.1% default_idle

- Karsten
