From: Andrey Wagin <avagin@gmail.com>
Subject: A conntrack, which is added via ctnetlink, can provoke a race condition
Date: Tue, 7 Jan 2014 13:40:51 +0400
Message-ID: <CANaxB-wntm+Vu5z0k9bRYLvPX3ezFZSEQkGPGH3AVYDT5DrOKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=089e015373bc15080804ef5e2c3d
Cc: vvs@openvz.org, Cyrill Gorcunov <gorcunov@openvz.org>,
	Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qe0-f43.google.com ([209.85.128.43]:63033 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaAGJkx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:40:53 -0500
Received: by mail-qe0-f43.google.com with SMTP id jy17so112459qeb.2
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jan 2014 01:40:52 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--089e015373bc15080804ef5e2c3d
Content-Type: text/plain; charset=ISO-8859-1

Hello All,

When a conntrack is created  by kernel, it is initialized (sets
IPS_{DST,SRC}_NAT_DONE_BIT bits in nf_nat_setup_info) and only then it
is added in hashes (__nf_conntrack_hash_insert), so one conntract
can't be initialized from a few threads concurrently.

ctnetlink can add an uninitialized conntrack (w/o
IPS_{DST,SRC}_NAT_DONE_BIT) in hashes, then a few threads can look up
this conntrack and start initialize it concurrently. It's dangerous,
because BUG can be triggered from  nf_nat_setup_info.

I added a busy loop in nf_nat_setup_info before BUG_ON to increase
race window and the bug is triggered without any problem. This kernel
patch is attached to this message. And I attached a test script for
sending packets and an user-space program to add conntrack via
netlink.

[ 1307.098595] ctnetlink_create_conntrack:1723: ffff8800a527bdf0
[ 1318.374303] nf_nat_setup_info:385 ffff8800a527bdf0 1 88
[ 1318.402729] nf_nat_setup_info:385 ffff8800a527bdf0 1 88
[ 1322.290041] nf_nat_setup_info:388 ffff8800a527bdf0 1 88
[ 1322.298476] nf_nat_setup_info:388 ffff8800a527bdf0 1 38a
[ 1322.299851] ------------[ cut here ]------------
[ 1322.300800] kernel BUG at net/netfilter/nf_nat_core.c:390!
[ 1322.300800] invalid opcode: 0000 [#1] SMP
[ 1322.300800] Dumping ftrace buffer:
[ 1322.300800]    (ftrace buffer empty)
[ 1322.300800] Modules linked in: binfmt_misc nf_conntrack_netlink
nfnetlink xt_nat iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat nf_conntrack nfsv3 nfs_acl nfs lockd sunrpc fscache
veth ip6table_filter ip6_tables iptable_filter ip_tables pcspkr
virtio_balloon i2c_piix4 virtio_net i2c_core virtio_blk floppy [last
unloaded: nf_conntrack]
[ 1322.300800] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-rc7+ #78
[ 1322.300800] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1322.300800] task: ffff8800bb168290 ti: ffff8800bb16c000 task.ti:
ffff8800bb16c000
[ 1322.300800] RIP: 0010:[<ffffffffa00692b2>]  [<ffffffffa00692b2>]
nf_nat_setup_info+0x392/0x400 [nf_nat]
[ 1322.300800] RSP: 0018:ffff8800bfa83bb8  EFLAGS: 00010206
[ 1322.300800] RAX: 0000000000000100 RBX: ffff8800a527bdf0 RCX: 0000000000000000
[ 1322.300800] RDX: 0000000000000100 RSI: ffff8800bb1689b8 RDI: 0000000000000246
[ 1322.300800] RBP: ffff8800bfa83c58 R08: 0000000000000000 R09: 0000000000000000
[ 1322.300800] R10: 0000000000000001 R11: ffff8800bfa838e6 R12: 0000000000000001
[ 1322.300800] R13: ffff880037ae4040 R14: ffff8800bfa83c78 R15: 0000000000000000
[ 1322.300800] FS:  0000000000000000(0000) GS:ffff8800bfa80000(0000)
knlGS:0000000000000000
[ 1322.300800] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1322.300800] CR2: 00007ffb9b71e000 CR3: 00000000b92d5000 CR4: 00000000000006e0
[ 1322.300800] Stack:
[ 1322.300800]  ffffffffa00440b8 ffff8800b992fd80 ffff8800a249ab80
ffff8800b992fd80
[ 1322.300800]  ffff8800b0d06400 00000000a0087c85 ffffe8ffffc80574
0000000100000001
[ 1322.300800]  ffffffffa0046598 ffff8800bb304480 0000000000000002
ffff8800b9664000
[ 1322.300800] Call Trace:
[ 1322.300800]  <IRQ>
[ 1322.300800]  [<ffffffffa00440b8>] ? ipt_do_table+0x2e8/0x4a5 [ip_tables]
[ 1322.300800]  [<ffffffffa007d2d2>] nf_nat_ipv4_fn+0x2d2/0x330 [iptable_nat]
[ 1322.300800]  [<ffffffffa007d5de>] nf_nat_ipv4_in+0x2e/0x84 [iptable_nat]
[ 1322.300800]  [<ffffffff8159d6f0>] ? inet_del_offload+0x40/0x40
[ 1322.300800]  [<ffffffff8159435a>] nf_iterate+0x9a/0xb0
[ 1322.300800]  [<ffffffff8159d6f0>] ? inet_del_offload+0x40/0x40
[ 1322.300800]  [<ffffffff8159440c>] nf_hook_slow+0x9c/0x160
[ 1322.300800]  [<ffffffff8159d6f0>] ? inet_del_offload+0x40/0x40
[ 1322.300800]  [<ffffffff8159e3a7>] ip_rcv+0x2f7/0x3d0
[ 1322.300800]  [<ffffffff815635a2>] __netif_receive_skb_core+0x4e2/0x880
[ 1322.300800]  [<ffffffff815631d2>] ? __netif_receive_skb_core+0x112/0x880
[ 1322.300800]  [<ffffffff81563958>] __netif_receive_skb+0x18/0x60
[ 1322.300800]  [<ffffffff8156460e>] process_backlog+0xbe/0x1a0
[ 1322.300800]  [<ffffffff81563e42>] net_rx_action+0x162/0x270
[ 1322.300800]  [<ffffffff8105dee4>] __do_softirq+0x104/0x2a0
[ 1322.300800]  [<ffffffff8105e45d>] irq_exit+0xcd/0xe0
[ 1322.300800]  [<ffffffff8167f586>] do_IRQ+0x56/0xc0
[ 1322.300800]  [<ffffffff81674f32>] common_interrupt+0x72/0x72
[ 1322.300800]  <EOI>
[ 1322.300800]  [<ffffffff8103d8e6>] ? native_safe_halt+0x6/0x10
[ 1322.300800]  [<ffffffff810a743d>] ? trace_hardirqs_on+0xd/0x10
[ 1322.300800]  [<ffffffff8100b284>] default_idle+0x24/0xc0
[ 1322.300800]  [<ffffffff8100bb4e>] arch_cpu_idle+0x2e/0x40
[ 1322.300800]  [<ffffffff810b9845>] cpu_startup_entry+0xc5/0x290
[ 1322.300800]  [<ffffffff8102fe6d>] start_secondary+0x21d/0x2d0
[ 1322.300800] Code: 00 48 01 d0 e9 b8 fe ff ff 48 81 8b b0 00 00 00
00 01 00 00 e9 9e fd ff ff 48 83 8b b0 00 00 00 20 e9 5f fd ff ff e8
ee f5 fe e0 <0f> 0b 4c 8b 8b b0 00 00 00 45 89 e0 48 89 d9 ba 81 01 00
00 48
[ 1322.300800] RIP  [<ffffffffa00692b2>] nf_nat_setup_info+0x392/0x400 [nf_nat]
[ 1322.300800]  RSP <ffff8800bfa83bb8>
[ 1322.383568] ---[ end trace c3cef76423498e85 ]---
[ 1322.384778] Kernel panic - not syncing: Fatal exception in interrupt
[ 1322.385766] Dumping ftrace buffer:
[ 1322.385766]    (ftrace buffer empty)

--089e015373bc15080804ef5e2c3d
Content-Type: text/x-patch; charset=US-ASCII; name="0001-debug.patch"
Content-Disposition: attachment; filename="0001-debug.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hq4a30l80

RnJvbSBmNTAxZDJlODBjMjgxMWFhN2Q2OTExMGQ3MmYyNGU2YjcxNzNkOTIwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbmRyZXkgVmFnaW4gPGF2YWdpbkBvcGVudnoub3JnPgpEYXRl
OiBNb24sIDYgSmFuIDIwMTQgMTg6NTk6MzcgKzA0MDAKU3ViamVjdDogW1BBVENIXSBkZWJ1ZwoK
U2lnbmVkLW9mZi1ieTogQW5kcmV5IFZhZ2luIDxhdmFnaW5Ab3BlbnZ6Lm9yZz4KLS0tCiBuZXQv
Y29yZS9kZXYuYyAgICAgICAgICAgICAgICAgICAgICAgfCAyICsrCiBuZXQvbmV0ZmlsdGVyL25m
X2Nvbm50cmFja19uZXRsaW5rLmMgfCAxICsKIG5ldC9uZXRmaWx0ZXIvbmZfbmF0X2NvcmUuYyAg
ICAgICAgICB8IDggKysrKysrKysKIDMgZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKQoK
ZGlmZiAtLWdpdCBhL25ldC9jb3JlL2Rldi5jIGIvbmV0L2NvcmUvZGV2LmMKaW5kZXggNGZjMTcy
Mi4uNjcxZTRiNCAxMDA2NDQKLS0tIGEvbmV0L2NvcmUvZGV2LmMKKysrIGIvbmV0L2NvcmUvZGV2
LmMKQEAgLTI5ODEsNyArMjk4MSw5IEBAIHN0YXRpYyBpbnQgZ2V0X3Jwc19jcHUoc3RydWN0IG5l
dF9kZXZpY2UgKmRldiwgc3RydWN0IHNrX2J1ZmYgKnNrYiwKIAlzdHJ1Y3QgcnBzX3NvY2tfZmxv
d190YWJsZSAqc29ja19mbG93X3RhYmxlOwogCWludCBjcHUgPSAtMTsKIAl1MTYgdGNwdTsKKwlz
dGF0aWMgaW50IHh4eCA9IDA7CiAKKwlyZXR1cm4gKHh4eCsrKSAlIDI7CiAJaWYgKHNrYl9yeF9x
dWV1ZV9yZWNvcmRlZChza2IpKSB7CiAJCXUxNiBpbmRleCA9IHNrYl9nZXRfcnhfcXVldWUoc2ti
KTsKIAkJaWYgKHVubGlrZWx5KGluZGV4ID49IGRldi0+cmVhbF9udW1fcnhfcXVldWVzKSkgewpk
aWZmIC0tZ2l0IGEvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfbmV0bGluay5jIGIvbmV0L25l
dGZpbHRlci9uZl9jb25udHJhY2tfbmV0bGluay5jCmluZGV4IDA4ODcwYjguLjJmNmM3MjQgMTAw
NjQ0Ci0tLSBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX25ldGxpbmsuYworKysgYi9uZXQv
bmV0ZmlsdGVyL25mX2Nvbm50cmFja19uZXRsaW5rLmMKQEAgLTE3MjAsNiArMTcyMCw3IEBAIGN0
bmV0bGlua19jcmVhdGVfY29ubnRyYWNrKHN0cnVjdCBuZXQgKm5ldCwgdTE2IHpvbmUsCiAJaWYg
KHRzdGFtcCkKIAkJdHN0YW1wLT5zdGFydCA9IGt0aW1lX3RvX25zKGt0aW1lX2dldF9yZWFsKCkp
OwogCisJcHJpbnRrKCIlczolZDogJXBcbiIsIF9fZnVuY19fLCBfX0xJTkVfXywgY3QpOwogCWVy
ciA9IG5mX2Nvbm50cmFja19oYXNoX2NoZWNrX2luc2VydChjdCk7CiAJaWYgKGVyciA8IDApCiAJ
CWdvdG8gZXJyMjsKZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIvbmZfbmF0X2NvcmUuYyBiL25l
dC9uZXRmaWx0ZXIvbmZfbmF0X2NvcmUuYwppbmRleCA2M2E4MTU0Li41NjAwYmZkIDEwMDY0NAot
LS0gYS9uZXQvbmV0ZmlsdGVyL25mX25hdF9jb3JlLmMKKysrIGIvbmV0L25ldGZpbHRlci9uZl9u
YXRfY29yZS5jCkBAIC0zNzksNiArMzc5LDE0IEBAIG5mX25hdF9zZXR1cF9pbmZvKHN0cnVjdCBu
Zl9jb25uICpjdCwKIAogCU5GX0NUX0FTU0VSVChtYW5pcHR5cGUgPT0gTkZfTkFUX01BTklQX1NS
QyB8fAogCQkgICAgIG1hbmlwdHlwZSA9PSBORl9OQVRfTUFOSVBfRFNUKTsKKwlpZiAobmV0ICE9
ICZpbml0X25ldCkKKwl7CisJCWxvbmcgbG9uZyBpOworCQlwcmludGsoIiVzOiVkICVwICVkICVs
eFxuIiwgX19mdW5jX18sIF9fTElORV9fLCBjdCwgbWFuaXB0eXBlLCBjdC0+c3RhdHVzKTsKKwkJ
Zm9yIChpID0gMDsgaSA8IDEwMDAwMDAwMDAwOyBpKyspCisJCQlhc20oIm5vcCIpOworCQlwcmlu
dGsoIiVzOiVkICVwICVkICVseFxuIiwgX19mdW5jX18sIF9fTElORV9fLCBjdCwgbWFuaXB0eXBl
LCBjdC0+c3RhdHVzKTsKKwl9CiAJQlVHX09OKG5mX25hdF9pbml0aWFsaXplZChjdCwgbWFuaXB0
eXBlKSk7CiAKIAkvKiBXaGF0IHdlJ3ZlIGdvdCB3aWxsIGxvb2sgbGlrZSBpbnZlcnNlIG9mIHJl
cGx5LiBOb3JtYWxseQotLSAKMS44LjQuMgoK
--089e015373bc15080804ef5e2c3d
Content-Type: text/x-csrc; charset=US-ASCII; name="conntrack_create.c"
Content-Disposition: attachment; filename="conntrack_create.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hq4c2s1p2

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN0cmluZy5o
PgojaW5jbHVkZSA8ZXJybm8uaD4KI2luY2x1ZGUgPGFycGEvaW5ldC5oPgoKI2luY2x1ZGUgPGxp
Ym5ldGZpbHRlcl9jb25udHJhY2svbGlibmV0ZmlsdGVyX2Nvbm50cmFjay5oPgojaW5jbHVkZSA8
bGlibmV0ZmlsdGVyX2Nvbm50cmFjay9saWJuZXRmaWx0ZXJfY29ubnRyYWNrX3RjcC5oPgoKaW50
IG1haW4odm9pZCkKewoJaW50IHJldDsKCXN0cnVjdCBuZmN0X2hhbmRsZSAqaDsKCXN0cnVjdCBu
Zl9jb25udHJhY2sgKmN0OwoKCWN0ID0gbmZjdF9uZXcoKTsKCWlmICghY3QpIHsKCQlwZXJyb3Io
Im5mY3RfbmV3Iik7CgkJcmV0dXJuIDA7Cgl9CgoJbmZjdF9zZXRfYXR0cl91OChjdCwgQVRUUl9M
M1BST1RPLCBBRl9JTkVUKTsKCW5mY3Rfc2V0X2F0dHJfdTMyKGN0LCBBVFRSX0lQVjRfU1JDLCBp
bmV0X2FkZHIoIjE5Mi4xNjguMTIyLjEiKSk7CgluZmN0X3NldF9hdHRyX3UzMihjdCwgQVRUUl9J
UFY0X0RTVCwgaW5ldF9hZGRyKCIxOTIuMTY4LjEyMi41NiIpKTsKCQoJbmZjdF9zZXRfYXR0cl91
OChjdCwgQVRUUl9MNFBST1RPLCBJUFBST1RPX1RDUCk7CgluZmN0X3NldF9hdHRyX3UxNihjdCwg
QVRUUl9QT1JUX1NSQywgaHRvbnMoNjU4OCkpOwoJbmZjdF9zZXRfYXR0cl91MTYoY3QsIEFUVFJf
UE9SVF9EU1QsIGh0b25zKDY1ODgpKTsKCgluZmN0X3NldG9iam9wdChjdCwgTkZDVF9TT1BUX1NF
VFVQX1JFUExZKTsKCW5mY3Rfc2V0b2Jqb3B0KGN0LCBORkNUX1NPUFRfVU5ET19TTkFUKTsKCglu
ZmN0X3NldF9hdHRyX3U4KGN0LCBBVFRSX1RDUF9TVEFURSwgVENQX0NPTk5UUkFDS19TWU5fU0VO
VCk7CgluZmN0X3NldF9hdHRyX3UzMihjdCwgQVRUUl9USU1FT1VULCAzMCk7CgoJaCA9IG5mY3Rf
b3BlbihDT05OVFJBQ0ssIDApOwoJaWYgKCFoKSB7CgkJcGVycm9yKCJuZmN0X29wZW4iKTsKCQlu
ZmN0X2Rlc3Ryb3koY3QpOwoJCXJldHVybiAtMTsKCX0KCglyZXQgPSBuZmN0X3F1ZXJ5KGgsIE5G
Q1RfUV9DUkVBVEUsIGN0KTsKCglwcmludGYoIlRFU1Q6IGNyZWF0ZSBjb25udHJhY2sgIik7Cglp
ZiAocmV0ID09IC0xKQoJCXByaW50ZigiKCVkKSglcylcbiIsIHJldCwgc3RyZXJyb3IoZXJybm8p
KTsKCWVsc2UKCQlwcmludGYoIihPSylcbiIpOwoKCW5mY3RfY2xvc2UoaCk7CgoJbmZjdF9kZXN0
cm95KGN0KTsKCglyZXQgPT0gLTEgPyBleGl0KEVYSVRfRkFJTFVSRSkgOiBleGl0KEVYSVRfU1VD
Q0VTUyk7Cn0K
--089e015373bc15080804ef5e2c3d
Content-Type: text/x-python; charset=US-ASCII; name="send_raw_packets.py"
Content-Disposition: attachment; filename="send_raw_packets.py"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hq4yfxj52

ZnJvbSBzY2FweS5hbGwgaW1wb3J0ICoKCmE9SVAoZHN0PSIxOTIuMTY4LjEyMi41NiIpL1RDUChm
bGFncz0iUyIsIHNwb3J0PTY1ODgsIGRwb3J0PTY1ODgpCmZvciBpIGluIHhyYW5nZSg0KToKCXNl
bmQoYSwgIHZlcmJvc2U9MCkK
--089e015373bc15080804ef5e2c3d--
