From: Patrick McHardy <kaber@trash.net>
Subject: Re: crash in nfnetlink_queue
Date: Mon, 09 Feb 2009 18:08:30 +0100
Message-ID: <4990630E.4090100@trash.net>
References: <92770c820901311319q2a35ca0fnd42112ab9b3db6fe@mail.gmail.com> <4984C2BB.3030501@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ilninno <ilninno@gmail.com>, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59602 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbZBIRIe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:08:34 -0500
In-Reply-To: <4984C2BB.3030501@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hi,
> 
> Could you specify your kernel version ?
> 
> By the way please use a explicit subject when posting: lot of people
> avoir to read 'I need help' messages.

Indeed. It was specified in the first email:

> BUG: unable to handle kernel NULL pointer dereference
> IP: [<f89848a9>] :nfnetlink_queue:nfqnl_enqueue_packet+0x18f/0x507
> *pde = 2264c067 *pte = 00000000
> Oops: 0000 [#1] SMP
> Modules linked in: nfnetlink_queue nfnetlink vfat fat fuse sco bridge
> stp bnep l2cap bluetooth sunrpc ts_bm xt_string xt_comment xt_NFQUEUE
> ipt_LOG xt_mark iptable_nat nf_nat ip6t_REJECT nf_conntrack_ipv6
> ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq
> dm_multipath uinput ata_generic pata_acpi snd_hda_intel ppdev
> snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_pcm_oss snd_mixer_oss snd_pcm floppy snd_timer i2c_i801 pcspkr
> firewire_ohci firewire_core snd_page_alloc i2c_core snd_hwdep
> parport_pc parport usb_storage iTCO_wdt pata_jmicron snd
> iTCO_vendor_support crc_itu_t sky2 soundcore [last unloaded:
> microcode]
> 
> Pid: 3258, comm: listener Not tainted (2.6.27.9-159.fc10.i686 #1)
> EIP: 0060:[<f89848a9>] EFLAGS: 00010282 CPU: 1
> EIP is at nfqnl_enqueue_packet+0x18f/0x507 [nfnetlink_queue]
> EAX: 00000000 EBX: 000000b0 ECX: 00000009 EDX: 00000001
> ESI: f25a9b40 EDI: e25c1a00 EBP: e749ebfc ESP: e749ebb0
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process listener (pid: 3258, ti=e749e000 task=e89a59b0 task.ti=e749e000)
> Stack: e75353c0 f5d73800 f8cfb0b4 e74c6cb8 e2872a00 0000003c e2872a00 e25c1a30
>        00040438 00000438 e2642c80 e749ebfc 00000286 00b10f03 00000300 00000040
>        e75353c0 00000002 f8984cdc e749ec24 c0648717 c06d7cec f5d73800 c080f50c
> Call Trace:
>  [<c0648717>] ? __nf_queue+0x108/0x18b
>  [<c06488ab>] ? nf_reinject+0x111/0x134
>  [<c0654a3c>] ? dst_output+0x0/0xb
>  [<f8984707>] ? nfqnl_recv_verdict+0x1db/0x1ee [nfnetlink_queue]
>  [<f8c0b1aa>] ? nfnetlink_rcv_msg+0x10e/0x125 [nfnetlink]
>  [<c04f5143>] ? security_netlink_recv+0xf/0x11
>  [<f8c0b0b5>] ? nfnetlink_rcv_msg+0x19/0x125 [nfnetlink]
>  [<f8c0b09c>] ? nfnetlink_rcv_msg+0x0/0x125 [nfnetlink]
>  [<c0646c7c>] ? netlink_rcv_skb+0x30/0x78
>  [<f8c0b01c>] ? nfnetlink_rcv+0x1c/0x29 [nfnetlink]
>  [<c064688d>] ? netlink_unicast+0xee/0x144
>  [<c0646b12>] ? netlink_sendmsg+0x22f/0x23c

This looks like the packet went into a loop back to the queue. Which
shouldn't actually be a problem.

>> I tested the issue in different examples:
>>
>> 1- When using NF_REPEAT with only 1 queue, there isnt any problem
>>    $IPTABLES -A OUTPUT -m state --state NEW -m mark ! --mark 1 -j NF_QUEUE 0
>>    $IPTABLES -A OUTPUT -j ACCEPT
>>
>> 2- When using NF_REPEAT with (program 1 in queue 0 and program 2 in queue 1)
>>
>>                 $IPTABLES -A OUTPUT -m state --state NEW -m mark !
>> --mark 1 -j NF_QUEUE 0
>>                 $IPTABLES -A OUTPUT -m state --state NEW -m mark
>> --mark 1 -j NF_QUEUE 1
>>
>> then i got kernel panic. I think the problem is that using
>> nfq_set_verdict_mark(myQueue, id, NF_REPEAT, htonl(1) ,0, NULL)  don't
>> modify packet length and kernel freezes, but im not sure, im newbie
>> please help me.

Did you perform any changes on the ruleset during your test,
or unload any netfilter modules?

Please also send me the nfnetlink_queue object file in private.
