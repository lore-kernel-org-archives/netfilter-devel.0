From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: pass netns to ->match or to not pass
Date: Fri, 24 Oct 2008 13:45:06 +0400
Message-ID: <20081024094506.GC19634@x200.localdomain>
References: <20081023231611.GA19245@x200.localdomain> <alpine.LNX.1.10.0810231915500.15705@fbirervta.pbzchgretzou.qr> <20081023233620.GA19634@x200.localdomain> <alpine.LNX.1.10.0810232021220.15705@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.182]:21600 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYJXJlw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:41:52 -0400
Received: by ik-out-1112.google.com with SMTP id c30so518935ika.5
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2008 02:41:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0810232021220.15705@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 23, 2008 at 08:23:10PM -0400, Jan Engelhardt wrote:
> 
> On Thursday 2008-10-23 19:36, Alexey Dobriyan wrote:
> >> 
> >> >xt_recent wants netns inside ->match hook (and xt_hashlimit probably,
> >> >haven't looked closely):
> >> >
> >> >	recent_mt
> >> >	recent_table_lookup
> >> >	[use per-netns tables list]
> >> >
> >> >Now, I can drag netns through struct xt_match_param, or use
> >> >dev_net(skb->dev ? skb->dev : skb->dst->dev) trick.
> >> >
> >> >And the latter should be better, because only xt_recent module will be
> >> >affected.
> >> >
> >> >Comments?
> >> 
> >> What exactly needs netns? This?
> >> 
> >> 	if (par->out != NULL && skb->sk == NULL)
> >> 		ttl++;
> >
> >Nope, something like below, and if I'm reading correctly,
> >struct xt_recent_mtinfo is immutable because of ABI, hence the question.
> 
> What info would you pass thorugh xt_recent_mtinfo anyway?

Well, if it would have a pointer like xt_connlimit has, I could take
netns from ->matchinfo. Here is xt_connlimit patch, btw.


commit d922d559ee30336579f56e7f45b4eac977643f29
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Fri Oct 24 02:37:00 2008 +0400

    netns nf: xt_connlimit in netns

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 7f404cc..ef01431 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -38,6 +38,7 @@ struct xt_connlimit_conn {
 struct xt_connlimit_data {
 	struct list_head iphash[256];
 	spinlock_t lock;
+	struct net *net;
 };
 
 static u_int32_t connlimit_rnd;
@@ -105,6 +106,7 @@ static int count_them(struct xt_connlimit_data *data,
 		      const union nf_inet_addr *mask,
 		      const struct xt_match *match)
 {
+	struct net *net = data->net;
 	const struct nf_conntrack_tuple_hash *found;
 	struct xt_connlimit_conn *conn;
 	struct xt_connlimit_conn *tmp;
@@ -123,7 +125,7 @@ static int count_them(struct xt_connlimit_data *data,
 
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, tmp, hash, list) {
-		found    = __nf_conntrack_find(&init_net, &conn->tuple);
+		found    = __nf_conntrack_find(net, &conn->tuple);
 		found_ct = NULL;
 
 		if (found != NULL)
@@ -242,6 +244,7 @@ static bool connlimit_mt_check(const struct xt_mtchk_param *par)
 	spin_lock_init(&info->data->lock);
 	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i)
 		INIT_LIST_HEAD(&info->data->iphash[i]);
+	info->data->net = par->net;
 
 	return true;
 }
