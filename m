From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: pass netns to ->match or to not pass
Date: Fri, 24 Oct 2008 03:36:20 +0400
Message-ID: <20081023233620.GA19634@x200.localdomain>
References: <20081023231611.GA19245@x200.localdomain> <alpine.LNX.1.10.0810231915500.15705@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:5421 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbYJWXdI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:33:08 -0400
Received: by ug-out-1314.google.com with SMTP id k3so32119ugf.37
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2008 16:33:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0810231915500.15705@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 23, 2008 at 07:17:29PM -0400, Jan Engelhardt wrote:
> 
> On Thursday 2008-10-23 19:16, Alexey Dobriyan wrote:
> 
> >xt_recent wants netns inside ->match hook (and xt_hashlimit probably,
> >haven't looked closely):
> >
> >	recent_mt
> >	recent_table_lookup
> >	[use per-netns tables list]
> >
> >Now, I can drag netns through struct xt_match_param, or use
> >dev_net(skb->dev ? skb->dev : skb->dst->dev) trick.
> >
> >And the latter should be better, because only xt_recent module will be
> >affected.
> >
> >Comments?
> 
> What exactly needs netns? This?
> 
> 	if (par->out != NULL && skb->sk == NULL)
> 		ttl++;

Nope, something like below, and if I'm reading correctly,
struct xt_recent_mtinfo is immutable because of ABI, hence the question.


--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -180,11 +180,12 @@ static void recent_entry_update(struct recent_table *t, struct recent_entry *e)
 	list_move_tail(&e->lru_list, &t->lru_list);
 }
 
-static struct recent_table *recent_table_lookup(const char *name)
+static struct recent_table *recent_table_lookup(struct net *net, const char *name)
 {
+	struct netns_recent *net_recent = net_generic(net, recent_net_id);
 	struct recent_table *t;
 
-	list_for_each_entry(t, &tables, list)
+	list_for_each_entry(t, &net_recent->tables, list)
 		if (!strcmp(t->name, name))
 			return t;
 	return NULL;
@@ -203,6 +204,7 @@ static void recent_table_flush(struct recent_table *t)
 static bool
 recent_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
+	struct net *net = ???;
 	const struct xt_recent_mtinfo *info = par->matchinfo;
 	struct recent_table *t;
 	struct recent_entry *e;
@@ -235,7 +237,7 @@ recent_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 		ttl++;
 
 	spin_lock_bh(&recent_lock);
-	t = recent_table_lookup(info->name);
+	t = recent_table_lookup(net, info->name);
 	e = recent_entry_lookup(t, &addr, par->match->family,
 				(info->check_set & XT_RECENT_TTL) ? ttl : 0);
 	if (e == NULL) {
