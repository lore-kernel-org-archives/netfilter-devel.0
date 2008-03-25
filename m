From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER 06/32]: nf_conntrack: introduce expectation classes
 and policies
Date: Tue, 25 Mar 2008 16:46:11 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0803251635320.9368@fbirervta.pbzchgretzou.qr>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain> <20080325141458.10539.61924.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34510 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbYCYPqM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:46:12 -0400
In-Reply-To: <20080325141458.10539.61924.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On Tuesday 2008-03-25 15:14, Patrick McHardy wrote:

> /****************************************************************************/
> +static const struct nf_conntrack_expect_policy h245_exp_policy = {
> +	.max_expected	= H323_RTP_CHANNEL_MAX * 4 + 2 /* T.120 */,
> +	.timeout	= 240,
> +};
> +

Developer questions: what does ->max_expected limit?
Expectations for one connection, or for the whole helper module?


>@@ -110,7 +110,8 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
> {
> 	unsigned int h = helper_hash(&me->tuple);
> 
>-	BUG_ON(me->timeout == 0);
>+	BUG_ON(me->expect_policy == NULL);
>+	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
>
> 	mutex_lock(&nf_ct_helper_mutex);
> 	hlist_add_head_rcu(&me->hnode, &nf_ct_helper_hash[h]);

A zero timeout triggered a BUG_ON in nf_conntrack_helper_register,
now this check is gone!?

