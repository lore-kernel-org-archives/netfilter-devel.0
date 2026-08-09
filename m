Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1BD3CAA52
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Aug 2026 10:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786272922; cv=none; b=UynAIK1tuwh/zmNFuKhtNob9W5XadzXkkEnO3UEyWdF87yleUgAhSakGk6Kpj0Y8JlGx+bgPrYP1JPMCRtZnyC9SLXwR3hifQ182CAfeLBaS5ti7q08TQC3srgl7B0ADvcnzb/OjNN1DVImoGdDpa/YC5Hfn2n+e1TvKT9edw5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786272922; c=relaxed/simple;
	bh=VlnqUl3iaZmXAwXCnN1dBaBt0KYmCZmIr1MgAPH7HpQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=gMjbjVoW5qkng6TrFdY5S35DqvJU+f8GFYwd2vdrpVtN4NmIe+zMSen4CL8g4k4WyjnGXsPDO1+Z/SjaLv2T2uR3J+4d+GbgLzK7KaNPe810YBUUYxJStbeEWaytdVT9LKGFDxBguGL30HYUZy8/O/Y/EfQWxF4B6oRM3vuOoII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4hHvt447LwzGFDCH;
	Sun, 09 Aug 2026 12:55:08 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id o8OC5FbzWX3c; Sun,  9 Aug 2026 12:55:06 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (78-131-74-220.pool.digikabel.hu [78.131.74.220])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4hHvt23dpmzGFDCG;
	Sun, 09 Aug 2026 12:55:04 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 501A9140E07; Sun,  9 Aug 2026 12:55:04 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 4D13E14053C;
	Sun,  9 Aug 2026 12:55:04 +0200 (CEST)
Date: Sun, 9 Aug 2026 12:55:04 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 0/5] netfilter: ipset fixes and rhastable prep work
In-Reply-To: <anBXgncZCSUoDSZk@strlen.de>
Message-ID: <35080efb-adee-7063-a02e-6700e99d48c1@netfilter.org>
References: <20260730183853.21868-1-fw@strlen.de> <amusRhSn19YQzmQe@strlen.de> <e7c0f855-d6bd-ce82-b223-786ed42853b7@netfilter.org> <anBXgncZCSUoDSZk@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Florian,

[Sorry for the long delay!]

On Mon, 3 Aug 2026, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > I will have another look at this to see if thats correct, in any case
> > > this should be handled in a different change.
> > 
> > I should have left out the call to atomic64_set(&set->ext_size, 0) in 
> > list_set_flush() and let the list_set_del() calls adjust the ext_size 
> > value. What do you thing, would it solve the issue?
> 
> Agree wrt. list_set_flush(), removing the explicit set should
> work.  What about:
> 
> mtype_flush(struct ip_set *set)
> {
>         struct mtype *map = set->data;
> 
>         if (set->extensions & IPSET_EXT_DESTROY)
>                 mtype_ext_cleanup(set);
>         bitmap_zero(map->members, map->elements);
>         set->elements = 0;
>         atomic64_set(&set->ext_size, 0);
> }
> 
> in ip_set_bitmap_gen.h ?
> 
> Should this be changed as well, i.e. remove atomic64_set()?
> 
> AFAICS this is harmless because its synchronous and runs with
> set->lock held, so this should set ext_size to 0 again.

Yes, it is synchronous so atomic64_set() just resets the value to zero 
again.

> Maybe this should be changed to
> 
> NET_DEBUG_WARN_ON_ONCE(atomic64_read() != 0) ?

Yes, I agree: it'd add a safety check that mtype_ext_cleanup() did the job 
properly.
 
> There is another new report:
> 
> #define INIT_CIDR(n, host_mask) ({                              \
>         const struct net_prefixes *__n = rcu_dereference(n);            \
>         DCIDR_PUT((__n)->len ? (__n)->nets[0].cidr : host_mask);\
> })
> 
> If we fail to allocate replacement net_prefix, then nets[0].count can
> be 0.  This means we either need to walk ->nets[] until we find a slot
> where count is > 0, or we need to resort to something like this:

You mean when we leave a hole in the first position? Yes, it's a corner 
case...

> [ not even compile tested! ]
> 
>  #define INIT_CIDR(n, host_mask)        \
> -       DCIDR_PUT((n)->len ? (n)->nets[0].cidr : host_mask)
> +       DCIDR_PUT((n)->len && (n)->nets[0].count ? (n)->nets[0].cidr : host_mask)
> 
>  #endif /* IP_SET_HASH_WITH_NETS */
>
> @@ -374,9 +374,20 @@ mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
>         len--;
>         tmp = kzalloc(sizeof(struct net_prefixes) +
>                       len * sizeof(struct net_prefix), GFP_ATOMIC);
> -       if (!tmp)
> -               /* Leave a hole */
> +       if (!tmp) { /* handle in-place */
> +               for (i = 0, j = 0; i < nets->len; i++) {
> +                       if (i == found)
> +                               continue;
> +                       if (i != j) {
> +                               WRITE_ONCE(nets->nets[j].cidr, nets->nets[i].cidr);
> +                               WRITE_ONCE(nets->nets[j].count, nets->nets[i].count);
> +                       }
> +                       j++;
> +               }
> +               while (j < nets->len)
> +                       WRITE_ONCE(nets->nets[j++].count, 0);
>                 goto unlock;
> +       }

... and I agree that your suggestion above is fine. We are talking about 
the case when the SET target adds/deletes an entry to/from a hash:*net* 
type of set and it should figure out the cidr value to use for the network 
address to add. The convention is "use the first, i.e. the most specific 
value from the list of already added cidr values or if (the list) is 
empty, the host_mask cidr. If the count of most specific cidr reached zero 
but the new net_prefix could not be created to remove it, it's fine to 
fall back to host_mask. Especially when the holes are moved to the end of 
the array.

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
