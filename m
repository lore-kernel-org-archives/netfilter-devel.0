From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
 	finding.
Date: Thu, 15 Apr 2010 17:35:02 +0200
Message-ID: <4BC73226.2030007@trash.net>
References: <4BBEA97A.5020303@gmail.com> <1271164991.16881.346.camel@edumazet-laptop> 	<4BC470B3.4030007@trash.net> <h2n412e6f7f1004142353uac023edfqc59d076c0d8a1784@mail.gmail.com> 	<4BC6EC15.4070205@trash.net> <t2t412e6f7f1004150735l54619e32t3e7fcdce7b118bd9@mail.gmail.com> 	<4BC72572.1050507@trash.net> <4BC726B4.1030003@trash.net> 	<j2w412e6f7f1004150801m66503602wbd0296c09aa45e90@mail.gmail.com> 	<4BC72B2B.9010104@trash.net> <m2l412e6f7f1004150811p3009f238if492b139770a0ea8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33955 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab0DOPfH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:35:07 -0400
In-Reply-To: <m2l412e6f7f1004150811p3009f238if492b139770a0ea8@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> static int
> nfqnl_rcv_nl_event(struct notifier_block *this,
>                    unsigned long event, void *ptr)
> {
>         struct netlink_notify *n = ptr;
> 
>         if (event == NETLINK_URELEASE && n->protocol == NETLINK_NETFILTER) {
>                 int i;
> 
>                 /* destroy all instances for this pid */
>                 spin_lock(&instances_lock);
>                 for (i = 0; i < INSTANCE_BUCKETS; i++) {
>                         struct hlist_node *tmp, *t2;
>                         struct nfqnl_instance *inst;
>                         struct hlist_head *head = &instance_table[i];
> 
>                         hlist_for_each_entry_safe(inst, tmp, t2, head, hlist) {
>                                 if ((n->net == &init_net) &&
>                                     (n->pid == inst->peer_pid))
>                                         __instance_destroy(inst);
>                         }
>                 }
>                 spin_unlock(&instances_lock);
>         }
>         return NOTIFY_DONE;
> }
> 
> static struct notifier_block nfqnl_rtnl_notifier = {
>         .notifier_call  = nfqnl_rcv_nl_event,
> };
>

Ah, right. So call nfnl_lock() or convert the spinlock to a
mutex.
