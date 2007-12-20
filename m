From: Gregory Etelson <Gregory.Etelson@expand.com>
Subject: [patch] crash in do_bindings()
Date: Thu, 20 Dec 2007 09:14:19 +0200
Message-ID: <476A164B.5000602@expand.com>
Reply-To: kiragon@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-tlv.expand.com ([192.116.193.121]:24773 "EHLO
	smtp-tlv.expand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbXLTHcv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Dec 2007 02:32:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello All,

I've stumbled upon kernel crash in linux-2.4.33, do_bindings()=20
ip_nat_core.c:811 during heavy FTP traffic.
Kernel crashes on attempt to access struct ip_conntrack siblings_list=20
member.
The crash is consistent.
Enabling CONFIG_DEBUG_SLAB shows that struct ip_conntrack_expect pointe=
d
by siblings_list was freed - see dump of 0x482bede0, while siblings_lis=
t=20
points at 0x482bedf8.

This patch solved the crash:

Index: net/ipv4/netfilter/ip_conntrack_core.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: /work/cvsroot/xsl/kernel/2.4.33/linux/net/ipv4/netfilter/ip_c=
onntrack_core.c,v
retrieving revision 1.3.26.3
diff -u -p -r1.3.26.3 ip_conntrack_core.c
--- net/ipv4/netfilter/ip_conntrack_core.c	25 Oct 2007 09:00:52 -0000	1=
=2E3.26.3
+++ net/ipv4/netfilter/ip_conntrack_core.c	20 Dec 2007 06:35:30 -0000
@@ -279,16 +279,9 @@ static void remove_expectations(struct i
 		exp =3D list_entry(exp_entry, struct ip_conntrack_expect,
 				 expected_list);
=20
-		/* we skip established expectations, as we want to delete
-		 * the un-established ones only */
 		if (exp->sibling) {
-			DEBUGP("remove_expectations: skipping established %p of %p\n", exp-=
>sibling, ct);
-			if (drop_refcount) {
-				/* Indicate that this expectations parent is dead */
-				ip_conntrack_put(exp->expectant);
-				exp->expectant =3D NULL;
-			}
-			continue;
+			ip_conntrack_put(exp->sibling);
+			exp->sibling =3D NULL;
 		}
=20
 		IP_NF_ASSERT(list_inlist(&ip_conntrack_expect_list, exp));
@@ -311,9 +304,6 @@ clean_from_lists(struct ip_conntrack *ct
 	hr =3D hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 	LIST_DELETE(&ip_conntrack_hash[ho], &ct->tuplehash[IP_CT_DIR_ORIGINAL=
]);
 	LIST_DELETE(&ip_conntrack_hash[hr], &ct->tuplehash[IP_CT_DIR_REPLY]);
-
-	/* Destroy all un-established, pending expectations */
-	remove_expectations(ct, 1);
 }
=20
 static void
@@ -338,8 +328,7 @@ destroy_conntrack(struct nf_conntrack *n
=20
 	WRITE_LOCK(&ip_conntrack_lock);
 	/* Make sure don't leave any orphaned expectations lying around */
-	if (ct->expecting)
-		remove_expectations(ct, 1);
+	remove_expectations(ct, 1);
=20
 	/* We overload first tuple to link into unconfirmed list. */
 	if (!is_confirmed(ct)) {
@@ -389,8 +378,7 @@ __destroy_conntrack(struct nf_conntrack=20
 		ip_conntrack_destroyed(ct);
=20
 	/* Make sure don't leave any orphaned expectations lying around */
-	if (ct->expecting)
-		remove_expectations(ct, 1);
+	remove_expectations(ct, 1);
=20
 	/* Delete our master expectation */
 	if (ct->master) {
@@ -767,7 +755,11 @@ init_conntrack(const struct ip_conntrack
 		/* Try dropping from random chain, or else from the
                    chain about to put into (in case they're trying to
                    bomb one hash chain). */
-		unsigned int next =3D (drop_next++)%ip_conntrack_htable_size;
+		unsigned int next;
+
+		do {
+			next =3D (drop_next++)%ip_conntrack_htable_size;
+		} while (next =3D=3D hash);
=20
 		if (!early_drop(&ip_conntrack_hash[next])
 		    && !early_drop(&ip_conntrack_hash[hash])) {

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

kdb dump:

Unable to handle kernel paging request at virtual address 5a5a5a5e
*pde =3D 00000000
Oops: 0000
ipt_mark iptable_tproxy iptable_filter iptable_mangle ebt_vlan_arpreply=
 ebt_vlan_arp ebt_redirect_expand ebtable_nat ebtable_filter ebtable_br=
oute ebt_vlan ebt_stp ebt_snat_arp_vlan ebt_snat_arp ebt_snat ebt_redir=
ect ebt_pkttype ebt_mark_m ebt_mark ebt_log ebt_limit ebt_ip ebt_dnat e=
bt_arpreply ebt_arp ebt_among ebt_802_3 ebtables bridge ip_nat_ftp ip_c=
onntrack_ftp iptable_nat ip_tables ip_conntrack bcm5700 raid1 md lvm-mo=
d
CPU:    0
EIP:    0010:[<50a18680>]    Tainted: P
EFLAGS: 00010206
EIP is at do_bindings+0x150/0x400 [iptable_nat]
eax: 5a5a5a5a   ebx: 5a5a5a5a   ecx: 5a5a5a5a   edx: 00000002
esi: 482bedec   edi: 4805be58   ebp: 4805bd44   esp: 4805bd00
ds: 0018   es: 0018   ss: 0018
Process lcdctl (pid: 1888, stackpage=3D4805b000)
Stack: 50c4f2be 486a61f4 4e87d084 50c500cb 4e931800 50ca8170 4705f808 4=
805a000
       00000000 00000001 00000000 00000001 00000000 50aabbe0 4705f7b0 0=
0000001
       4805be58 4805bd78 50a160f0 4705f7b0 00000000 4705f84c 00000000 4=
805be58
Call Trace:
 [<508baf63>] MM_IndicateRxPackets+0x327/0x3d8 [bcm5700]
 [<402683d5>] netif_rx+0x95/0x1e0 [kernel]
 [<402683d5>] netif_rx+0x95/0x1e0 [kernel]
 [<508baf63>] MM_IndicateRxPackets+0x327/0x3d8 [bcm5700]
 [<402683d5>] netif_rx+0x95/0x1e0 [kernel]
 [<402683d5>] netif_rx+0x95/0x1e0 [kernel]
 [<508c2359>] LM_ServiceInterrupts+0x89/0x114 [bcm5700]
 [<508baf63>] MM_IndicateRxPackets+0x327/0x3d8 [bcm5700]
 [<508baf63>] MM_IndicateRxPackets+0x327/0x3d8 [bcm5700]
 [<508c2369>] LM_ServiceInterrupts+0x99/0x114 [bcm5700]
 [<508c2369>] LM_ServiceInterrupts+0x99/0x114 [bcm5700]
 [<508b6928>] bcm5700_interrupt+0x164/0x478 [bcm5700]
 [<508b6928>] bcm5700_interrupt+0x164/0x478 [bcm5700]
 [<4010b09b>] handle_IRQ_event+0x6b/0xa0 [kernel]
 [<4010b387>] do_IRQ+0xf7/0x120 [kernel]
 [<402683d5>] netif_rx+0x95/0x1e0 [kernel]
 [<508baf63>] MM_IndicateRxPackets+0x327/0x3d8 [bcm5700]
 [<508c2359>] LM_ServiceInterrupts+0x89/0x114 [bcm5700]
 [<402683d5>] netif_rx+0x95/0x1e0 [kernel]
 [<402683d5>] netif_rx+0x95/0x1e0 [kernel]
 [<508baf63>] MM_IndicateRxPackets+0x327/0x3d8 [bcm5700]
 [<402683d5>] netif_rx+0x95/0x1e0 [kernel]
 [<508baf63>] MM_IndicateRxPackets+0x327/0x3d8 [bcm5700]
 [<402683d5>] netif_rx+0x95/0x1e0 [kernel]
 [<40263b5c>] skb_release_data+0x6c/0x80 [kernel]
 [<40263b5c>] skb_release_data+0x6c/0x80 [kernel]
 [<40263d0f>] __kfree_skb+0x11f/0x190 [kernel]
 [<40284f99>] ip_fragment+0x3c9/0x450 [kernel]
 [<50c4ff00>] br_dev_queue_push_xmit+0x0/0x100 [bridge]
 [<50a03571>] ip_refrag+0x71/0x80 [ip_conntrack]
 [<50c4ff00>] br_dev_queue_push_xmit+0x0/0x100 [bridge]
 [<50c4ff00>] br_dev_queue_push_xmit+0x0/0x100 [bridge]
 [<40272132>] nf_iterate+0x52/0x80 [kernel]
 [<50c4ff00>] br_dev_queue_push_xmit+0x0/0x100 [bridge]
 [<4027253d>] nf_hook_slow+0xcd/0x220 [kernel]
 [<50c4ff00>] br_dev_queue_push_xmit+0x0/0x100 [bridge]
 [<50a0a090>] ip_conntrack_out_ops+0x0/0x18 [ip_conntrack]
 [<50c54c85>] br_nf_post_routing+0x115/0x1c0 [bridge]
 [<50c4ff00>] br_dev_queue_push_xmit+0x0/0x100 [bridge]
 [<40272132>] nf_iterate+0x52/0x80 [kernel]
 [<50c4ff00>] br_dev_queue_push_xmit+0x0/0x100 [bridge]
 [<50caa8c0>] packet_filter+0x0/0x40 [iptable_filter]
 [<4027253d>] nf_hook_slow+0xcd/0x220 [kernel]
 [<50c4ff00>] br_dev_queue_push_xmit+0x0/0x100 [bridge]
 [<4027253d>] nf_hook_slow+0xcd/0x220 [kernel]
 [<50c56e60>] br_nf_ops+0x60/0x140 [bridge]
 [<50c5004f>] br_forward_finish+0x4f/0x70 [bridge]
 [<50c4ff00>] br_dev_queue_push_xmit+0x0/0x100 [bridge]
 [<50c54ab9>] br_nf_local_out+0x1c9/0x280 [bridge]
 [<50c50000>] br_forward_finish+0x0/0x70 [bridge]
 [<40272132>] nf_iterate+0x52/0x80 [kernel]
 [<50c50000>] br_forward_finish+0x0/0x70 [bridge]
 [<50c54ab9>] br_nf_local_out+0x1c9/0x280 [bridge]
 [<50c50000>] br_forward_finish+0x0/0x70 [bridge]
 [<40247bd0>] vgacon_cursor+0x130/0x1e0 [kernel]
 [<401dc993>] set_cursor+0x73/0x90 [kernel]
 [<401e0098>] vt_console_print+0x238/0x350 [kernel]
 [<401e77d2>] serial_console_write+0x172/0x210 [kernel]
 [<4011b3fc>] __call_console_drivers+0x4c/0x70 [kernel]
 [<4011b4ac>] _call_console_drivers+0x8c/0x90 [kernel]
 [<4011b50b>] call_console_drivers+0x5b/0x130 [kernel]
 [<4011b7ba>] printk+0x16a/0x180 [kernel]
 [<4011e10a>] print_symbol+0xea/0x15d [kernel]
 [<402d4266>] E kdba_dumpregs+0x4b16/0xffef6720
 [<402cf750>] kdba_dumpregs+0x0/0x1c0 [kernel]
 [<402cf910>] kdba_getpc+0x0/0x20 [kernel]
 [<402cf910>] kdba_getpc+0x0/0x20 [kernel]
 [<4010953a>] show_trace+0x7a/0xf0 [kernel]
 [<4010953a>] show_trace+0x7a/0xf0 [kernel]
 [<40109662>] show_stack+0x82/0xa0 [kernel]
 [<50a18930>] icmp_reply_translation+0x0/0x330 [iptable_nat]
 [<401097ea>] show_registers+0x14a/0x1b0 [kernel]
 [<40109962>] die+0x72/0xb0 [kernel]
 [<40116c86>] do_page_fault+0x536/0x589 [kernel]
 [<50c5004f>] br_forward_finish+0x4f/0x70 [bridge]
 [<50c4ff00>] br_dev_queue_push_xmit+0x0/0x100 [bridge]
 [<50c54ab9>] br_nf_local_out+0x1c9/0x280 [bridge]
 [<50c50000>] br_forward_finish+0x0/0x70 [bridge]
 [<40272132>] nf_iterate+0x52/0x80 [kernel]
 [<50c50000>] br_forward_finish+0x0/0x70 [bridge]
 [<4027253d>] nf_hook_slow+0xcd/0x220 [kernel]
 [<50c50000>] br_forward_finish+0x0/0x70 [bridge]
 [<40116750>] do_page_fault+0x0/0x589 [kernel]
 [<40109354>] error_code+0x34/0x3c [kernel]
 [<50a18680>] do_bindings+0x150/0x400 [iptable_nat]
 [<50c4f2be>] __br_dev_xmit+0x7e/0xc0 [bridge]
 [<50c500cb>] __br_deliver+0x5b/0x70 [bridge]
 [<50aabbe0>] ftp+0x0/0x1e0 [ip_nat_ftp]
 [<50a160f0>] ip_nat_fn+0x90/0x290 [iptable_nat]
 [<50a16331>] ip_nat_in+0x41/0x80 [iptable_nat]
 [<40280440>] ip_rcv_finish+0x0/0x2d5 [kernel]
 [<40272132>] nf_iterate+0x52/0x80 [kernel]
 [<40280440>] ip_rcv_finish+0x0/0x2d5 [kernel]
 [<4027253d>] nf_hook_slow+0xcd/0x220 [kernel]
 [<40280440>] ip_rcv_finish+0x0/0x2d5 [kernel]
 [<50a1c5e0>] ip_nat_in_ops+0x0/0x18 [iptable_nat]
 [<40280440>] ip_rcv_finish+0x0/0x2d5 [kernel]
 [<402803a2>] ip_rcv+0x472/0x510 [kernel]
 [<40280440>] ip_rcv_finish+0x0/0x2d5 [kernel]
 [<40268931>] netif_receive_skb+0x1f1/0x240 [kernel]
 [<40268a24>] process_backlog+0xa4/0x140 [kernel]
 [<40268b95>] net_rx_action+0xd5/0x180 [kernel]
 [<4012043a>] do_softirq+0xaa/0x150 [kernel]
 [<4025fbeb>] sock_map_fd+0x10b/0x1d0 [kernel]
 [<40261c64>] .text.lock.socket+0x80/0xbc [kernel]
 [<40260467>] sock_close+0x27/0x60 [kernel]
 [<4026039d>] sock_ioctl+0x3d/0x80 [kernel]
 [<4014530d>] fput+0x12d/0x140 [kernel]
 [<40143b4f>] filp_close+0x8f/0xe0 [kernel]
 [<40143c02>] sys_close+0x62/0x90 [kernel]
 [<40109263>] system_call+0x33/0x38 [kernel]

Code: 8b 40 04 0f 18 00 3b 5d d4 75 e5 8b 7d dc 85 ff 75 0d 8b 4d

Entering kdb (current=3D0x4805a000, pid 1888) on processor 0 Oops: Oops
due to oops @ 0x50a18680
eax =3D 0x5a5a5a5a ebx =3D 0x5a5a5a5a ecx =3D 0x5a5a5a5a edx =3D 0x0000=
0002
esi =3D 0x482bedec edi =3D 0x4805be58 esp =3D 0x4805bd00 eip =3D 0x50a1=
8680
ebp =3D 0x4805bd44 xss =3D 0x402c0018 xcs =3D 0x00000010 eflags =3D 0x0=
0010206
xds =3D 0x00000018 xes =3D 0x00000018 origeax =3D 0xffffffff &regs =3D =
0x4805bccc
[0]kdb> bt
Stack traceback for pid 1888
0x4805a000     1888     1887  1    0   R  0x4805a370 *lcdctl
EBP        EIP        Function (args)
0x4805bd44 0x50a18680 [iptable_nat]do_bindings+0x150 (0x4705f7b0, 0x0, =
0x4705f84c, 0x0, 0x4805be58)
                               iptable_nat .text 0x50a16060 0x50a18530 =
0x50a18930
0x4805bd78 0x50a160f0 [iptable_nat]ip_nat_fn+0x90 (0x0, 0x4805be58, 0x5=
0c285a0, 0x0, 0x40280440)
                               iptable_nat .text 0x50a16060 0x50a16060 =
0x50a162f0
0x4805bda0 0x50a16331 [iptable_nat]ip_nat_in+0x41 (0x0, 0x4805be58, 0x5=
0c285a0, 0x0, 0x40280440)
                               iptable_nat .text 0x50a16060 0x50a162f0 =
0x50a16370
0x4805bdd0 0x40272132 nf_iterate+0x52 (0x40517a40, 0x4805be58, 0x0, 0x5=
0c285a0, 0x0)
                               kernel .text 0x40100000 0x402720e0 0x402=
72160
0x4805be10 0x4027253d nf_hook_slow+0xcd (0x2, 0x0, 0x4805be58, 0x50c285=
a0, 0x0)
                               kernel .text 0x40100000 0x40272470 0x402=
72690
0x4805be50 0x402803a2 ip_rcv+0x472 (0x47ed9a44, 0x50c285a0, 0x403d5364,=
 0x50c285a0, 0x4043de2c)
                               kernel .text 0x40100000 0x4027ff30 0x402=
80440
0x4805be70 0x40268931 netif_receive_skb+0x1f1 (0x47ed9a44, 0x558, 0x206=
, 0x0, 0x63e3)
                               kernel .text 0x40100000 0x40268740 0x402=
68980
0x4805bea0 0x40268a24 process_backlog+0xa4 (0x4043de4c, 0x4805bec0, 0x4=
805bed0, 0x63e2, 0x4043de20)
                               kernel .text 0x40100000 0x40268980 0x402=
68ac0
0x4805bed0 0x40268b95 net_rx_action+0xd5 (0x4043d8f0, 0x4805bf4c, 0x402=
5fbeb, 0x5, 0x246)
                               kernel .text 0x40100000 0x40268ac0 0x402=
68c40
0x4805bf00 0x4012043a do_softirq+0xaa (0x0, 0x40467e68, 0x0, 0x4ffb7708=
, 0x4fa24040)
[0]more>
                               kernel .text 0x40100000 0x40120390 0x401=
204e0
           0x40261c64 .text.lock.socket+0x80
                               kernel .text 0x40100000 0x40261be4 0x402=
61ca0
0x4805bf3c 0x40260660 sock_fasync+0x1c0 (0xffffffff, 0x47856790)
                               kernel .text 0x40100000 0x402604a0 0x402=
607e0
0x4805bf5c 0x40260467 sock_close+0x27 (0x47856790, 0x47856790)
                               kernel .text 0x40100000 0x40260440 0x402=
604a0
           0x4026039d sock_ioctl+0x3d (0x48f6b41c, 0x47856790, 0x4fa248=
24, 0x47856790, 0x3f7ffbe0)
                               kernel .text 0x40100000 0x40260360 0x402=
603e0
0x4805bf7c 0x4014530d fput+0x12d (0x47856790, 0x48e9d0a4, 0x0, 0x478567=
90, 0x3f7ffbe0)
                               kernel .text 0x40100000 0x401451e0 0x401=
45320
0x4805bf9c 0x40143b4f filp_close+0x8f (0x47856790, 0x48e9d0a4, 0x4043cc=
c0, 0x4805a000, 0x3f7ffbe0)
                               kernel .text 0x40100000 0x40143ac0 0x401=
43ba0
0x4805bfbc 0x40143c02 sys_close+0x62 (0x5, 0x155b5bd8, 0x155b5bd8, 0x3f=
7ffbe0, 0x0)
                               kernel .text 0x40100000 0x40143ba0 0x401=
43c30
           0x40109263 system_call+0x33
                               kernel .text 0x40100000 0x40109230 0x401=
09268
[0]kdb>
[0]kdb> md 0x4705f7b0	; ip_conntrack
0x4705f7b0 00000001 50a03f00 00000000 00000000   ....P=EF=BF=BD?.......=
=2E.
0x4705f7c0 155a650a 4ee47020 145c650a 00061500   .Ze.N=EF=BF=BDp .\e...=
=2E.
0x4705f7d0 4705f7b0 00000000 00000000 145c650a   G.=EF=BF=BD=EF=BF=BD..=
=2E......\e.
0x4705f7e0 50cb1500 155a650a 00067020 4705f7b0   P=EF=BF=BD...Ze...p G.
0x4705f7f0 0000008e 00000000 00000000 000092c0   ...............=EF=BF=BD
0x4705f800 4705f7b0 50a04180 482bedf8 482bedf8   G.=EF=BF=BD=EF=BF=BDP=EF=
=BF=BDA.H+=EF=BF=BD=EF=BF=BDH+=EF=BF=BD=EF=BF=BD
0x4705f810 00000000 00000000 50bda080 4705f7b0   ........P=EF=BF=BD=EF=BF=
=BD.G.=EF=BF=BD=EF=BF=BD
0x4705f820 4705f7b0 4705f7b0 4705f7b0 4705f7b0   G.=EF=BF=BD=EF=BF=BDG.=
=EF=BF=BD=EF=BF=BDG.=EF=BF=BD=EF=BF=BDG.=EF=BF=BD=EF=BF=BD
[0]kdb>
0x4705f830 00000005 4a5b6d2c 2eff81ff 2c6d5c34   ....J[m,.=EF=BF=BD.=EF=
=BF=BD,m\4
0x4705f840 00000001 00000001 00000000 00000003   ................
0x4705f850 00000000 00000000 00000000 00000000   ................
0x4705f860 00000000 00000000 00000000 00000000   ................
0x4705f870 00000000 00000000 00000000 00000000   ................
0x4705f880 00000000 00000000 00000000 00000000   ................
0x4705f890 00000000 00000000 00000000 47107dec   ............G.}=EF=BF=BD
0x4705f8a0 4754b720 4705f7b0 4753b2d8 4791a454   GT=EF=BF=BD G.=EF=BF=BD=
=EF=BF=BDGS=EF=BF=BD=EF=BF=BDG.=EF=BF=BDT
[0]kdb>
0x4705f8b0 4705f7b0 50aabbe0 00000000 00000000   G.=EF=BF=BD=EF=BF=BDP=EF=
=BF=BD=EF=BF=BD=EF=BF=BD........
0x4705f8c0 00000000 00000000 00000000 00000000   ................
0x4705f8d0 00000000 00000000 00000000 471d330c   ............G.3.
0x4705f8e0 4722ba74 4705f7b0 00000000 00000000   G"=EF=BF=BDtG.=EF=BF=BD=
=EF=BF=BD........
0x4705f8f0 00000000 00000000 00000000 00000000   ................
0x4705f900 00000000 170fc2a5 170fc2a5 00000001   ......=C2=A5..=C2=A5..=
=2E.
0x4705f910 50a03f00 47924ce8 476aa8f0 155c650a   P=EF=BF=BD?.G.L=EF=BF=BD=
Gj=EF=BF=BD=EF=BF=BD.\e.
0x4705f920 28001400 2c5a650a 0006cef9 4705f90c   (...,Ze...=EF=BF=BD=EF=
=BF=BDG.=EF=BF=BD.
[0]kdb>
0x4705f930 4714b4c0 470b2b8c 2c5a650a 06bfcef9   G.=EF=BF=BD=EF=BF=BDG.=
+.,Ze..=EF=BF=BD=EF=BF=BD=EF=BF=BD
0x4705f940 155c650a 00061400 4705f90c 0000008f   .\e.....G.=EF=BF=BD...=
=2E.
0x4705f960 50a04180 4705f964 4705f964 00000000   P=EF=BF=BDA.G.=EF=BF=BD=
dG.=EF=BF=BDd....
0x4705f970 470591f4 00000000 4705f90c 4705f90c   G..=EF=BF=BD....G.=EF=BF=
=BD.G.=EF=BF=BD.
0x4705f980 4705f90c 4705f90c 4705f90c 00000001   G.=EF=BF=BD.G.=EF=BF=BD=
=2EG.=EF=BF=BD.....
0x4705f990 c9bf232e 00000000 00000000 00000000   =C9=BF#.............
0x4705f9a0 00000000 00000000 00000003 00000000   ................
[0]kdb> md 0x482bede0 ;ip_conntrack_expect starts at 0x482bede8
0x482bede0 a55a5a5a 170fc2a5 5a2cf071 5a5a5a5a   =EF=BF=BDZZZ..=C2=A5Z,=
=EF=BF=BDqZZZZ
0x482bedf0 5a5a5a5a 5a5a5a5a 5a5a5a5a 5a5a5a5a   ZZZZZZZZZZZZZZZZ
0x482bee00 5a5a5a5a 5a5a5a5a 5a5a5a5a 5a5a5a5a   ZZZZZZZZZZZZZZZZ
0x482bee10 5a5a5a5a 5a5a5a5a 5a5a5a5a 5a5a5a5a   ZZZZZZZZZZZZZZZZ
0x482bee20 5a5a5a5a 5a5a5a5a 5a5a5a5a 5a5a5a5a   ZZZZZZZZZZZZZZZZ
0x482bee30 5a5a5a5a 5a5a5a5a 5a5a5a5a 5a5a5a5a   ZZZZZZZZZZZZZZZZ
0x482bee40 5a5a5a5a 5a5a5a5a 5a5a5a5a 5a5a5a5a   ZZZZZZZZZZZZZZZZ
0x482bee50 5a5a5a5a 5a5a5a5a 5a5a5a5a 5a5a5a5a   ZZZZZZZZZZZZZZZZ
[0]kdb>
0x482bee60 5a5a5a5a 5a5a5a5a a55a5a5a 5a2cf071   ZZZZZZZZ=EF=BF=BDZZZZ,=
=EF=BF=BDq
0x482bee70 170fc2a5 00000001 00000002 46f0267c   ..=C2=A5........F=EF=BF=
=BD&|
0x482bee80 46fd6e3c 00003f72 00020001 0000000c   F=EF=BF=BDn<..?r......=
=2E.
0x482bee90 00000374 0000000c 00000374 0000000c   ...t.......t....
0x482beea0 00000448 00000000 0000000c 000003d9   ...H...........=EF=BF=BD
0x482beeb0 0000000c 000003d9 0000000c 000004cd   .......=EF=BF=BD......=
=2E=EF=BF=BD
0x482beec0 00000000 00000000 00000000 00000000   ................
0x482beed0 00000000 00000000 00000000 00000000   ................
[0]kdb>
0x482beee0 00000000 5a5a5a5a 5a5a5a5a 5a5a5a5a   ....ZZZZZZZZZZZZ
0x482beef0 a55a5a5a 170fc2a5 170fc2a5 00000000   =EF=BF=BDZZZ..=C2=A5..=
=C2=A5....
0x482bef00 00000000 00000001 46fc5a60 46fc5a60   ........F=EF=BF=BDZ`F=EF=
=BF=BDZ`
0x482bef10 46fc5a08 471cfe3c 155c650a 00000000   F=EF=BF=BDZ.G.=EF=BF=BD=
<.\e.....
0x482bef20 145a650a 0006dcb2 00000000 00000000   .Ze...........
0x482bef30 00000000 00000000 00000000 482bef3c   ............H+=EF=BF=BD=
<
0x482bef40 482bef3c 155c650a ffff0000 145a650a   H+=EF=BF=BD<.\e.=EF=BF=
=BD=EF=BF=BD...Ze.
0x482bef50 0006dcb2 ffffffff 00000000 ffffffff   ..=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD....=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
[0]kdb>


-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
