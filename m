From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables RFH PATCH] netfilter: nf_tables: add set_elem notifications
Date: Wed, 19 Mar 2014 17:05:12 +0100
Message-ID: <20140319160352.2849.30373.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:45722 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965600AbaCSQFX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:05:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds set_elems notifications.

When a set_elem is added/deleted, all listening peers in userspace will
receive the corresponding notification.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
RFH: I'm requesting for a bit of help.
Could anyone give me a few hints about what may be wrong?

When adding a rule with an anonymous set with some elements, I keep having this:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff812cb20d>] __skb_recv_datagram+0x126/0x3c1
PGD 3694a067 PUD 3714f067 PMD 0 
Oops: 0002 [#1] SMP 
Modules linked in: nf_conntrack_netlink nf_conntrack loop snd_pcm snd_timer snd soundcore microcode psmouse parport_pc evdev parport pcspkr virtio_balloon serio_raw i2c_piix4 i2c_core processor button thermal_sys ext4 crc16 jbd2 mbcache sg sr_mod cdrom ata_generic floppy virtio_blk virtio_net ata_piix uhci_hcd ehci_hcd libata usbcore virtio_pci usb_common virtio_ring virtio scsi_mod
CPU: 0 PID: 2782 Comm: lt-nft-events Not tainted 3.13.0+ #57
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
task: ffff8800373d8210 ti: ffff88003a4ac000 task.ti: ffff88003a4ac000
RIP: 0010:[<ffffffff812cb20d>]  [<ffffffff812cb20d>] __skb_recv_datagram+0x126/0x3c1
RSP: 0018:ffff88003a4adb58  EFLAGS: 00010046
RAX: ffff88003a87f090 RBX: 7fffffffffffffff RCX: 0000000000000000
RDX: ffff88003a87f0a4 RSI: 0000000000000246 RDI: ffff88003a4adc20
RBP: ffff88003a87f090 R08: ffff88003a4adc48 R09: 00007f066a578700
R10: 0000000000000000 R11: 0000000000001000 R12: ffff88003a4adc48
R13: ffff88003a87f000 R14: ffff8800371b4940 R15: 0000000000000000
FS:  00007f066a578700(0000) GS:ffff88003ce00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 00000000369ae000 CR4: 00000000000006f0
Stack:
 ffff88003a87f0a4 0000000000000000 ffff88003d0fbb08 ffff88003a87f090
 ffff88003a4adc24 ffff88003a4adfd8 ffff8800373d8210 ffff88003a4adc20
 ffff88003a4adfd8 ffff8800373d8210 0000000000000044 0000000000000000
Call Trace:
 [<ffffffff812cb4d4>] ? skb_recv_datagram+0x2c/0x31
 [<ffffffff812f4845>] ? netlink_recvmsg+0x47/0x2dd
 [<ffffffff8105b8b1>] ? resched_task+0x15/0x4b
 [<ffffffff81062073>] ? check_preempt_wakeup+0x125/0x18b
 [<ffffffff812c01e8>] ? sock_recvmsg+0x54/0x71
 [<ffffffff8104cc77>] ? __queue_work+0x1ef/0x23d
 [<ffffffff812c0e26>] ? ___sys_recvmsg+0x14a/0x1fc
 [<ffffffff810676d9>] ? __wake_up+0x35/0x46
 [<ffffffff8113c30e>] ? fsnotify+0x216/0x252
 [<ffffffff81060bb8>] ? __dequeue_entity+0x19/0x2d
 [<ffffffff810015dc>] ? __switch_to+0x1b1/0x3e0
 [<ffffffff8105ae8d>] ? finish_task_switch+0x44/0xbd
 [<ffffffff812c135f>] ? __sys_recvmsg+0x39/0x57
 [<ffffffff813ab2a2>] ? system_call_fastpath+0x16/0x1b
Code: 80 4e 7d 40 f0 41 ff 86 e4 00 00 00 eb 24 41 ff 8d a0 00 00 00 49 8b 0e 49 8b 46 08 49 c7 06 00 00 00 00 49 c7 46 08 00 00 00 00 <48> 89 41 08 48 89 08 48 89 d7 e8 30 af 0d 00 48 8b 4c 24 20 44 
RIP  [<ffffffff812cb20d>] __skb_recv_datagram+0x126/0x3c1
RSP <ffff88003a4adb58>
CR2: 0000000000000008
---[ end trace 4dbd24a21c60d72b ]---

 net/netfilter/nf_tables_api.c |   68 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index adce01e..33b1585 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2712,6 +2712,71 @@ static int nf_tables_getsetelem(struct sock *nlsk, struct sk_buff *skb,
 	return -EOPNOTSUPP;
 }
 
+static int nf_tables_setelem_notify(const struct nft_ctx *ctx,
+				    const struct nft_set *set,
+				    const struct nft_set_elem *elem,
+				    int event, u16 flags)
+{
+	const struct sk_buff *oskb = ctx->skb;
+	struct sk_buff *skb;
+	struct net *net;
+	struct nfgenmsg *nfmsg;
+	struct nlmsghdr *nlh;
+	struct nlattr *nest;
+	bool report;
+	u32 portid;
+	u32 seq = ctx->nlh->nlmsg_seq;
+	int err;
+
+	portid = oskb ? NETLINK_CB(oskb).portid : 0;
+	net = oskb ? sock_net(oskb->sk) : &init_net;
+
+	report = ctx->nlh ? nlmsg_report(ctx->nlh) : false;
+	if (!report && !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
+		return 0;
+
+	err = -ENOBUFS;
+	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (skb == NULL)
+		goto err;
+
+	event |= NFNL_SUBSYS_NFTABLES << 8;
+	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
+			flags);
+	if (nlh == NULL)
+		goto err_free;
+
+	nfmsg = nlmsg_data(nlh);
+	nfmsg->nfgen_family	= ctx->afi->family;
+	nfmsg->version		= NFNETLINK_V0;
+	nfmsg->res_id		= 0;
+
+	if (nla_put_string(skb, NFTA_SET_TABLE, ctx->table->name))
+		goto err_free;
+	if (nla_put_string(skb, NFTA_SET_NAME, set->name))
+		goto err_free;
+
+	nest = nla_nest_start(skb, NFTA_SET_ELEM_LIST_ELEMENTS);
+	if (nest == NULL)
+		goto err_free;
+
+	err = nf_tables_fill_setelem(skb, set, elem);
+	if (err < 0)
+		goto err_free;
+
+	nla_nest_end(skb, nest);
+	nlmsg_end(skb, nlh);
+
+	err = nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report,
+			     GFP_KERNEL);
+err_free:
+	kfree_skb(skb);
+err:
+	if (err < 0)
+		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
+	return err;
+}
+
 static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr)
 {
@@ -2788,6 +2853,7 @@ static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		goto err3;
 
+	nf_tables_setelem_notify(ctx, set, &elem, NFT_MSG_NEWSETELEM, 0);
 	return 0;
 
 err3:
@@ -2857,6 +2923,8 @@ static int nft_del_setelem(const struct nft_ctx *ctx, struct nft_set *set,
 
 	set->ops->remove(set, &elem);
 
+	nf_tables_setelem_notify(ctx, set, &elem, NFT_MSG_DELSETELEM, 0);
+
 	nft_data_uninit(&elem.key, NFT_DATA_VALUE);
 	if (set->flags & NFT_SET_MAP)
 		nft_data_uninit(&elem.data, set->dtype);

