Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9A516DEB3;
	Wed, 16 Oct 2024 12:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729081143; cv=none; b=BckVn2AT+tJBm4FOWcl/6JODs4xWodaOPR1ks9Va6+3dyH2gWOfeeRELH6fsW1OvMdl6Xhyn9RMoDeiTEYc+SavoT54k713KV1VSNqCuQtZrvgw3ouQ8EXfdBjOuwZZgjmoK79crZQJvz809COJVHYo6WO4YLTGKenvBuHLLuEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729081143; c=relaxed/simple;
	bh=Tg7daPNANsLMXw6t436MrDDaM6Gy7AI11cNU2czLM00=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BxKhpInsCsv2kCGlJYeYOCYyUUTvwpnKwfo/3X95p4RCHHcXcpyX7m6Lb2Y/xLNdJ/8QjOf6GL/96s6Obznui5Pstxz5Sbq61lbiCSFZgoHJnaEgIV6GvPywDAxLIKjmU1cA7cMWE/3XoYcEZ7IfBo/GutDKJG+nHwaOUQrKTGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IrDxv4Z0; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IrDxv4Z0"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-539f8490856so3542942e87.2;
        Wed, 16 Oct 2024 05:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729081140; x=1729685940; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FYxY3chHsnd8qlC+a4Z880hpz+HOektoVb7zuR601Dw=;
        b=IrDxv4Z0FLGDP725SJ/RczpHZSe9Jlj1oj7mOuVVKyKgsezkJqf9Kk3R4AABNX2roj
         IgSSwHJ9q1jMkNxlIsvft/Frh42X5CItAn9yjYeLTF0PKGC+Q/xo5qXxkVTrTENMS08t
         lVP9yL+vAdGNS/BZnjuGpj7N2fQo54EyCwAlQCBMUOdysbdYnj1klWraDeeKZGzAzBy6
         Rpo53UskiyU7HRSlZ4SLLe9FNTbBvWeq30bZP2ziaHOpcXraEUbXjxK2ccDZTdi8aBVj
         4Ec6P2Afto4tJLCy8Ph7oT05KY/MxkMTpMeYGfrZDQaY6vVSOGzUJytLQ5L8hWHWo5zO
         yUdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729081140; x=1729685940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FYxY3chHsnd8qlC+a4Z880hpz+HOektoVb7zuR601Dw=;
        b=as1IRbaT+KSbh3fkVWEBBEWIH80m3Z05Zb9p1nbN4xUVCJwWMwgfkg5FQnifeZfCaf
         FjKh3mPbTRJ6ADBp8ENaDJoKS4l9ipBcFX7nRU2y12kCqQZNnj8jsbYcWOegd86rdjuP
         3SbyE8RiJL1wHrZUNFC3e4+9BJiA/x2WiqtfczuqT70IpB9OkXOlQC6bw6iT4Od8pyPL
         YxVUbuAVG3iPXgOtk1kUAfQw0BDm7+948qxWT8GyunUY573mPq7EH8Y2VFdMMmo08ElN
         aDBsgQoriUEe4zhHhXdPTGYElVz7zH5y64b4q3CvDqHAKqloeI6t6GH/bvsEK59liu09
         kMYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUe70BxYVMMfExGV1Ji+hblPtstgmR6TgF8v8dOyaqD0VGuGAWFq2+oK7gUr351YkpQogI8HezeAmblbKQz99lQ@vger.kernel.org, AJvYcCVYAmpFpTiJV6kx8uxljXAZ2PAW+VR93Puk+pzKk9olXp7m7263nUAdmR6Dc3+1l8pUwFZ26yxPL4gMgtgzc+s=@vger.kernel.org, AJvYcCVdmlAlmVkpdRB/sxGwajNIvV6idx1PzVIcRI2VS2t/tRnnP8XueCbqgQ70Kdfg+qakEQ1SKABzBwIGDRMV@vger.kernel.org, AJvYcCXvdiHVlpuwzxAeu3dDcGXznW1PR0El5Mf7ANqT/tuuCI+ws1dIbBqjYK5qFoA1j7dkEpmBRDFM@vger.kernel.org
X-Gm-Message-State: AOJu0YwiANdW/P95eG/t0IBQvfthujsGfq/EvR43FVyLg4bPrcTdlR0X
	/AvxZepHlcTE+B1gqW/VCtmpAVYsuuLQB/nbHTznQv/a0unHgjsU
X-Google-Smtp-Source: AGHT+IGuseZ5x4pV9Xp1LZbfGRiSAi+PYNkZazWo8KA8h/UgnRCLPaF2P1lScJIgRv7B3oTZEUEREA==
X-Received: by 2002:a05:6512:1092:b0:539:f5a9:b224 with SMTP id 2adb3069b0e04-539f5a9b44dmr6192455e87.11.1729081139953;
        Wed, 16 Oct 2024 05:18:59 -0700 (PDT)
Received: from pc636 (host-95-203-1-67.mobileonline.telia.com. [95.203.1.67])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a000060easm438005e87.187.2024.10.16.05.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 05:18:59 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 16 Oct 2024 14:18:56 +0200
To: Julia Lawall <Julia.Lawall@inria.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	kernel-janitors@vger.kernel.org, vbabka@suse.cz, paulmck@kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] netfilter: nf_conncount: replace call_rcu by
 kfree_rcu for simple kmem_cache_free callback
Message-ID: <Zw-vML6o5eyCgMII@pc636>
References: <20241013201704.49576-1-Julia.Lawall@inria.fr>
 <20241013201704.49576-16-Julia.Lawall@inria.fr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241013201704.49576-16-Julia.Lawall@inria.fr>

On Sun, Oct 13, 2024 at 10:17:02PM +0200, Julia Lawall wrote:
> Since SLOB was removed and since
> commit 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()"),
> it is not necessary to use call_rcu when the callback only performs
> kmem_cache_free. Use kfree_rcu() directly.
> 
> The changes were made using Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  net/netfilter/nf_conncount.c |   10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
> index 4890af4dc263..6a7a6c2d6ebc 100644
> --- a/net/netfilter/nf_conncount.c
> +++ b/net/netfilter/nf_conncount.c
> @@ -275,14 +275,6 @@ bool nf_conncount_gc_list(struct net *net,
>  }
>  EXPORT_SYMBOL_GPL(nf_conncount_gc_list);
>  
> -static void __tree_nodes_free(struct rcu_head *h)
> -{
> -	struct nf_conncount_rb *rbconn;
> -
> -	rbconn = container_of(h, struct nf_conncount_rb, rcu_head);
> -	kmem_cache_free(conncount_rb_cachep, rbconn);
> -}
> -
>  /* caller must hold tree nf_conncount_locks[] lock */
>  static void tree_nodes_free(struct rb_root *root,
>  			    struct nf_conncount_rb *gc_nodes[],
> @@ -295,7 +287,7 @@ static void tree_nodes_free(struct rb_root *root,
>  		spin_lock(&rbconn->list.list_lock);
>  		if (!rbconn->list.count) {
>  			rb_erase(&rbconn->node, root);
> -			call_rcu(&rbconn->rcu_head, __tree_nodes_free);
> +			kfree_rcu(rbconn, rcu_head);
>  		}
>  		spin_unlock(&rbconn->list.list_lock);
>  	}
> 
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki
