From: Pierre Chifflier <chifflier@edenwall.com>
Subject: Re: [PATCH 1/3] Make the afinfo structure optional in nf_queue and
 nf_reinject
Date: Fri, 04 Feb 2011 15:15:48 +0100
Message-ID: <4D4C0A14.2070402@edenwall.com>
References: <4D49E1E0.50304@trash.net> <1296743540-8148-2-git-send-email-chifflier@edenwall.com> <4D4BFED9.7090605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-6807.dedibox.fr ([88.191.37.40]:58837 "EHLO
	sd-6807.edenwall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751503Ab1BDOPv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 09:15:51 -0500
In-Reply-To: <4D4BFED9.7090605@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/04/2011 02:27 PM, Patrick McHardy wrote:
> On 03.02.2011 15:32, Pierre Chifflier wrote:
>> Packets coming from the bridge do not have an afinfo registered,
>> so make the call to get the structure optional.
> 
> This patch looks fine to me.
> 
> Regarding your crash - in what chain are you queueing the packet?
> We also need the exact backtrace.

The problem is that I must be running out of luck, but since today at
the moment the bridges goes in forwarding mode, I always got an oops.

Here's all the information I have, in hope it'll be useful.

Here is the backtrace (taken from kgdb):
Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread -2]
0x14488b55 in ?? ()
(gdb) bt
#0  0x14488b55 in ?? ()
#1  0xc128e506 in br_handle_frame (skb=0xd79aad80) at
net/bridge/br_input.c:181
#2  0xc11e3b7c in __netif_receive_skb (skb=0xd79aad80) at
net/core/dev.c:3085
#3  0xc11e754d in netif_receive_skb (skb=0xd79aad80) at net/core/dev.c:3179
#4  0xe0cbdf4d in ?? ()
#5  0xc11e7adf in net_rx_action (h=<value optimized out>)
    at net/core/dev.c:3727
#6  0xc1034319 in __do_softirq () at kernel/softirq.c:238
#7  0xc1004056 in call_on_stack () at arch/x86/kernel/irq_32.c:66
#8  do_softirq () at arch/x86/kernel/irq_32.c:176
#9  0xc10341f4 in irq_exit () at kernel/softirq.c:328
#10 0xc1003893 in do_IRQ (regs=<value optimized out>)
    at arch/x86/kernel/irq.c:247
#11 0xc1002e30 in ?? () at arch/x86/kernel/entry_32.S:825
#12 0xc101b6cf in native_safe_halt ()
    at /home/pollux/build/nf-next-2.6/arch/x86/include/asm/irqflags.h:49
#13 0xc1007ec0 in arch_safe_halt ()
    at /home/pollux/build/nf-next-2.6/arch/x86/include/asm/paravirt.h:110
#14 default_idle () at arch/x86/kernel/process.c:385
#15 0xc1001aa0 in cpu_idle () at arch/x86/kernel/process_32.c:114
#16 0xc12a4f94 in rest_init () at init/main.c:454
#17 0xc14058d3 in start_kernel () at init/main.c:704
#18 0xc14050d2 in i386_start_kernel () at arch/x86/kernel/head32.c:78
---Type <return> to continue, or q <return> to quit---
#19 0x00000000 in ?? ()

On the screen, I have only a very few information, only that bridge is
entering forwarding state, and that last sysfs file is
/sys/devices/virtual/net/lo/operstate


The commands I used to setup the bridge are:
brctl addbr br0
brctl stp br0 off
brctl addif br0 eth0
brctl addif br0 eth1

ifconfig eth0 up
ifconfig eth1 up
ifconfig br0 up


At this point, I got the problem reported in the backtrace.

If that may be important, my test setup is using 2 VMs (using KVM)
[test client (debian squeeze)] -> [ebtables (nf-next-2.6)] -> real network
I start the 2 VMs and setup the bridge, then boom.



The following lines are not related to the backtrace, since it generally
happens *before* I can even add an ebtables rule.

To add a test rule, I just use
ebtables -A FORWARD -j nfqueue

Running a Python program to listen on the queue. I can provide it, the
most important lines are

q.set_callback(cb)
q.fast_open(1, AF_BRIDGE)

The callback:
def cb(i,payload):
	payload.set_verdict(nfqueue.NF_ACCEPT)

Thanks,
Pierre
