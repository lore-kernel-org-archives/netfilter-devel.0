From: Thomas Spatzier <tspat@de.ibm.com>
Subject: Re: [netfilter-core] memory leak with IP connection tracking and IP forwarding
Date: Tue, 18 May 2004 08:29:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200405180829.10869.tspat@de.ibm.com>
References: <200405041305.55627.tspat@de.ibm.com> <200405041602.26635.tspat@de.ibm.com> <20040517071453.GE26147@obroa-skai.de.gnumonks.org>
Reply-To: tspat@gmx.de
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-net@vger.kernel.org, coreteam@netfilter.org,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040517071453.GE26147@obroa-skai.de.gnumonks.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> >
> > On the router I issue a 'watch -n 1 cat /proc/meminfo'.
> > Then I do a 'ping -f -s 64000' from one host to another host via the
> > router. On each update of my watch above there are about 10 MB of memory
> > (MemFree) missing.
>
> MemFree is not significant in this case.  please refer to your favourite
> linux kernel FAQ.

Somehow it must be significant, since after a few minutes the system dies
in a out-of-memory situation:

swapper: page allocation failure. order:0, mode:0x20                        
0067b8f0 0011811c 0046646c 8011846e 80118630 0067b868 0067b910 00400000     
       00000000 00000001 00407b00 00000011                                  
Call Trace:                                                                 
<000000000013aad2>| __alloc_pages+0x30e/0x374                             
<000000000013ac08>| __get_free_pages+0x30/0x74                            
<000000000013dd2c>| cache_alloc_refill+0x354/0x6fc                        
<000000000013d708>| __kmalloc+0xb8/0xe0                                   
<00000000002a8d16>| pskb_expand_head+0x5a/0x190                           
<00000000002c7662>| ip_forward+0xe6/0x318                                 
<00000000002c5ae0>| ip_rcv_finish+0x22c/0x33c                             
<00000000002b95cc>| nf_hook_slow+0x138/0x154                              
<00000000002c5dfe>| ip_rcv+0x20e/0x5d0                                    
<00000000002ae3e2>| netif_receive_skb+0x1f2/0x214                         
<00000000002ae49a>| process_backlog+0x96/0x190                            
<00000000002ae616>| net_rx_action+0x82/0x164                              
<000000000011cda8>| do_softirq+0x90/0x100                                 
<000000000010dfb2>| do_call_base+0x20/0x2a                                
<0000000000246354>| do_IRQ+0x190/0x1c8                                    
<000000000010e3e6>| io_return+0x0/0x10                                    


>
> > I also watched /proc/slabinfo and noticed the increasing size of the
> > skbuff_head_cache slab.
>
> does it increase and stay at a certain value, or increase indefinitely?
> my guess is that you are observing quite normal behaviour, after getting
> used, the slab cache allocates some memory which is then re-used again
> and again.

The size of the SLAB increases indefinitely. Also, if I stop the test and run
some other memory intensive task, the SLAB does not shrink --- normally
it is supposed to shrink in that case, right?

> Interesting is also not the sizze of the SLAB, but the number of objects
> in use from a particular slab.

-- 
Regards,
Thomas.
