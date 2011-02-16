From: Pierre Chifflier <chifflier@wzdftpd.net>
Subject: Re: [RFH] bridge: add new target NFQUEUE for ebtables
Date: Wed, 16 Feb 2011 17:57:09 +0100
Message-ID: <4D5C01E5.8000302@wzdftpd.net>
References: <4D49E1E0.50304@trash.net> <1296743540-8148-4-git-send-email-chifflier@edenwall.com> <4D4BFE3C.3060407@trash.net> <4D4C01B2.2030605@edenwall.com> <4D4C020A.9000909@trash.net> <4D5104C4.3010105@edenwall.com> <4D59C047.5050404@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-6807.dedibox.fr ([88.191.37.40]:35733 "EHLO
	sd-6807.edenwall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753696Ab1BPRmx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:42:53 -0500
In-Reply-To: <4D59C047.5050404@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/15/2011 12:52 AM, Patrick McHardy wrote:

>> That looks interesting, however I am not sure of what you meant:
>> - using the ebtables tool to add a rule with a xtables target ? (that
>> does not seem to work)
> 
> It depends on the registration, if you either register for
> NFPROTO_BRIDGE or NFPROTO_UNSPEC, this should work. ARP (the
> only additional protocol besides INET/INET6/BRIDGE) should
> work just fine with userspace queueing with your changes to
> not require an afinfo in nf_queue. So using AF_UNSPEC seems
> like the proper choice.

[CC-ing -devel]

Hi,

Thanks for your reply Patrick.
So I did the following:
- rebased on today's nf-next-2.6
- apply only the first patch (which makes afinfo optional)
- revert all other patches
- apply the recent fix on nf_iterate since it was the cause of my oops

I patched ebtables to use xt_NFQUEUE (using a struct xt_NFQ_info_v1 with
arguments queuenum 1 and queues_total 1), and removed any other change.

When I add a rule with the NFQUEUE target with ebtables, I almost
immediately get a panic (full backtrace later in this mail).

What is weird is that I got a NULL skb  in ebt_in_hook (frame 2) while
the skb was not NULL earlier - like if it was stolen by some hook. Any
idea on what could cause that ?

Thanks for your help.

Pierre


(gdb) bt
#0  0xc1292de3 in ebt_do_table (hook=<value optimized out>,
    skb=<value optimized out>, in=<value optimized out>, out=0xdcbfd000,
    table=0xdcbd8200) at net/bridge/netfilter/ebtables.c:287
#1  0xc1293753 in ebt_in_hook (hook=65539, skb=0x0, in=0x1, out=0xdcbfd000,
    okfn=0xc128cc05 <br_forward_finish>)
    at net/bridge/netfilter/ebtable_filter.c:66
#2  0xc11fc573 in nf_iterate (head=<value optimized out>,
    skb=<value optimized out>, hook=2, indev=0xd7530000, outdev=0xdcbfd000,
    i=0xdf071e58, okfn=0xc128cc05 <br_forward_finish>,
hook_thresh=-2147483648)
    at net/netfilter/core.c:137
#3  0xc11fc5fb in nf_hook_slow (pf=<value optimized out>, hook=2,
    skb=<value optimized out>, indev=0xd7530000, outdev=0xdcbfd000,
    okfn=0xc128cc05 <br_forward_finish>, hook_thresh=-2147483648)
    at net/netfilter/core.c:173
#4  0xc128cb3a in nf_hook_thresh (hook=<value optimized out>,
skb=0xd7a73c00,
    in=<value optimized out>, out=0xdcbfd000,
    okfn=0xc128cc05 <br_forward_finish>, pf=<value optimized out>)
    at include/linux/netfilter.h:185
#5  NF_HOOK_THRESH (hook=<value optimized out>, skb=0xd7a73c00,
    in=<value optimized out>, out=0xdcbfd000,
    okfn=0xc128cc05 <br_forward_finish>, pf=<value optimized out>)
    at include/linux/netfilter.h:217
#6  NF_HOOK (hook=<value optimized out>, skb=0xd7a73c00,
---Type <return> to continue, or q <return> to quit---
    in=<value optimized out>, out=0xdcbfd000,
    okfn=0xc128cc05 <br_forward_finish>, pf=<value optimized out>)
    at include/linux/netfilter.h:241
#7  0xc128cc85 in __br_forward (to=<value optimized out>, skb=0x0)
    at net/bridge/br_forward.c:94
#8  0xc128c9e8 in deliver_clone (prev=0xd79a9e00, skb=<value optimized
out>,
    __packet_hook=0xc128cc20 <__br_forward>) at net/bridge/br_forward.c:137
#9  0xc128ca71 in br_flood (br=<value optimized out>, skb=0xd759d000,
    skb0=0xd759d000, __packet_hook=0xc128cc20 <__br_forward>)
    at net/bridge/br_forward.c:184
#10 0xc128ca99 in br_flood_forward (br=0x10003, skb=0x0, skb2=0x1)
    at net/bridge/br_forward.c:205
#11 0xc128d6bf in br_handle_frame_finish (skb=0xd759d000)
    at net/bridge/br_input.c:104
#12 0xc128d5fe in NF_HOOK_THRESH (hook=<value optimized out>,
skb=0xd759d000,
    in=<value optimized out>, okfn=0xc128d605 <br_handle_frame_finish>,
    out=<value optimized out>, pf=<value optimized out>)
    at include/linux/netfilter.h:219
#13 NF_HOOK (hook=<value optimized out>, skb=0xd759d000,
    in=<value optimized out>, okfn=0xc128d605 <br_handle_frame_finish>,
    out=<value optimized out>, pf=<value optimized out>)
    at include/linux/netfilter.h:241
#14 0xc128d87a in br_handle_frame (skb=0x0) at net/bridge/br_input.c:190
---Type <return> to continue, or q <return> to quit---
#15 0xc11e3c02 in __netif_receive_skb (skb=0xd759d000) at
net/core/dev.c:3137
#16 0xc11e7524 in netif_receive_skb (skb=0xd759d000) at net/core/dev.c:3231
#17 0xe0bca898 in ?? ()
#18 0xc11e7ab6 in net_rx_action (h=<value optimized out>)
    at net/core/dev.c:3779
#19 0xc1034345 in __do_softirq () at kernel/softirq.c:238
#20 0xc1003f96 in call_on_stack () at arch/x86/kernel/irq_32.c:66
#21 do_softirq () at arch/x86/kernel/irq_32.c:173
#22 0xc1034228 in irq_exit () at kernel/softirq.c:328
#23 0xc10037d3 in do_IRQ (regs=<value optimized out>)
    at arch/x86/kernel/irq.c:248
#24 0xc1002d70 in ?? () at arch/x86/kernel/entry_32.S:825
#25 0xc101b82b in native_safe_halt ()
    at /home/pollux/build/nf-next-2.6/arch/x86/include/asm/irqflags.h:49
#26 0xc1007e3f in arch_safe_halt ()
    at /home/pollux/build/nf-next-2.6/arch/x86/include/asm/paravirt.h:110
#27 default_idle () at arch/x86/kernel/process.c:380
#28 0xc1001a66 in cpu_idle () at arch/x86/kernel/process_32.c:112
#29 0xc12af2ce in start_secondary (unused=<value optimized out>)
    at arch/x86/kernel/smpboot.c:355
#30 0x00000000 in ?? ()
