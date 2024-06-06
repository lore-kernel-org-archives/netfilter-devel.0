Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A037119644F;
	Thu,  6 Jun 2024 14:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682968; cv=none; b=qDRNA2F3yz7Od1TD0xjAinrVcCVKMgEwfgHKV5vnlV26vrEmwil5c1MZ4RVVpHXSrYk6b0mUrVFYDA3MWd1qK+TiOLhZFfQsU3Z7c13gu20OcSq+cQKaoPpZEltKFRBKrmwdpERNWWnNrrVg8tENSRZNp8DI5E1M1kK57kMOHwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682968; c=relaxed/simple;
	bh=ptVna0Kj72D8l1Q0rFXRV9/q/BSGoKZcuRnmKhVbcfU=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=X6ApYvQBwSF2prEzpm2Z6onfdKlSOzTljW+Q8IyzQOquVVeS5jSXIjals5BfPIZO5PX8ZFHRHgrCrbXP3ozeXRY0FexAYZF/xzyICB7vyp6iFRCrwwKvA0ot2J0KMctEoDZYJ8H6+6ToG6Aemj2i6mq31JGOfwdqsh2dgT1PgWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rf5wYjdR; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rf5wYjdR"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4402602a116so5165981cf.0;
        Thu, 06 Jun 2024 07:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717682965; x=1718287765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4akmxwipQbmjTYb7w37FoCOnBT3ApDVnDQZCkAgV2sQ=;
        b=Rf5wYjdRgtIZmkzI18eAm6G731mk4EJdETT/XQWR1pCcz6dFsmipF040hSExSURMye
         9LPthuospEi2a4oylE27yq5R9FSRzPoYUhChIKaKoB4jhXOL3qlKehO1f8nYMVuer2lj
         IiSfiKauJkPbJ+rUvZ20d/OcklCOPW8qQZSic2qoAtvZx2pM6ler4omjUkCkO66cg7Ir
         NGz3i3y9VFMcxtWGSeZW0x4O9ggXGK+MNuweI/2KLjqW4IbiD81LEF1J7GWG7NOGSPxx
         LeI5JpbyHiHLu0fVpymLbE8M+OeZZKWjTt2n9BpcPJpmJ2gPOV/U/0M87Raq0oazZfPG
         VJ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717682965; x=1718287765;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4akmxwipQbmjTYb7w37FoCOnBT3ApDVnDQZCkAgV2sQ=;
        b=mLevPmzYbH06GyDx2hwv+MrDRow7xyVXEntkKtrdABf9JqEHErMvZhaoKdrXiACEou
         sRoMxvskhIB/0icrpNQB95RvVayccK5Iy902IUtTyoQkh4vWlmKyMeq+WOOZh71jlX/m
         jUliguUXlqbuGBhoz3469pdnnC1lAkydAcAEMjt8qA8now8QZlwg4AUaLAV+1W/qtNhx
         1/mNbzoYfIVGE3gxIj0z3pJnHe6Xj7UpFJH7wFauQTKwwvZYF7ZqH7Mjj10ap7FTY1Xy
         u6dShfoCakfUMJmcnY3wtYdnIQGdWzOkb3qiZCHxmrKlaiOoos1wJB/mjUM5KfqVqypw
         ANWw==
X-Forwarded-Encrypted: i=1; AJvYcCUhVVWbJUqN/iygFOz3iQsRLK6VExpj76zVOR4I0oNDZRI1vG1Tu1FjooOQtV/hNPTStGMQZkhsYHZijC7FqMTmyPSqB6SYvlUtxjCklPcDoijXbU5Kq7s6nrXFpg46I2SyFz7Jcem1
X-Gm-Message-State: AOJu0YzD8RxBSVJ04K3P719QhZ9C/9xgXxGWOkZ90ELZ9XLAIRe+kQCw
	6R7eCw7B9Zq2NZ9C8yFVSOVKQVzPqinxq+Kjbbl/ZdqDVeq4Izwu
X-Google-Smtp-Source: AGHT+IEpGNoktN9UVnmRRZAFwqC/QqHyWhW8pj+SXXP9rtDMq8tSsKcDTB56epxTjXXTy3vXgDjjWg==
X-Received: by 2002:a05:622a:40b:b0:43e:e6e:21dc with SMTP id d75a77b69052e-4402b5f6cbbmr61447431cf.12.1717682964555;
        Thu, 06 Jun 2024 07:09:24 -0700 (PDT)
Received: from localhost (112.49.199.35.bc.googleusercontent.com. [35.199.49.112])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79539c26295sm9745185a.8.2024.06.06.07.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jun 2024 07:09:24 -0700 (PDT)
Date: Thu, 06 Jun 2024 10:09:23 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Florian Westphal <fw@strlen.de>, 
 Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Christoph Paasch <cpaasch@apple.com>, 
 Netfilter <netfilter-devel@vger.kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 netdev@vger.kernel.org, 
 daniel@iogearbox.net, 
 willemb@google.com
Message-ID: <6661c313cf1fe_37b6f32942e@willemb.c.googlers.com.notmuch>
In-Reply-To: <20240606130457.GA9890@breakpoint.cc>
References: <20240604120311.27300-1-fw@strlen.de>
 <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc>
 <ZmCwlbF8BvLGNgRM@calendula>
 <20240605190833.GB7176@breakpoint.cc>
 <20240606092620.GC4688@breakpoint.cc>
 <20240606130457.GA9890@breakpoint.cc>
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > ... doesn't solve the nft_hash.c issue (which calls _symmetric version, and
> > that uses flow_key definiton that isn't exported outside flow_dissector.o.
> 
> and here is the diff that would pass net for _symmetric, not too
> horrible I think.
> 
> With that and the copypaste of skb_get_hash into nf_trace infra
> netfilter can still pass skbs to the flow dissector with NULL skb->sk,dev
> but the WARN would no longer trigger as struct net is non-null.

Thanks for coding this up Florian. This overall looks good to me.

One suggested change is to introduce a three underscore variant (yes
really) ___skb_get_hash_symmetric that takes the optional net, and
leave the existing callers of the two underscore version as is.

The copypaste probably belongs with the other flow dissector wrappers
in sk_buff.h.

> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 9254bca2813d..e9e6cf3d148c 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -524,12 +524,13 @@ static inline void tun_flow_save_rps_rxhash(struct tun_flow_entry *e, u32 hash)
>   */
>  static u16 tun_automq_select_queue(struct tun_struct *tun, struct sk_buff *skb)
>  {
> +	const struct net *net = dev_net(tun->dev);
>  	struct tun_flow_entry *e;
>  	u32 txq, numqueues;
>  
>  	numqueues = READ_ONCE(tun->numqueues);
>  
> -	txq = __skb_get_hash_symmetric(skb);
> +	txq = __skb_get_hash_symmetric(net, skb);
>  	e = tun_flow_find(&tun->flows[tun_hashfn(txq)], txq);
>  	if (e) {
>  		tun_flow_save_rps_rxhash(e, txq);
> @@ -1038,10 +1039,11 @@ static void tun_automq_xmit(struct tun_struct *tun, struct sk_buff *skb)
>  		/* Select queue was not called for the skbuff, so we extract the
>  		 * RPS hash and save it into the flow_table here.
>  		 */
> +		const struct net *net = dev_net(tun->dev);
>  		struct tun_flow_entry *e;
>  		__u32 rxhash;
>  
> -		rxhash = __skb_get_hash_symmetric(skb);
> +		rxhash = __skb_get_hash_symmetric(net, skb);
>  		e = tun_flow_find(&tun->flows[tun_hashfn(rxhash)], rxhash);
>  		if (e)
>  			tun_flow_save_rps_rxhash(e, rxhash);
> @@ -1938,7 +1940,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>  	 */
>  	if (!rcu_access_pointer(tun->steering_prog) && tun->numqueues > 1 &&
>  	    !tfile->detached)
> -		rxhash = __skb_get_hash_symmetric(skb);
> +		rxhash = __skb_get_hash_symmetric(dev_net(tun->dev), skb);
>  
>  	rcu_read_lock();
>  	if (unlikely(!(tun->dev->flags & IFF_UP))) {
> @@ -2521,7 +2523,7 @@ static int tun_xdp_one(struct tun_struct *tun,
>  
>  	if (!rcu_dereference(tun->steering_prog) && tun->numqueues > 1 &&
>  	    !tfile->detached)
> -		rxhash = __skb_get_hash_symmetric(skb);
> +		rxhash = __skb_get_hash_symmetric(dev_net(tun->dev), skb);
>  
>  	if (tfile->napi_enabled) {
>  		queue = &tfile->sk.sk_write_queue;
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 1c2902eaebd3..60a4dc5586c8 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1493,7 +1493,7 @@ __skb_set_sw_hash(struct sk_buff *skb, __u32 hash, bool is_l4)
>  }
>  
>  void __skb_get_hash(struct sk_buff *skb);
> -u32 __skb_get_hash_symmetric(const struct sk_buff *skb);
> +u32 __skb_get_hash_symmetric(const struct net *net, const struct sk_buff *skb);
>  u32 skb_get_poff(const struct sk_buff *skb);
>  u32 __skb_get_poff(const struct sk_buff *skb, const void *data,
>  		   const struct flow_keys_basic *keys, int hlen);
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index f82e9a7d3b37..634896129780 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -1831,14 +1831,14 @@ EXPORT_SYMBOL(make_flow_keys_digest);
>  
>  static struct flow_dissector flow_keys_dissector_symmetric __read_mostly;
>  
> -u32 __skb_get_hash_symmetric(const struct sk_buff *skb)
> +u32 __skb_get_hash_symmetric(const struct net *net, const struct sk_buff *skb)
>  {
>  	struct flow_keys keys;
>  
>  	__flow_hash_secret_init();
>  
>  	memset(&keys, 0, sizeof(keys));
> -	__skb_flow_dissect(NULL, skb, &flow_keys_dissector_symmetric,
> +	__skb_flow_dissect(net, skb, &flow_keys_dissector_symmetric,
>  			   &keys, NULL, 0, 0, 0, 0);
>  
>  	return __flow_hash_from_keys(&keys, &hashrnd);
> diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
> index 92d47e469204..3e7296ed5319 100644
> --- a/net/netfilter/nft_hash.c
> +++ b/net/netfilter/nft_hash.c
> @@ -51,7 +51,8 @@ static void nft_symhash_eval(const struct nft_expr *expr,
>  	struct sk_buff *skb = pkt->skb;
>  	u32 h;
>  
> -	h = reciprocal_scale(__skb_get_hash_symmetric(skb), priv->modulus);
> +	h = reciprocal_scale(__skb_get_hash_symmetric(nft_net(pkt), skb),
> +			     priv->modulus);
>  
>  	regs->data[priv->dreg] = h + priv->offset;
>  }
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index 964225580824..0e6166784972 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -1084,7 +1084,8 @@ static int clone(struct datapath *dp, struct sk_buff *skb,
>  			     !dont_clone_flow_key);
>  }
>  
> -static void execute_hash(struct sk_buff *skb, struct sw_flow_key *key,
> +static void execute_hash(const struct net *net,
> +			 struct sk_buff *skb, struct sw_flow_key *key,
>  			 const struct nlattr *attr)
>  {
>  	struct ovs_action_hash *hash_act = nla_data(attr);
> @@ -1097,7 +1098,7 @@ static void execute_hash(struct sk_buff *skb, struct sw_flow_key *key,
>  		/* OVS_HASH_ALG_SYM_L4 hashing type.  NOTE: this doesn't
>  		 * extend past an encapsulated header.
>  		 */
> -		hash = __skb_get_hash_symmetric(skb);
> +		hash = __skb_get_hash_symmetric(net, skb);
>  	}
>  
>  	hash = jhash_1word(hash, hash_act->hash_basis);
> @@ -1359,7 +1360,7 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
>  			break;
>  
>  		case OVS_ACTION_ATTR_HASH:
> -			execute_hash(skb, key, a);
> +			execute_hash(ovs_dp_get_net(dp), skb, key, a);
>  			break;
>  
>  		case OVS_ACTION_ATTR_PUSH_MPLS: {
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index ea3ebc160e25..b047fdb0c02c 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1364,7 +1364,9 @@ static unsigned int fanout_demux_hash(struct packet_fanout *f,
>  				      struct sk_buff *skb,
>  				      unsigned int num)
>  {
> -	return reciprocal_scale(__skb_get_hash_symmetric(skb), num);
> +	struct net *net = read_pnet(&f->net);
> +
> +	return reciprocal_scale(__skb_get_hash_symmetric(net, skb), num);
>  }
>  
>  static unsigned int fanout_demux_lb(struct packet_fanout *f,


