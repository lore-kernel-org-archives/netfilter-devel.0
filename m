From: Jorrit Kronjee <j.kronjee@infopact.nl>
Subject: Re: debugging kernel during packet drops
Date: Fri, 26 Mar 2010 11:41:06 +0100
Message-ID: <4BAC8F42.7090706@infopact.nl>
References: <4BA74950.6000305@infopact.nl> <4BA7A5D8.5080101@trash.net>	 <4BA8DAC5.6050002@infopact.nl> <1269364893.2983.296.camel@edumazet-laptop>	 <4BAA2DC5.7000409@infopact.nl>  <1269447674.3213.64.camel@edumazet-laptop> <1269509574.3626.9.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.infopact.nl ([212.29.160.180]:60950 "EHLO
	smtp1.infopact.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751702Ab0CZKlO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Mar 2010 06:41:14 -0400
In-Reply-To: <1269509574.3626.9.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 3/25/2010 10:32 AM, Eric Dumazet wrote:
> Le mercredi 24 mars 2010 =C3=A0 17:22 +0100, Eric Dumazet a =C3=A9cri=
t :
>  =20
>> Sure this helps a lot !
>>
>> You might try RPS by doing :
>>
>> echo f >/sys/class/net/eth3/queues/rx-0/rps_cpus
>>
>> (But you'll also need a new xt_hashlimit module to make it more
>> scalable, I can work on this this week if necessary)
>>
>>    =20
> Here is patch I cooked for xt_hashlimit (on top of net-next-2.6) to m=
ake
> it use RCU and scale better in your case (allowing several concurrent
> cpus once RPS is activated), but also on more general cases.
>
> [PATCH] xt_hashlimit: RCU conversion
>
> xt_hashlimit uses a central lock per hash table and suffers from
> contention on some workloads.
>
> After RCU conversion, central lock is only used when a writer wants t=
o
> add or delete an entry. For 'readers', updating an existing entry, th=
ey
> use an individual lock per entry.
>  =20
Eric,

Awesome work, thanks for the effort! I've tried the patch and got some
results. The drop rate was reduced dramatically after I activated RPS.

I did the same test I did before, namely I rebooted and started floodin=
g
the machine immediately after with 300 kpps. After 5 minutes, perf top
looked like this:

-----------------------------------------------------------------------=
--------------------------------------------------
   PerfTop:    1962 irqs/sec  kernel:99.3% [1000Hz cycles],  (all, 4 CP=
Us)
-----------------------------------------------------------------------=
--------------------------------------------------

             samples  pcnt function                 DSO
             _______ _____ ________________________
_____________________________________________________________________

             4501.00 14.0% __ticket_spin_lock     =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
             2985.00  9.3% dsthash_find           =20
/lib/modules/2.6.34-rc1-net-next/kernel/net/netfilter/xt_hashlimit.ko
             2346.00  7.3% __ticket_spin_unlock   =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
             1354.00  4.2% e1000_xmit_frame       =20
/lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000e/e1000e.ko
             1070.00  3.3% __slab_free            =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
              997.00  3.1% memcpy                 =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
              809.00  2.5% dev_queue_xmit         =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
              791.00  2.5% nf_iterate             =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
              705.00  2.2% e1000_clean_tx_irq     =20
/lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000e/e1000e.ko
              634.00  2.0% nf_hook_slow           =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
              624.00  1.9% skb_release_head_state =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
              584.00  1.8% e1000_intr             =20
/lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000/e1000.ko
              536.00  1.7% br_nf_pre_routing_finish
/lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
              528.00  1.6% nommu_map_page         =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
              499.00  1.6% kfree                  =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
              494.00  1.5% __netif_receive_skb    =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
              472.00  1.5% __alloc_skb            =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
              448.00  1.4% br_fdb_update          =20
/lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
              437.00  1.4% __slab_alloc           =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
              428.00  1.3% ipt_do_table             [ip_tables]
              403.00  1.3% memset                 =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
              402.00  1.3% br_handle_frame        =20
/lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
              389.00  1.2% e1000_clean_rx_irq     =20
/lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000/e1000.ko
              388.00  1.2% e1000_clean            =20
/lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000/e1000.ko
              381.00  1.2% uhci_irq               =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
              366.00  1.1% get_rps_cpu            =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux
              365.00  1.1% br_nf_pre_routing      =20
/lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
              349.00  1.1% dst_release            =20
/lib/modules/2.6.34-rc1-net-next/build/vmlinux

And iptables-save -c produced this:
# Generated by iptables-save v1.4.4 on Fri Mar 26 11:24:59 2010
*filter
:INPUT ACCEPT [1043:60514]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [942:282723]
[99563191:3783420610] -A FORWARD -m hashlimit --hashlimit-upto 10000/se=
c
--hashlimit-burst 100 --hashlimit-mode dstip --hashlimit-name hashtable
--hashlimit-htable-max 131072 --hashlimit-htable-expire 1000 -j ACCEPT
[0:0] -A FORWARD -m limit --limit 5/sec -j LOG --log-prefix "HASHLIMITE=
D
-- "
[0:0] -A FORWARD -j DROP
COMMIT
# Completed on Fri Mar 26 11:24:59 2010

And /proc/interrupts looked like this:
     CPU0       CPU1       CPU2       CPU3
  0:         47          0          1          0   IO-APIC-edge      ti=
mer
  1:          0          1          0          1   IO-APIC-edge      i8=
042
  6:          1          1          0          0   IO-APIC-edge      fl=
oppy
  8:          1          0          0          0   IO-APIC-edge      rt=
c0
  9:          0          0          0          0   IO-APIC-fasteoi   ac=
pi
 12:          0          1          1          2   IO-APIC-edge      i8=
042
 14:         21         22         22         21   IO-APIC-edge    =20
ata_piix
 15:          0          0          0          0   IO-APIC-edge    =20
ata_piix
 16:        492        464        463        474   IO-APIC-fasteoi   ar=
cmsr
 17:          0          0          0          0   IO-APIC-fasteoi =20
ehci_hcd:usb1
 18:     971171     971391     948171     948663   IO-APIC-fasteoi =20
uhci_hcd:usb3, uhci_hcd:usb7, eth3
 19:          0          0          0          0   IO-APIC-fasteoi =20
uhci_hcd:usb6
 21:          0          0          0          0   IO-APIC-fasteoi =20
ata_piix, uhci_hcd:usb4
 23:          1          0          1          0   IO-APIC-fasteoi =20
ehci_hcd:usb2, uhci_hcd:usb5
 27:    1003145    1002952    1026174    1025671   PCI-MSI-edge      et=
h4
NMI:     202553     185135     134999     185071   Non-maskable interru=
pts
LOC:      20270      19227      17387      23282   Local timer interrup=
ts
SPU:          0          0          0          0   Spurious interrupts
PMI:     202553     185135     134999     185071   Performance
monitoring interrupts
PND:     201464     183939     134067     184098   Performance pending =
work
RES:       2216       2449       1212       1432   Rescheduling interru=
pts
CAL:    2223380    2226493    2233481    2228957   Function call interr=
upts
TLB:        606        584       1274       1216   TLB shootdowns
TRM:          0          0          0          0   Thermal event interr=
upts
THR:          0          0          0          0   Threshold APIC inter=
rupts
MCE:          0          0          0          0   Machine check except=
ions
MCP:          2          2          2          2   Machine check polls
ERR:          3
MIS:          0

ifconfig reported only 2 drops after these 5 minutes. I'm thinking abou=
t
removing/changing the hashing algorithm to make dsthash_find faster. Al=
l
I need after all is a match against a destination IP address. Also, I'd
like the limit of 10kpps to be a bit higher. I'll see if I can work on
that during the weekend.

Thanks again for everything!

Regards,

Jorrit Kronjee

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
