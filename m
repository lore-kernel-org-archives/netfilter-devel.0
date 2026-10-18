Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8A024679C;
	Sun, 18 Oct 2026 01:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792287377; cv=none; b=pTJ6Ec36MvPKVeNpzR8dhYS06nkJ5rDWcSid4bwYGZwbdRlMUFUFjpKopJDjGtFgYrUP2+cBhpHQy0kM47X6y/DM2BiqkEQBwPy0qiA71jOAgXlo246rvcEU0SN1rvHekTFE8saONuiHc/PfQUlwYitYAe1q1Nd+5rp/ENp5VQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792287377; c=relaxed/simple;
	bh=gX6R+wd8/Dhb9oVDBVgN61vef4xrpK+H46HuzzzE8ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JSAXPV8u+SfG9tG5eKQmVISbC7x3stRJKB76tE/hU0NSsczVujl9D+pF5waot/nAYwJbREYhobe7ovKQIGHTlroiz7aav4PjkCVjcYx2l5kUpeC2feOoz2e56QNr4W/AbBTSaBaQ2CtZzDVqdUZpoQvlYaswTCI7UztJzObSRnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IGzky4EX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IGzky4EX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792287373;
	bh=IkmJzDgSFoisQ8iLJvywzLH72RtyXOmXmMQFlhXWiGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IGzky4EXlEvNS5lZWFPU9+nQ0agFJqbFBRLlaAtFD0Hi798GVtK1zoLgfOqPovwkP
	 H/tlIRYgDSfXlI9zeCUa3LdjF8AirKws+VFl08Rsg4LJfeMElQhH7mq66MS53od+h0
	 JARlwg3wwjzfQke7IlmzP5WQj59IPAZSQDaVgW5KBVb8794dnNHYN9f7usa0AMuFSa
	 zzPfYgU9eIVu8WWHs/qzLe6Tyemtkcv2ofu2v60uX2z44DkOOvdCe7htcMViSbu58i
	 V917YgAzs4XVgq7XXLBWFGwVjSafhhEJAby8znyopG5GIK0hnQYL3FOA41suPSQglE
	 nLaeyzBzHNeXg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CDAF260055;
	Sun, 18 Oct 2026 03:36:13 +0200 (CEST)
Date: Sun, 18 Oct 2026 03:36:11 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	geldot@protonmail.com, shuah@kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH nf-next v2 1/4] netfilter: conntrack: pick up a TCP flow
 whose SYN was never answered
Message-ID: <atQii0cO-HJb5TQ7@chamomile>
References: <20261004171628.3544978-1-julius@bairaktaris.de>
 <20261004171628.3544978-2-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261004171628.3544978-2-julius@bairaktaris.de>

On Sun, Oct 04, 2026 at 07:16:25PM +0200, Julius Bairaktaris wrote:
> From: Gary Dotzler <geldot@protonmail.com>
> 
> When only one direction of a connection passes the host, conntrack sees
> the SYN but not the SYN/ACK. The client's next ACK is invalid in
> SYN_SENT, as is every packet after it.
> 
> Had the SYN not been seen, the loose pickup in tcp_new() would have
> taken that ACK, with window checks off in both directions. Delete the
> SYN_SENT entry and look the packet up again so that tcp_new() picks it
> up. This applies only with nf_conntrack_tcp_loose, without synproxy,
> before any reply, and to an original direction ACK at the expected
> sequence number. No TCP state or transition is added.
> 
> Signed-off-by: Gary Dotzler <geldot@protonmail.com>
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> ---
>  net/netfilter/nf_conntrack_proto_tcp.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index ad6f1986d52a..31bd4b926e48 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1173,6 +1173,22 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
>  			return NF_ACCEPT;
>  		}
>  
> +		/* No reply seen and the client continues after its SYN: the
> +		 * reply takes another path. Recreate the entry through the
> +		 * loose pickup in tcp_new().
> +		 */
> +		if (tn->tcp_loose && !nfct_synproxy(ct) &&
> +		    old_state == TCP_CONNTRACK_SYN_SENT &&
> +		    index == TCP_ACK_SET && dir == IP_CT_DIR_ORIGINAL &&
> +		    !test_bit(IPS_SEEN_REPLY_BIT, &ct->status) &&
> +		    ntohl(th->seq) == ct->proto.tcp.seen[dir].td_end) {
> +			spin_unlock_bh(&ct->lock);
> +
> +			if (nf_ct_kill(ct))
> +				return -NF_REPEAT;
> +			return NF_DROP;
> +		}

I bet we will get more workaround patches like this soon to make this
work.

What is the point of TCP tracking this flow if it does not see all
traffic?

> +
>  		/* Invalid packet */
>  		spin_unlock_bh(&ct->lock);
>  		nf_ct_l4proto_log_invalid(skb, ct, state,
> -- 
> 2.53.0
> 
