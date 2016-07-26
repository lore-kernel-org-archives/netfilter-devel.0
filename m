From: "Anders K. Pedersen" <akp@akp.dk>
Subject: nft_rbtree_lookup: BUG: unable to handle kernel NULL pointer
 dereference
Date: Tue, 26 Jul 2016 15:18:28 +0200
Message-ID: <1469539108.1032.30.camel@akp.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 85.204.120.79.ip4.gigabit.dk ([85.204.120.79]:53950 "EHLO
	mail.kbh.akp.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbcGZNSc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 09:18:32 -0400
Received: from [10.68.143.192] (plato-eth1.surftown.net [212.97.129.13])
	by mail.kbh.akp.dk (Postfix) with ESMTPSA id 49B92B61C4
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2016 15:18:29 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

While doing some tests with nftables, I've run into the the following
bug, which is easily reproducable:

[ 1409.721487] BUG: unable to handle kernel NULL pointer dereference at=
 0000000000000010
[ 1409.730512] IP: [<ffffffff81495de9>] nft_rbtree_lookup+0xa9/0x150
[ 1409.737525] PGD 0
[ 1409.739841] Oops: 0000 [#1] SMP
[ 1409.743445] Modules linked in:
[ 1409.746966] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.7.0 #1
[ 1409.753660] Hardware name: Dell Inc. PowerEdge R730/0H21J3, BIOS 2.1=
=2E6 05/19/2016
[ 1409.762253] task: ffffffff8180b500 ti: ffffffff81800000 task.ti: fff=
fffff81800000
[ 1409.770846] RIP: 0010:[<ffffffff81495de9>]  [<ffffffff81495de9>] nft=
_rbtree_lookup+0xa9/0x150
[ 1409.780651] RSP: 0018:ffff88085f2039c8  EFLAGS: 00010202
[ 1409.786745] RAX: ffff88083dc76f80 RBX: ffff88083dc76fa4 RCX: 0000000=
000000002
[ 1409.794937] RDX: 0000000000000004 RSI: ffff88083dc76de0 RDI: ffff880=
83dc76fa4
[ 1409.803130] RBP: 0000000000000004 R08: 0000000000000000 R09: ffff880=
85f203aa0
[ 1409.811323] R10: ffff88083dc699e2 R11: ffff88085803d000 R12: ffff880=
85ae2f700
[ 1409.819517] R13: ffff88083dc76f80 R14: ffff88085f203aa0 R15: 0000000=
000000000
[ 1409.827710] FS:  0000000000000000(0000) GS:ffff88085f200000(0000) kn=
lGS:0000000000000000
[ 1409.837006] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1409.843594] CR2: 0000000000000010 CR3: 0000000001806000 CR4: 0000000=
0001406f0
[ 1409.851788] Stack:
[ 1409.854095]  ffffffff00000002 ffff8800785b0100 0000000000000000 ffff=
88085f203a20
[ 1409.862641]  ffff88085ae2f700 ffff880855e16428 ffff88085f203a90 0000=
000000000002
[ 1409.871184]  00000000ffffffff ffff880855e16428 ffffffff81493a4e ffff=
880859d699d8
[ 1409.879736] Call Trace:
[ 1409.882539]  <IRQ>
[ 1409.884751]  [<ffffffff81493a4e>] ? nft_lookup_eval+0x2e/0x80
[ 1409.891561]  [<ffffffff8148b089>] ? nft_do_chain+0xc9/0x400
[ 1409.897959]  [<ffffffff814804ae>] ? __qdisc_run+0x3e/0x1b0
[ 1409.904249]  [<ffffffff8145dd52>] ? __dev_queue_xmit+0x212/0x4d0
[ 1409.911147]  [<ffffffff814cca65>] ? arp_xmit+0x25/0xa0
[ 1409.917045]  [<ffffffff814ccb07>] ? arp_send_dst.part.19+0x27/0x50
[ 1409.924141]  [<ffffffff814cd493>] ? arp_solicit+0x103/0x240
[ 1409.930540]  [<ffffffff814d9924>] ? fib_validate_source+0x124/0x350
[ 1409.937732]  [<ffffffff8146b1f0>] ? __neigh_event_send+0x50/0x230
[ 1409.944729]  [<ffffffff8146c0c4>] ? neigh_resolve_output+0x114/0x1a0
[ 1409.952027]  [<ffffffff8149f615>] ? ip_finish_output2+0x135/0x2e0
[ 1409.959027]  [<ffffffff810a1aa3>] ? update_group_capacity+0x23/0x1c0
[ 1409.966328]  [<ffffffff814e6f1c>] ? nft_do_chain_ipv4+0x8c/0xa0
[ 1409.973119]  [<ffffffff81487ba4>] ? nf_iterate+0x54/0x70
[ 1409.979217]  [<ffffffff81487c1d>] ? nf_hook_slow+0x5d/0xb0
[ 1409.985518]  [<ffffffff8149c8b1>] ? ip_rcv+0x2e1/0x370
[ 1409.991420]  [<ffffffff8149c0b0>] ? ip_local_deliver_finish+0xd0/0xd=
0
[ 1409.998818]  [<ffffffff8145a166>] ? __netif_receive_skb_core+0x3f6/0=
x790
[ 1410.006516]  [<ffffffff8145a57f>] ? netif_receive_skb_internal+0x1f/=
0x80
[ 1410.014215]  [<ffffffff8145ab3b>] ? napi_gro_receive+0xbb/0x110
[ 1410.021009]  [<ffffffff813c99b5>] ? i40e_napi_poll+0x7f5/0x1010
[ 1410.034501]  [<ffffffff8145e796>] ? net_rx_action+0x1b6/0x2f0
[ 1410.047758]  [<ffffffff81539ae0>] ? __do_softirq+0x100/0x288
[ 1410.060885]  [<ffffffff81075550>] ? irq_exit+0x80/0x90
[ 1410.073235]  [<ffffffff8153982f>] ? do_IRQ+0x4f/0xd0
[ 1410.085168]  [<ffffffff81537efc>] ? common_interrupt+0x7c/0x7c
[ 1410.098089]  <EOI>
[ 1410.100301]  [<ffffffff81423745>] ? cpuidle_enter_state+0x145/0x2a0
[ 1410.120442]  [<ffffffff81423721>] ? cpuidle_enter_state+0x121/0x2a0
[ 1410.133960]  [<ffffffff810a90e5>] ? cpu_startup_entry+0x2e5/0x320
[ 1410.147132]  [<ffffffff818f0e17>] ? start_kernel+0x3f9/0x401
[ 1410.159720] Code: 7f 08 4d 85 ff 75 d0 4d 85 ed 0f 84 9f 00 00 00 41=
 f6 84 24 90 00 00 00 04 0f 84 90 00 00 00 4c 89 e8 0f b6 0c 24 84 48 1=
8 74 49 <4d> 8b 7f 10 eb a1 4d 85 ed 4d 8b 47 10 74 23 41 0f b6 45 19 4=
8
[ 1410.194716] RIP  [<ffffffff81495de9>] nft_rbtree_lookup+0xa9/0x150
[ 1410.208085]  RSP <ffff88085f2039c8>
[ 1410.218333] CR2: 0000000000000010
[ 1410.228391] ---[ end trace d872214fea68c281 ]---
[ 1410.241846] Kernel panic - not syncing: Fatal exception in interrupt

I have narrowed the rule set in use down to:

table ip filter {
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0set bogons {
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0type ipv4_addr
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0flags interval
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}

=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0chain prerouting {
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0type filter hook prerouting priority -300; poli=
cy accept;
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0iif lo accept
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ip daddr @bogons ip daddr !=3D 224.0.0.0/4 log =
prefix "Bogon" group 0 snaplen 80 counter packets 0 bytes 0 drop
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ip saddr @bogons log prefix "Bogon" group 0 sna=
plen 80 counter packets 0 bytes 0 drop
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
}

With the following shell code, the box will crash quite quickly (within
seconds) during the "nft delete element" part:

I=3D1
while : ; do
	echo -n "${I} add"
	nft add element ip filter bogons { 0.0.0.0/8 }
	echo -n " delete"
	nft delete element ip filter bogons { 0.0.0.0/8 }
	echo
	I=3D$[${I}+1]
done

Traffic to/from the box is limited to the ssh connection used to run
the shell code above and some broadcast on the network segment.

Dump of assembler code for function nft_rbtree_lookup:
=C2=A0=C2=A0=C2=A00xffffffff81495d40 <+0>:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
callq=C2=A0=C2=A00xffffffff81539530 <__fentry__>
=C2=A0=C2=A0=C2=A00xffffffff81495d45 <+5>:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
push=C2=A0=C2=A0=C2=A0%r15
=C2=A0=C2=A0=C2=A00xffffffff81495d47 <+7>:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
mov=C2=A0=C2=A0=C2=A0=C2=A0$0x1,%r15d
=C2=A0=C2=A0=C2=A00xffffffff81495d4d <+13>:=C2=A0=C2=A0=C2=A0=C2=A0push=
=C2=A0=C2=A0=C2=A0%r14
=C2=A0=C2=A0=C2=A00xffffffff81495d4f <+15>:=C2=A0=C2=A0=C2=A0=C2=A0mov=C2=
=A0=C2=A0=C2=A0=C2=A0%rsi,%r14
=C2=A0=C2=A0=C2=A00xffffffff81495d52 <+18>:=C2=A0=C2=A0=C2=A0=C2=A0push=
=C2=A0=C2=A0=C2=A0%r13
=C2=A0=C2=A0=C2=A00xffffffff81495d54 <+20>:=C2=A0=C2=A0=C2=A0=C2=A0xor=C2=
=A0=C2=A0=C2=A0=C2=A0%r13d,%r13d
=C2=A0=C2=A0=C2=A00xffffffff81495d57 <+23>:=C2=A0=C2=A0=C2=A0=C2=A0push=
=C2=A0=C2=A0=C2=A0%r12
=C2=A0=C2=A0=C2=A00xffffffff81495d59 <+25>:=C2=A0=C2=A0=C2=A0=C2=A0mov=C2=
=A0=C2=A0=C2=A0=C2=A0%rdi,%r12
=C2=A0=C2=A0=C2=A00xffffffff81495d5c <+28>:=C2=A0=C2=A0=C2=A0=C2=A0push=
=C2=A0=C2=A0=C2=A0%rbp
=C2=A0=C2=A0=C2=A00xffffffff81495d5d <+29>:=C2=A0=C2=A0=C2=A0=C2=A0push=
=C2=A0=C2=A0=C2=A0%rbx
=C2=A0=C2=A0=C2=A00xffffffff81495d5e <+30>:=C2=A0=C2=A0=C2=A0=C2=A0sub=C2=
=A0=C2=A0=C2=A0=C2=A0$0x20,%rsp
=C2=A0=C2=A0=C2=A00xffffffff81495d62 <+34>:=C2=A0=C2=A0=C2=A0=C2=A0mov=C2=
=A0=C2=A0=C2=A0=C2=A00x88(%rdi),%rax
=C2=A0=C2=A0=C2=A00xffffffff81495d69 <+41>:=C2=A0=C2=A0=C2=A0=C2=A0mov=C2=
=A0=C2=A0=C2=A0=C2=A0$0xffffffff81a7b6b0,%rdi
=C2=A0=C2=A0=C2=A00xffffffff81495d70 <+48>:=C2=A0=C2=A0=C2=A0=C2=A0mov=C2=
=A0=C2=A0=C2=A0=C2=A0%rdx,0x18(%rsp)
=C2=A0=C2=A0=C2=A00xffffffff81495d75 <+53>:=C2=A0=C2=A0=C2=A0=C2=A0movz=
bl 0xeec(%rax),%ecx
=C2=A0=C2=A0=C2=A00xffffffff81495d7c <+60>:=C2=A0=C2=A0=C2=A0=C2=A0shl=C2=
=A0=C2=A0=C2=A0=C2=A0%cl,%r15d
=C2=A0=C2=A0=C2=A00xffffffff81495d7f <+63>:=C2=A0=C2=A0=C2=A0=C2=A0mov=C2=
=A0=C2=A0=C2=A0=C2=A0%r15d,(%rsp)
=C2=A0=C2=A0=C2=A00xffffffff81495d83 <+67>:=C2=A0=C2=A0=C2=A0=C2=A0call=
q=C2=A0=C2=A00xffffffff81537280 <_raw_spin_lock_bh>
=C2=A0=C2=A0=C2=A00xffffffff81495d88 <+72>:=C2=A0=C2=A0=C2=A0=C2=A0mov=C2=
=A0=C2=A0=C2=A0=C2=A00x98(%r12),%r15
=C2=A0=C2=A0=C2=A00xffffffff81495d90 <+80>:=C2=A0=C2=A0=C2=A0=C2=A0test=
=C2=A0=C2=A0=C2=A0%r15,%r15
=C2=A0=C2=A0=C2=A00xffffffff81495d93 <+83>:=C2=A0=C2=A0=C2=A0=C2=A0je=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A00xffffffff81495dc5 <nft_rbtree_lookup+133>
=C2=A0=C2=A0=C2=A00xffffffff81495d95 <+85>:=C2=A0=C2=A0=C2=A0=C2=A0movz=
bl 0x19(%r15),%eax
=C2=A0=C2=A0=C2=A00xffffffff81495d9a <+90>:=C2=A0=C2=A0=C2=A0=C2=A0mov=C2=
=A0=C2=A0=C2=A0=C2=A0%r14,%rsi
=C2=A0=C2=A0=C2=A00xffffffff81495d9d <+93>:=C2=A0=C2=A0=C2=A0=C2=A0movz=
bl 0x92(%r12),%ebp
=C2=A0=C2=A0=C2=A00xffffffff81495da6 <+102>:=C2=A0=C2=A0=C2=A0lea=C2=A0=
=C2=A0=C2=A0=C2=A00x18(%r15,%rax,1),%rbx
=C2=A0=C2=A0=C2=A00xffffffff81495dab <+107>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A0%rbp,%rdx
=C2=A0=C2=A0=C2=A00xffffffff81495dae <+110>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A0%rbx,%rdi
=C2=A0=C2=A0=C2=A00xffffffff81495db1 <+113>:=C2=A0=C2=A0=C2=A0callq=C2=A0=
=C2=A00xffffffff81299680 <memcmp>
=C2=A0=C2=A0=C2=A00xffffffff81495db6 <+118>:=C2=A0=C2=A0=C2=A0test=C2=A0=
=C2=A0=C2=A0%eax,%eax
=C2=A0=C2=A0=C2=A00xffffffff81495db8 <+120>:=C2=A0=C2=A0=C2=A0js=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A00xffffffff81495def <nft_rbtree_lookup+175>
=C2=A0=C2=A0=C2=A00xffffffff81495dba <+122>:=C2=A0=C2=A0=C2=A0je=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A00xffffffff81495e26 <nft_rbtree_lookup+230>
=C2=A0=C2=A0=C2=A00xffffffff81495dbc <+124>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A00x8(%r15),%r15
=C2=A0=C2=A0=C2=A00xffffffff81495dc0 <+128>:=C2=A0=C2=A0=C2=A0test=C2=A0=
=C2=A0=C2=A0%r15,%r15
=C2=A0=C2=A0=C2=A00xffffffff81495dc3 <+131>:=C2=A0=C2=A0=C2=A0jne=C2=A0=
=C2=A0=C2=A0=C2=A00xffffffff81495d95 <nft_rbtree_lookup+85>
=C2=A0=C2=A0=C2=A00xffffffff81495dc5 <+133>:=C2=A0=C2=A0=C2=A0test=C2=A0=
=C2=A0=C2=A0%r13,%r13
=C2=A0=C2=A0=C2=A00xffffffff81495dc8 <+136>:=C2=A0=C2=A0=C2=A0je=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A00xffffffff81495e6d <nft_rbtree_lookup+301>
=C2=A0=C2=A0=C2=A00xffffffff81495dce <+142>:=C2=A0=C2=A0=C2=A0testb=C2=A0=
=C2=A0$0x4,0x90(%r12)
=C2=A0=C2=A0=C2=A00xffffffff81495dd7 <+151>:=C2=A0=C2=A0=C2=A0je=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A00xffffffff81495e6d <nft_rbtree_lookup+301>
=C2=A0=C2=A0=C2=A00xffffffff81495ddd <+157>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A0%r13,%rax
=C2=A0=C2=A0=C2=A00xffffffff81495de0 <+160>:=C2=A0=C2=A0=C2=A0movzbl (%=
rsp),%ecx
=C2=A0=C2=A0=C2=A00xffffffff81495de4 <+164>:=C2=A0=C2=A0=C2=A0test=C2=A0=
=C2=A0=C2=A0%cl,0x18(%rax)
=C2=A0=C2=A0=C2=A00xffffffff81495de7 <+167>:=C2=A0=C2=A0=C2=A0je=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A00xffffffff81495e32 <nft_rbtree_lookup+242>
>=C2=A0=C2=A00xffffffff81495de9 <+169>:=C2=A0=C2=A0=C2=A0mov=C2=A0=C2=A0=
=C2=A0=C2=A00x10(%r15),%r15
=C2=A0=C2=A0=C2=A00xffffffff81495ded <+173>:=C2=A0=C2=A0=C2=A0jmp=C2=A0=
=C2=A0=C2=A0=C2=A00xffffffff81495d90 <nft_rbtree_lookup+80>
=C2=A0=C2=A0=C2=A00xffffffff81495def <+175>:=C2=A0=C2=A0=C2=A0test=C2=A0=
=C2=A0=C2=A0%r13,%r13
=C2=A0=C2=A0=C2=A00xffffffff81495df2 <+178>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A00x10(%r15),%r8
=C2=A0=C2=A0=C2=A00xffffffff81495df6 <+182>:=C2=A0=C2=A0=C2=A0je=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A00xffffffff81495e1b <nft_rbtree_lookup+219>
=C2=A0=C2=A0=C2=A00xffffffff81495df8 <+184>:=C2=A0=C2=A0=C2=A0movzbl 0x=
19(%r13),%eax
=C2=A0=C2=A0=C2=A00xffffffff81495dfd <+189>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A0%rbp,%rdx
=C2=A0=C2=A0=C2=A00xffffffff81495e00 <+192>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A0%rbx,%rdi
=C2=A0=C2=A0=C2=A00xffffffff81495e03 <+195>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A0%r8,0x10(%rsp)
=C2=A0=C2=A0=C2=A00xffffffff81495e08 <+200>:=C2=A0=C2=A0=C2=A0lea=C2=A0=
=C2=A0=C2=A0=C2=A00x18(%r13,%rax,1),%rsi
=C2=A0=C2=A0=C2=A00xffffffff81495e0d <+205>:=C2=A0=C2=A0=C2=A0callq=C2=A0=
=C2=A00xffffffff81299680 <memcmp>
=C2=A0=C2=A0=C2=A00xffffffff81495e12 <+210>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A00x10(%rsp),%r8
=C2=A0=C2=A0=C2=A00xffffffff81495e17 <+215>:=C2=A0=C2=A0=C2=A0test=C2=A0=
=C2=A0=C2=A0%eax,%eax
=C2=A0=C2=A0=C2=A00xffffffff81495e19 <+217>:=C2=A0=C2=A0=C2=A0je=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A00xffffffff81495e1e <nft_rbtree_lookup+222>
=C2=A0=C2=A0=C2=A00xffffffff81495e1b <+219>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A0%r15,%r13
=C2=A0=C2=A0=C2=A00xffffffff81495e1e <+222>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A0%r8,%r15
=C2=A0=C2=A0=C2=A00xffffffff81495e21 <+225>:=C2=A0=C2=A0=C2=A0jmpq=C2=A0=
=C2=A0=C2=A00xffffffff81495d90 <nft_rbtree_lookup+80>
=C2=A0=C2=A0=C2=A00xffffffff81495e26 <+230>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A0%r15,%rax
=C2=A0=C2=A0=C2=A00xffffffff81495e29 <+233>:=C2=A0=C2=A0=C2=A0movzbl (%=
rsp),%ecx
=C2=A0=C2=A0=C2=A00xffffffff81495e2d <+237>:=C2=A0=C2=A0=C2=A0test=C2=A0=
=C2=A0=C2=A0%cl,0x18(%rax)
=C2=A0=C2=A0=C2=A00xffffffff81495e30 <+240>:=C2=A0=C2=A0=C2=A0jne=C2=A0=
=C2=A0=C2=A0=C2=A00xffffffff81495de9 <nft_rbtree_lookup+169>
=C2=A0=C2=A0=C2=A00xffffffff81495e32 <+242>:=C2=A0=C2=A0=C2=A0movzbl 0x=
1b(%rax),%edx
=C2=A0=C2=A0=C2=A00xffffffff81495e36 <+246>:=C2=A0=C2=A0=C2=A0lea=C2=A0=
=C2=A0=C2=A0=C2=A00x18(%rax),%rbx
=C2=A0=C2=A0=C2=A00xffffffff81495e3a <+250>:=C2=A0=C2=A0=C2=A0test=C2=A0=
=C2=A0=C2=A0%dl,%dl
=C2=A0=C2=A0=C2=A00xffffffff81495e3c <+252>:=C2=A0=C2=A0=C2=A0je=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A00xffffffff81495e45 <nft_rbtree_lookup+261>
=C2=A0=C2=A0=C2=A00xffffffff81495e3e <+254>:=C2=A0=C2=A0=C2=A0testb=C2=A0=
=C2=A0$0x1,0x18(%rax,%rdx,1)
=C2=A0=C2=A0=C2=A00xffffffff81495e43 <+259>:=C2=A0=C2=A0=C2=A0jne=C2=A0=
=C2=A0=C2=A0=C2=A00xffffffff81495e6d <nft_rbtree_lookup+301>
=C2=A0=C2=A0=C2=A00xffffffff81495e45 <+261>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A0$0xffffffff81a7b6b0,%rdi
=C2=A0=C2=A0=C2=A00xffffffff81495e4c <+268>:=C2=A0=C2=A0=C2=A0callq=C2=A0=
=C2=A00xffffffff81537240 <_raw_spin_unlock_bh>
=C2=A0=C2=A0=C2=A00xffffffff81495e51 <+273>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A00x18(%rsp),%rax
=C2=A0=C2=A0=C2=A00xffffffff81495e56 <+278>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A0%rbx,(%rax)
=C2=A0=C2=A0=C2=A00xffffffff81495e59 <+281>:=C2=A0=C2=A0=C2=A0add=C2=A0=
=C2=A0=C2=A0=C2=A0$0x20,%rsp
=C2=A0=C2=A0=C2=A00xffffffff81495e5d <+285>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A0$0x1,%eax
=C2=A0=C2=A0=C2=A00xffffffff81495e62 <+290>:=C2=A0=C2=A0=C2=A0pop=C2=A0=
=C2=A0=C2=A0=C2=A0%rbx
=C2=A0=C2=A0=C2=A00xffffffff81495e63 <+291>:=C2=A0=C2=A0=C2=A0pop=C2=A0=
=C2=A0=C2=A0=C2=A0%rbp
=C2=A0=C2=A0=C2=A00xffffffff81495e64 <+292>:=C2=A0=C2=A0=C2=A0pop=C2=A0=
=C2=A0=C2=A0=C2=A0%r12
=C2=A0=C2=A0=C2=A00xffffffff81495e66 <+294>:=C2=A0=C2=A0=C2=A0pop=C2=A0=
=C2=A0=C2=A0=C2=A0%r13
=C2=A0=C2=A0=C2=A00xffffffff81495e68 <+296>:=C2=A0=C2=A0=C2=A0pop=C2=A0=
=C2=A0=C2=A0=C2=A0%r14
=C2=A0=C2=A0=C2=A00xffffffff81495e6a <+298>:=C2=A0=C2=A0=C2=A0pop=C2=A0=
=C2=A0=C2=A0=C2=A0%r15
=C2=A0=C2=A0=C2=A00xffffffff81495e6c <+300>:=C2=A0=C2=A0=C2=A0retq
=C2=A0=C2=A0=C2=A00xffffffff81495e6d <+301>:=C2=A0=C2=A0=C2=A0mov=C2=A0=
=C2=A0=C2=A0=C2=A0$0xffffffff81a7b6b0,%rdi
=C2=A0=C2=A0=C2=A00xffffffff81495e74 <+308>:=C2=A0=C2=A0=C2=A0callq=C2=A0=
=C2=A00xffffffff81537240 <_raw_spin_unlock_bh>
=C2=A0=C2=A0=C2=A00xffffffff81495e79 <+313>:=C2=A0=C2=A0=C2=A0add=C2=A0=
=C2=A0=C2=A0=C2=A0$0x20,%rsp
=C2=A0=C2=A0=C2=A00xffffffff81495e7d <+317>:=C2=A0=C2=A0=C2=A0xor=C2=A0=
=C2=A0=C2=A0=C2=A0%eax,%eax
=C2=A0=C2=A0=C2=A00xffffffff81495e7f <+319>:=C2=A0=C2=A0=C2=A0pop=C2=A0=
=C2=A0=C2=A0=C2=A0%rbx
=C2=A0=C2=A0=C2=A00xffffffff81495e80 <+320>:=C2=A0=C2=A0=C2=A0pop=C2=A0=
=C2=A0=C2=A0=C2=A0%rbp
=C2=A0=C2=A0=C2=A00xffffffff81495e81 <+321>:=C2=A0=C2=A0=C2=A0pop=C2=A0=
=C2=A0=C2=A0=C2=A0%r12
=C2=A0=C2=A0=C2=A00xffffffff81495e83 <+323>:=C2=A0=C2=A0=C2=A0pop=C2=A0=
=C2=A0=C2=A0=C2=A0%r13
=C2=A0=C2=A0=C2=A00xffffffff81495e85 <+325>:=C2=A0=C2=A0=C2=A0pop=C2=A0=
=C2=A0=C2=A0=C2=A0%r14
=C2=A0=C2=A0=C2=A00xffffffff81495e87 <+327>:=C2=A0=C2=A0=C2=A0pop=C2=A0=
=C2=A0=C2=A0=C2=A0%r15
=C2=A0=C2=A0=C2=A00xffffffff81495e89 <+329>:=C2=A0=C2=A0=C2=A0retq
End of assembler dump.

Regards,
Anders K. Pedersen
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
