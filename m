Received: from mta1.migadu.com (out-31.mta1.migadu.com [95.215.58.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA972F7F02
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2026 03:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787195594; cv=none; b=V2zno9q0xfqrb6PZOHd+odKHl9Sk/wogWFhsN7PeT2kn/RBvRvxyKkYjyzoLDTrZH/lFo105ooJKpQcTTvapZ0LiUag73x6k8ydE2VgGTuMtLNdRhlSdXS0c8HnO6g5PxYJAva/p2wvBZsflvwa9JMxcgQh2I0VImZ0plbRhS7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787195594; c=relaxed/simple;
	bh=3LV6u6BSP3d3OSqWxksUK0AqLicPVWoRRXmku2xGEmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bG8jMAJECD958laH/Om7RHrZjolQH+lBTMYAHJgxnYacuyIXCKIKPevzPUrV+9Qlrxwg5lNdaNpq6ZY/Mbq8LIObb5h/NFaVJAPHjBPBLd7UvjvBprIgHXuzIq9DLiQHUiW30Vjb/FpkwydDOPH29ci7xxA9oKWNVonXdzM8fdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M2RNS9vj; arc=none smtp.client-ip=95.215.58.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M2RNS9vj"
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3LV6u6BSP3d3OSqWxksUK0AqLicPVWoRRXmku2xGEmI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787195590; v=1; x=1787800390;
 b=M2RNS9vjiunCbuUSTUEeV75tmvCQZ1LfxnPuOlBCgG6Sn5qIBhmjHQb/sHmbauk/fJU97KMx
 aF/l2iCl7NBhMmcnGeuTvRi9+bpCHTSBWv3S4ha6RltH5SDHo5q3o1z93v7KaHIhRakaXZMTCf7
 Z9FE1A1gu/neNhTyIiybEWro=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: from [198.18.0.1] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 67db544991d7f40b;
	Thu, 20 Aug 2026 03:13:10 +0000
X-Mizu-Trace-ID: 67db544991d7f40b
X-Migadu-Flow: FLOW_OUT
Message-ID: <f3093e85-fd58-420b-b435-c39263c46e3c@linux.dev>
Date: Thu, 20 Aug 2026 11:12:59 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] netfilter: ipset: list:set: defer ip_set_put_byindex
 to RCU callback
To: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>
Cc: phil@nwl.cc, horms@kernel.org, kadlec@netfilter.org, kees@kernel.org,
 enrico.pozzobon@dissecto.com, sbrivio@redhat.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 AutonomousCodeSecurity@microsoft.com, xmei5@asu.edu,
 tgopinath@linux.microsoft.com, kys@microsoft.com, pablo@netfilter.org,
 fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com
References: <20260820010617.46851-1-blbllhy@gmail.com>
From: luoxuanqiang <xuanqiang.luo@linux.dev>
In-Reply-To: <20260820010617.46851-1-blbllhy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/8/20 09:06, Cen Zhang (Microsoft) 写道:
> list_set_del() and list_set_replace() call ip_set_put_byindex() before
> call_rcu(), dropping the child set refcount to zero. Meanwhile,
> list_set_ktest() on another CPU may have already read e->id under
> rcu_read_lock(). A concurrent ip_set_destroy() sees refcount zero,
> NULLs ip_set_list[index], and frees the child set. list_set_ktest()
> then passes the now-dangling index to ip_set_test(), ip_set_rcu_get()
> returns NULL, and BUG_ON(!set) fires at ip_set_core.c:746.
>
>   kernel BUG at net/netfilter/ipset/ip_set_core.c:746!
>     ip_set_test+0x329/0x590
>     list_set_kadt+0x2a6/0x810
>     ip_set_test+0x24f/0x590
>     set_match_v1+0x1a9/0x280
>     ipt_do_table+0x83d/0x1360
>     nf_hook_slow+0xac/0x1e0
>
> Move ip_set_put_byindex() from list_set_del()/list_set_replace() into
> the __list_set_del_rcu() callback so the refcount is not decremented
> until all RCU readers have finished.
>
> Fixes: 439cd39ea136 ("netfilter: ipset: list:set: Decrease refcount synchronously on deletion and replace")
> Reported-by: AutonomousCodeSecurity@microsoft.com
> Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
> Reported-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
> Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
> ---
>   net/netfilter/ipset/ip_set_list_set.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
> index f070088742d6..aeee0c6c314d 100644
> --- a/net/netfilter/ipset/ip_set_list_set.c
> +++ b/net/netfilter/ipset/ip_set_list_set.c
> @@ -144,7 +144,9 @@ __list_set_del_rcu(struct rcu_head * rcu)
>   {
>   	struct set_elem *e = container_of(rcu, struct set_elem, rcu);
>   	struct ip_set *set = e->set;
> +	struct list_set *map = set->data;
>   
> +	ip_set_put_byindex(map->net, e->id);
>   	ip_set_ext_destroy(set, e);
>   	kfree(e);
>   }
> @@ -152,21 +154,15 @@ __list_set_del_rcu(struct rcu_head * rcu)
>   static void
>   list_set_del(struct ip_set *set, struct set_elem *e)
>   {
> -	struct list_set *map = set->data;
> -
>   	set->elements--;
>   	list_del_rcu(&e->list);
> -	ip_set_put_byindex(map->net, e->id);
>   	call_rcu(&e->rcu, __list_set_del_rcu);
>   }
>   
>   static void
>   list_set_replace(struct ip_set *set, struct set_elem *e, struct set_elem *old)
>   {
> -	struct list_set *map = set->data;
> -
>   	list_replace_rcu(&old->list, &e->list);
> -	ip_set_put_byindex(map->net, old->id);
>   	call_rcu(&old->rcu, __list_set_del_rcu);
>   }
>   

Thanks for the patch.

But this is effectively a revert of 439cd39ea136 and brings back the
problem it fixed: within the grace period after the del, userspace still
sees a stale refcount, and destroy/rename are briefly rejected as well.

Please take a look at that commit's message first.

