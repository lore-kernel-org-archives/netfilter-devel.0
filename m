Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6DF2ECE96
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 15:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763047864; cv=none; b=hq0cqf4IKPpXCf49TX2J/NVCLj/7Jznqk++jAhngAT9qRSrEYEeS4AAFFFKbvoQnxn5FNB+S8rzZ6tljVDMKJSzq7D4QXMtAT/FjVF3m4UB72UzUvOO5I4ljnS5ecBWXfr4QzGCKVQw/fKZ5wIVH54XqEXSip+l4mut5xWb0j+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763047864; c=relaxed/simple;
	bh=cLL+QJfU6/rSryWG0kNr6jJj29W3dje9rR+7Zxauf5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MpvuEL++zS5bi1OVEIiyVv0JGEok8lbqk4PgVtmQx8uFpfVmqC5VVM0bxf+as3/Whfe2BB2QbBDasfwlhBlpmDuIbRl1gUMEmkAWoOFiqSGZzMXxPDdB0MvYc11rHxp+SkVjxmuPTYVPu65tZ9LSiEV/9G0OuDhC0pO22wN2AXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R1k8FqFI; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R1k8FqFI"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-559f4801609so344462e0c.0
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 07:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763047860; x=1763652660; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xF2SVFkeCIEKSwrJ2QVnWGz6Tzdsu34uG8BCaZLxcA0=;
        b=R1k8FqFIW1yN82HFVhVVM/KXWE8FqtrL1Fjyq8rGUy13uixRqmwfQMYFREQDzSXtlI
         ZClGdFEjYhlBXZoiMSXG3EwZ6YuU/690AyLgxpByKTv1fQsy8JSDvE5+DKxVEyfSqq9r
         z1T/WCeMJhqgN+9ybZmDPDqvka94j6UeIHqAXfdFd+bD/sTv4VU3Lh3RoVayOYqWTEZk
         WLZ+VVGtMQkEHtjmQroypHgL9aMW0o7BnsTlvTycwU4pdzXxjDe4I9uHgkEZWkPZNFQP
         NobUphBixD9SwVO4mo87owChrLqwPFUG3i80nWk6VzD4flnH7LCccoRhXpl376BZrup5
         nPGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763047860; x=1763652660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xF2SVFkeCIEKSwrJ2QVnWGz6Tzdsu34uG8BCaZLxcA0=;
        b=v1HpFV6+ja8hz4wjWkF2LSZmC8wHEnSbTwEq8x2HwC9W7BANItBWL5Em7xCQMk/FlO
         OZAwjbByHAIC8yXwhSUmFTtXG7ZCx3MxCmbdmdhwkkca7dWKvJ85TwDqUwsTgnYCLNjy
         li1ajM5tRWZSdp87o0dkrh9d679MghFzjFJrPSbJlLt/CD6qsiZxOWPQQOOsI86FdCjn
         xVH+0VvYCYE5SfNFasVKTYVl5UrLM/E/JCZVU4/xamZvf6Cup7q46/40b+/gQ/gQBkaM
         Q8mGz0u4GYMyaUvBszxjlZlr3BM3UhaCmnKD1zX8IstnOQ8PoN67Te1As00M3yXSxsb+
         4yVw==
X-Forwarded-Encrypted: i=1; AJvYcCV9gMyiMu78gFgldt4encHu7MrqPWEL2dyWsXh/lOFveAtlgKR+mx0AxiUGg+Q9Updq6kKWSBQFT+ylibTaDtg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf7qONrboAiMgFF1F2ADKMawPAtsr2D2CTbueZd3Ok5I0GtlN6
	xMypgK1PYr7+NEFV0EfH6WiaFlBkIumSfF3yTaI3IW4SNwqaxpoXfoUq2l5E8zMUBOcShi1SewU
	yeP/sLDo7yigSLeDgNBRYF0KBQIUJB+g=
X-Gm-Gg: ASbGncvOim9JNgYG+XYn5P+pdyPvjmZti1ZtXfsKXtgwFR1V7OSkeasuu2WvDKoG+f3
	sWcPFaKYc3r9V0Fcq5w5p60c7NjdVYvHNe9xw87is44O6JvpH+ZIPgWxASANs1h3sibG1uUhQdy
	znN8JWZ3VUwU7WtBbj112pk5jpcQBZ41jeAjIwlvtam1MB85NdOiUJoBqltP+Y1+nldeB0O9Oli
	JKTJSLe0Xp5SuKRJSQDYBd8MjhYlAl9DEhHJi1SS3611b20YLoUZUPji75SbSLXVpQuHd9a+w==
