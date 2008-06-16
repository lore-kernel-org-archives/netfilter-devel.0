From: madbug <gdmadbug@gmail.com>
Subject: Re: H323 cause kernel panic when release the connection
Date: Mon, 16 Jun 2008 14:09:28 +0800
Message-ID: <5e81daf20806152309j2dcb6798g7e398d91e31c8e0a@mail.gmail.com>
References: <200806141025007657504@twsz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: liannan <liannan@twsz.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.181]:9030 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbYFPGJa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:09:30 -0400
Received: by ik-out-1112.google.com with SMTP id c28so4022074ika.5
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2008 23:09:28 -0700 (PDT)
In-Reply-To: <200806141025007657504@twsz.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--- ip_conntrack_helper_h323.c
+++ ip_conntrack_helper_h323.c
@@ -1814,6 +1814,7 @@
{
        ip_conntrack_helper_unregister(&ip_conntrack_helper_ras);
        ip_conntrack_helper_unregister(&ip_conntrack_helper_q931);
+       ip_conntrack_helper_unregister(&ip_conntrack_helper_h245);
        kfree(h323_buffer);
        DEBUGP("ip_ct_h323: fini\n");
}
@@ -1828,7 +1829,8 @@
        if (!h323_buffer)
                return -ENOMEM;
        if ((ret = ip_conntrack_helper_register(&ip_conntrack_helper_q931)) ||
-           (ret = ip_conntrack_helper_register(&ip_conntrack_helper_ras))) {
+           (ret = ip_conntrack_helper_register(&ip_conntrack_helper_ras)) ||
+           (ret = ip_conntrack_helper_register(&ip_conntrack_helper_h245)))  {
                fini();
                return ret;
        }


