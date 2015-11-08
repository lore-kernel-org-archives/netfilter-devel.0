From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nfnetlink_queue: remove
 duplicated obsolete commands handling
Date: Sun, 8 Nov 2015 23:14:54 +0100
Message-ID: <20151108221454.GA21221@salvia>
References: <20151005025046.GE14637@gmail.com>
 <20151005152315.GA11562@salvia>
 <20151006021001.GA30037@gmail.com>
 <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
 <20151007042016.GA23203@gmail.com>
 <20151007042550.GC23203@gmail.com>
 <20151016170532.GA18148@salvia>
 <20151106004640.GA11266@gmail.com>
 <20151106004947.GB11266@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34803 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbbKHWPB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Nov 2015 17:15:01 -0500
Content-Disposition: inline
In-Reply-To: <20151106004947.GB11266@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 06, 2015 at 09:49:47AM +0900, Ken-ichirou MATSUZAWA wrote:
> Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> ---
>  net/netfilter/nfnetlink_queue.c |   18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 7d81d28..f85a3d3 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -1116,21 +1116,10 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
>  	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
>  	u_int16_t queue_num = ntohs(nfmsg->res_id);
>  	struct nfqnl_instance *queue;
> -	struct nfqnl_msg_config_cmd *cmd = NULL;
>  	struct net *net = sock_net(ctnl);
>  	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
>  	int ret = 0;
>  
> -	if (nfqa[NFQA_CFG_CMD]) {
> -		cmd = nla_data(nfqa[NFQA_CFG_CMD]);
> -
> -		/* Obsolete commands without queue context */
> -		switch (cmd->command) {
> -		case NFQNL_CFG_CMD_PF_BIND: return 0;
> -		case NFQNL_CFG_CMD_PF_UNBIND: return 0;
> -		}
> -	}
> -

Thanks for following up on this Ken-ichirou.

However, I suspect this is wrong:

commit 0360ae412d09bc6f4864c801effcb20bfd84520e
Author: Florian Westphal <fw@strlen.de>
Date:   Fri Nov 23 06:22:21 2012 +0000

    netfilter: kill support for per-af queue backends

The former behaviour before Florian's patch is that
NFQNL_CFG_CMD_PF_BIND and NFQNL_CFG_CMD_PF_UNBIND are terminal.

This code is there not to break backward compatibility, ie. old
userspace that rely on these commands.

After this patch, we inspect if there is an existing queue for this,
which was not happening before.

As I said, my concerns go in the direction of possible breakage of old
code, we shouldn't break backward.

Let me know, thanks.

>  	rcu_read_lock();
>  	queue = instance_lookup(q, queue_num);
>  	if (queue && queue->peer_portid != NETLINK_CB(skb).portid) {

