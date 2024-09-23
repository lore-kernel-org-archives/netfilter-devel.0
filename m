Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACA41953A2
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Sep 2024 09:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727083809; cv=none; b=NwgCTOQ/HaUKcfn6EYx2vWOFc1h+t+ZGVzRU/sPbr5Oz+eD3kaYInRDeEDSMiyi0C6iFNtLu6Ps2Sf9zQovdLNIw8I+D1ZqMfCQNpbWTX4ziry2kOUl4kHOjbof1O0cKQqDfGw72gEGX7cEQibKQrcWLKJ7F6EK9ygU15GZk6jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727083809; c=relaxed/simple;
	bh=xveS8An5yPxN/MxZ/eWTONl87PHoFBR9KHYvY0iw02A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YZYz9L+MGl+DdgsKVHfk8X620KjgtM1MjBXV4YzXV1uwEuVDNPc6T1jnwE6PXYKIm88t9oDqI4OcxqYMSobO0/VYvAluQeX+WF68Hz6kdYOvLpqxpnURzbZs6e36zBj1FgtIGNbOI07Lc+WNmaMzGXTQnCBW+3va9r7vvSXiGjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ME467GUe; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ME467GUe"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c4226a56a8so5147024a12.2
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Sep 2024 02:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727083806; x=1727688606; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vuk3CfC/8d2trmHsLKwiAc84e3WNXWpr9l6TZadOWI4=;
        b=ME467GUeuCMJRBo5Kv+Q02kLumBmhWulAqBLUOaTCTsP3zVqz43URJ+1kZ/221Le7+
         YxXDyz6iRFXbbjcSrkzWSgOOnN7+fgL0LZxT42S1Xv1LGdczmB7V0nIwBYpjetoutwRf
         ABZ+WhBjj0JoSp0gmsToSQIBCw2Mdr3ZtFFc1xUaz8iGxUy0NZxLdozJn+FkvqlzwswC
         usW4uJj+GA7W0EYCZZ45Lul8nEHuLOEDEdxVafBG4GikxDVCj++pxZKgr//5OO3+OaHi
         KFFsVRwxD4fI2XzbrjAHCe2TwQDXLlNgnvYQ9BTczs8dBLLTM4Ozr8KZeCRQM/xt4FWg
         /2Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727083806; x=1727688606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vuk3CfC/8d2trmHsLKwiAc84e3WNXWpr9l6TZadOWI4=;
        b=QtSHmLvJAzQiK2V816kmWSFjI2AW50SWIRgkL18rO9yzvs/d5cRt32DW7I/HCn5f6S
         211bdrPW/iOe4XWge41HbS3dc2ZqaR7Ft8CsKJqcbCGAp8wUR1Axyji7jIuUeC2BFjem
         HB8JmIIYDKI66zt9lxsUb6djN9I8WMObsj/imTUg1GwqlHlJBggRxzt1e3KlqlnEqaVt
         5j8is0l9QLlqmNBNmdURs+916xUrFWKmTtsdumvlCP9edTXAL+PYJKk7bPVspsPiKmWq
         HY0vSBl012UhrzkvPXp2BvKx8nRy9QAJqrr3jcfGLjI6Hrid3YHPDR1yz/F5Ld+m8t50
         +QKg==
X-Forwarded-Encrypted: i=1; AJvYcCXKmGQqIc/d+i5aofFgRbaJiqu+VfkoTgdytVV0z6LSXmu1Km2R2S0QmxnoKgjS8uOUAYmKE8gIa9setOuSn5M=@vger.kernel.org
X-Gm-Message-State: AOJu0YywA0NI9yvpFmihTzRRGYrsyDS9euzkKzGuwVwZiG0XeVL4xmod
	2SYt8OlE7TEd9z/T+NV/cj9vC/8mcuiF9jBZwSxIeBjTyytvuuMt6jsFrwRHRZYSmxg1hVgcBTD
	0985cC1JMV7WoZU2y6m+xdjgq9Ec2rknPIJCG
X-Google-Smtp-Source: AGHT+IFVRkOuz/0hqyC4TUZW9wr9CQzEnHCIPDxI2kRUa/SbM68opPu+QAgvUStGeDqWB+N5a4dUu9svuUD/5ab7oWo=
X-Received: by 2002:a05:6402:2b94:b0:5a1:c43:82ca with SMTP id
 4fb4d7f45d1cf-5c464a5d40emr9977738a12.26.1727083805807; Mon, 23 Sep 2024
 02:30:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <EC5AC714C75A855E+20240923091535.77865-1-yushengjin@uniontech.com>
In-Reply-To: <EC5AC714C75A855E+20240923091535.77865-1-yushengjin@uniontech.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 23 Sep 2024 11:29:54 +0200
Message-ID: <CANn89i+4wbef3k6at_Kf+8MBmU4HhE9nxMRvROR_OxsZptffjA@mail.gmail.com>
Subject: Re: [PATCH] net/bridge: Optimizing read-write locks in ebtables.c
To: yushengjin <yushengjin@uniontech.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, roopa@nvidia.com, 
	razor@blackwall.org, davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	bridge@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2024 at 11:16=E2=80=AFAM yushengjin <yushengjin@uniontech.c=
