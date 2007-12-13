From: Greg KH <gregkh@suse.de>
Subject: [patch 37/60] netfilter: Fix kernel panic with REDIRECT target.
Date: Wed, 12 Dec 2007 22:52:53 -0800
Message-ID: <20071213065253.GM6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
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
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Patrick McHardy <kaber@trash.net>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55484 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762587AbXLMG5e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:57:34 -0500
Content-Disposition: inline; filename="netfilter-fix-kernel-panic-with-redirect-target.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
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

-- 