X-Google-Smtp-Source: AGHT+IGb0OyOeZ3rJF4PQyPBEgerq/OhD2yVdHMwgMWuNlK6dT0VXBxgUF1TzUsj9RQuVBpMCDj4RG7ZEfNSSBv9GuY=
X-Received: by 2002:a05:6122:791:b0:559:3d59:1fdc with SMTP id
 71dfb90a1353d-559e7d9dfbemr3267331e0c.14.1763047859828; Thu, 13 Nov 2025
 07:30:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113092606.91406-1-scott_mitchell@apple.com> <CANn89iJAH0-6FiK-wnA=WUS8ddyQ-q2e7vfK=7-Yrqgi_HrXAQ@mail.gmail.com>
In-Reply-To: <CANn89iJAH0-6FiK-wnA=WUS8ddyQ-q2e7vfK=7-Yrqgi_HrXAQ@mail.gmail.com>
From: Scott Mitchell <scott.k.mitch1@gmail.com>
Date: Thu, 13 Nov 2025 07:30:48 -0800
X-Gm-Features: AWmQ_blLhmvcg0BMTovERebKeevypY01q9GYx5CaBw_9fIVqLTrv9PxhLLEb3M0
Message-ID: <CAFn2buAXHDcKiHyPs_7rT617j7=BopZRrMKVv5pYWNi2OxRAfQ@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
To: Eric Dumazet <edumazet@google.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Scott Mitchell <scott_mitchell@apple.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 2:25=E2=80=AFAM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Thu, Nov 13, 2025 at 1:26=E2=80=AFAM Scott Mitchell <scott.k.mitch1@gm=
ail.com> wrote:
> >
> > The current implementation uses a linear list to find queued packets by
> > ID when processing verdicts from userspace. With large queue depths and
> > out-of-order verdicting, this O(n) lookup becomes a significant
> > bottleneck, causing userspace verdict processing to dominate CPU time.
> >
> > Replace the linear search with a hash table for O(1) average-case
> > packet lookup by ID. The hash table size is configurable via the new
> > NFQA_CFG_HASH_SIZE netlink attribute (default 1024 buckets, matching
> > NFQNL_QMAX_DEFAULT; max 131072). The size is normalized to a power of
> > two to enable efficient bitwise masking instead of modulo operations.
> > Unpatched kernels silently ignore the new attribute, maintaining
> > backward compatibility.
> >
> > The existing list data structure is retained for operations requiring
> > linear iteration (e.g. flush, device down events). Hot fields
> > (queue_hash_mask, queue_hash pointer) are placed in the same cache line
> > as the spinlock and packet counters for optimal memory access patterns.
> >
> > Signed-off-by: Scott Mitchell <scott_mitchell@apple.com>
> > ---
> > Changes in v2:
> > - Use kvcalloc/kvfree with GFP_KERNEL_ACCOUNT to support larger hash
> >   tables with vmalloc fallback (Florian Westphal)
> > - Remove incorrect comment about concurrent resizes - nfnetlink subsyst=
em
> >   mutex already serializes config operations (Florian Westphal)
> > - Fix style: remove unnecessary braces around single-line if (Florian W=
estphal)
> >
> >  include/net/netfilter/nf_queue.h              |   1 +
> >  .../uapi/linux/netfilter/nfnetlink_queue.h    |   1 +
> >  net/netfilter/nfnetlink_queue.c               | 129 ++++++++++++++++--
> >  3 files changed, 123 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/n=
f_queue.h
> > index 4aeffddb7586..3d0def310523 100644
> > --- a/include/net/netfilter/nf_queue.h
> > +++ b/include/net/netfilter/nf_queue.h
> > @@ -11,6 +11,7 @@
> >  /* Each queued (to userspace) skbuff has one of these. */
> >  struct nf_queue_entry {
> >         struct list_head        list;
> > +       struct hlist_node       hash_node;
> >         struct sk_buff          *skb;
> >         unsigned int            id;
> >         unsigned int            hook_index;     /* index in hook_entrie=
s->hook[] */
> > diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/u=
api/linux/netfilter/nfnetlink_queue.h
> > index efcb7c044a74..bc296a17e5aa 100644
> > --- a/include/uapi/linux/netfilter/nfnetlink_queue.h
> > +++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
> > @@ -107,6 +107,7 @@ enum nfqnl_attr_config {
> >         NFQA_CFG_QUEUE_MAXLEN,          /* __u32 */
> >         NFQA_CFG_MASK,                  /* identify which flags to chan=
ge */
> >         NFQA_CFG_FLAGS,                 /* value of these flags (__u32)=
 */
> > +       NFQA_CFG_HASH_SIZE,             /* __u32 hash table size (round=
ed to power of 2) */
> >         __NFQA_CFG_MAX
> >  };
> >  #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
> > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_=
queue.c
> > index 8b7b39d8a109..f076609cac32 100644
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -46,7 +46,10 @@
> >  #include <net/netfilter/nf_conntrack.h>
> >  #endif
> >
> > -#define NFQNL_QMAX_DEFAULT 1024
> > +#define NFQNL_QMAX_DEFAULT      1024
> > +#define NFQNL_MIN_HASH_SIZE     16
> > +#define NFQNL_DEFAULT_HASH_SIZE 1024
> > +#define NFQNL_MAX_HASH_SIZE     131072
> >
> >  /* We're using struct nlattr which has 16bit nla_len. Note that nla_le=
n
> >   * includes the header length. Thus, the maximum packet length that we
> > @@ -65,6 +68,7 @@ struct nfqnl_instance {
> >         unsigned int copy_range;
> >         unsigned int queue_dropped;
> >         unsigned int queue_user_dropped;
> > +       unsigned int queue_hash_size;
> >
> >
> >         u_int16_t queue_num;                    /* number of this queue=
 */
> > @@ -77,6 +81,8 @@ struct nfqnl_instance {
> >         spinlock_t      lock    ____cacheline_aligned_in_smp;
> >         unsigned int    queue_total;
> >         unsigned int    id_sequence;            /* 'sequence' of pkt id=
s */
> > +       unsigned int    queue_hash_mask;
> > +       struct hlist_head *queue_hash;
> >         struct list_head queue_list;            /* packets in queue */
> >  };
> >
> > @@ -95,6 +101,39 @@ static struct nfnl_queue_net *nfnl_queue_pernet(str=
uct net *net)
> >         return net_generic(net, nfnl_queue_net_id);
> >  }
> >
> > +static inline unsigned int
> > +nfqnl_packet_hash(u32 id, unsigned int mask)
> > +{
> > +       return hash_32(id, 32) & mask;
> > +}
> > +
>
> (Resent in plaintext for the lists, sorry for duplicates)
>
> I do not think this is an efficient hash function.
>
> queue->id_sequence is monotonically increasing (controlled by the
> kernel : __nfqnl_enqueue_packet(), not user space).
>
> I would use   return (id & mask) so that we have better use of cpu
> caches and hardware prefetchers,
> in case a cpu receives a batch of ~64 packets from a busy network device.
>
> Your hash function would require 8x more cache line misses.
>

