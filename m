From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: debugging kernel during packet drops
Date: Wed, 24 Mar 2010 17:21:14 +0100
Message-ID: <1269447674.3213.64.camel@edumazet-laptop>
References: <4BA74950.6000305@infopact.nl> <4BA7A5D8.5080101@trash.net>
	 <4BA8DAC5.6050002@infopact.nl> <1269364893.2983.296.camel@edumazet-laptop>
	 <4BAA2DC5.7000409@infopact.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jorrit Kronjee <j.kronjee@infopact.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54203 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab0CXQXO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:23:14 -0400
Received: by bwz1 with SMTP id 1so78133bwz.21
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Mar 2010 09:23:12 -0700 (PDT)
In-Reply-To: <4BAA2DC5.7000409@infopact.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 24 mars 2010 =C3=A0 16:20 +0100, Jorrit Kronjee a =C3=A9cri=
t :
> On 3/23/2010 6:21 PM, Eric Dumazet wrote:
> >
> > Could you post more information about your machine ?
> >
> > cat /proc/interrupts
> >
> > If running a recent kernel, a "perf top" would be useful
> >
> > Maybe RPS will help your setup  (included in net-next-2.?6 tree)
> >  =20
> Eric,
>=20
> To make things easier, I just installed the latest net-next tree.
> Traffic flows from eth3 (e1000 7.3.21-k5-NAPI) to eth4 (e1000e
> 1.0.2-k2). After a reboot and 5 minutes of flooding it with 300 kpps,
> perftop shows this:
>=20
> ---------------------------------------------------------------------=
-----------------------------------------------------------------------=
----
>    PerfTop:     918 irqs/sec  kernel:99.6% [1000Hz cycles],  (all, 4 =
CPUs)
> ---------------------------------------------------------------------=
-----------------------------------------------------------------------=
----
>=20
>              samples  pcnt function                 DSO
>              _______ _____ ________________________
> _____________________________________________________________________=
__
>=20
>              1588.00 11.4% __slab_free            =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>              1571.00 11.3% dsthash_find           =20
> /lib/modules/2.6.34-rc1-net-next/kernel/net/netfilter/xt_hashlimit.ko
>              1117.00  8.0% _raw_spin_lock         =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               899.00  6.4% e1000_clean_tx_irq     =20
> /lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000e/e1000e.ko
>               702.00  5.0% skb_release_head_state =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               650.00  4.7% kfree                  =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               540.00  3.9% __slab_alloc           =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               514.00  3.7% memcpy                 =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               481.00  3.4% e1000_xmit_frame       =20
> /lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000e/e1000e.ko
>               335.00  2.4% nf_iterate             =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               285.00  2.0% e1000_clean            =20
> /lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000e/e1000e.ko
>               264.00  1.9% kmem_cache_free        =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               258.00  1.8% nf_hook_slow           =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               257.00  1.8% e1000_intr_msi         =20
> /lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000e/e1000e.ko
>               207.00  1.5% ipt_do_table           =20
> /lib/modules/2.6.34-rc1-net-next/kernel/net/ipv4/netfilter/ip_tables.=
ko
>               202.00  1.4% dev_queue_xmit         =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               180.00  1.3% memset                 =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               173.00  1.2% __alloc_skb            =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               165.00  1.2% br_nf_pre_routing      =20
> /lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
>               159.00  1.1% __kmalloc_track_caller =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               159.00  1.1% br_nf_pre_routing_finish
> /lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
>               158.00  1.1% e1000_clean_rx_irq     =20
> /lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000/e1000.ko
>               147.00  1.1% kmem_cache_alloc       =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               140.00  1.0% kmem_cache_alloc_notrace
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               130.00  0.9% _raw_spin_lock_bh      =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               122.00  0.9% hashlimit_mt_init      =20
> /lib/modules/2.6.34-rc1-net-next/kernel/net/netfilter/xt_hashlimit.ko
>               101.00  0.7% br_fdb_update          =20
> /lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
>               101.00  0.7% br_handle_frame        =20
> /lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
>               100.00  0.7% __netif_receive_skb    =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>                90.00  0.6% __netdev_alloc_skb     =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>                88.00  0.6% irq_entries_start      =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>                85.00  0.6% br_handle_frame_finish =20
> /lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
>                83.00  0.6% br_nf_post_routing     =20
> /lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
>                76.00  0.5% __br_fdb_get           =20
> /lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
>                64.00  0.5% eth_type_trans         =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>                59.00  0.4% br_nf_forward_ip       =20
> /lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
>                55.00  0.4% add_partial            =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>                52.00  0.4% __kfree_skb            =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>                50.00  0.4% e1000_put_txbuf        =20
> /lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000e/e1000e.ko
>                50.00  0.4% local_bh_disable       =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>                50.00  0.4% e1000_alloc_rx_buffers =20
> /lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000/e1000.ko
>                49.00  0.4% htable_selective_cleanup
> /lib/modules/2.6.34-rc1-net-next/kernel/net/netfilter/xt_hashlimit.ko
>=20
> And /proc/interrupts shows this:
>=20
>            CPU0       CPU1       CPU2       CPU3
>   0:         46          0          1          0   IO-APIC-edge      =
timer
>   1:          0          1          0          1   IO-APIC-edge      =
i8042
>   6:          0          1          1          0   IO-APIC-edge      =
floppy
>   8:          0          0          1          0   IO-APIC-edge      =
rtc0
>   9:          0          0          0          0   IO-APIC-fasteoi   =
acpi
>  12:          1          1          1          1   IO-APIC-edge      =
i8042
>  14:         25         20         20         21   IO-APIC-edge    =20
> ata_piix
>  15:          0          0          0          0   IO-APIC-edge    =20
> ata_piix
>  16:        622        640        655        667   IO-APIC-fasteoi   =
arcmsr
>  17:          0          0          0          0   IO-APIC-fasteoi =20
> ehci_hcd:usb1
>  18:      31149      31209      31023      30680   IO-APIC-fasteoi =20
> uhci_hcd:usb3, uhci_hcd:usb7, eth3
>  19:          0          0          0          0   IO-APIC-fasteoi =20
> uhci_hcd:usb6
>  21:          0          0          0          0   IO-APIC-fasteoi =20
> ata_piix, uhci_hcd:usb4
>  23:          1          1          0          0   IO-APIC-fasteoi =20
> ehci_hcd:usb2, uhci_hcd:usb5
>  27:     541048     540974     541145     541475   PCI-MSI-edge      =
eth4
> NMI:      80763      83546      37524      37703   Non-maskable inter=
rupts
> LOC:      26176      24807      10336      13595   Local timer interr=
upts
> SPU:          0          0          0          0   Spurious interrupt=
s
> PMI:      80763      83546      37524      37703   Performance
> monitoring interrupts
> PND:      79733      82513      36495      36674   Performance pendin=
g work
> RES:         34        196        110         93   Rescheduling inter=
rupts
> CAL:        801        566         54         53   Function call inte=
rrupts
> TLB:        145        152         89         72   TLB shootdowns
> TRM:          0          0          0          0   Thermal event inte=
rrupts
> THR:          0          0          0          0   Threshold APIC int=
errupts
> MCE:          0          0          0          0   Machine check exce=
ptions
> MCP:          2          2          2          2   Machine check poll=
s
> ERR:          3
> MIS:          0
>=20
>=20
> I hope this helps! Is there anything special I need to do to use RPS?
>=20

Sure this helps a lot !

You might try RPS by doing :

echo f >/sys/class/net/eth3/queues/rx-0/rps_cpus

(But you'll also need a new xt_hashlimit module to make it more
scalable, I can work on this this week if necessary)



Also, you might try to cpu affine eth3 interrupts :

echo 1 >/proc/irq/18/smp_affinity

You might also cpu affine eth4 interrupts (Tx completions)
echo 4 >/proc/irq/27/smp_affinity

Playing with "ethtool -C eth4 ..." might help to reduce number of
interrupts (TX completions) and batch them. Please send "ethtool -c
eth4"

dsthash_find() takes a lot of cpu, its a sign your hash table params
might be suboptimal.

Please send us "iptables -nvL"=20




--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
