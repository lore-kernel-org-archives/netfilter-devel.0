From: Karsten Desler <kdesler@soohrt.org>
Subject: Re: Questions about your dual Opteron packetfiltering tests
Date: Sun, 12 Sep 2004 18:13:50 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040912161350.GB15158@soohrt.org>
References: <20040716015152.GA29337@soohrt.org>
	<20040716131829.GC2214@obroa-skai.de.gnumonks.org>
	<20040906205653.GA4626@soohrt.org>
	<20040907084151.GG16651@obroa-skai.de.gnumonks.org>
	<20040910140617.GA4314@soohrt.org>
	<20040911182309.26bb9d2d.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
   laforge@gnumonks.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20040911182309.26bb9d2d.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

* David S. Miller wrote:
> On Fri, 10 Sep 2004 16:06:17 +0200
> Karsten Desler <kdesler@soohrt.org> wrote:
> > Ok, I've disabled rp_filter and added rp_filter-like iptables
> > rules, doesn't make much (any?) difference though.
> 
> Please only disable rp_filter, then test.
> 
> You're making it difficult to determine the source of the
> bad performance if you add a new set of overhead.  So please
> don't add the new rp_filter-like iptables rules, and test
> like that.

Ok, I've done some measurements/profiles today.
Traffic information: 40mbit/s, 50kpps, 53444 flows.
iptables: on  refers to around 180 iptables rules
iptables: off refers to a iptables/conntrack still being in the kernel,
              but no currently active iptables rules.

kernel booted with profile=1; readprofile commandline:
  readprofile -r; sleep 60; readprofile -m /boot/System.map

iptables: on, rp_filter: off:
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 0  1   5876 570184   9548 1341064   0    0     0    92 7235   395  1 43 56  0
 0  0   5876 570256   9568 1341180   0    0     0   152 7215   349  0 44 56  0
 0  0   5876 569512   9576 1341376   0    0     0    74 7270   317  0 44 56  0
 0  0   5876 569576   9584 1341640   0    0     0    48 7213   316  0 44 56  0

   183 pfifo_fast_dequeue                         1.9062
   194 ip_refrag                                  1.5156
   198 ip_forward_finish                          1.5469
   253 hash_conntrack                             1.5813
   254 udp_packet                                 3.1750
   256 kmem_cache_alloc                           4.0000
   274 e1000_irq_enable                           5.7083
   274 vgacon_scroll                              0.5189
   276 e1000_intr                                 1.0781
   289 kmem_cache_free                            3.0104
   336 dma_map_single                             1.4000
   339 __kmalloc                                  2.6484
   359 ip_rcv_finish                              0.6599
   384 ip_ct_find_proto                           4.8000
   389 memcpy                                     2.2102
   392 ip_confirm                                 6.1250
   393 ip_rcv                                     0.3512
   407 nf_hook_slow                               1.4132
   442 netif_receive_skb                          1.0625
   443 dev_queue_xmit                             0.7691
   512 ip_finish_output2                          1.0000
   527 ip_conntrack_in                            0.2967
   560 ip_forward                                 0.8140
   602 e1000_alloc_rx_buffers                     1.7917
   686 ip_conntrack_find_get                      8.5750
   718 nf_iterate                                 3.7396
   735 csum_partial                               0.5889
   771 alloc_skb                                  2.6771
   778 skb_release_data                           4.4205
   818 eth_type_trans                             3.4083
   833 local_bh_enable                            6.5078
   857 kfree                                      3.5708
  1130 qdisc_restart                              2.6157
  1177 __mod_timer                                3.5030
  1213 e1000_xmit_frame                           0.5616
  1218 del_timer                                  9.5156
  1310 memset                                     6.9681
  1466 ip_output                                 10.1806
  1561 ip_ct_refresh_acct                         4.4347
  1825 __ip_conntrack_find                        9.5052
  2660 e1000_clean                                1.3516
  3292 __kfree_skb                               12.8594
  6064 ip_route_input                             2.1173
 10901 ipt_do_table                              12.1663
 68252 default_idle                             1421.9167
