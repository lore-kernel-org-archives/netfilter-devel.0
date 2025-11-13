Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7695B2E11D7
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 10:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763029538; cv=none; b=pVVtYQXA6xl+INn5hJu3DRY4iGIlpp/N4Y2m6Q3pS7+kx8Id/quaSjKHIBI6IgeC3LDSghGjTIj2YYU6jemHY1hPPbHzTHwjGYHsF0Ls0bU+JJlMIkDyXSQMufyGR1iW5TawAvLOP6ZdAYpxt1lV5BhHT7FgK0DCjUxIhiSy1yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763029538; c=relaxed/simple;
	bh=aH5rpD0CSM0ilgrGAhZvKLz05628GUg4OJyEeEY3QUM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m2+qThUXCPq4Cyt77lxU+LBryZbwxHGe2AiPgt1vW7oHfUgzkKtrtwtXwZRjgHtv35hIK9ozSYWBQDhOFwgzepuYlN/Vx0GL1VEWwW0l2BZmJtm3Kb25h8Gk+ppckwUA2g7fvdejeq4FIxR3CruJ26DIUqiRPkNr3XFDL0oqZes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M3Dj0lM/; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M3Dj0lM/"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8b2a4b6876fso89360485a.3
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 02:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763029535; x=1763634335; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LxbCJsnQqpyHMhLDpT/LiawaPufi/zcLwtckDWnZsq4=;
        b=M3Dj0lM/3nDBzbqZreUJdXJhDMfojz1uFRDZVJYN31I8orB/iIuDnhsb8XcM8nj+4H
         E0FPNiosRcXhrdrvMvJQVVSeHPGQfS7MzJwroT2tpjA3lUxpgfk3iMAG0Z0weoEDXKsM
         cb8YfatmxkV+be4fCae+kQ41UWJ9/kLXPZrSWhzLGLlidGy+6J6iN/h7OZGMn8nYXkID
         OJ5FU00Yt1Y7aT6EM7Hucafuu4IU3dJWH7LXswpUu0Kg+2zdo9S0CJnS5CY7T6L8a6by
         wg9JYCociCk6HSnJX3lU3eY8JU/9aBVaD7s1iQCQvpob3s87s9LoqfGTo4TM6ADGhZfQ
         74sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763029535; x=1763634335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LxbCJsnQqpyHMhLDpT/LiawaPufi/zcLwtckDWnZsq4=;
        b=erIH4sYyPhDsTneZuezEB4kykMopbrqMywqXTINQi+V+3qUslauv0uDipsS7ZS8CVR
         AQ/WMohkvw5vJpy9uGl1YASEVSvTcBdqRQJGmwVEzjCdCqhgjvyv8VtNLld26MRgqROC
         lqb556+pIBAWj0DZprKMwNgxww6KkdUzx/tWv9cepUg46ggMZPPj60KfI/DmfaESrtXs
         THqnSa4msQQsN/URV0ayto5ub24LsZmQn94bJiFffGIw0MXYIHSvSenduDP/WXDGK5M5
         ICg2jc8QDpsQ2Qa/gQga9Tsc1to8rm/SGyJ49FVajw1sgy7dOSUAsROGjC/f3nY3UICe
         toKw==
X-Forwarded-Encrypted: i=1; AJvYcCVUgIJRmPt5UICvzmc3HvpieKt6UhrHBhVrasdNyAGoX84quddQ9i868vVfnB6mHv/0VuSXKTR2mrYFR6/xpgE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHgHwyq8IpihMQIoRdTrhYmcpNoXadOfL/iu5VA2a4NNitEx3E
	LQu+aS/39yb378IJ9Bg6qtRxopj5jJT9wT5fAVoIhy+cVS/NpQhwYpWh7Mu6P1eSN64HBaq6iy5
	OY6+6ydjC4wyJFI8SBe4wGHA6g8IQNStjn48FOSwj
X-Gm-Gg: ASbGnctmZshDSxVWdrau0XIiTpahkpCYktSLZYk2jbbgxPRsLy4dqWAPOpT942unMkM
	eZm+I/2EjjuKwbGgWesr0maXH2QEJoRAF3bp30GIiXVcnQtdQtCrZ+UXI2Fh9tdG8KI1yHFMraK
	SYnxC1YAgFMh4yJWn4zgLk1jYOioZk33W854WXLnziy0sEKEvP8XJMvhgLobCxjSVNvM4s4UxQ2
	JVphPm+BiG3+BvmOz34Oo3Z2F34Idc+2yjDAz8vomisIDNbSpQxJ/Ab67rDfxpOckyZa+IMKKZR
	3rM=
