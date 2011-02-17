From: Pierre Chifflier <chifflier@wzdftpd.net>
Subject: Re: [RFH] bridge: add new target NFQUEUE for ebtables
Date: Thu, 17 Feb 2011 14:37:27 +0100
Message-ID: <4D5D2497.5020908@wzdftpd.net>
References: <4D49E1E0.50304@trash.net> <1296743540-8148-4-git-send-email-chifflier@edenwall.com> <4D4BFE3C.3060407@trash.net> <4D4C01B2.2030605@edenwall.com> <4D4C020A.9000909@trash.net> <4D5104C4.3010105@edenwall.com> <4D59C047.5050404@trash.net> <4D5C01E5.8000302@wzdftpd.net> <4D5CFCDD.10007@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-6807.dedibox.fr ([88.191.37.40]:37587 "EHLO
	sd-6807.edenwall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756420Ab1BQNhb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Feb 2011 08:37:31 -0500
In-Reply-To: <4D5CFCDD.10007@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/17/2011 11:47 AM, Patrick McHardy wrote:
> Am 16.02.2011 17:57, schrieb Pierre Chifflier:
>> Hi,
>>
>> Thanks for your reply Patrick.
>> So I did the following:
>> - rebased on today's nf-next-2.6
>> - apply only the first patch (which makes afinfo optional)
>> - revert all other patches
>> - apply the recent fix on nf_iterate since it was the cause of my oops
>>
>> I patched ebtables to use xt_NFQUEUE (using a struct xt_NFQ_info_v1 with
>> arguments queuenum 1 and queues_total 1), and removed any other change.
>>
>> When I add a rule with the NFQUEUE target with ebtables, I almost
>> immediately get a panic (full backtrace later in this mail).
>>
>> What is weird is that I got a NULL skb  in ebt_in_hook (frame 2) while
>> the skb was not NULL earlier - like if it was stolen by some hook. Any
>> idea on what could cause that ?
> 
> The backtrace doesn't seem to be fully accurate. Please also post
> the full oops output corresponding to the backtrace.
> 
> Two more questions:
> 
> - is the bridge device in promiscous mode?
> - do you have IGMP snooping enabled?
> 

Here is the most relevant part of the log I could capture on the serial
port.
- Bridge device is not in promiscuous mode
- CONFIG_BRIDGE_ICMP_SNOOPING is not set

What I do to reproduce the crash:
- setup the bridge (at this point, everything is fine)
- load an ebtables rule: ebtables -A FORWARD -j NFQUEUE
the crash happens immediately when adding the rule.

If relevant, the code for ebt_NFQUEUE.c is available at
https://www.wzdftpd.net/downloads/ebt_NFQUEUE.c

Thanks,
Pierre

[   24.581479] 8021q: adding VLAN 0 to HW filter on device eth0
[   24.592863] eth1: link up, 100Mbps, full-duplex, lpa 0x05E1
[   24.603313] br0: port 2(eth1) entering learning state
[   24.605984] br0: port 2(eth1) entering learning state
[   24.608683] br0: port 1(eth0) entering learning state
[   24.611226] br0: port 1(eth0) entering learning state
[   39.648175] br0: port 2(eth1) entering forwarding state
[   39.654425] br0: port 1(eth0) entering forwarding state
[   56.168359] BUG: unable to handle kernel NULL pointer dereference at
00000008
[   56.172005] IP: [<c1292de3>] ebt_do_table+0x420/0x4bf
[   56.172005] *pde = 00000000
[   56.172005] Oops: 0002 [#1] SMP
[   56.172005] last sysfs file: /sys/devices/virtual/net/lo/operstate
[   56.172005] Modules linked in: usbhid hid psmouse serio_raw pcspkr
evdev virtio_balloon virtio_net virtio_blk 8139too uhci_hcd ehci_hcd
usbcore 8139cp mii virtio_pci virtio_ring virtio [last unloaded:
scsi_wait_scan]
[   56.172005]
[   56.172005] Pid: 0, comm: swapper Not tainted 2.6.38-rc1+ #11 /Bochs
[   56.172005] EIP: 0060:[<c1292de3>] EFLAGS: 00010202 CPU: 0
[   56.172005] EIP is at ebt_do_table+0x420/0x4bf
[   56.172005] EAX: 00010003 EBX: e10aa060 ECX: 00000001 EDX: 00000000
[   56.172005] ESI: e10aa030 EDI: e10aa030 EBP: df023de0 ESP: df023d7c
[   56.172005]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   56.172005] Process swapper (pid: 0, ti=df022000 task=c13daf20
task.ti=c13ae000)
[   56.172005] Stack:
[   56.172005]  e10aa000 d76481b0 d76491b0 00000001 e10a7040 e10a7040
00000000 00000003
[   56.172005]  d78dfd80 d7649000 00000000 00000000 d786a070 00000070
c14042b4 e10aa0f4
[   56.172005]  d7649000 d7648000 d78dfd80 d78dfd80 00000002 df020007
c152c240 c1405adc
[   56.172005] Call Trace:
[   56.172005]  [<c1293753>] ebt_in_hook+0x18/0x1d
[   56.172005]  [<c11fc573>] nf_iterate+0x2f/0x74
[   56.172005]  [<c128cc05>] ? br_forward_finish+0x0/0x1b
[   56.172005]  [<c128cc05>] ? br_forward_finish+0x0/0x1b
[   56.172005]  [<c11fc5fb>] nf_hook_slow+0x43/0xd0
[   56.172005]  [<c128cc05>] ? br_forward_finish+0x0/0x1b
[   56.172005]  [<c128cc05>] ? br_forward_finish+0x0/0x1b
[   56.172005]  [<c128cc20>] ? __br_forward+0x0/0x6c
[   56.172005]  [<c128cb3a>] T.922+0x22/0x35
[   56.172005]  [<c128cc05>] ? br_forward_finish+0x0/0x1b
[   56.172005]  [<c128cc85>] __br_forward+0x65/0x6c
[   56.172005]  [<c128cc05>] ? br_forward_finish+0x0/0x1b
[   56.172005]  [<c11ddcca>] ? skb_clone+0x4d/0x54
[   56.172005]  [<c128c9e8>] deliver_clone+0x30/0x37
[   56.172005]  [<c128ca71>] br_flood+0x82/0x9d
[   56.172005]  [<c128ca99>] br_flood_forward+0xd/0x10
[   56.172005]  [<c128cc20>] ? __br_forward+0x0/0x6c
[   56.172005]  [<c128d6bf>] br_handle_frame_finish+0xba/0x113
[   56.172005]  [<c128d605>] ? br_handle_frame_finish+0x0/0x113
[   56.172005]  [<c128d5fe>] T.917+0x2d/0x34
[   56.172005]  [<c128d87a>] br_handle_frame+0x162/0x178
[   56.172005]  [<c128d605>] ? br_handle_frame_finish+0x0/0x113
[   56.172005]  [<c11e3c02>] __netif_receive_skb+0x1aa/0x2eb
[   56.172005]  [<c128d718>] ? br_handle_frame+0x0/0x178
[   56.172005]  [<c11e7524>] netif_receive_skb+0x5d/0x63
[   56.172005]  [<c11df762>] ? __netdev_alloc_skb+0x16/0x34
[   56.172005]  [<e0d7cf4f>] virtnet_poll+0x3bb/0x486 [virtio_net]
[   56.172005]  [<c11e7ab6>] net_rx_action+0x98/0x1be
[   56.172005]  [<c1034345>] __do_softirq+0x9c/0x157
[   56.172005]  [<c10342a9>] ? __do_softirq+0x0/0x157
[   56.172005]  <IRQ>