119731 total                                      0.0562
------

iptables: on, rp_filter: on:
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 0  0   5876 562976  10076 1348048   0    0     0    57 7060   318  0 42 58  0
 0  0   5876 562656  10084 1348244   0    0     0    50 7095   317  0 42 58  0
 0  0   5876 562720  10092 1348440   0    0     0    54 7098   321  0 42 57  0
 0  0   5876 562592  10100 1348568   0    0     0    48 7127   317  0 43 57  0

   139 ip_conntrack_defrag                        2.1719
   140 udp_error                                  0.2823
   144 pfifo_fast_dequeue                         1.5000
   186 ip_refrag                                  1.4531
   191 __read_lock_failed                         9.5500
   193 ip_forward_finish                          1.5078
   204 udp_packet                                 2.5500
   208 hash_conntrack                             1.3000
   231 kmem_cache_alloc                           3.6094
   271 e1000_irq_enable                           5.6458
   279 kmem_cache_free                            2.9062
   282 memcpy                                     1.6023
   290 e1000_intr                                 1.1328
   295 dma_map_single                             1.2292
   299 ip_rcv_finish                              0.5496
   301 __kmalloc                                  2.3516
   334 dev_queue_xmit                             0.5799
   344 ip_ct_find_proto                           4.3000
   367 ip_confirm                                 5.7344
   378 nf_hook_slow                               1.3125
   403 ip_rcv                                     0.3601
   403 netif_receive_skb                          0.9688
   498 ip_finish_output2                          0.9727
   502 e1000_alloc_rx_buffers                     1.4940
   506 ip_conntrack_in                            0.2849
   523 ip_forward                                 0.7602
   633 ip_conntrack_find_get                      7.9125
   650 nf_iterate                                 3.3854
   757 csum_partial                               0.6066
   758 skb_release_data                           4.3068
   764 alloc_skb                                  2.6528
   790 kfree                                      3.2917
   831 eth_type_trans                             3.4625
   842 local_bh_enable                            6.5781
  1066 qdisc_restart                              2.4676
  1141 e1000_xmit_frame                           0.5282
  1148 __mod_timer                                3.4167
  1162 del_timer                                  9.0781
  1236 memset                                     6.5745
  1364 ip_output                                  9.4722
  1510 ip_ct_refresh_acct                         4.2898
  1690 __ip_conntrack_find                        8.8021
  2557 e1000_clean                                1.2993
  2805 ipt_do_table                               3.1306
  3163 __kfree_skb                               12.3555
  5304 ip_route_input                             1.8520
 80113 default_idle                             1669.0208
119832 total                                      0.0563


