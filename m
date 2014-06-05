From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 3/3] netfilter: Add SKPID and SKSID meta keys
Date: Thu, 5 Jun 2014 16:25:25 +0200
Message-ID: <20140605142525.GB23367@breakpoint.cc>
References: <1401977956-15500-1-git-send-email-yshuiv7@gmail.com>
 <1401977956-15500-3-git-send-email-yshuiv7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Yuxuan Shui <yshuiv7@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40422 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbaFEOZ1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:25:27 -0400
Content-Disposition: inline
In-Reply-To: <1401977956-15500-3-git-send-email-yshuiv7@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yuxuan Shui <yshuiv7@gmail.com> wrote:
 +	case NFT_META_SKPID:
> +		if (skb->sk == NULL || skb->sk->sk_state == TCP_TIME_WAIT)
> +			goto err;
> +
> +		read_lock_bh(&skb->sk->sk_callback_lock);
> +		dest->data[0] = pid_nr(skb->sk->sk_peer_pid);
> +		read_unlock_bh(&skb->sk->sk_callback_lock);
> +		break;
> +	case NFT_META_SKSID:
> +		if (skb->sk == NULL || skb->sk->sk_state == TCP_TIME_WAIT)
> +			goto err;
> +
> +		read_lock_bh(&skb->sk->sk_callback_lock);
> +		task = get_pid_task(skb->sk->sk_peer_pid, PIDTYPE_PID);
> +		sid = task_session(task);
> +		if (!sid)

looks like you need to unlock here.

> +			goto err;
