Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964755;
	b=qkuH7cA9umW0EPaBJj63zBZeVtLqoH1pQk1TqOSbUMnw0zCpGWoandbQnk2wItxcXCJW
	 eb7oOPYkdQrhxburrodlinAQIWU0rzyID541qnQeaumjbVbOUZhY80QRL8M9SzqfM/+mJ
	 FwcZfElFaPP8dOWzJLkYXoq1RzwVE3g5tEcCz9UiogKiNypIiShCr5YV/lOmexog0S8Ng
	 eF4jN7ajdS8v3S4nMcKDwljwRYXV8e1JnjOQb1ZAqwUZDmewI+Nx4QaJozAfetuXPkglf
	 wFmJA+GnS4IbB6UGHb6Wc+MxPO0KlsCY6EC+PJC/1uTSw+FNYftxxdSTbNlokOmMRHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964755;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=RHThgPq8ETxy2w8YbH6+HBlKF4n78ToOruBNT76Nrpc=;
	b=SXqfUU8k59ezDM3esRRPAkp9keXijOKDmxxKNPuzibzQr7Hqq2P2LL8qxr4zk6kY4e0o
	 srAClt/CWbnK0TN5NztLCkVu9D3JzESamqZBi9uCo3fUBZb91cjp/pefRsfIofAnqoN8q
	 qZFyyMRYyT2eWnKOwlmtP2no6VoU/eY53LesPbcAHOEYgspKrKent435dJufUYsuAAuZ9
	 zOAqfNzvJ6zyntbwOfYLoFlTjcZWxzfp2S54/kdqmzXP7OTGZe1D77n6IG2xZGGSC/tgk
	 PO3qZ8z93op2Mux34CbbMoZhDyUesYV+XNjKa+awaOax6FnGrSankNtQJO8aoDIdTag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=SgNe5ZeD;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C6CA860A6F53;
	Fri,  6 Nov 2026 11:32:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6CA860A6F53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=SgNe5ZeD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793964751;
	bh=RHThgPq8ETxy2w8YbH6+HBlKF4n78ToOruBNT76Nrpc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SgNe5ZeDNzDk8DsG2ojzwQWNtdeJyTylVAQIR7T2f9Qitl3VG91+DSuKgVpglRcRg
	 Ek4Ai6zZJ4XzbvWBz7xzZKkkHy+sekPEJ2wqbSVwlYMLM2psbvcene/1lxn7I+Ul6s
	 DmH5IvcRU2SJmozRHKtSGTOaFkxxpixSq29N9knBcN3lSl1alVU3Q3iYzK3eP6Tz70
	 8+HBUNp4KAmEj2dy/lGgPqNnGZs3xurYeD0u6ukct1fNcNCLupissjXe2hRwFmM0Hm
	 gGvKQgBX9rx0JdxvBAYDHnOt3dGojrWccJZTAyKIp1UKzoYi/ddqNU9ZZI+oPEQIaN
	 qWC9BMvYINCYA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 528676005F;
	Fri,  6 Nov 2026 12:32:31 +0100 (CET)
Date: Fri, 6 Nov 2026 12:32:29 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: luoqing <l1138897701@163.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] netfilter: conntrack: avoid secs-to-jiffies
 overflow in SIP helper
Message-ID: <au26zXXqfRh6t-kU@chamomile>
References: <20261106060948.540233-1-l1138897701@163.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261106060948.540233-1-l1138897701@163.com>

Hi,

This is not net.git stuff, route this to nf-next.git

Thanks.

On Fri, Nov 06, 2026 at 02:09:47PM +0800, luoqing wrote:
> From: Qing Luo <luoqing@kylinos.cn>
> 
> refresh_signalling_expectation() converts the expiry from a SIP
> REGISTER 2xx response with "expires * HZ" in 32-bit arithmetic and
> stores it in a u32.  sip_strtouint() only rejects values above
> UINT_MAX, so the answering registrar controls the input.
> 
> Expectations are reaped with "(__s32)(exp->timeout - nfct_time_stamp)
> <= 0".  A wrapped product can only cut the lifetime short, never
> extend it: at HZ=1000 an expiry of 2147484 seconds (24.9 days)
> crosses 2^31, so the expectation is born expired and registration
> refreshes break, while 4294968 seconds wraps to 704 jiffies and the
> expectation is reaped almost immediately.
> 
> Add nf_ct_secs_to_jiffies(), which multiplies in u64 and saturates at
> INT_MAX so the signed expiry test stays positive, and use it for the
> SIP expectation refresh.  Oversized expiries now saturate to the
> INT_MAX jiffies ceiling - about 24.8 days at HZ=1000 and 248 days at
> HZ=100 - which is the same maximum a registrar could already request
> with the largest non-wrapping value; the longest lifetime does not
> change.
> 
> Sweeping all 2^32-1 inputs at HZ=1000, the helper never wraps, never
> yields a value that reads as expired, and matches the old expression
> up to INT_MAX / HZ.
> 
> Fixes: 0f32a40fc91a ("[NETFILTER]: nf_conntrack_sip: create signalling expectations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qing Luo <luoqing@kylinos.cn>
> ---
> 
> v2: 
> - Clarified in the commit message that this patch introduces the
>   nf_ct_secs_to_jiffies() helper, which the subsequent H.323 patch depends on.
> - Added a note about the stable backporting dependency for the helper.
> - Addressed the Sashiko AI review comments.
> 
> v1: https://lore.kernel.org/all/20261104085925.773471-1-l1138897701@163.com/
> 
> ---
>  include/net/netfilter/nf_conntrack.h | 10 ++++++++++
>  net/netfilter/nf_conntrack_sip.c     |  3 ++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index c39425e54d87..b32716084ea8 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -210,6 +210,16 @@ bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
>  void __nf_ct_refresh_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
>  			  u32 extra_jiffies, unsigned int bytes);
>  
> +/* Convert a timeout in seconds to jiffies, saturating at INT_MAX instead of
> + * wrapping the "secs * HZ" product in u32.
> + */
> +static inline u32 nf_ct_secs_to_jiffies(u32 secs)
> +{
> +	u64 delta = (u64)secs * HZ;
> +
> +	return delta > INT_MAX ? INT_MAX : (u32)delta;
> +}
> +
>  /* Refresh conntrack for this many jiffies and do accounting */
>  static inline void nf_ct_refresh_acct(struct nf_conn *ct,
>  				      enum ip_conntrack_info ctinfo,
> diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> index 64bc440b1181..e2fd97f53386 100644
> --- a/net/netfilter/nf_conntrack_sip.c
> +++ b/net/netfilter/nf_conntrack_sip.c
> @@ -891,7 +891,8 @@ static int refresh_signalling_expectation(struct nf_conn *ct,
>  		    exp->tuple.dst.protonum != proto ||
>  		    exp->tuple.dst.u.udp.port != port)
>  			continue;
> -		WRITE_ONCE(exp->timeout, nfct_time_stamp + (expires * HZ));
> +		WRITE_ONCE(exp->timeout,
> +			   nfct_time_stamp + nf_ct_secs_to_jiffies(expires));
>  		WRITE_ONCE(exp->flags, exp->flags & ~NF_CT_EXPECT_INACTIVE);
>  		found = 1;
>  		break;
> -- 
> 2.25.1
> 