om> wrote:
>
> When conducting WRK testing, the CPU usage rate of the testing machine wa=
s
> 100%. forwarding through a bridge, if the network load is too high, it ma=
y
> cause abnormal load on the ebt_do_table of the kernel ebtable module, lea=
ding
> to excessive soft interrupts and sometimes even directly causing CPU soft
> deadlocks.
>
> After analysis, it was found that the code of ebtables had not been optim=
ized
> for a long time, and the read-write locks inside still existed. However, =
other
> arp/ip/ip6 tables had already been optimized a lot, and performance bottl=
enecks
> in read-write locks had been discovered a long time ago.
>
> Ref link: https://lore.kernel.org/lkml/20090428092411.5331c4a1@nehalam/
>
> So I referred to arp/ip/ip6 modification methods to optimize the read-wri=
te
> lock in ebtables.c.
>
> test method:
> 1) Test machine creates bridge :
> ``` bash
> brctl addbr br-a
> brctl addbr br-b
> brctl addif br-a enp1s0f0 enp1s0f1
> brctl addif br-b enp130s0f0 enp130s0f1
> ifconfig br-a up
> ifconfig br-b up
> ```
> 2) Testing with another machine:
> ``` bash
> ulimit -n 2048
> ./wrk -t48 -c2000 -d6000 -R10000 -s request.lua http://4.4.4.2:80/4k.html=
 &
> ./wrk -t48 -c2000 -d6000 -R10000 -s request.lua http://5.5.5.2:80/4k.html=
 &
> ```
>
> Signed-off-by: yushengjin <yushengjin@uniontech.com>
> ---
>  include/linux/netfilter_bridge/ebtables.h |  47 +++++++-
>  net/bridge/netfilter/ebtables.c           | 132 ++++++++++++++++------
>  2 files changed, 145 insertions(+), 34 deletions(-)
>
> diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/ne=
tfilter_bridge/ebtables.h
> index fd533552a062..dd52dea20fb8 100644
> --- a/include/linux/netfilter_bridge/ebtables.h
> +++ b/include/linux/netfilter_bridge/ebtables.h
> @@ -93,7 +93,6 @@ struct ebt_table {
>         char name[EBT_TABLE_MAXNAMELEN];
>         struct ebt_replace_kernel *table;
>         unsigned int valid_hooks;
> -       rwlock_t lock;
>         /* the data used by the kernel */
>         struct ebt_table_info *private;
>         struct nf_hook_ops *ops;
> @@ -124,4 +123,50 @@ static inline bool ebt_invalid_target(int target)
>
>  int ebt_register_template(const struct ebt_table *t, int(*table_init)(st=
ruct net *net));
>  void ebt_unregister_template(const struct ebt_table *t);
> +
> +/**
> + * ebt_recseq - recursive seqcount for netfilter use
> + *
> + * Packet processing changes the seqcount only if no recursion happened
> + * get_counters() can use read_seqcount_begin()/read_seqcount_retry(),
> + * because we use the normal seqcount convention :
> + * Low order bit set to 1 if a writer is active.
> + */
> +DECLARE_PER_CPU(seqcount_t, ebt_recseq);
> +
> +/**
> + * ebt_write_recseq_begin - start of a write section
> + *
> + * Begin packet processing : all readers must wait the end
> + * 1) Must be called with preemption disabled
> + * 2) softirqs must be disabled too (or we should use this_cpu_add())
> + * Returns :
> + *  1 if no recursion on this cpu
> + *  0 if recursion detected
> + */
> +static inline unsigned int ebt_write_recseq_begin(void)
> +{
> +       unsigned int addend;
> +
> +       addend =3D (__this_cpu_read(ebt_recseq.sequence) + 1) & 1;
> +
> +       __this_cpu_add(ebt_recseq.sequence, addend);
> +       smp_mb();
> +
> +       return addend;
> +}
> +
> +/**
> + * ebt_write_recseq_end - end of a write section
> + * @addend: return value from previous ebt_write_recseq_begin()
> + *
> + * End packet processing : all readers can proceed
> + * 1) Must be called with preemption disabled
> + * 2) softirqs must be disabled too (or we should use this_cpu_add())
> + */
> +static inline void ebt_write_recseq_end(unsigned int addend)
> +{
> +       smp_wmb();
> +       __this_cpu_add(ebt_recseq.sequence, addend);
> +}

Why not reusing xt_recseq, xt_write_recseq_begin(), xt_write_recseq_end(),
instead of copy/pasting them ?

This was added in

commit 7f5c6d4f665bb57a19a34ce1fb16cc708c04f219    netfilter: get rid
of atomic ops in fast path

If this is an include mess, just move them in a separate include file.
