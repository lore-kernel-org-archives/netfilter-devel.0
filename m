Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792684338;
	b=sKfoKKCWUM9yFkH3RJIAzARaPgor0NfZCgqdY5xQN7ZRW+93m3aKf5M8nuYG0IFgwmTJ
	 ybCE6URDuRTeBoemrdi6dB3IXBWmywkaRmldVo/nTVIQghmqRr5ok+dZep4oGBPWrvwGc
	 cQcSR85VDryfwSbcmNayFQTmp/x9y/VKPZdI2XVpDvPr2msw3RyOZME+sVyz+Z5ZjCjxa
	 0qm8zTt/TGtsLmXA1yY5/WB7u5UBDVrAHcwdR6vFjbgrCec6yH9Cz/xEnEI1yUBVbV0UT
	 rCrknANjPaTohwAENdy8fBQYstlr781/tq0DdzyAJkDoflikU29360IGYHNJNkocicw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792684338;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=YbTyNtbzchqmfRjX2FlxXrSUFcXqkvUuetDIx2XOUwE=;
	b=rYN69g4AmZ4sI+uHB7ZmO9GQsT2e1UOoWHnzaJA1D/2+plvgggD9bNmWt/393nB+CQvs
	 3srCZYQ7sDtlDRLmzlwj07dcmGcqcT+gz43BFVLsyK/0CKjPbOLRzMd4bRy0BDLK6fr0o
	 TAT+DXOKAV38A9CjX9ECZP2KI2Ae6T39VsEqWTWMB40eQO8ntezN94N/l2Jn+mY7XX25F
	 KsvRcW7/TaeCfp0zyoj0q436phBgloLsKnw6/JmYE7N2vC/t/M7ttzLOLfTgPDYCvz/oz
	 QOh2c0JEEdqvo8tb0T+Cx7lOoGdOtEaebKVn2VEebD2F9qhEpt62O5iwjNXogCPulFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=cQ3hf6Nj;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D8BF4606A31B
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 15:52:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8BF4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=cQ3hf6Nj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792684335;
	bh=YbTyNtbzchqmfRjX2FlxXrSUFcXqkvUuetDIx2XOUwE=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=cQ3hf6NjhCjfkC6fkj62wREbf5ZaKruJkzU86jG2JI+AE7WiP/2JW5WuVUlIoPWAV
	 8nXYKNu59RlT+3QIE2lvwbUnby7ceqxDHEwu4FLyBdWho0BGMBO2TYA7jFh5M2AXsl
	 dDlnLhkxsa6Ky6SyD1fKJq4jG+eOYlgmLaLMUz4op5VjtsXCXQm8nubK0MXJI1XBZU
	 IXatiiSNWzhtQODz58c40+ORYZj9pPbqEbxhqrmKlIF5O453abcdhY5lKL4UItjhCg
	 EduI/K2GTqVoHhLWZx7/mVSUYEYT/IMXDQ7IJaay2R6NLYTxTVdHeQFwcEI4+NEtyt
	 GkqbmnVYfGoyg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8A8CB60058
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 17:52:15 +0200 (CEST)
Date: Thu, 22 Oct 2026 17:52:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v3] netfilter: nfnetlink_queue: restrict NFQA_EXP to
 userspace helpers
Message-ID: <atoxLV1J9bHXfa_Z@chamomile>
References: <20261022154644.2002766-1-pablo@netfilter.org>
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
In-Reply-To: <20261022154644.2002766-1-pablo@netfilter.org>

On Thu, Oct 22, 2026 at 05:46:44PM +0200, Pablo Neira Ayuso wrote:
> Adding expectations to unconfirmed conntracks are problematic because of
> reallocations of the ct extension area can happen while expectations are
> placed in the ct extension expectation list.
> 
> NFQA_EXP was added with the purpose of supporting userspace conntrack
> helpers, which create expectations in confirmation hook.
> 
> On packet reinjection, hook updates could result in a stale hook_index
> that point to different hooks, but this is not an issue because, in such
> rare case, expectation will not be created, else it could be created on
> the confirmation hook, which is the only hook where userspace helpers
> are possible.

I forgot to send two dependency patches, scratch this, I'm resending.

> Fixes: bd0779370588 ("netfilter: nfnetlink_queue: allow to attach expectations to conntracks")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v3: - add check for bridge
>     - expand commit description to try to calm down LLM, stale hook_index
>       is not an issue in this case.
> 
>  net/netfilter/nfnetlink_queue.c | 43 ++++++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 6ebf2bb8bbbd..677ec191df06 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -1786,6 +1786,22 @@ static int nfqnl_recv_verdict_batch(struct sk_buff *skb,
>  	return 0;
>  }
>  
> +static bool nfqnl_hook_exp_support(struct nf_hook_ops *ops)
> +{
> +	return (ops->pf == NFPROTO_IPV4 &&
> +		(ops->hooknum == NF_INET_POST_ROUTING ||
> +		 ops->hooknum == NF_INET_LOCAL_IN) &&
> +		ops->priority == NF_IP_PRI_CONNTRACK_CONFIRM) ||
> +	       (ops->pf == NFPROTO_IPV6 &&
> +		((ops->hooknum == NF_INET_POST_ROUTING &&
> +		 ops->priority == NF_IP6_PRI_LAST) ||
> +		 (ops->hooknum == NF_INET_LOCAL_IN &&
> +		  ops->priority == NF_IP6_PRI_LAST - 1))) ||
> +	       (ops->pf == NFPROTO_BRIDGE &&
> +		(ops->hooknum == NF_BR_POST_ROUTING ||
> +		 ops->priority == NF_IP_PRI_CONNTRACK_CONFIRM));
> +}
> +
>  static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
>  				      const struct nlmsghdr *nlh,
>  				      const struct nlattr * const nfqa[],
> @@ -1802,10 +1818,29 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
>  	if (nfnl_ct->parse(nfqa[NFQA_CT], ct) < 0)
>  		return NULL;
>  
> -	if (nfqa[NFQA_EXP])
> -		nfnl_ct->attach_expect(nfqa[NFQA_EXP], ct,
> -				      NETLINK_CB(entry->skb).portid,
> -				      nlmsg_report(nlh));
> +	if (nfqa[NFQA_EXP]) {
> +		const struct nf_hook_entries *hooks;
> +		struct nf_hook_ops **ops;
> +		unsigned int i;
> +
> +		hooks = nf_queue_hook_entries(entry);
> +		if (!hooks)
> +			return NULL;
> +
> +		ops = nf_hook_entries_get_hook_ops(hooks);
> +		if (!ops)
> +			return NULL;
> +
> +		i = entry->hook_index;
> +		if (i >= hooks->num_hook_entries)
> +			return NULL;
> +
> +		if (nfqnl_hook_exp_support(ops[i])) {
> +			nfnl_ct->attach_expect(nfqa[NFQA_EXP], ct,
> +					       NETLINK_CB(entry->skb).portid,
> +					       nlmsg_report(nlh));
> +		}
> +	}
>  	return ct;
>  #else
>  	return NULL;
> -- 
> 2.47.3
> 
> 
