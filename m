Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7DF1AB6CB;
	Wed, 23 Oct 2024 14:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729692096; cv=none; b=edn76Sv/t+PgW3B4qsQI26xPfsv3MdljEWn48VLXjdkyVYGUG5/2d2upjQq8C0qePrnaSbozTWXYrNMRhTWxxR7qiVfkSkHyiqXbgJ11WmPTW7kaE4u2jqNDN/ZmrRzW8FIIP1eHCCu7gTO6a4AQa44xG3dhxM96SX9IO2kepcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729692096; c=relaxed/simple;
	bh=5b50b5GFMBss2urlySnrHy9PIeMWVclc5a4cudcsbwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=Z9Bn5uVti8w+0TpY4a8MvgHKvM1ID69uf4E/LnKlN2XIrsf7xhxTeH6DhjV40aoMJ+1WVnqZuqX+/kHLGyz7lncq/oN2dYHl1KUlrkxDp86dX95C/1F0t6Mbe2bkwtNXUqow90iWnJ45PgjpTT9ACt6r/l8jEtgJCZMajHNdnzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p6KF6CvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p6KF6CvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2141C4CEC6;
	Wed, 23 Oct 2024 14:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729692094;
	bh=5b50b5GFMBss2urlySnrHy9PIeMWVclc5a4cudcsbwo=;
	h=Date:Subject:To:References:Cc:From:In-Reply-To:From;
	b=p6KF6CvBE3E/fJ3TK2PrSOwru6E2p2b8S1Y4XOGav2E7CgcKWybrcI/w6kKeTGSCW
	 fwBeGYWSpl67AY4mPAkklRTSe54DSiuxzJc1qavnk+Rzmn89Q0+5w3PrJZQmQlHyQJ
	 acU/ZGOZrtaMXpuS6ptiHkGQfpAidyoWe86e+oeKmaROf38y4D3gmgNwjTMl7oOL4g
	 4bACxpd4WnswgJNaFl7yDuCM9uTpw64GQ3e/kR3GNRnAmai4hjzU6BWSiHLfdeUHGV
	 LYpYRSKS/+xGBh9znOcOwKN7n+Da/eHZAjSZPDm6+pa5g9/Cf5HQDJNu/n9h5qsOi/
	 GnBGjPq4Tc7hQ==
Message-ID: <efbf5943-f136-4330-b896-d6b7a2d02796@kernel.org>
Date: Wed, 23 Oct 2024 16:01:29 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] netfliter: xtables: fix typo causing some targets to not
 load on IPv6
Content-Language: en-GB
To: Ilya Katsnelson <me@0upti.me>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Florian Westphal <fw@strlen.de>, Sasha Levin <sashal@kernel.org>
References: <20241018-xtables-typos-v1-1-02a51789c0ec@0upti.me>
 <fde8d1b6-9812-418c-8ba4-ae2384251ee7@kernel.org>
 <83f8ef32-9060-4fde-b947-926ec1d830c8@0upti.me>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <83f8ef32-9060-4fde-b947-926ec1d830c8@0upti.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Ilya,

(+ add people/ML back in cc)

