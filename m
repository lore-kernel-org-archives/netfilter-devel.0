From: Greg KH <gregkh@suse.de>
Subject: [patch 11/15] nf_conntrack: fix ctnetlink related crash in
	nf_nat_setup_info()
Date: Thu, 19 Jun 2008 14:30:05 -0700
Message-ID: <20080619213005.GL20267@suse.de>
References: <20080619211313.834170620@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>, davem@davemloft.net
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:38197 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbYFSVc0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:32:26 -0400
Content-Disposition: inline; filename="nf_conntrack-fix-ctnetlink-related-crash-in-nf_nat_setup_info.patch"
In-Reply-To: <20080619212621.GA20267@suse.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Patrick McHardy <kaber@trash.net>

netfilter: nf_conntrack: fix ctnetlink related crash in nf_nat_setup_info()

Upstream commit ceeff7541e5a4ba8e8d97ffbae32b3f283cb7a3f

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nf_conntrack_core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -199,8 +199,6 @@ destroy_conntrack(struct nf_conntrack *n
 	if (l4proto && l4proto->destroy)
 		l4proto->destroy(ct);
 
-	nf_ct_ext_destroy(ct);
-
 	rcu_read_unlock();
 
 	spin_lock_bh(&nf_conntrack_lock);
@@ -523,6 +521,7 @@ static void nf_conntrack_free_rcu(struct
 
 void nf_conntrack_free(struct nf_conn *ct)
 {
+	nf_ct_ext_destroy(ct);
 	call_rcu(&ct->rcu, nf_conntrack_free_rcu);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_free);

-- 
