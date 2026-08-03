Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632ED389106
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Aug 2026 08:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785747341; cv=none; b=AsNWPVY+WOXPJ2BxfrHh95OmPJHlcERbzj8Vf3qgeZashxgBc8vhwWdQWuhCfVCnWkeVm5lyumlxOYbLZjSQ5qanBsvwJvp+w/rPK2RklfRQ4FMFMBBsoxF+WcPITs0ZfaxO3dRYdpWNCwV3FFa2Ap63rL/F3LsimvBTjHavS9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785747341; c=relaxed/simple;
	bh=JZ/r6AOWx/g8W7hVpQGGqyG4PUTOYsj4buQkhaUhPb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ODD9Mdc13uHKWadhdwpszo9wTHciwFsD4BkUcD4yjva+jLM0tv4k+YsI5Uv48zwGKh2hESh6EF8sZsGiKrTyiD+f2rHvj+OIL1QbIJ1v49Th0PiydhNvlN/YUfVT56nJk3s2w/qIrduTw2+3Ofjyo51oB0Z81tKpZvp25LYnFcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 42ADC6059E; Mon, 03 Aug 2026 10:55:37 +0200 (CEST)
Date: Mon, 3 Aug 2026 10:55:37 +0200
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 0/5] netfilter: ipset fixes and rhastable prep work
Message-ID: <anBXgncZCSUoDSZk@strlen.de>
References: <20260730183853.21868-1-fw@strlen.de>
 <amusRhSn19YQzmQe@strlen.de>
 <e7c0f855-d6bd-ce82-b223-786ed42853b7@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7c0f855-d6bd-ce82-b223-786ed42853b7@netfilter.org>

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > I will have another look at this to see if thats correct, in any case
> > this should be handled in a different change.
> 
> I should have left out the call to atomic64_set(&set->ext_size, 0) in 
> list_set_flush() and let the list_set_del() calls adjust the ext_size 
> value. What do you thing, would it solve the issue?

Agree wrt. list_set_flush(), removing the explicit set should
work.  What about:

mtype_flush(struct ip_set *set)
{
        struct mtype *map = set->data;

        if (set->extensions & IPSET_EXT_DESTROY)
                mtype_ext_cleanup(set);
        bitmap_zero(map->members, map->elements);
        set->elements = 0;
        atomic64_set(&set->ext_size, 0);
}

in ip_set_bitmap_gen.h ?

Should this be changed as well, i.e. remove atomic64_set()?

AFAICS this is harmless because its synchronous and runs with
set->lock held, so this should set ext_size to 0 again.

Maybe this should be changed to

NET_DEBUG_WARN_ON_ONCE(atomic64_read() != 0) ?

There is another new report:

#define INIT_CIDR(n, host_mask) ({                              \
        const struct net_prefixes *__n = rcu_dereference(n);            \
        DCIDR_PUT((__n)->len ? (__n)->nets[0].cidr : host_mask);\
})

If we fail to allocate replacement net_prefix, then nets[0].count can
be 0.  This means we either need to walk ->nets[] until we find a slot
where count is > 0, or we need to resort to something like this:

[ not even compile tested! ]

 #define INIT_CIDR(n, host_mask)        \
-       DCIDR_PUT((n)->len ? (n)->nets[0].cidr : host_mask)
+       DCIDR_PUT((n)->len && (n)->nets[0].count ? (n)->nets[0].cidr : host_mask)

 #endif /* IP_SET_HASH_WITH_NETS */

@@ -374,9 +374,20 @@ mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
        len--;
        tmp = kzalloc(sizeof(struct net_prefixes) +
                      len * sizeof(struct net_prefix), GFP_ATOMIC);
-       if (!tmp)
-               /* Leave a hole */
+       if (!tmp) { /* handle in-place */
+               for (i = 0, j = 0; i < nets->len; i++) {
+                       if (i == found)
+                               continue;
+                       if (i != j) {
+                               WRITE_ONCE(nets->nets[j].cidr, nets->nets[i].cidr);
+                               WRITE_ONCE(nets->nets[j].count, nets->nets[i].count);
+                       }
+                       j++;
+               }
+               while (j < nets->len)
+                       WRITE_ONCE(nets->nets[j++].count, 0);
                goto unlock;
+       }