On 6/14/08, liannan <liannan@twsz.com> wrote:
> Hi, zhaojingmin
>     Two computer(a linux box as a router, one in nat, the other one outside of nat) has established a connection by Windows Netmeeting. When I did rmmod ip_nat_h323.ko & ip_conntrack_h323.ko, then hang up the call, it caused a kernel panic.
>     I found that the epc is the address of "h245_help" function. The helper didn't set to null when h323 conntrack module fini.
>     If I flushed ip_conntrack first, then rmmod the module & hang up, it' all right. I also tried patch-2.6.18-nath323-1.5, the problem still exist.
>
> ________________________________________________________________________________________________
>
> CPU 0 Unable to handle kernel paging request at virtual address c00a6828, epc == 802224dc, ra == 801d4e7c
> Oops[#1]:
> Cpu 0
> $ 0   : 00000000 00000000 00000004 c00a67f0
> $ 4   : 802a5ad0 81657e00 00000000 00000000
> $ 8   : 00000008 801461c8 00000000 80570050
> $12   : 819b0280 819b04b0 00000006 00000000
> $16   : 802a5a60 80000000 80b46000 80321010
> $20   : 00000000 00000004 802a5ad0 00000001
> $24   : 00000000 802257a8
> $28   : 802a4000 802a59e8 00000004 801d4e7c
> Hi    : 0000000b
> Lo    : 00506320
> epc   : 802224dc ip_conntrack_help+0x38/0x74     Tainted: P
> ra    : 801d4e7c nf_iterate+0xbc/0x130
> Status: 1000f403    KERNEL EXL IE
> Cause : 00800008
> BadVA : c00a6828
> PrId  : 00019374
> Modules linked in: ip_nat_pptp ip_conntrack_pptp ath_pktlog wlan_acl wlan_wep wlan_tkip wlan_ccmp wlan_xauth ath_pci ath_dev ath_dfs ath_rate_atheros wlan ath_hal ip_nat_tftp ip_conntrack_tftp ip_nat_ftp ip_conntrack_ftp pppoe ppp_async ppp_deflate ppp_mppe pppox ppp_generic slhc
> Process swapper (pid: 0, threadinfo=802a4000, task=802a6000)
> Stack : 801e7d98 00000004 802a5a60 80000000 801d4e7c 801d4e7c 802a5ad0 00000004
>        00000000 00000000 801e7d98 00000000 00000004 802a5ad0 00000000 00000010
>        801e7d98 80b46000 802a5a60 80320000 80000000 801d4f8c 802a5b00 00000002
>        80063834 00000000 80b46000 802a5a60 801e7d98 80000000 802ba854 00000000
>        81a02180 80b7e260 81a021b0 819b0000 819b0000 80570056 00000000 00000001
>        ...
> Call Trace:
>  [<801e7d98>] ip_finish_output+0x0/0x23c
>  [<801d4e7c>] nf_iterate+0xbc/0x130
>  [<801d4e7c>] nf_iterate+0xbc/0x130
>  [<801e7d98>] ip_finish_output+0x0/0x23c
>  [<801e7d98>] ip_finish_output+0x0/0x23c
>  [<801d4f8c>] nf_hook_slow+0x9c/0x1a4
>  [<80063834>] handle_adel_int+0x2c/0x38
>  [<801e7d98>] ip_finish_output+0x0/0x23c
>  [<801e81c8>] ip_output+0x1f4/0x30c
>  [<801e4d70>] ip_forward_finish+0x0/0x58
>  [<801e7d98>] ip_finish_output+0x0/0x23c
>  [<801e4fe0>] ip_forward+0x218/0x368
>  [<801e5104>] ip_forward+0x33c/0x368
>  [<801e4d70>] ip_forward_finish+0x0/0x58
>  [<801e3780>] ip_rcv+0x33c/0x65c
>  [<801e30ec>] ip_rcv_finish+0x0/0x358
>  [<801bad10>] netif_receive_skb+0x464/0x4d0
>  [<80255650>] br_pass_frame_up+0xa0/0xac
>  [<801ba8ac>] netif_receive_skb+0x0/0x4d0
>  [<80255f4c>] br_handle_frame_finish+0x188/0x250
>  [<80255e58>] br_handle_frame_finish+0x94/0x250
>  [<801d4f8c>] nf_hook_slow+0x9c/0x1a4
>  [<80255dc4>] br_handle_frame_finish+0x0/0x250
>  [<8025af70>] br_nf_pre_routing_finish+0x224/0x474
>  [<80233408>] ip_nat_in+0x30/0xd8
>  [<80255dc4>] br_handle_frame_finish+0x0/0x250
>  [<80233428>] ip_nat_in+0x50/0xd8
>  [<8025ad4c>] br_nf_pre_routing_finish+0x0/0x474
>  [<801d4e7c>] nf_iterate+0xbc/0x130
>  [<8025ad4c>] br_nf_pre_routing_finish+0x0/0x474
>  [<8025ad4c>] br_nf_pre_routing_finish+0x0/0x474
>  [<801d4f8c>] nf_hook_slow+0x9c/0x1a4
>  [<8025ad4c>] br_nf_pre_routing_finish+0x0/0x474
>  [<8025ba1c>] br_nf_pre_routing+0x7ec/0x838
>  [<8025ba50>] br_nf_pre_routing+0x820/0x838
>  [<8025ad4c>] br_nf_pre_routing_finish+0x0/0x474
>  [<801d4e7c>] nf_iterate+0xbc/0x130
>  [<80255dc4>] br_handle_frame_finish+0x0/0x250
>  [<80255dc4>] br_handle_frame_finish+0x0/0x250
>  [<801d4f8c>] nf_hook_slow+0x9c/0x1a4
>  [<80255dc4>] br_handle_frame_finish+0x0/0x250
>  [<802562cc>] br_handle_frame+0x260/0x274
>  [<c01b5e24>] ath_rx_tasklet+0x5e4/0xa50 [ath_dev]
>  [<8017e758>] ag7100_buffer_alloc+0x18/0x50
>  [<80255dc4>] br_handle_frame_finish+0x0/0x250
>  [<801bac5c>] netif_receive_skb+0x3b0/0x4d0
>  [<c011d304>] ath_hal_reg_read+0x38/0x4c [ath_hal]
>  [<8017eb0c>] ag7100_poll+0x214/0x664
>  [<801baff0>] net_rx_action+0x9c/0x19c
>  [<8008c2ec>] __do_softirq+0x84/0x118
>  [<8008c3e8>] do_softirq+0x68/0x80
>  [<800647f4>] do_IRQ+0x24/0x34
>  [<8006134c>] ar7100_interrupt_receive+0xec/0x100
>  [<8006134c>] ar7100_interrupt_receive+0xec/0x100
>  [<80062be4>] r4k_wait+0x0/0xc
>  [<80064a30>] cpu_idle+0x50/0x58
>  [<80062be8>] r4k_wait+0x4/0xc
>  [<802df884>] start_kernel+0x26c/0x2b8
>  [<802df130>] unknown_bootoption+0x0/0x310
> Code: 24020004  10e2000c  00e03021 <8c620038> 0040f809  00000000  24030001  10430005  00402021
> Kernel panic - not syncing: Aiee, killing interrupt handler!
>
>
>
>
>
> liannan
> 2008-06-14
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
