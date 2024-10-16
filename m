Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B8F16DEB3;
	Wed, 16 Oct 2024 12:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729081189; cv=none; b=QQLCkZ85/G3+Xzdh5uPh0VNQgN8a/4fOZGJXYrL6hPfneQLCPEB8O8dGl6JtH5Tb5j7hKK4fIDVQsr0X0cZTpJbtZ74PB9Gc5sHjBiOGOQp2EeW2Ac/l+M4b9fl+MIhYOjfj3xsMZ5+EeLrYjew0un04SBwiYTpF42EvyYY80xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729081189; c=relaxed/simple;
	bh=eBg+okqE6WO9sK9n/f+xbL6CSwxVfW+puNcpb1nVHgA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oF7+Z5QISyyI0crUb3LPKzhWzmMiPVEb1mVi/KC3zqPIrg2qOyDl2lVyG5SqNZUxjwci8avHD/MSo1WpfSy+A5l8i1Dk+NbfgGnwgYJ1jsasT1rRQGtCm4HQBOCnnABqVo/5Aw2HvzKKC32GchlJEBIxuEWIUaMo3Rrt1QZ2FOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nlUtOY0x; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nlUtOY0x"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539e59dadebso5479287e87.0;
        Wed, 16 Oct 2024 05:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729081186; x=1729685986; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h2e4sicaQ+optgZAIgTbYqm11BxdMt5i/9Q5+KkXvzM=;
        b=nlUtOY0x49tZayqkgwDjDHjDKo/gKMJTpQxtQvAayjDRjlonAThoSTpxzO77Yp5Ln2
         lKZQnKrxFMoXgzOQfndVPCF0foq+vPSxdhdVDpvTOkINyBLLq6brpOMovo11BjD8r1GY
         nm0ltS1f7TcRwPVpg05StzSH+MFAjwkN6lkyyL+99yJCtiTFNr5iPqCfwmb4XIttIYCu
         V/AlMRAuIp4H+zlEwbQqHQl8c2IibGaADy0jDxlQ+/Zq/9bRIrVkL0J0CsfWOp3LEgdy
         B99JN5w9xQi2X3sbAeUYrIE05ni9nxyVgVjxzQO6sg5Ig+8lc8O09Gsx1z8s9qpuqkXn
         Fl1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729081186; x=1729685986;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2e4sicaQ+optgZAIgTbYqm11BxdMt5i/9Q5+KkXvzM=;
        b=ggQi3ay4/h6AwN1QiYSBlhYvxiZdPeRaHO9B4mQHnN8NsQ54M4X3BE/hRxtJX7DEy1
         YrgVeaX0p1PFshUyjLepCGfQR7U1UJSmOwRcEshQGGrP9/f2c9YUEcxKHDeWC7gg6W4j
         Gx/5OnBx0zV6/Kvjc+FlkBZ9lUR7btJVEFwbmNTKCNU4kff+BtfoIODUAou0Rg5cyveg
         /SWgyWZ52fUSzKm3VzDgDZ5Wgn1EhG6MtFD2/C+1VVwHA+wolFd9Ia8t0+ZfJM11q/Z6
         tn+ez+Gk32hgnU12B8tD6ChDaZIL4209Cyz1VOOx0JQ4DeUAVCOLdg/AnA4TGqCiBPvr
         yu2w==
X-Forwarded-Encrypted: i=1; AJvYcCUZnX/+imYLy3CeGsX3jZMgcpr3DoeU2mBjhGQu1VOsbUcu0W9cL2vGBNrwZMl7LSsowW2iP4yj3j3KzUZY0g8=@vger.kernel.org, AJvYcCVS2D18Fq26dVONhN7F6ufTICRVvc+vTCpK1eTv/W/EgOpwY2RbY2SdYRaPp6Va7pZgk58bOhsEUfKGvHbB@vger.kernel.org, AJvYcCVxKiUsLU0l6Tz53op81ZRdvyABPM4PwqwKTLuzELVCA7HgaRB7EkWh7Oo7PPXbruokKku9SvKa@vger.kernel.org, AJvYcCWZJVqo3QERoewTV4r77FvrBrdRaWZdrjAJI4L+d0XmqlUJxsk0nVwreaVrhKfLuJ4nN7Qwv0fdWJQFoHM8GMG+@vger.kernel.org
X-Gm-Message-State: AOJu0YwUZoeM0oVjZuuODH6XAi5bJUAuV1k6a1c/r1LAK6YiupKHLeIp
	fe9ibtqkLoTd/fprzYtFHEHaMjaudmuBSlNiWpkvZ7dpjuccHQru
X-Google-Smtp-Source: AGHT+IEyUUVOGHcF4PNLf1rTndKJUqKbElmMnHkhy+6Wlq5CJ6js/Elpwme/vIf5fCuo06DBXXuppg==
X-Received: by 2002:a05:6512:3d8d:b0:539:e873:6e2 with SMTP id 2adb3069b0e04-53a03f044d8mr2887429e87.8.1729081185966;
        Wed, 16 Oct 2024 05:19:45 -0700 (PDT)
Received: from pc636 (host-95-203-1-67.mobileonline.telia.com. [95.203.1.67])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a0413434fsm286988e87.160.2024.10.16.05.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 05:19:45 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 16 Oct 2024 14:19:42 +0200
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
Subject: Re: [PATCH 17/17] netfilter: xt_hashlimit: replace call_rcu by
 kfree_rcu for simple kmem_cache_free callback
Message-ID: <Zw-vXsVQCfxm7DM1@pc636>
References: <20241013201704.49576-1-Julia.Lawall@inria.fr>
 <20241013201704.49576-18-Julia.Lawall@inria.fr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241013201704.49576-18-Julia.Lawall@inria.fr>

On Sun, Oct 13, 2024 at 10:17:04PM +0200, Julia Lawall wrote:
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
>  net/netfilter/xt_hashlimit.c |    9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
> index 0859b8f76764..c2b9b954eb53 100644
> --- a/net/netfilter/xt_hashlimit.c
> +++ b/net/netfilter/xt_hashlimit.c
> @@ -256,18 +256,11 @@ dsthash_alloc_init(struct xt_hashlimit_htable *ht,
>  	return ent;
>  }
>  
> -static void dsthash_free_rcu(struct rcu_head *head)
> -{
> -	struct dsthash_ent *ent = container_of(head, struct dsthash_ent, rcu);
> -
> -	kmem_cache_free(hashlimit_cachep, ent);
> -}
> -
>  static inline void
>  dsthash_free(struct xt_hashlimit_htable *ht, struct dsthash_ent *ent)
>  {
>  	hlist_del_rcu(&ent->node);
> -	call_rcu(&ent->rcu, dsthash_free_rcu);
> +	kfree_rcu(ent, rcu);
>  	ht->count--;
>  }
>  static void htable_gc(struct work_struct *work);
> 
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki
