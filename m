Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F7F722085;
	Wed, 10 Apr 2024 23:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712790806; cv=none; b=tiHldZEKEfUwCSIkELrBdjtlTt8gNsiUQrX/6hebPhCPV1+cloASGVHvuASYA22be1+QtnPDkuUbsE1xaLbdg9vH7FiMTcQsfJkLBIE8Zq1QlB/FEoOYEijAV32sb5SyxA0ERb+B2xrpIRIsxtscKYoKwGqK9irPa9ccba3l91A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712790806; c=relaxed/simple;
	bh=bHyt7N5icrXFS1QjKwCymQusO+NZNrKNBTvtubLCLHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t6ay1WoryLD7XZ6sYbhmmUNjS2Kx0lkwlz1Fq46sNMx2j5csrc2uohyU4V5dZrhi9SaBVJ2tw485oIMkIt1RimQFEFBzdepC/UWnYfGSdqTM4CNpOI5D8pBYCMjnZfaMwMJPKa76s1Svv8myy1C4rz3ma5pApCPzOwGIxKfghDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 11 Apr 2024 01:13:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 2/3] netfilter: nfnetlink: Handle ACK flags
 for batch messages
Message-ID: <ZhcdCUA2yJ56xdbj@calendula>
References: <20240410221108.37414-1-donald.hunter@gmail.com>
 <20240410221108.37414-3-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240410221108.37414-3-donald.hunter@gmail.com>

On Wed, Apr 10, 2024 at 11:11:07PM +0100, Donald Hunter wrote:
> The NLM_F_ACK flag is not processed for nfnetlink batch messages.

Let me clarify: It is not processed for the begin and end marker
netlink message, but it is processed for command messages.

> This is a problem for ynl which wants to receive an ack for every
> message it sends. Add processing for ACK and provide responses when
> requested.

NLM_F_ACK is regarded for the specific command messages that are
contained in the batch, that is:

batch begin
command
command
...
command
batch end

Thus, NLM_F_ACK can be set on for the command messages and it is not
ignore in that case.

May I ask why do you need this? Is it to make your userspace tool happy?

> I have checked that iproute2, pyroute2 and systemd are unaffected by
> this change since none of them use NLM_F_ACK for batch begin/end.
> I also ran a search on github and did not spot any usage that would
> break.
> 
> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
> ---
>  net/netfilter/nfnetlink.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index c9fbe0f707b5..37762941c288 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -427,6 +427,9 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>  
>  	nfnl_unlock(subsys_id);
>  
> +	if (nlh->nlmsg_flags & NLM_F_ACK)
> +		nfnl_err_add(&err_list, nlh, 0, &extack);
> +
>  	while (skb->len >= nlmsg_total_size(0)) {
>  		int msglen, type;
>  
> @@ -463,6 +466,8 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			goto done;
>  		} else if (type == NFNL_MSG_BATCH_END) {
>  			status |= NFNL_BATCH_DONE;
> +			if (nlh->nlmsg_flags & NLM_F_ACK)
> +				nfnl_err_add(&err_list, nlh, 0, &extack);

if (status == NFNL_BATCH_DONE) should probably be a better place for
this. I would like to have userspace that uses this, I don't have a
usecase at this moment for this new code.

Thanks.

>  			goto done;
>  		} else if (type < NLMSG_MIN_TYPE) {
>  			err = -EINVAL;
> -- 
> 2.43.0
> 
