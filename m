From: <gregkh@suse.de>
Subject: patch netfilter-fix-kernel-panic-with-redirect-target.patch queued to -stable tree
Date: Tue, 11 Dec 2007 16:01:31 -0800
Message-ID: <20071212000227.6A6D71454450@imap.suse.de>
References: <474D2D56.9090503@trash.net>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: johnpol@2ka.mipt.ru, davem@davemloft.net, david@unsolicited.net,
	gregkh@suse.de, kaber@trash.net, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:59309 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbXLLAC3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:02:29 -0500
In-Reply-To: <474D2D56.9090503@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

     Subject: netfilter: Fix kernel panic with REDIRECT target.

to the 2.6.23-stable tree.  Its filename is

     netfilter-fix-kernel-panic-with-redirect-target.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Wed Nov 28 00:57:19 2007
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Date: Wed, 28 Nov 2007 09:56:54 +0100
Subject: netfilter: Fix kernel panic with REDIRECT target.
To: stable@kernel.org
Cc: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
Message-ID: <474D2D56.9090503@trash.net>

From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

This patch fixes a NAT regression in 2.6.23, resulting in a
crash when a connection is NATed and matches a conntrack
helper after NAT.

Please apply, thanks.
[NETFILTER]: Fix kernel panic with REDIRECT target.

Upstream commit 1f305323ff5b9ddc1a4346d36072bcdb58f3f68a

When connection tracking entry (nf_conn) is about to copy itself it can
have some of its extension users (like nat) as being already freed and
thus not required to be copied.

Actually looking at this function I suspect it was copied from
nf_nat_setup_info() and thus bug was introduced.

Report and testing from David <david@unsolicited.net>.

[ Patrick McHardy states:

        I now understand whats happening:

        - new connection is allocated without helper
        - connection is REDIRECTed to localhost
        - nf_nat_setup_info adds NAT extension, but doesn't initialize it yet
        - nf_conntrack_alter_reply performs a helper lookup based on the
           new tuple, finds the SIP helper and allocates a helper extension,
           causing reallocation because of too little space
        - nf_nat_move_storage is called with the uninitialized nat extension

        So your fix is entirely correct, thanks a lot :)  ]

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Acked-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/netfilter/nf_nat_core.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -607,13 +607,10 @@ static void nf_nat_move_storage(struct n
 	struct nf_conn_nat *new_nat = nf_ct_ext_find(conntrack, NF_CT_EXT_NAT);
 	struct nf_conn_nat *old_nat = (struct nf_conn_nat *)old;
 	struct nf_conn *ct = old_nat->ct;
-	unsigned int srchash;
 
-	if (!(ct->status & IPS_NAT_DONE_MASK))
+	if (!ct || !(ct->status & IPS_NAT_DONE_MASK))
 		return;
 
-	srchash = hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-
 	write_lock_bh(&nf_nat_lock);
 	hlist_replace_rcu(&old_nat->bysource, &new_nat->bysource);
 	new_nat->ct = ct;


Patches currently in stable-queue which might be from johnpol@2ka.mipt.ru are

queue-2.6.23/netfilter-fix-null-pointer-dereference-in-nf_nat_move_storage.patch
queue-2.6.23/netfilter-fix-kernel-panic-with-redirect-target.patch