On 23/10/2024 14:11, Ilya K wrote:
>> Hi Ilya,
>>
>> On 18/10/2024 17:45, Ilya Katsnelson wrote:
>>> These were added with the wrong family in 4cdc55e, which seems
>>> to just have been a typo, but now ip6tables rules with --set-mark
>>> don't work anymore, which is pretty bad.
>>
>> Funny, with this patch, now the v4 version doesn't work any more, which
>> is pretty bad as well ;-)
>>
>> More seriously, it looks like your patch broke MPTCP selftests:
>>
>>
>> https://netdev-3.bots.linux.dev/vmksft-mptcp-dbg/results/826643/1-mptcp-join-sh/stdout
>>
>> Two tests are now failing, because they can no longer add a mark:
>>
>>> # iptables -t mangle -A OUTPUT -j MARK --set-mark 1
>>> Warning: Extension MARK revision 0 not supported, missing kernel module?
>>> iptables v1.8.10 (nf_tables):  RULE_APPEND failed (No such file or directory): rule in chain OUTPUT
>>
>> Please see below:
>>
>>> diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
>>> index d80abd6ccaf8f71fa70605fef7edada827a19ceb..6dcf4bc7e30b2ae364a1cd9ac8df954a90905c52 100644
>>> --- a/net/netfilter/xt_NFLOG.c
>>> +++ b/net/netfilter/xt_NFLOG.c
>>> @@ -79,7 +79,7 @@ static struct xt_target nflog_tg_reg[] __read_mostly = {
>>>  	{
>>>  		.name       = "NFLOG",
>>>  		.revision   = 0,
>>> -		.family     = NFPROTO_IPV4,
>>> +		.family     = NFPROTO_IPV6,
>>
>> Here, by setting the family to v6 instead of v4, we now have two targets
>> that are exactly the same, both for v6:
>>
>>>   67   │ static struct xt_target nflog_tg_reg[] __read_mostly = {
>>>   68   │     {
>>>   69   │         .name       = "NFLOG",
>>>   70   │         .revision   = 0,
>>>   71   │         .family     = NFPROTO_IPV6,  /* <== The line you modified */
>>>   72   │         .checkentry = nflog_tg_check,
>>>   73   │         .destroy    = nflog_tg_destroy,
>>>   74   │         .target     = nflog_tg,
>>>   75   │         .targetsize = sizeof(struct xt_nflog_info),
>>>   76   │         .me         = THIS_MODULE,
>>>   77   │     },
>>>   78   │ #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
>>>   79   │     {
>>>   80   │         .name       = "NFLOG",
>>>   81   │         .revision   = 0,
>>>   82   │         .family     = NFPROTO_IPV6,  /* <== v6 was already there */
>>>   83   │         .checkentry = nflog_tg_check,
>>>   84   │         .destroy    = nflog_tg_destroy,
>>>   85   │         .target     = nflog_tg,
>>>   86   │         .targetsize = sizeof(struct xt_nflog_info),
>>>   87   │         .me         = THIS_MODULE,
>>>   88   │     },
>>>   89   │ #endif
>>>   90   │ };
>>
>> Are you sure you didn't have the bug you mentioned because your kernel
>> config doesn't have CONFIG_IP6_NF_IPTABLES?
>>
>>>  		.checkentry = nflog_tg_check,
>>>  		.destroy    = nflog_tg_destroy,
>>>  		.target     = nflog_tg,
>>> diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
>>> index f76fe04fc9a4e19f18ac323349ba6f22a00eafd7..65b965ca40ea7ea5d9feff381b433bf267a424c4 100644
>>> --- a/net/netfilter/xt_mark.c
>>> +++ b/net/netfilter/xt_mark.c
>>> @@ -62,7 +62,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
>>>  	{
>>>  		.name           = "MARK",
>>>  		.revision       = 2,
>>> -		.family         = NFPROTO_IPV4,
>>> +		.family         = NFPROTO_IPV6,
>>
>> Same here.
>>
>> So I think this patch is not needed, right?
>>
>>>  		.target         = mark_tg,
>>>  		.targetsize     = sizeof(struct xt_mark_tginfo2),
>>>  		.me             = THIS_MODULE,
>>>
>>> ---
>>> base-commit: 75aa74d52f43e75d0beb20572f98529071b700e5
>>> change-id: 20241018-xtables-typos-dfeadb8b122d
>>>
>>> Best regards,
>>
>> Cheers,
>> Matt
> 
> The patch never got merged, but Pablo's very similar patch did. Are you
> by any chance applying my changes on top of a tree that also contains
> his?

Thank you for this reply!

Oh, sorry, I see the issue now, just an unlucky situation:

- On one hand, and probably because the issue was visible on stable too,
Pablo sent a new version changing the author and the title ("not to
load" vs "to not load") [1]. Because of that, the bot didn't mark the
previous version as superseded.

- On the other hand, the CI tried to apply all the pending patches,
including this patch here: when git tried to apply this patch, it
managed to find the exact same context a bit before, and then modified
the wrong line [2].

The two combined resulted in the CI trying to validate a buggy patch not
doing what it was intended to do.

From what I understood, Paolo is changing the status of [1] and even [3]
on Patchwork, and soon the CI will stop using the wrong patch.

[1]
https://patchwork.kernel.org/project/netdevbpf/patch/20241021094536.81487-3-pablo@netfilter.org/
[2]
https://github.com/linux-netdev/testing/commit/096e5d7e7d38271b6353ecd197e8ec00a01dbfd3
[3]
https://patchwork.kernel.org/project/netdevbpf/patch/20241018162517.39154-1-ignat@cloudflare.com/

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

