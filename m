From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@sysophe.eu>
Subject: BUG: Fatal in exception in interrupt, at nf_conncount_count
 [regression in 4.19(.1)]
Date: Mon, 12 Nov 2018 15:04:06 +0100
Message-ID: <20181112150406.1bbb7bee@pluto.restena.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Cc: "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: Yi-Hung Wei <yihung.wei@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

With linux-4.19.1 I'm seeing regular kernel panics since this night
with uptime of 5 to 30 minutes in between. System is not heavily loaded.

With the following trace (transcribed):

Call Trace:
  <IRQ>
  nf_conncount_count+0x48c/0x4f0
  ? nf_ct_ext_add+0x80/0x170
  connlimit_mt+0xa1/0x1a0
  ? ipt_do_table+0x245/0x420
  ipt_do_table+0x245/0x420
  nf_hook_slow+0x3e/0xb0
  ip_local_deliver+0x9a/0xd0
  ? ip_sublist_rcv_finish+0x60/0x60
  ip_rcv+0x8f/0xb0
  ? ip_rcv_finish_core.isra.17+0x300/0x300
  __netif_receive_skb_internal+0x4d/0x70
  netif_receive_skb_internal+0x3e/0xd0
  napi_gro_receive+0x6a/0x80
  receive_buf+0x294/0xe40
  ? detach_buf+0x63/0x100
  virtnet_poll+0xba/0x2f0
  net_rx_action+0x137/0x330
  __do_softirq+0xd6/0x238
  irq_exit+0xc6/0xd0
  do_IRQ+0x78/0xd0
  common_interrupt+0xf/xf
  </IRQ>
 RIP: :native_safe_halt+0x2/0x10
 Code: f3 c3 65 48 8b 04 25 40 4c 01 00 f0 80 48 02 20 48 8b 00 a8 08 74
       8b eb c1 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 fb f4 <c3>
       0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 f4 c3 90 90 90 90 90 90
 RSP: 0018:ffffc90000073ec8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
 RAX: 0000000000000001 RBX: 0000000000000001 RCX: ffff88007db19200
 RDX: ffffffff81c30638 RSI: ffff88007db19200 RDI: 0000000000000087
 RBP: ffffffff81c670e8 R08: 000001b3fa8aad88 R09: ffff88007c417c00
 R10: 000000010000ecef R11: 000000000000a000 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
  default_idle+0xc/0x20
  do_idle+0x1f0/0x220
  ? do_idle+0x172/0x220
  cpu_startup_entry+0x6a/0x70
  secondary_startup_64+0xa4/0xb0
---[ end trace a4bf7eecae5cc0ae ]---
 RIP: 0010rb_insert_color+0x17/0x190
 Code: 4c 89 78 10 e9 72 ff ff ff 49 89 ef e9 27 ff ff ff 66 90 48 8b 17
       48 85 d2 0f 84 4d 01 00 00 48 8b 02 a8 01 0f 85 6d 01 00 00 <48>
       8b 48 08 49 89 c0 48 39 d1 74 53 48 85 c9 74 09 f6 01 01 0f 84
 RSP: 0018:ffff88007db03a58 EFLAGS: 00010246
 RAX: 930d659731af356e RBX: ffff88007db03b3c RCX: ffff88005f09c8c0
 RDX: ffff8800631c4c00 RSI: ffff88007c4474b0 RDI: ffff88005f09c8a0
 RBP: 0000000000000001 R08: ffff8800631c4c00 R09: ffff88005f09c8d0
 R10: ffff88007db03bc8 R11: 0000000000000000 R12: ffff88007c4474b0
 R13: 0000000000000002 R14: ffff88005f09c8a0 R15: ffff8800631c4c00
 FS:  0000000000000000(0000) GS:ffff88007db00000(0000) knlGS:00000000000000=
00
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f83d0291018 CR3: 000000007b036000 CR4: 00000000000406a0
 Kernel panic - not syncing: Fatal exception in interrupt

That's all I can get from machine's display.


The following commits have touched nf_conncount/connlimit code:
- 33b78aaa4457ce5d531c6a06f461f8d402774cad  netfilter: use PTR_ERR_OR_ZERO()
- 5c789e131cbb997a528451564ea4613e812fc718  netfilter: nf_conncount: Add li=
st lock and gc worker, and RCU for init tree search
- 34848d5c896ea1ab4e3c441b9c4fed39928ccbaf  netfilter: nf_conncount: Split =
insert and traversal
- 2ba39118c10ae3a7d3411c073485bba9576684cd  netfilter: nf_conncount: Move l=
ocking into count_tree()
- 976afca1ceba53df6f4a543014e15d1c7a962571  netfilter: nf_conncount: Early =
exit in nf_conncount_lookup() and cleanup
- cb2b36f5a97df76f547fcc4ab444a02522fb6c96  netfilter: nf_conncount: Switch=
 to plain list
- 2a406e8ac7c3e7e96b94d6c0765d5a4641970446  netfilter: nf_conncount: Early =
exit for garbage collection
- 5cd3da4ba2397ef07226ca2aa5094ed21ff8198f  Merge ra.kernel.org:/pub/scm/li=
nux/kernel/git/davem/net

It looks like those locking related changes may be the cause.
Bisecting it will be hard as I don't have exact packet stream
triggering the issue and as a production system it's not ideal
to run loops of testing.
(note, system is running under QEMU at a hosting provider)

Regards,
Bruno
