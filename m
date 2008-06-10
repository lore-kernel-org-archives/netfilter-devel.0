From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrackd causes kernel panic
Date: Tue, 10 Jun 2008 16:29:28 +0200
Message-ID: <484E8FC8.4000402@trash.net>
References: <200806101343.12607.sabelka@iue.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030704060404060109060208"
Cc: netfilter-devel@vger.kernel.org
To: Rainer Sabelka <sabelka@iue.tuwien.ac.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42046 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776AbYFJO3h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:29:37 -0400
In-Reply-To: <200806101343.12607.sabelka@iue.tuwien.ac.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030704060404060109060208
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Rainer Sabelka wrote:
>
>  fw1b kernel: [ 6714.379206] ------------[ cut here ]------------
>  fw1b kernel: [ 6714.381285] invalid opcode: 0000 [#1] SMP
>  fw1b kernel: [ 6714.388793] Process kjournald (pid: 2267, ti=c79ac000 
> task=c5121140 task.ti=c79ac000)
>  fw1b kernel: [ 6714.388824] Stack: c5c40a80 00000000 c5c40a80 00000000 
> c1422000 c5121140 c50e0000 00000002
>  fw1b kernel: [ 6714.389418]        c79adf84 c79adf7c 00000000 c04980e0 
> c049b480 c049b480 c049b480 c79adf88
>  fw1b kernel: [ 6714.390152]        00000286 c013b547 c79882ec ffffffff 
> c79882ec 00000286 c013b5c5 00000286
>  fw1b kernel: [ 6714.391701] Call Trace:
>  fw1b kernel: [ 6714.392871]  [<c013b547>] lock_timer_base+0x27/0x60
>  fw1b kernel: [ 6714.393652]  [<c013b5c5>] try_to_del_timer_sync+0x45/0x50
>  fw1b kernel: [ 6714.394210]  [<c8ace740>] kjournald+0xa0/0x200 [jbd]
>  fw1b kernel: [ 6714.394780]  [<c0145fc0>] autoremove_wake_function+0x0/0x40
>  fw1b kernel: [ 6714.395354]  [<c8ace6a0>] kjournald+0x0/0x200 [jbd]
>  fw1b kernel: [ 6714.395907]  [<c0145d02>] kthread+0x42/0x70
>  fw1b kernel: [ 6714.396440]  [<c0145cc0>] kthread+0x0/0x70
>  fw1b kernel: [ 6714.396994]  [<c010900b>] kernel_thread_helper+0x7/0x10
>  fw1b kernel: [ 6714.397580]  =======================
>  fw1b kernel: [ 6714.398150] Code: ff f3 90 8b 03 a9 00 00 20 00 0f 84 1f f5 
> ff ff eb ef 0f 0b eb fe f3 90 8b 03 a9 00 00 20 00 0f 84 af f3 ff ff eb ef 0f 
> 0b eb fe <0f> 0b eb fe 0f 0b eb fe 56 53 89 d3 8d 34 90 eb 16 8d b4 26 00
>  fw1b kernel: [ 6714.399468] EIP: [<c8acb958>] 
> journal_commit_transaction+0xd88/0xd90 [jbd] SS:ESP 0068:c79adf2c
>
> At first glance this oops seems to unrelated because it happens within 
> kjournald. But is triggered by the conntrackd -c command, so I suspect 
> (rather naively) that conntrackd calls some kernel function which mixes up 
> some kenel memory (stack?) causing a crash later on.
>
> Does anybody have a hint what could be wrong with my setup?

Do these two patches help?


--------------030704060404060109060208
Content-Type: text/x-diff;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

netfilter: nf_conntrack: fix ctnetlink related crash in nf_nat_setup_info()

When creation of a new conntrack entry in ctnetlink fails after having
set up the NAT mappings, the conntrack has an extension area allocated
that is not getting properly destroyed when freeing the conntrack again.
This means the NAT extension is still in the bysource hash, causing a
crash when walking over the hash chain the next time:

BUG: unable to handle kernel paging request at 00120fbd
IP: [<c03d394b>] nf_nat_setup_info+0x221/0x58a
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP

Pid: 2795, comm: conntrackd Not tainted (2.6.26-rc5 #1)
EIP: 0060:[<c03d394b>] EFLAGS: 00010206 CPU: 1
EIP is at nf_nat_setup_info+0x221/0x58a
EAX: 00120fbd EBX: 00120fbd ECX: 00000001 EDX: 00000000
ESI: 0000019e EDI: e853bbb4 EBP: e853bbc8 ESP: e853bb78
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process conntrackd (pid: 2795, ti=e853a000 task=f7de10f0 task.ti=e853a000)
Stack: 00000000 e853bc2c e85672ec 00000008 c0561084 63c1db4a 00000000 00000000
       00000000 0002e109 61d2b1c3 00000000 00000000 00000000 01114e22 61d2b1c3
       00000000 00000000 f7444674 e853bc04 00000008 c038e728 0000000a f7444674
Call Trace:
 [<c038e728>] nla_parse+0x5c/0xb0
 [<c0397c1b>] ctnetlink_change_status+0x190/0x1c6
 [<c0397eec>] ctnetlink_new_conntrack+0x189/0x61f
 [<c0119aee>] update_curr+0x3d/0x52
 [<c03902d1>] nfnetlink_rcv_msg+0xc1/0xd8
 [<c0390228>] nfnetlink_rcv_msg+0x18/0xd8
 [<c0390210>] nfnetlink_rcv_msg+0x0/0xd8
 [<c038d2ce>] netlink_rcv_skb+0x2d/0x71
 [<c0390205>] nfnetlink_rcv+0x19/0x24
 [<c038d0f5>] netlink_unicast+0x1b3/0x216
 ...

Move invocation of the extension destructors to nf_conntrack_free()
to fix this problem.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=10875

Reported-and-Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8a3d245effe6e699e587133a3f8ea700bd47842d
tree 38676f126c592455747598b6d56bccf9550d0214
parent 21fa91adce646ad0449e898a64edaa828ca131e7
author Patrick McHardy <kaber@trash.net> Tue, 10 Jun 2008 10:56:29 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 10 Jun 2008 10:56:29 +0200

 net/netfilter/nf_conntrack_core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c4b1799..662c1cc 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -196,8 +196,6 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	if (l4proto && l4proto->destroy)
 		l4proto->destroy(ct);
 
-	nf_ct_ext_destroy(ct);
-
 	rcu_read_unlock();
 
 	spin_lock_bh(&nf_conntrack_lock);
@@ -520,6 +518,7 @@ static void nf_conntrack_free_rcu(struct rcu_head *head)
 
 void nf_conntrack_free(struct nf_conn *ct)
 {
+	nf_ct_ext_destroy(ct);
 	call_rcu(&ct->rcu, nf_conntrack_free_rcu);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_free);

--------------030704060404060109060208
Content-Type: text/x-diff;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

netfilter: nf_nat: fix RCU races

Fix three ct_extend/NAT extension related races:

- When cleaning up the extension area and removing it from the bysource hash,
  the nat->ct pointer must not be set to NULL since it may still be used in
  a RCU read side

- When replacing a NAT extension area in the bysource hash, the nat->ct
  pointer must be assigned before performing the replacement

- When reallocating extension storage in ct_extend, the old memory must
  not be freed immediately since it may still be used by a RCU read side

Possibly fixes https://bugzilla.redhat.com/show_bug.cgi?id=449315
and/or http://bugzilla.kernel.org/show_bug.cgi?id=10875

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f4efed322f3d3a30df1bb5fc33403e84aca66d8e
tree 72d463aa289ab27850f40c76b68a24e91af7a6b0
parent 8a3d245effe6e699e587133a3f8ea700bd47842d
author Patrick McHardy <kaber@trash.net> Tue, 10 Jun 2008 11:00:35 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 10 Jun 2008 11:00:35 +0200

 include/net/netfilter/nf_conntrack_extend.h |    1 +
 net/ipv4/netfilter/nf_nat_core.c            |    3 +--
 net/netfilter/nf_conntrack_extend.c         |    9 ++++++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index f736e84..f80c0ed 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -15,6 +15,7 @@ enum nf_ct_ext_id
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
+	struct rcu_head rcu;
 	u8 offset[NF_CT_EXT_NUM];
 	u8 len;
 	char data[0];
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 0457859..d2a887f 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -556,7 +556,6 @@ static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 
 	spin_lock_bh(&nf_nat_lock);
 	hlist_del_rcu(&nat->bysource);
-	nat->ct = NULL;
 	spin_unlock_bh(&nf_nat_lock);
 }
 
@@ -570,8 +569,8 @@ static void nf_nat_move_storage(void *new, void *old)
 		return;
 
 	spin_lock_bh(&nf_nat_lock);
-	hlist_replace_rcu(&old_nat->bysource, &new_nat->bysource);
 	new_nat->ct = ct;
+	hlist_replace_rcu(&old_nat->bysource, &new_nat->bysource);
 	spin_unlock_bh(&nf_nat_lock);
 }
 
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index bcc19fa..8a3f8b3 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -59,12 +59,19 @@ nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
 	if (!*ext)
 		return NULL;
 
+	INIT_RCU_HEAD(&(*ext)->rcu);
 	(*ext)->offset[id] = off;
 	(*ext)->len = len;
 
 	return (void *)(*ext) + off;
 }
 
+static void __nf_ct_ext_free_rcu(struct rcu_head *head)
+{
+	struct nf_ct_ext *ext = container_of(head, struct nf_ct_ext, rcu);
+	kfree(ext);
+}
+
 void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
 	struct nf_ct_ext *new;
@@ -106,7 +113,7 @@ void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 					(void *)ct->ext + ct->ext->offset[i]);
 			rcu_read_unlock();
 		}
-		kfree(ct->ext);
+		call_rcu(&ct->ext->rcu, __nf_ct_ext_free_rcu);
 		ct->ext = new;
 	}
 

--------------030704060404060109060208--