iptables: off, rp_filter: off:
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 0  0   5876 558860  10408 1351932   0    0     0    10 7271    11  0 34 66  0
 0  0   5876 558404  10408 1351932   0    0     0     2 7183    37  1 34 65  0
 0  0   5876 558716  10444 1351964   0    0     1   139 7265    97  0 35 65  0
 0  0   5876 558724  10444 1351964   0    0     0     0 7252     7  0 34 66  0

   139 ip_conntrack_defrag                        2.1719
   140 udp_error                                  0.2823
   144 pfifo_fast_dequeue                         1.5000
   186 ip_refrag                                  1.4531
   191 __read_lock_failed                         9.5500
   193 ip_forward_finish                          1.5078
   204 udp_packet                                 2.5500
   208 hash_conntrack                             1.3000
   231 kmem_cache_alloc                           3.6094
   271 e1000_irq_enable                           5.6458
   279 kmem_cache_free                            2.9062
   282 memcpy                                     1.6023
   290 e1000_intr                                 1.1328
   295 dma_map_single                             1.2292
   299 ip_rcv_finish                              0.5496
   301 __kmalloc                                  2.3516
   334 dev_queue_xmit                             0.5799
   344 ip_ct_find_proto                           4.3000
   367 ip_confirm                                 5.7344
   378 nf_hook_slow                               1.3125
   403 ip_rcv                                     0.3601
   403 netif_receive_skb                          0.9688
   498 ip_finish_output2                          0.9727
   502 e1000_alloc_rx_buffers                     1.4940
   506 ip_conntrack_in                            0.2849
   523 ip_forward                                 0.7602
   633 ip_conntrack_find_get                      7.9125
   650 nf_iterate                                 3.3854
   757 csum_partial                               0.6066
   758 skb_release_data                           4.3068
   764 alloc_skb                                  2.6528
   790 kfree                                      3.2917
   831 eth_type_trans                             3.4625
   842 local_bh_enable                            6.5781
  1066 qdisc_restart                              2.4676
  1141 e1000_xmit_frame                           0.5282
  1148 __mod_timer                                3.4167  
  1162 del_timer                                  9.0781 
  1236 memset                                     6.5745 
  1364 ip_output                                  9.4722 
  1510 ip_ct_refresh_acct                         4.2898 
  1690 __ip_conntrack_find                        8.8021
  2557 e1000_clean                                1.2993
  2805 ipt_do_table                               3.1306
  3163 __kfree_skb                               12.3555
  5304 ip_route_input                             1.8520
 80113 default_idle                             1669.0208
119832 total                                      0.0563

iptables: off, rp_filter: off:
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 0  0   5872 558852  10540 1352008   0    0     0    10 7380    10  0 33 67  0
 0  0   5872 558596  10540 1352008   0    0     0     2 7429     9  0 34 66  0
 0  0   5872 558596  10540 1352008   0    0     0     0 7457     7  0 34 66  0
 0  0   5872 558956  10556 1351992   0    0     0    97 7476   113  1 33 66  0

   112 __write_lock_failed                        3.5000
   154 __read_lock_failed                         7.7000
   161 ip_refrag                                  1.2578
   168 pfifo_fast_dequeue                         1.7500
   171 udp_error                                  0.3448
   188 ip_forward_finish                          1.4688
   200 kmem_cache_alloc                           3.1250
   214 udp_packet                                 2.6750
   223 hash_conntrack                             1.3938
   237 kmem_cache_free                            2.4688
   239 e1000_intr                                 0.9336
   256 e1000_irq_enable                           5.3333
   266 memcpy                                     1.5114
   292 ip_rcv_finish                              0.5368
   296 dma_map_single                             1.2333
   310 __kmalloc                                  2.4219
   338 ip_ct_find_proto                           4.2250
   342 dev_queue_xmit                             0.5938
   370 ip_confirm                                 5.7812
   400 ip_rcv                                     0.3575
   420 nf_hook_slow                               1.4583
   424 netif_receive_skb                          1.0192
   466 ip_finish_output2                          0.9102
   514 ip_forward                                 0.7471
   526 ip_conntrack_in                            0.2962
   583 e1000_alloc_rx_buffers                     1.7351
   598 ip_conntrack_find_get                      7.4750
   658 nf_iterate                                 3.4271
   710 csum_partial                               0.5689
   740 skb_release_data                           4.2045
   757 alloc_skb                                  2.6285
   762 eth_type_trans                             3.1750
   772 kfree                                      3.2167
   819 local_bh_enable                            6.3984
  1080 qdisc_restart                              2.5000
  1132 __mod_timer                                3.3690
  1174 memset                                     6.2447
  1195 e1000_xmit_frame                           0.5532
  1224 del_timer                                  9.5625
  1353 ip_output                                  9.3958
  1593 ip_ct_refresh_acct                         4.5256
  1692 __ip_conntrack_find                        8.8125
  2599 e1000_clean                                1.3206
  2872 ipt_do_table                               3.2054
  3100 __kfree_skb                               12.1094
  5676 ip_route_input                             1.9818
 79665 default_idle                             1659.6875
119723 total                                      0.0562

- Karsten