X-Google-Smtp-Source: AGHT+IE1p16rCG95Lk56iPp318mizgbsJa9WfQwtgfs7boT6IWwGbfEBGUUMO5XgkEJaotAF2sFBHvHwALSd+dqLNs0=
X-Received: by 2002:a05:620a:4112:b0:8b2:1f8d:f115 with SMTP id
 af79cd13be357-8b29b7df2f6mr871444685a.65.1763029534966; Thu, 13 Nov 2025
 02:25:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113092606.91406-1-scott_mitchell@apple.com>
In-Reply-To: <20251113092606.91406-1-scott_mitchell@apple.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 13 Nov 2025 02:25:24 -0800
X-Gm-Features: AWmQ_bkcJa76VC8K88WzD96TmkoMJTfngyd-xFZypacyaJ8EJvpRTfoChfhs6nk
Message-ID: <CANn89iJAH0-6FiK-wnA=WUS8ddyQ-q2e7vfK=7-Yrqgi_HrXAQ@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Scott Mitchell <scott_mitchell@apple.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 1:26=E2=80=AFAM Scott Mitchell <scott.k.mitch1@gmai=
l.com> wrote:
>
> The current implementation uses a linear list to find queued packets by
> ID when processing verdicts from userspace. With large queue depths and
> out-of-order verdicting, this O(n) lookup becomes a significant
> bottleneck, causing userspace verdict processing to dominate CPU time.
>
> Replace the linear search with a hash table for O(1) average-case
> packet lookup by ID. The hash table size is configurable via the new
> NFQA_CFG_HASH_SIZE netlink attribute (default 1024 buckets, matching
> NFQNL_QMAX_DEFAULT; max 131072). The size is normalized to a power of
> two to enable efficient bitwise masking instead of modulo operations.
> Unpatched kernels silently ignore the new attribute, maintaining
> backward compatibility.
>
> The existing list data structure is retained for operations requiring
> linear iteration (e.g. flush, device down events). Hot fields
> (queue_hash_mask, queue_hash pointer) are placed in the same cache line
> as the spinlock and packet counters for optimal memory access patterns.
>
> Signed-off-by: Scott Mitchell <scott_mitchell@apple.com>
> ---
> Changes in v2:
> - Use kvcalloc/kvfree with GFP_KERNEL_ACCOUNT to support larger hash
>   tables with vmalloc fallback (Florian Westphal)
> - Remove incorrect comment about concurrent resizes - nfnetlink subsystem
>   mutex already serializes config operations (Florian Westphal)
> - Fix style: remove unnecessary braces around single-line if (Florian Wes=
tphal)
>
>  include/net/netfilter/nf_queue.h              |   1 +
>  .../uapi/linux/netfilter/nfnetlink_queue.h    |   1 +
>  net/netfilter/nfnetlink_queue.c               | 129 ++++++++++++++++--
>  3 files changed, 123 insertions(+), 8 deletions(-)
>
> diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_=
queue.h
> index 4aeffddb7586..3d0def310523 100644
> --- a/include/net/netfilter/nf_queue.h
> +++ b/include/net/netfilter/nf_queue.h
> @@ -11,6 +11,7 @@
>  /* Each queued (to userspace) skbuff has one of these. */
>  struct nf_queue_entry {
>         struct list_head        list;
> +       struct hlist_node       hash_node;
>         struct sk_buff          *skb;
>         unsigned int            id;
>         unsigned int            hook_index;     /* index in hook_entries-=
>hook[] */
> diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uap=
i/linux/netfilter/nfnetlink_queue.h
> index efcb7c044a74..bc296a17e5aa 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_queue.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
> @@ -107,6 +107,7 @@ enum nfqnl_attr_config {
>         NFQA_CFG_QUEUE_MAXLEN,          /* __u32 */
>         NFQA_CFG_MASK,                  /* identify which flags to change=
 */
>         NFQA_CFG_FLAGS,                 /* value of these flags (__u32) *=
/
> +       NFQA_CFG_HASH_SIZE,             /* __u32 hash table size (rounded=
 to power of 2) */
>         __NFQA_CFG_MAX
>  };
>  #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_qu=
eue.c
> index 8b7b39d8a109..f076609cac32 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -46,7 +46,10 @@
>  #include <net/netfilter/nf_conntrack.h>
>  #endif
>
> -#define NFQNL_QMAX_DEFAULT 1024
> +#define NFQNL_QMAX_DEFAULT      1024
> +#define NFQNL_MIN_HASH_SIZE     16
> +#define NFQNL_DEFAULT_HASH_SIZE 1024
> +#define NFQNL_MAX_HASH_SIZE     131072
>
>  /* We're using struct nlattr which has 16bit nla_len. Note that nla_len
>   * includes the header length. Thus, the maximum packet length that we
> @@ -65,6 +68,7 @@ struct nfqnl_instance {
>         unsigned int copy_range;
>         unsigned int queue_dropped;
>         unsigned int queue_user_dropped;
> +       unsigned int queue_hash_size;
>
>
>         u_int16_t queue_num;                    /* number of this queue *=
/
> @@ -77,6 +81,8 @@ struct nfqnl_instance {
>         spinlock_t      lock    ____cacheline_aligned_in_smp;
>         unsigned int    queue_total;
>         unsigned int    id_sequence;            /* 'sequence' of pkt ids =
*/
> +       unsigned int    queue_hash_mask;
> +       struct hlist_head *queue_hash;
>         struct list_head queue_list;            /* packets in queue */
>  };
>
> @@ -95,6 +101,39 @@ static struct nfnl_queue_net *nfnl_queue_pernet(struc=
t net *net)
>         return net_generic(net, nfnl_queue_net_id);
>  }
>
> +static inline unsigned int
> +nfqnl_packet_hash(u32 id, unsigned int mask)
> +{
> +       return hash_32(id, 32) & mask;
> +}
> +