Nice improvement, done!

>
> > +static inline u32
> > +nfqnl_normalize_hash_size(u32 hash_size)
> > +{
> > +       /* Must be power of two for queue_hash_mask to work correctly.
> > +        * Avoid overflow of is_power_of_2 by bounding NFQNL_MAX_HASH_S=
IZE.
> > +        */
> > +       BUILD_BUG_ON(!is_power_of_2(NFQNL_MIN_HASH_SIZE) ||
> > +                    !is_power_of_2(NFQNL_DEFAULT_HASH_SIZE) ||
> > +                    !is_power_of_2(NFQNL_MAX_HASH_SIZE) ||
> > +                    NFQNL_MAX_HASH_SIZE > 1U << 31);
> > +
> > +       if (!hash_size)
> > +               return NFQNL_DEFAULT_HASH_SIZE;
> > +
> > +       /* Clamp to valid range before power of two to avoid overflow *=
/
> > +       if (hash_size <=3D NFQNL_MIN_HASH_SIZE)
> > +               return NFQNL_MIN_HASH_SIZE;
> > +
> > +       if (hash_size >=3D NFQNL_MAX_HASH_SIZE)
> > +               return NFQNL_MAX_HASH_SIZE;
> > +
> > +       if (!is_power_of_2(hash_size))
> > +               hash_size =3D roundup_pow_of_two(hash_size);
> > +
> > +       return hash_size;
> > +}
> > +
> >  static inline u_int8_t instance_hashfn(u_int16_t queue_num)
> >  {
> >         return ((queue_num >> 8) ^ queue_num) % INSTANCE_BUCKETS;
> > @@ -114,13 +153,56 @@ instance_lookup(struct nfnl_queue_net *q, u_int16=
_t queue_num)
> >         return NULL;
> >  }
> >
> > +static int
> > +nfqnl_hash_resize(struct nfqnl_instance *inst, u32 hash_size)
> > +{
> > +       struct hlist_head *new_hash, *old_hash;
> > +       struct nf_queue_entry *entry;
> > +       unsigned int h, hash_mask;
> > +
> > +       hash_size =3D nfqnl_normalize_hash_size(hash_size);
> > +       if (hash_size =3D=3D inst->queue_hash_size)
> > +               return 0;
> > +
> > +       new_hash =3D kvcalloc(hash_size, sizeof(*new_hash), GFP_KERNEL_=
ACCOUNT);
> > +       if (!new_hash)
> > +               return -ENOMEM;
> > +
> > +       hash_mask =3D hash_size - 1;
> > +
> > +       for (h =3D 0; h < hash_size; h++)
> > +               INIT_HLIST_HEAD(&new_hash[h]);
> > +
> > +       spin_lock_bh(&inst->lock);
> > +
> > +       list_for_each_entry(entry, &inst->queue_list, list) {
> > +               /* No hlist_del() since old_hash will be freed and we h=
old lock */
> > +               h =3D nfqnl_packet_hash(entry->id, hash_mask);
> > +               hlist_add_head(&entry->hash_node, &new_hash[h]);
> > +       }
> > +
> > +       old_hash =3D inst->queue_hash;
> > +       inst->queue_hash_size =3D hash_size;
> > +       inst->queue_hash_mask =3D hash_mask;
> > +       inst->queue_hash =3D new_hash;
> > +
> > +       spin_unlock_bh(&inst->lock);
> > +
> > +       kvfree(old_hash);
> > +
> > +       return 0;
> > +}
> > +
> >  static struct nfqnl_instance *
> > -instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 por=
tid)
> > +instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 por=
tid,
> > +               u32 hash_size)
> >  {
> >         struct nfqnl_instance *inst;
> >         unsigned int h;
> >         int err;
> >
> > +       hash_size =3D nfqnl_normalize_hash_size(hash_size);
> > +
> >         spin_lock(&q->instances_lock);
> >         if (instance_lookup(q, queue_num)) {
> >                 err =3D -EEXIST;
> > @@ -133,11 +215,24 @@ instance_create(struct nfnl_queue_net *q, u_int16=
_t queue_num, u32 portid)
> >                 goto out_unlock;
> >         }
> >
> > +       inst->queue_hash =3D kvcalloc(hash_size, sizeof(*inst->queue_ha=
sh),
> > +                                   GFP_KERNEL_ACCOUNT);
> > +       if (!inst->queue_hash) {
> > +               kfree(inst);
> > +               err =3D -ENOMEM;
> > +               goto out_unlock;
> > +       }
> > +
> > +       for (h =3D 0; h < hash_size; h++)
> > +               INIT_HLIST_HEAD(&inst->queue_hash[h]);
> > +
> >         inst->queue_num =3D queue_num;
> >         inst->peer_portid =3D portid;
> >         inst->queue_maxlen =3D NFQNL_QMAX_DEFAULT;
> >         inst->copy_range =3D NFQNL_MAX_COPY_RANGE;
> >         inst->copy_mode =3D NFQNL_COPY_NONE;
> > +       inst->queue_hash_size =3D hash_size;
> > +       inst->queue_hash_mask =3D hash_size - 1;
> >         spin_lock_init(&inst->lock);
> >         INIT_LIST_HEAD(&inst->queue_list);
> >
> > @@ -154,6 +249,7 @@ instance_create(struct nfnl_queue_net *q, u_int16_t=
 queue_num, u32 portid)
> >         return inst;
> >
> >  out_free:
> > +       kvfree(inst->queue_hash);
> >         kfree(inst);
> >  out_unlock:
> >         spin_unlock(&q->instances_lock);
> > @@ -172,6 +268,7 @@ instance_destroy_rcu(struct rcu_head *head)
> >         rcu_read_lock();
> >         nfqnl_flush(inst, NULL, 0);
> >         rcu_read_unlock();
> > +       kvfree(inst->queue_hash);
> >         kfree(inst);
> >         module_put(THIS_MODULE);
> >  }
> > @@ -194,13 +291,17 @@ instance_destroy(struct nfnl_queue_net *q, struct=
 nfqnl_instance *inst)
> >  static inline void
> >  __enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *e=
ntry)
> >  {
> > -       list_add_tail(&entry->list, &queue->queue_list);
> > -       queue->queue_total++;
> > +       unsigned int hash =3D nfqnl_packet_hash(entry->id, queue->queue=
_hash_mask);
> > +
> > +       hlist_add_head(&entry->hash_node, &queue->queue_hash[hash]);
> > +       list_add_tail(&entry->list, &queue->queue_list);
> > +       queue->queue_total++;
> >  }
> >
> >  static void
> >  __dequeue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *e=
ntry)
> >  {
> > +       hlist_del(&entry->hash_node);
> >         list_del(&entry->list);
> >         queue->queue_total--;
> >  }
> > @@ -209,10 +310,11 @@ static struct nf_queue_entry *
> >  find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
> >  {
> >         struct nf_queue_entry *entry =3D NULL, *i;
> > +       unsigned int hash =3D nfqnl_packet_hash(id, queue->queue_hash_m=
ask);
> >
> >         spin_lock_bh(&queue->lock);
> >
> > -       list_for_each_entry(i, &queue->queue_list, list) {
> > +       hlist_for_each_entry(i, &queue->queue_hash[hash], hash_node) {
> >                 if (i->id =3D=3D id) {
> >                         entry =3D i;
> >                         break;
> > @@ -407,8 +509,7 @@ nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmp=
fn cmpfn, unsigned long data)
> >         spin_lock_bh(&queue->lock);
> >         list_for_each_entry_safe(entry, next, &queue->queue_list, list)=
 {
> >                 if (!cmpfn || cmpfn(entry, data)) {
> > -                       list_del(&entry->list);
> > -                       queue->queue_total--;
> > +                       __dequeue_entry(queue, entry);
> >                         nfqnl_reinject(entry, NF_DROP);
> >                 }
> >         }
> > @@ -1483,6 +1584,7 @@ static const struct nla_policy nfqa_cfg_policy[NF=
QA_CFG_MAX+1] =3D {
> >         [NFQA_CFG_QUEUE_MAXLEN] =3D { .type =3D NLA_U32 },
> >         [NFQA_CFG_MASK]         =3D { .type =3D NLA_U32 },
> >         [NFQA_CFG_FLAGS]        =3D { .type =3D NLA_U32 },
> > +       [NFQA_CFG_HASH_SIZE]    =3D { .type =3D NLA_U32 },
> >  };
> >
> >  static const struct nf_queue_handler nfqh =3D {
> > @@ -1495,11 +1597,15 @@ static int nfqnl_recv_config(struct sk_buff *sk=
b, const struct nfnl_info *info,
> >  {
> >         struct nfnl_queue_net *q =3D nfnl_queue_pernet(info->net);
> >         u_int16_t queue_num =3D ntohs(info->nfmsg->res_id);
> > +       u32 hash_size =3D 0;
> >         struct nfqnl_msg_config_cmd *cmd =3D NULL;
> >         struct nfqnl_instance *queue;
> >         __u32 flags =3D 0, mask =3D 0;
> >         int ret =3D 0;
> >
> > +       if (nfqa[NFQA_CFG_HASH_SIZE])
> > +               hash_size =3D ntohl(nla_get_be32(nfqa[NFQA_CFG_HASH_SIZ=
E]));
> > +
> >         if (nfqa[NFQA_CFG_CMD]) {
> >                 cmd =3D nla_data(nfqa[NFQA_CFG_CMD]);
> >
> > @@ -1559,11 +1665,12 @@ static int nfqnl_recv_config(struct sk_buff *sk=
b, const struct nfnl_info *info,
> >                                 goto err_out_unlock;
> >                         }
> >                         queue =3D instance_create(q, queue_num,
> > -                                               NETLINK_CB(skb).portid)=
;
> > +                                               NETLINK_CB(skb).portid,=
 hash_size);
> >                         if (IS_ERR(queue)) {
> >                                 ret =3D PTR_ERR(queue);
> >                                 goto err_out_unlock;
> >                         }
> > +                       hash_size =3D 0; /* avoid resize later in this =
function */
> >                         break;
> >                 case NFQNL_CFG_CMD_UNBIND:
> >                         if (!queue) {
> > @@ -1586,6 +1693,12 @@ static int nfqnl_recv_config(struct sk_buff *skb=
, const struct nfnl_info *info,
> >                 goto err_out_unlock;
> >         }
> >
> > +       if (hash_size > 0) {
> > +               ret =3D nfqnl_hash_resize(queue, hash_size);
> > +               if (ret)
> > +                       goto err_out_unlock;
> > +       }
> > +
> >         if (nfqa[NFQA_CFG_PARAMS]) {
> >                 struct nfqnl_msg_config_params *params =3D
> >                         nla_data(nfqa[NFQA_CFG_PARAMS]);
> > --
> > 2.39.5 (Apple Git-154)
> >
