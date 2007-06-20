From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [NETFILTER]: nfctnetlink: Don't allow to change helper (Was: Re:
 [NETFILTER 01/03]: nf_conntrack: fix helper module unload races)
Date: Wed, 20 Jun 2007 19:57:30 +0900 (JST)
Message-ID: <200706201057.l5KAvVla005539@toshiba.co.jp>
References: <46767AA7.4040208@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46767AA7.4040208@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi, Pablo,

What do you think about this ?

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 18 Jun 2007 14:29:27 +0200

> > [NETFILTER]: nf_conntrack: Fixes race on changing helper
> > 
> > nfctnetlink may change the helper assigned to a conntrack and clear
> > private area in the conntrack. To fix the race, this exports spin locks
> > of helpers and nfctnetlink uses them. Some helpers do not need to grab
> > spin lock, because they do not store any state in the private area.
> > 
> > Other staff does not need to grab spin lock.
> > - unhelp() assigns NULL to conntrack, but it does not touch the private
> >   area.
> > - init_conntrack(), nf_conntrack_alter_reply(), and
> >   nfctnetlink_create_conntrack() assign a helper to a conntrack,
> >   but the conntrack is unconfirmed. No competitor exists.
> 
> 
> The fix looks correct, but considering the other problems that changing
> helpers cause for ct_extend I'm wondering whether we could restrict the
> helper change operation to conntracks that don't already have a helper
> assigned. I can't imagine any use for changing helpers of a connection
> that already has one assigned and it will always be racy anyway.
> Pablo, are you aware of anything using/needing this feature?




[NETFILTER]: nfctnetlink: Don't allow to change helper

There is no realistic situation to change helper (Who wants IRC helper to
track FTP traffic ?). Moreover, if we want to do that, we need to fix race
issue by nfctnetlink and running helper. That will add overhead to packet
processing. It wouldn't pay. So this rejects the request to change
helper. The requests to add or remove helper are accepted as ever.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 net/netfilter/nf_conntrack_netlink.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3f73327..d0fe3d7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -869,8 +869,7 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nfattr *cda[])
 		return 0;
 
 	if (help->helper)
-		/* we had a helper before ... */
-		nf_ct_remove_expectations(ct);
+		return -EBUSY;
 
 	/* need to zero data of old helper */
 	memset(&help->help, 0, sizeof(help->help));
-- 
1.5.2.2
