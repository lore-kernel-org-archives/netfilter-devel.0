From: "Michael Lawson (mshindo)" <michael@sphinix.com>
Subject: Fwd: PROBLEM: Null pointer deference in nf_reinject()
Date: Mon, 8 Mar 2010 11:15:43 +1300
Message-ID: <c97a47b91003071415q6c5157adidd1789749773ca37@mail.gmail.com>
References: <c97a47b91003061849l1133250bg895516ea191eac11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36597 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab0CGWQG convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Mar 2010 17:16:06 -0500
Received: by pvb32 with SMTP id 32so1251736pvb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Mar 2010 14:16:03 -0800 (PST)
In-Reply-To: <c97a47b91003061849l1133250bg895516ea191eac11@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---------- Forwarded message ----------
=46rom: Michael Lawson (mshindo) <michael@sphinix.com>
Date: Sun, Mar 7, 2010 at 3:49 PM
Subject: PROBLEM: Null pointer deference in nf_reinject()
To: linux-kernel <linux-kernel@vger.kernel.org>


I have found a weird bug caused by calls to nf_reinject in the 64Bit
version of 2.6.32 and 2.6.33.

We have a test module that captures all incoming packets on a queue
and then calls nf_reinject on that entry. On calling nf_reinject, the
kernel panics complaining about a null pointer. The arguments being
parsed to nf_reinject are _not_ null. And neither is the skb structure
inside the entry.

The module test code is as follows:

static struct nf_hook_ops* in_hook;
static struct nf_queue_handler* nfqh;

unsigned int hook_func(unsigned int hooknum,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct sk_buff *pskb,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct net_device =
*in,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct net_device =
*out,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int (*okfn)(struct sk_bu=
ff *))
{
=A0 =A0 =A0 =A0return NF_QUEUE;
}

int squeue_add_packet(struct nf_queue_entry *entry, unsigned int queuen=
um){
=A0 =A0 =A0 =A0//This is where things get nasty --->
=A0 =A0 =A0 =A0if(entry && entry->skb)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nf_reinject(entry, NF_ACCEPT);
return 0;
}

static void register_hooks(){
=A0 =A0 =A0 =A0in_hook =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D (struct nf_h=
ook_ops*)
kmalloc(sizeof(struct nf_hook_ops), GFP_ATOMIC);
=A0 =A0 =A0 =A0in_hook->hook =A0 =A0 =A0 =A0 =A0 =3D hook_func;
=A0 =A0 =A0 =A0in_hook->hooknum =A0 =A0 =A0 =A0=3D NF_INET_LOCAL_IN;
=A0 =A0 =A0 =A0in_hook->pf =A0 =A0 =A0 =A0 =A0 =A0 =3D 2;
=A0 =A0 =A0 =A0in_hook->priority =A0 =A0 =A0 =3D NF_IP_PRI_FIRST;

=A0 =A0 =A0 =A0nfqh =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D (struct =
nf_queue_handler*)
kmalloc(sizeof(struct nf_queue_handler),GFP_ATOMIC);
=A0 =A0 =A0 =A0nfqh->name =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D "queue";
=A0 =A0 =A0 =A0nfqh->outfn =A0 =A0 =A0 =A0 =A0 =A0 =3D &squeue_add_pack=
et;

=A0 =A0 =A0 =A0nf_register_hook(in_hook);

=A0 =A0 =A0 =A0nf_register_queue_handler(2, nfqh);
}

The resulting panic:

