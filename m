Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CA93246FE
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2026 10:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777027161; cv=none; b=UDKwzSiCnQsopFiimT7aUk0MBxrblYqCaE+D9bqDiPmXMTc3Fa85IpqNFbahxOMGBoOPVzy1167aAtu1VNuR9wFIHjD59UBU97/YCDWIErz7sgKCtytrjDw3woCkqchnp2scUC4G1lMmAfLNnku8EUAFy//1GHZjKzyak14j9LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777027161; c=relaxed/simple;
	bh=0jRdgofD41sdUg1MZut9lYtOvaJHnjNMV5kyTfo63W8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=JTkulLXmtoIQTS+xEEXGyo2M1zKY29XSZbyY+wg3iTydJ/IYq4IAxUErTw0c/AT0lVzhesK1d++7ltP9SKlZrH5Z3mXHUHzrMkA83bRmLajDd9k6l4dUoB2exlhZpx6Ht9rxVXp2CVWlWft7yxR9nDG6sjwUAw2oymaZx2zoh4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=Elo9OWnB; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="Elo9OWnB"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4g28Mm4thMz3sbBf;
	Fri, 24 Apr 2026 12:29:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1777026562; x=1778840963; bh=zq9k+lSAmJ
	jFP95mPGnlJzwJTFnmmg2f6oZBsnu/hB0=; b=Elo9OWnBEGt3oHGoekOrkQlv2r
	5H8FuC4PVU9R5T9vfKoc4NjcH9Xru9hNTo6/DLalwJPJIY+vwTJH3NVZj1fXawXC
	hPb0ioMJYRQkbz5+ornj3q+uK/CBz5DPKT88l0Zdyuxq104HHNtHR36gL7e6ayjU
	tnNeyc2HS7PScup8I=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 9nshsPDRJOMB; Fri, 24 Apr 2026 12:29:22 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4g28Mj0t9fz3sbBH;
	Fri, 24 Apr 2026 12:29:20 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id A50EE34316A; Fri, 24 Apr 2026 12:29:20 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id A33ED340D75;
	Fri, 24 Apr 2026 12:29:20 +0200 (CEST)
Date: Fri, 24 Apr 2026 12:29:20 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Ren Wei <n05ec@lzu.edu.cn>
cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, 
    phil@nwl.cc, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
    pabeni@redhat.com, horms@kernel.org, kees@kernel.org, yuantan098@gmail.com, 
    kadlec@netfilter.org, yifanwucs@gmail.com, zhen.ni@easystack.cn, 
    tomapufckgml@gmail.com, bird@lzu.edu.cn, zcliangcn@gmail.com
Subject: Re: [PATCH nf 1/1] netfilter: ipset: keep comment extensions private
 on resize
In-Reply-To: <aa7edd8cd7d1c5d337d5b6bfb0747d1829862296.1776819297.git.zcliangcn@gmail.com>
Message-ID: <4dfcf8f6-0121-109b-83ee-c68fd06010c7@blackhole.kfki.hu>
References: <cover.1776819297.git.zcliangcn@gmail.com> <aa7edd8cd7d1c5d337d5b6bfb0747d1829862296.1776819297.git.zcliangcn@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi,

On Wed, 22 Apr 2026, Ren Wei wrote:

> From: Zhengchuan Liang <zcliangcn@gmail.com>
>
> Hash resize rebuilds the table by copying live elements into a new
> table, while comment data is stored outside of the element body.
>
> Recreate the comment extension for resized entries so the new table
> does not share comment storage with the retired table. Once resize
> gives each table its own comment data again, the old table can return
> to destroying its extensions in the normal teardown paths.
>
> This keeps comment lifetime and accounting consistent across resize
> and the follow-up gc, dump, add, del and flush paths.

I appreciate your patch and it solves the issue but I think it's not 
optimal.

Could you rework it to use the 'struct list_head ad' add|del backlist 
infrastructure of the hash types which handles the added/deleted entries 
during resizing, but the proper handling of the comment extension for 
deleted elements is missing. That way the unnecessary 
allocation/deallocation of the comment extension of all set element can be 
avoided.

Best regards,
Jozsef

> Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
> Cc: stable@kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
> include/linux/netfilter/ipset/ip_set.h |  1 +
> net/netfilter/ipset/ip_set_core.c      | 36 ++++++++++++++++++++++++++
> net/netfilter/ipset/ip_set_hash_gen.h  | 15 ++++++-----
> 3 files changed, 46 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
> index b98331572ad2..c3620899744c 100644
> --- a/include/linux/netfilter/ipset/ip_set.h
> +++ b/include/linux/netfilter/ipset/ip_set.h
> @@ -336,6 +336,7 @@ extern size_t ip_set_elem_len(struct ip_set *set, struct nlattr *tb[],
> 			      size_t len, size_t align);
> extern int ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
> 				 struct ip_set_ext *ext);
> +extern int ip_set_ext_copy(struct ip_set *set, void *dst, const void *src);
> extern int ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
> 				 const void *e, bool active);
> extern bool ip_set_match_extensions(struct ip_set *set,
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index c5a26236a0bb..0f5994ffec96 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -367,6 +367,42 @@ ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
> }
> EXPORT_SYMBOL_GPL(ip_set_init_comment);
>
> +static int
> +ip_set_copy_comment(struct ip_set *set, struct ip_set_comment *dst,
> +		    const struct ip_set_comment *src)
> +{
> +	struct ip_set_comment_rcu *c, *newc;
> +	size_t len;
> +
> +	RCU_INIT_POINTER(dst->c, NULL);
> +
> +	c = rcu_dereference_bh(src->c);
> +	if (!c)
> +		return 0;
> +
> +	len = strlen(c->str);
> +	newc = kmalloc(sizeof(*newc) + len + 1, GFP_ATOMIC);
> +	if (unlikely(!newc))
> +		return -ENOMEM;
> +
> +	memcpy(newc->str, c->str, len + 1);
> +	set->ext_size += sizeof(*newc) + len + 1;
> +	rcu_assign_pointer(dst->c, newc);
> +
> +	return 0;
> +}
> +
> +int
> +ip_set_ext_copy(struct ip_set *set, void *dst, const void *src)
> +{
> +	if (SET_WITH_COMMENT(set))
> +		return ip_set_copy_comment(set, ext_comment(dst, set),
> +					   ext_comment(src, set));
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ip_set_ext_copy);
> +
> /* Used only when dumping a set, protected by rcu_read_lock() */
> static int
> ip_set_put_comment(struct sk_buff *skb, const struct ip_set_comment *comment)
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index b79e5dd2af03..b937a478f5ac 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -584,7 +584,7 @@ mtype_gc(struct work_struct *work)
>
> 	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
> 		pr_debug("Table destroy after resize by expire: %p\n", t);
> -		mtype_ahash_destroy(set, t, false);
> +		mtype_ahash_destroy(set, t, true);
> 	}
>
> 	queue_delayed_work(system_power_efficient_wq, &gc->dwork, next_run);
> @@ -743,6 +743,9 @@ mtype_resize(struct ip_set *set, bool retried)
> 				}
> 				d = ahash_data(m, m->pos, dsize);
> 				memcpy(d, data, dsize);
> +				ret = ip_set_ext_copy(set, d, data);
> +				if (ret < 0)
> +					goto cleanup;
> 				set_bit(m->pos++, m->used);
> 				t->hregion[nr].elements++;
> #ifdef IP_SET_HASH_WITH_NETS
> @@ -778,7 +781,7 @@ mtype_resize(struct ip_set *set, bool retried)
> 	/* If there's nobody else using the table, destroy it */
> 	if (atomic_dec_and_test(&orig->uref)) {
> 		pr_debug("Table destroy by resize %p\n", orig);
> -		mtype_ahash_destroy(set, orig, false);
> +		mtype_ahash_destroy(set, orig, true);
> 	}
>
> out:
> @@ -791,7 +794,7 @@ mtype_resize(struct ip_set *set, bool retried)
> 	rcu_read_unlock_bh();
> 	atomic_set(&orig->ref, 0);
> 	atomic_dec(&orig->uref);
> -	mtype_ahash_destroy(set, t, false);
> +	mtype_ahash_destroy(set, t, true);
> 	if (ret == -EAGAIN)
> 		goto retry;
> 	goto out;
> @@ -1023,7 +1026,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> out:
> 	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
> 		pr_debug("Table destroy after resize by add: %p\n", t);
> -		mtype_ahash_destroy(set, t, false);
> +		mtype_ahash_destroy(set, t, true);
> 	}
> 	return ret;
> }
> @@ -1135,7 +1138,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> 	}
> 	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
> 		pr_debug("Table destroy after resize by del: %p\n", t);
> -		mtype_ahash_destroy(set, t, false);
> +		mtype_ahash_destroy(set, t, true);
> 	}
> 	return ret;
> }
> @@ -1341,7 +1344,7 @@ mtype_uref(struct ip_set *set, struct netlink_callback *cb, bool start)
> 		if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
> 			pr_debug("Table destroy after resize "
> 				 " by dump: %p\n", t);
> -			mtype_ahash_destroy(set, t, false);
> +			mtype_ahash_destroy(set, t, true);
> 		}
> 		cb->args[IPSET_CB_PRIVATE] = 0;
> 	}
> -- 
> 2.39.5
>
>
