From: P@draigBrady.com
Subject: Re: performance
Date: Thu, 12 Jun 2003 13:04:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EE86C47.7030204@draigBrady.com>
References: <3EE4B1EB.9090305@draigBrady.com> <3EE4B2E3.2070700@draigBrady.com> <723210746.20030609212730@lf.lv> <3EE59BB2.1070009@draigBrady.com> <20030611121611.GM32593@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: Peteris Krumins <newsgroups@lf.lv>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030611121611.GM32593@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> In order to get any idea about how those clock ticks are distributed
> among the various pars of kernel networking, you need to use some means
> of profiling.

iptables is in modules so I can't profile it at the moment.
But this is informative. This is with 160 match any rules in the
mangle::PREROUTING chain and then the packets are just dropped after.
Packet rate again is 85Kpps.

  14754 total                                      0.0096
  11421 default_idle                             142.7625 (71% !!)
    537 handle_IRQ_event                           3.3563
    341 eth_type_trans                             1.7760
    298 ip_rcv                                     0.4233
    238 do_gettimeofday                            1.8594
    224 netif_rx                                   0.5185
    217 add_timer_randomness                       0.9042
    196 skb_release_data                           1.3611
    180 batch_entropy_store                        1.0227
    162 alloc_skb                                  0.3375
    157 process_backlog                            0.5164
    137 kfree                                      0.7784
    126 __kmem_cache_alloc                         0.3937
    109 netif_receive_skb                          0.2004
     85 nf_hook_slow                               0.1771
     66 kmalloc                                    0.8250
     61 kfree_skbmem                               0.4766
     50 __constant_c_and_count_memset              0.3125
     36 __kfree_skb                                0.0978
     28 nf_iterate                                 0.1750
     16 get_sample_stats                           0.1250
     15 add_entropy_words                          0.0852
     14 ip_promisc_rcv_finish                      0.2917
     10 kmem_cache_free                            0.0625
      8 add_interrupt_randomness                   0.1250
      6 __generic_copy_to_user                     0.0625
      4 schedule                                   0.0030
      2 net_rx_action                              0.0057
      2 do_softirq                                 0.0089

The main question is why all the idle time?
Note userspace is locked out at this packet rate.

system specs:
    dual 1.4GHz PIII
    e1000 nic
    kernel 2.4.20

P=E1draig.