[ =A035.944199J BUG: unable to handle kernel NULL pointer dereference a=
t
0000000000000002
[ =A0 =A0 =A0 35.948124] =A0 IP: [<ffffffff81259ad4>] __nf_queue+0xaf/0=
x25f
[ =A0 =A0 =A0 35.949358] =A0 PGD 37870067 PUD 860dd067 PMD 0
[ =A0 =A0 =A0 35.950538] =A0 Thread overran stack, or stack corrupted
[ =A0 =A0 =A0 35.951638] =A0 Oops: 0000 [#1] SMP
[ =A0 =A0 =A0 35.954663] =A0 last sysfs file: /sys/devices/virtual/net/=
lo/operstate
[ =A0 =A0 =A0 35.957962] =A0 CPU 0
[ =A0 =A0 =A0 35.959177] =A0 Modules linked in: queue loop snd_ensl371
parport_pc gameport snd_rawmidi snd_seq_device snd_ac97_codec
serio_raui ac97_bus snd_pcm parport snd_ti
mer =A0pcspkr psmouse snd soundcore snd_page_alloc shpchp i2c_piix4
container i2c_core processor ac evdev pci_hotplug ext3 jbd mbcache
sd_mod crc_tlOdif ide_cd_mod
cdrom ide_pci_generic ata_generic libata uhci_hcd intel_agp mptspi
mptscsih mptbase scsi_transport_spi button floppy ehci_hcd piix elOOO
scsi_mod ide_core agpg
art =A0 usbcore nls_base thermal fan thermal_sys [last unloaded: scsi_u=
iait_scan]
[ =A0 =A0 =A0 35.991694] =A0 Pid: 0, comm: swapper Not tainted
2.6.32-trunk-amd64 #1 VMuiare Virtual Platform
[ =A0 =A0 =A0 36.000926] =A0 RIP: 0010: [<ffffffff81259ad4>]
[<ffffffff81259ad4>] __nf_queue+0xaf/0x25f
[ =A0 =A0 =A0 36.012149] =A0 RSP: 0018:ffff880001803C10 EFLAGS: 0001020=
2
[ =A0 =A0 =A0 36.031984] =A0 RAX: 0000000000000000 RBX: 000000000000000=
2 RCX:
0000000000000000
[ =A0 =A0 =A0 36.041312] =A0 RDX: 0000000000000058 RSI: ffff88003765ae4=
0 RDI:
ffff88003765ae88
[ =A0 =A0 =A0 36.052140] =A0 RBP: ffff88003765ae40 R08: 000000000000002=
0 R09:
0000000000000000
[ =A0 =A0 =A0 36.055722] =A0 RIO: 00008020ff00a8c0 Rll: ffff88008698060=
0 R12:
0000000000000002
[ =A0 =A0 =A0 36.057163] =A0 R13: ffff88003781d000 R14: 000000000000000=
0 R15:
0000000000000001
[ =A0 =A0 =A0 36.058517] =A0 FS: 0000000000000000(0000)
GS:ffff880001800000(0000) knlGS:0000000000000000
[ =A0 =A0 =A0 36.059896] =A0 CS: 0010 DS: 0018 ES: 0018 CRO: 0000000080=
05003b
[ =A0 =A0 =A0 36.061246] =A0 CR2: 0000000000000002 CR3: 000000008620a00=
0 CR4:
00000000000006f0
[ =A0 =A0 =A0 36.071174] =A0 DRO: 0000000000000000 DR1: 000000000000000=
0 DR2:
0000000000000000
[ =A0 =A0 =A0 36.075407] =A0 DR3: 0000000000000000 DR6: OOOOOOOOffffOff=
0 DR7:
0000000000000400
[ =A0 =A0 =A0 36.076844] =A0 Process swapper (pid: 0, threadinfo
ffffffff8140a000, task ffffffff8143flfO)
[ =A0 =A0 =A0 36.078274] =A0 Stack:
[ =A0 =A0 =A0 36.079649] =A0ffff880087204d00 ffffffff81327ff0 ffff88008=
7fe0530
0000000000000001
[ =A0 =A0 =A0 36.079687] =A0 <0> ffff880087204d00 ffffffff814b4f30
ffffffff8125f6d6 0000000000000000
[ =A0 =A0 =A0 36.081093] =A0 <0> ffff88003781d000 ffffffff8125923c
ffffffff8125f6d6 0000000000000000
[ =A0 =A0 =A0 36.102951] =A0 Call Trace:
[ =A0 =A0 =A0 36.105623] =A0<IRQ>
[ =A0 =A0 =A0 36.107111] =A0[<ffffffff8125f6d6>] ? ip_local_deliver_fin=
ish+0x0/0xle9
[ =A0 =A0 =A0 36.108539] =A0[<ffffffff8125923c>] ? nf_hook_sloui+0xae/0=
xc3
[ =A0 =A0 =A0 36.109969] =A0[<ffffffff8125f6d6>] ? ip_local_deliver_fin=
ish+0x0/0xle9
[ =A0 =A0 =A0 36.111381] =A0[<ffffffff8125f91e>] ? ip_local_deliver+0x5=
f/0x77
[ =A0 =A0 =A0 36.121758] =A0[<ffffffff8125f36b>] ? ip_rcv_finish+0x373/=
0x38d
[ =A0 =A0 =A0 36.125598] =A0[<ffffffffa00b3bld>] ?
el000_clean_rx_irq+0x326/0x3ea [elOOO]
[ =A0 =A0 =A0 36.127118] =A0[<ffffffffa00b78c2>] ? el000_clean+0x2fa/0x=
49c [elOOO]
[ =A0 =A0 =A0 36.128730] =A0[<ffffffff8105aal8>] ? __mod_timer+Ox141/0x=
153
[ =A0 =A0 =A0 36.130154] =A0[<ffffffff810c6b05>] ? sync_supers_timer_fn=
+0x0/0xl3
[ =A0 =A0 =A0 36.131572] =A0[<ffffffff8123c7bb>] ? net_rx_action+0xae/0=
xlc9
[ =A0 =A0 =A0 36.142427] =A0[<ffffffff810539ca>] ? __do_softirq+0xdd/0x=
l9f
[ =A0 =A0 =A0 36.162124] =A0[<ffffffff81011c6c>] ? call_softirq+0xlc/0x=
30
[ =A0 =A0 =A0 36.171237] =A0[<ffffffff810138c3>] ? do_softirq+0x3f/0x7c
[ =A0 =A0 =A0 36.182263] =A0[<ffffffff81053839>] ? irq_exit+0x36/0x76
[ =A0 =A0 =A0 36.202031] =A0[<ffffffff81012fba>] ? do_IRQ+0xa0/0xb6
{ =A0 =A0 =A0 36.205138] =A0[<ffffffff81011493>] ? ret_from_intr+0x0/0x=
ll
{ =A0 =A0 =A0 36.206542] =A0<E0I>
{ =A0 =A0 =A0 36.207920] =A0[<ffffffff8102c55c>] ? native.safe_halt+0x2=
/0x3
{ =A0 =A0 =A0 36.209259] =A0[<ffffffff81017d0d>] ? default_idle+0x34/0x=
51
{ =A0 =A0 =A0 36.210628] =A0[<ffffffff8100fe6f>] ? cpu_idle+0xa2/0xda
[ =A0 =A0 =A0 36.211945] =A0[<ffffffff814cel40>] ? early_idt_handler+0x=
0/0x71
[ =A0 =A0 =A0 36.220268] =A0[<ffffffff814cecd7>] ? Start_kernel+0x3d0/0=
x3dc
{ =A0 =A0 =A0 36.231257] =A0[<ffffffff814ce3b7>] ? x86_64_start_kernel+=
0xf9/0xl06
[ =A0 =A0 =A0 36.251002] =A0 Code: 44 89 7d 2c 4c 89 6d 30 4c 89 75 38 =
48 89
45 10 48 8b 44 24 50 48 89 45 40 4d 8b 64 24 18 4d 85 e4 74 6d 65 8b
04 25 a8 e3 00 00 <41> 83 3c
24 =A002 Of 84 99 01 00 00 48 63 dO 49 8b 84 24 28 02 00
{ =A0 =A0 =A0 36.262593] =A0 RIP =A0[<ffffffff81259ad4>] __nf_queue+0xa=
f/0x25f
[ =A0 =A0 =A0 36.290513] =A0RSP <ffff880001803cl0>
[ =A0 =A0 =A0 36.299797] =A0 CR2: 0000000000000002
[ =A0 =A0 =A0 36.302571] =A0 =97[ end trace c4b32f6153873714 ] =97
[ =A0 =A0 =A0 36.322849] =A0 Kernel panic - not syncing: Fatal exceptio=
n in interrupt

I have tested this on several different machines, but the particular
vmware image this individual stack trace came from was:

root@debian2:~# cat /proc/version
Linux version 2.6.32-trunk-amd64 (Debian 2.6.32-5)
(ben@decadent.org.uk) (gcc version 4.3.4 (Debian 4.3.4-6) ) #1 SMP Sun
Jan 10 22:40:40 UTC 2010

The code in question works perfectly in 32Bit linux.

Please consider looking at this, and when required any further
information can be provided

--
Thanks,
Michael Lawson
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
