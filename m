From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] peer_pid checking in ip_queue
Date: Tue, 23 Mar 2004 18:25:01 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <406072ED.8060304@trash.net>
References: <40601AE4.5070206@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
 Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40601AE4.5070206@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

Pablo Neira wrote:
> Hi,
> 
> I patched ip_queue.c to modify the default behaviour if peer_pid is 0. 
> In this case, there's no program in user space to receive the skbuff via 
> netlink, but ip_queue will allocate space for the skbuff and after 
> checking if peer_pid is 0, it will destroy this skbuff allocated. Am I 
> missing anything?

peer_pid is protected by queue_lock, you move it out of the locked
section. This leads to a small race which can cause message loss.
Not sure if it's bad though as netlink is unreliable itself.

Regards
Patrick

> 
> best regards,
> Pablo
> 
> P.S: BTW, Harald, I noticed that I had some problems with my smtp server 
> and some email got lost, I sent you an email with a "digest" of all my 
> recent patches, did you receive it? If not, please let me know.
> 
> 
> ------------------------------------------------------------------------
> 
> --- linux-2.6.3-old/net/ipv4/netfilter/ip_queue.c	2004-02-18 04:59:59.000000000 +0100
> +++ linux-2.6.3/net/ipv4/netfilter/ip_queue.c	2004-03-23 10:31:16.000000000 +0100
> @@ -277,6 +277,9 @@
>  	struct sk_buff *nskb;
>  	struct ipq_queue_entry *entry;
>  
> +	if (!peer_pid)
> +		return -EINVAL;
> +
>  	if (copy_mode == IPQ_COPY_NONE)
>  		return -EAGAIN;
>  
> @@ -303,9 +306,6 @@
>  		
>  	write_lock_bh(&queue_lock);
>  	
> -	if (!peer_pid)
> -		goto err_out_free_nskb; 
> -
>   	/* netlink_unicast will either free the nskb or attach it to a socket */ 
>  	status = netlink_unicast(ipqnl, nskb, peer_pid, MSG_DONTWAIT);
>  	if (status < 0)
> @@ -318,9 +318,6 @@
>  	write_unlock_bh(&queue_lock);
>  	return status;
>  
> -err_out_free_nskb:
> -	kfree_skb(nskb); 
> -	
>  err_out_unlock:
>  	write_unlock_bh(&queue_lock);
>  
