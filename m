From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: use idr instead of list to speed up packet
 lookup by id
Date: Wed, 07 Apr 2010 13:48:46 +0200
Message-ID: <4BBC711E.7050602@trash.net>
References: <4BBBFE21.9070507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: xiaosuo@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45728 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab0DGLsu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 07:48:50 -0400
In-Reply-To: <4BBBFE21.9070507@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> use idr instead of list to speed up packet lookup by id.
> 
> The current implementations of nfnetlink_queue, ip_queue and ip6_queue
> are all use list to save the packets queued. If the verdicts aren't
> received in order, the lookup for the corresponding packets isn't
> efficient. As the ids is generated and maintained in kernel, we can use
> idr to speed up the lookup. The side effect of this patch is fixing the
> potential id overlap in nfnetlink_queue.

This doesn't compile:

net/netfilter/nfnetlink_queue.c:57: error: field 'idr' has incomplete type
net/netfilter/nfnetlink_queue.c: In function 'instance_create':
net/netfilter/nfnetlink_queue.c:112: error: implicit declaration of
function 'idr_init'
net/netfilter/nfnetlink_queue.c: In function 'instance_destroy_rcu':
net/netfilter/nfnetlink_queue.c:143: error: implicit declaration of
function 'idr_destroy'
net/netfilter/nfnetlink_queue.c: In function 'find_dequeue_entry':
net/netfilter/nfnetlink_queue.c:170: error: implicit declaration of
function 'idr_find'
net/netfilter/nfnetlink_queue.c:170: warning: assignment makes pointer
from integer without a cast
net/netfilter/nfnetlink_queue.c:172: error: implicit declaration of
function 'idr_remove'
net/netfilter/nfnetlink_queue.c: In function 'nfqnl_flush':
net/netfilter/nfnetlink_queue.c:188: error: implicit declaration of
function 'idr_get_next'
net/netfilter/nfnetlink_queue.c:188: warning: assignment makes pointer
from integer without a cast
net/netfilter/nfnetlink_queue.c: In function 'nfqnl_build_packet_message':
net/netfilter/nfnetlink_queue.c:253: error: implicit declaration of
function 'idr_pre_get'
net/netfilter/nfnetlink_queue.c:254: error: implicit declaration of
function 'idr_get_new'

I'm interested in how this affects performance for the vast majority
of users, which process messages in order. A simple hash table looks
like a better choice here since we know the maximum number of entries
in advance and also could have the user specify the desired hash size.

> @@ -223,6 +211,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
>  	struct sk_buff *entskb = entry->skb;
>  	struct net_device *indev;
>  	struct net_device *outdev;
> +	u32 id;
>  
>  	size =    NLMSG_SPACE(sizeof(struct nfgenmsg))
>  		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
> @@ -262,7 +251,11 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
>  		break;
>  	}
>  
> -	entry->id = queue->id_sequence++;
> +	if (!idr_pre_get(&queue->idr, GFP_ATOMIC) ||
> +	    idr_get_new(&queue->idr, entry, &id) != 0) {
> +	    	spin_unlock_bh(&queue->lock);
> +		return NULL;
> +	}
>  
>  	spin_unlock_bh(&queue->lock);

You probably shouldn't be making the entry visible before the message
is successfully built and sent.

>  
> @@ -279,7 +272,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
>  	nfmsg->version = NFNETLINK_V0;
>  	nfmsg->res_id = htons(queue->queue_num);
>  
> -	pmsg.packet_id 		= htonl(entry->id);
> +	pmsg.packet_id 		= htonl(id);
>  	pmsg.hw_protocol	= entskb->protocol;
>  	pmsg.hook		= entry->hook;
>  
> @@ -375,6 +368,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
>  	}
>  
>  	nlh->nlmsg_len = skb->tail - old_tail;
> +	*pid = id;
>  	return skb;
>  
>  nlmsg_failure:
> @@ -383,6 +377,9 @@ nla_put_failure:
>  		kfree_skb(skb);
>  	if (net_ratelimit())
>  		printk(KERN_ERR "nf_queue: error creating packet message\n");
> +	spin_lock_bh(&queue->lock);
> +	idr_remove(&queue->idr, id);
> +	spin_unlock_bh(&queue->lock);
>  	return NULL;
>  }
>  
> @@ -392,6 +389,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
>  	struct sk_buff *nskb;
>  	struct nfqnl_instance *queue;
>  	int err;
> +	u32 id;
>  
>  	/* rcu_read_lock()ed by nf_hook_slow() */
>  	queue = instance_lookup(queuenum);
> @@ -401,7 +399,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
>  	if (queue->copy_mode == NFQNL_COPY_NONE)
>  		goto err_out;
>  
> -	nskb = nfqnl_build_packet_message(queue, entry);
> +	nskb = nfqnl_build_packet_message(queue, entry, &id);
>  	if (nskb == NULL)
>  		goto err_out;
>  
> @@ -426,7 +424,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
>  		goto err_out_unlock;
>  	}
>  
> -	__enqueue_entry(queue, entry);
> +	queue->queue_total++;
>  
>  	spin_unlock_bh(&queue->lock);
>  	return 0;
> @@ -434,6 +432,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
>  err_out_free_nskb:
>  	kfree_skb(nskb);
>  err_out_unlock:
> +	idr_remove(&queue->idr, id);
>  	spin_unlock_bh(&queue->lock);
>  err_out:
>  	return -1;
> @@ -867,7 +866,7 @@ static int seq_show(struct seq_file *s, void *v)
>  			  inst->peer_pid, inst->queue_total,
>  			  inst->copy_mode, inst->copy_range,
>  			  inst->queue_dropped, inst->queue_user_dropped,
> -			  inst->id_sequence, 1);
> +			  0, 1);
>  }
>  
>  static const struct seq_operations nfqnl_seq_ops = {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

