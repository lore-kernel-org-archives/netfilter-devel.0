From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable]: Fix kernel panic with REDIRECT target.
Date: Wed, 28 Nov 2007 09:56:54 +0100
Message-ID: <474D2D56.9090503@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000702070401020704090905"
Cc: "David S. Miller" <davem@davemloft.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40806 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbXK1I47 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 03:56:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000702070401020704090905
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes a NAT regression in 2.6.23, resulting in a
crash when a connection is NATed and matches a conntrack
helper after NAT.

Please apply, thanks.

--------------000702070401020704090905
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

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

---
commit 8c02679fa33928aedf94caac69e3665eb04f4902
tree 3a54efa718001478244e26daf799298b54562480
parent 5811c2a0705a77524b2b12d927e874d2fa6520b3
author Evgeniy Polyakov <johnpol@2ka.mipt.ru> Wed, 28 Nov 2007 09:26:13 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 28 Nov 2007 09:26:13 +0100

 net/ipv4/netfilter/nf_nat_core.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 553ebb8..9731d2c 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -607,13 +607,10 @@ static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
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

--------------000702070401020704090905--