(Resent in plaintext for the lists, sorry for duplicates)

I do not think this is an efficient hash function.

queue->id_sequence is monotonically increasing (controlled by the
kernel : __nfqnl_enqueue_packet(), not user space).

I would use   return (id & mask) so that we have better use of cpu
caches and hardware prefetchers,
in case a cpu receives a batch of ~64 packets from a busy network device.

Your hash function would require 8x more cache line misses.


> +static inline u32
> +nfqnl_normalize_hash_size(u32 hash_size)
> +{
> +       /* Must be power of two for queue_hash_mask to work correctly.
> +        * Avoid overflow of is_power_of_2 by bounding NFQNL_MAX_HASH_SIZ=
E.
> +        */
> +       BUILD_BUG_ON(!is_power_of_2(NFQNL_MIN_HASH_SIZE) ||
> +                    !is_power_of_2(NFQNL_DEFAULT_HASH_SIZE) ||
> +                    !is_power_of_2(NFQNL_MAX_HASH_SIZE) ||
> +                    NFQNL_MAX_HASH_SIZE > 1U << 31);
> +
> +       if (!hash_size)
> +               return NFQNL_DEFAULT_HASH_SIZE;
> +
> +       /* Clamp to valid range before power of two to avoid overflow */
> +       if (hash_size <=3D NFQNL_MIN_HASH_SIZE)
> +               return NFQNL_MIN_HASH_SIZE;
> +
> +       if (hash_size >=3D NFQNL_MAX_HASH_SIZE)
> +               return NFQNL_MAX_HASH_SIZE;
> +
> +       if (!is_power_of_2(hash_size))
> +               hash_size =3D roundup_pow_of_two(hash_size);
> +
> +       return hash_size;
> +}
> +
>  static inline u_int8_t instance_hashfn(u_int16_t queue_num)
>  {
>         return ((queue_num >> 8) ^ queue_num) % INSTANCE_BUCKETS;
> @@ -114,13 +153,56 @@ instance_lookup(struct nfnl_queue_net *q, u_int16_t=
 queue_num)
>         return NULL;
>  }
>
> +static int
> +nfqnl_hash_resize(struct nfqnl_instance *inst, u32 hash_size)
> +{
> +       struct hlist_head *new_hash, *old_hash;
> +       struct nf_queue_entry *entry;
> +       unsigned int h, hash_mask;
> +
> +       hash_size =3D nfqnl_normalize_hash_size(hash_size);
> +       if (hash_size =3D=3D inst->queue_hash_size)
> +               return 0;
> +
> +       new_hash =3D kvcalloc(hash_size, sizeof(*new_hash), GFP_KERNEL_AC=
COUNT);
> +       if (!new_hash)
> +               return -ENOMEM;
> +
> +       hash_mask =3D hash_size - 1;
> +
> +       for (h =3D 0; h < hash_size; h++)
> +               INIT_HLIST_HEAD(&new_hash[h]);
> +
> +       spin_lock_bh(&inst->lock);
> +
> +       list_for_each_entry(entry, &inst->queue_list, list) {
> +               /* No hlist_del() since old_hash will be freed and we hol=
d lock */
> +               h =3D nfqnl_packet_hash(entry->id, hash_mask);
> +               hlist_add_head(&entry->hash_node, &new_hash[h]);
> +       }
> +
> +       old_hash =3D inst->queue_hash;
> +       inst->queue_hash_size =3D hash_size;
> +       inst->queue_hash_mask =3D hash_mask;
> +       inst->queue_hash =3D new_hash;
> +
> +       spin_unlock_bh(&inst->lock);
> +
> +       kvfree(old_hash);
> +
> +       return 0;
> +}
> +
>  static struct nfqnl_instance *
> -instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 porti=
d)
> +instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 porti=
d,
> +               u32 hash_size)
>  {
>         struct nfqnl_instance *inst;
>         unsigned int h;
>         int err;
>
> +       hash_size =3D nfqnl_normalize_hash_size(hash_size);
> +
>         spin_lock(&q->instances_lock);
>         if (instance_lookup(q, queue_num)) {
>                 err =3D -EEXIST;
> @@ -133,11 +215,24 @@ instance_create(struct nfnl_queue_net *q, u_int16_t=
 queue_num, u32 portid)
>                 goto out_unlock;
>         }
>
> +       inst->queue_hash =3D kvcalloc(hash_size, sizeof(*inst->queue_hash=
),
> +                                   GFP_KERNEL_ACCOUNT);
> +       if (!inst->queue_hash) {
> +               kfree(inst);
> +               err =3D -ENOMEM;
> +               goto out_unlock;
> +       }
> +
> +       for (h =3D 0; h < hash_size; h++)
> +               INIT_HLIST_HEAD(&inst->queue_hash[h]);
> +
>         inst->queue_num =3D queue_num;
>         inst->peer_portid =3D portid;
>         inst->queue_maxlen =3D NFQNL_QMAX_DEFAULT;
>         inst->copy_range =3D NFQNL_MAX_COPY_RANGE;
>         inst->copy_mode =3D NFQNL_COPY_NONE;
> +       inst->queue_hash_size =3D hash_size;
> +       inst->queue_hash_mask =3D hash_size - 1;
>         spin_lock_init(&inst->lock);
>         INIT_LIST_HEAD(&inst->queue_list);
>
> @@ -154,6 +249,7 @@ instance_create(struct nfnl_queue_net *q, u_int16_t q=
ueue_num, u32 portid)
>         return inst;
>
>  out_free:
> +       kvfree(inst->queue_hash);
>         kfree(inst);
>  out_unlock:
>         spin_unlock(&q->instances_lock);
> @@ -172,6 +268,7 @@ instance_destroy_rcu(struct rcu_head *head)
>         rcu_read_lock();
>         nfqnl_flush(inst, NULL, 0);
>         rcu_read_unlock();
> +       kvfree(inst->queue_hash);
>         kfree(inst);
>         module_put(THIS_MODULE);
>  }
> @@ -194,13 +291,17 @@ instance_destroy(struct nfnl_queue_net *q, struct n=
fqnl_instance *inst)
>  static inline void
>  __enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *ent=
ry)
>  {
> -       list_add_tail(&entry->list, &queue->queue_list);
> -       queue->queue_total++;
> +       unsigned int hash =3D nfqnl_packet_hash(entry->id, queue->queue_h=
ash_mask);
> +
> +       hlist_add_head(&entry->hash_node, &queue->queue_hash[hash]);
> +       list_add_tail(&entry->list, &queue->queue_list);
> +       queue->queue_total++;
>  }
>
>  static void
>  __dequeue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *ent=
ry)
>  {
> +       hlist_del(&entry->hash_node);
>         list_del(&entry->list);
>         queue->queue_total--;
>  }
> @@ -209,10 +310,11 @@ static struct nf_queue_entry *
>  find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
>  {
>         struct nf_queue_entry *entry =3D NULL, *i;
> +       unsigned int hash =3D nfqnl_packet_hash(id, queue->queue_hash_mas=
k);
>
>         spin_lock_bh(&queue->lock);
>
> -       list_for_each_entry(i, &queue->queue_list, list) {
> +       hlist_for_each_entry(i, &queue->queue_hash[hash], hash_node) {
>                 if (i->id =3D=3D id) {
>                         entry =3D i;
>                         break;
> @@ -407,8 +509,7 @@ nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn=
 cmpfn, unsigned long data)
>         spin_lock_bh(&queue->lock);
>         list_for_each_entry_safe(entry, next, &queue->queue_list, list) {
>                 if (!cmpfn || cmpfn(entry, data)) {
> -                       list_del(&entry->list);
> -                       queue->queue_total--;
> +                       __dequeue_entry(queue, entry);
>                         nfqnl_reinject(entry, NF_DROP);
>                 }
>         }
> @@ -1483,6 +1584,7 @@ static const struct nla_policy nfqa_cfg_policy[NFQA=
_CFG_MAX+1] =3D {
>         [NFQA_CFG_QUEUE_MAXLEN] =3D { .type =3D NLA_U32 },
>         [NFQA_CFG_MASK]         =3D { .type =3D NLA_U32 },
>         [NFQA_CFG_FLAGS]        =3D { .type =3D NLA_U32 },
> +       [NFQA_CFG_HASH_SIZE]    =3D { .type =3D NLA_U32 },
>  };
>
>  static const struct nf_queue_handler nfqh =3D {
> @@ -1495,11 +1597,15 @@ static int nfqnl_recv_config(struct sk_buff *skb,=
 const struct nfnl_info *info,
>  {
>         struct nfnl_queue_net *q =3D nfnl_queue_pernet(info->net);
>         u_int16_t queue_num =3D ntohs(info->nfmsg->res_id);
> +       u32 hash_size =3D 0;
>         struct nfqnl_msg_config_cmd *cmd =3D NULL;
>         struct nfqnl_instance *queue;
>         __u32 flags =3D 0, mask =3D 0;
>         int ret =3D 0;
>
> +       if (nfqa[NFQA_CFG_HASH_SIZE])
> +               hash_size =3D ntohl(nla_get_be32(nfqa[NFQA_CFG_HASH_SIZE]=
));
> +
>         if (nfqa[NFQA_CFG_CMD]) {
>                 cmd =3D nla_data(nfqa[NFQA_CFG_CMD]);
>
> @@ -1559,11 +1665,12 @@ static int nfqnl_recv_config(struct sk_buff *skb,=
 const struct nfnl_info *info,
>                                 goto err_out_unlock;
>                         }
>                         queue =3D instance_create(q, queue_num,
> -                                               NETLINK_CB(skb).portid);
> +                                               NETLINK_CB(skb).portid, h=
ash_size);
>                         if (IS_ERR(queue)) {
>                                 ret =3D PTR_ERR(queue);
>                                 goto err_out_unlock;
>                         }
> +                       hash_size =3D 0; /* avoid resize later in this fu=
nction */
>                         break;
>                 case NFQNL_CFG_CMD_UNBIND:
>                         if (!queue) {
> @@ -1586,6 +1693,12 @@ static int nfqnl_recv_config(struct sk_buff *skb, =
const struct nfnl_info *info,
>                 goto err_out_unlock;
>         }
>
> +       if (hash_size > 0) {
> +               ret =3D nfqnl_hash_resize(queue, hash_size);
> +               if (ret)
> +                       goto err_out_unlock;
> +       }
> +
>         if (nfqa[NFQA_CFG_PARAMS]) {
>                 struct nfqnl_msg_config_params *params =3D
>                         nla_data(nfqa[NFQA_CFG_PARAMS]);
> --
> 2.39.5 (Apple Git-154)
>
