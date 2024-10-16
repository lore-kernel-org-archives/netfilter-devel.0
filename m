Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F551206E71;
	Wed, 16 Oct 2024 12:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729081094; cv=none; b=cDXPH2GWVzOZ6QLLeQSBPZ/62rVy9TXUnPiEoovqc/LEK5WMkxShUI9e8Oxdpm85NqcInWrIyghLj3gYmkhoJmNMrkKaVXkvOpoYzZfM0w0qhfRpPImR9k6nvHtofXytcf33LHUVWYUpqsfMnb7IvFbVXRm54w19JRRCY8sHWJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729081094; c=relaxed/simple;
	bh=VE3vvit23P0+USt/yIlIXHODZ1vWSLYZXNEVrLwpKrQ=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h0erx7LuPckdKOYkx7bjmNH3x+J7yWDpORXxurSzVjNLGx+T7HAsDHujldJsQGcIPkMULqTruxY+oXgga8QjD8QDvisn7/MRg7GzaG/lnwMbZclvrmZk7Tjf2Ckx03Qshq7n9oSJvtZuKxgdsYW2KZUAZomT0GnMg5Q0L2BT054=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZYdsGP02; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZYdsGP02"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539f76a6f0dso3072842e87.1;
        Wed, 16 Oct 2024 05:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729081091; x=1729685891; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RlYmgAFXSAyX0VM0McobVNjJxsrO1YN8W/zUQvWby+A=;
        b=ZYdsGP02ncz33Hr6zDBKs6vwgojgR/Z0m4v8+FS7PEZk+sxiFgfJf8qMPO/QLEA6vC
         cVd2froBR0ydk3DWaPUdwBZIMjF2CcpZrfLZSAUCqrfoIqsqeJbKnhw/S8MPeniMUe9j
         9SeFhVdz4gPTTr2bHgfcYrJvO6p/72gPH9V5tEbW42XW5GonIzf/FHyrl+cmBe7MUeku
         MIwlvhmakENsKL/XRxVnVNFUd8FrpLbfREvwVFXghk7x/2c4J93l+m/PSuxJCYfgKvaA
         KDTAIjYBe7L7HQlHfPz0DqNZwzXgCocENJlZGb5aOJPEv4J17dqCO/TE/fkOONes7fVG
         zuyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729081091; x=1729685891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RlYmgAFXSAyX0VM0McobVNjJxsrO1YN8W/zUQvWby+A=;
        b=PboZschfK7Qh/XvdKpma++vbvR5T4n89vv4hpoNz5t9cEFkdlSQlzkhybCEJoN+h7B
         jf80Eq8IHafI31yd2xF8fMJqQ1EC6/y1qt5Tyd2rZKKDiS5H5i8NVhPsBWe/Wkyp1P66
         d7ziiVKOlu9Hx9wkBb5C/y+j+dTjRWDW+4iEiv5uWiTFNfKAP8oKAlojQwj7bbiI11UE
         Ssugpafgohk1SIHdS5OAesOXNVTY6vOrTP+DHJMKbnwIozijouvyk+7UTkn+K7zhhP1r
         lA7PkE3aPd2tsmh6kwW7Qv75pnZejDmhMzyr1VGud1ImQCZjPlkoHBdCJ30nFwffTkjh
         gAwA==
X-Forwarded-Encrypted: i=1; AJvYcCU5gFH6gzukOOZBsRBLOsF1CZtnuDb6L1cf6JJWo2xIJoivOhx06g4mMnR3jW84R1srpbCAA7m1@vger.kernel.org, AJvYcCVooYk2xlBQqyzmftITo5d3LXimibpqqvfURJoo5vQTghPFUg9ZZB5L1XguBH+tQUOKClaWcb0HBtj2maaqnm+4@vger.kernel.org, AJvYcCWeayEOxsTJJmdvup40URdjBycnyrVVL4awTE/2tpLGUnxIZWcbYuF7cyJ3BL7RedVeG+BIk5lWQedg9niQ@vger.kernel.org, AJvYcCWgr9knRl2Fa1EZi1LrMivRNLBYa7+YhNbTTM22ForFwpdBm/Ue98clxQZtV8j8lfoWfBWxoBGtghZwtASc4Vw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlnnZr1NGRlQSKu3SjapOZlsvIb3OkshhMBiZGt0vOVe2m/t1X
	pOQzRuGTp0oQL0SRrkxLEq3vDF1lgd8SaBz9Meaa4UNj9Ugo4ts6
X-Google-Smtp-Source: AGHT+IEh405fIE8O2dgxoey2Tjwfu4VDPTNDqK3Xi0W6ubocSWeelce5HL1j3sLXc1WD/lVvPidpkg==
X-Received: by 2002:a05:6512:685:b0:539:d1d4:9c3b with SMTP id 2adb3069b0e04-539da3c5e45mr9390487e87.14.1729081090387;
        Wed, 16 Oct 2024 05:18:10 -0700 (PDT)
Received: from pc636 (host-95-203-1-67.mobileonline.telia.com. [95.203.1.67])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-539ffff3ad7sm440905e87.141.2024.10.16.05.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 05:18:10 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 16 Oct 2024 14:18:07 +0200
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
Subject: Re: [PATCH 16/17] netfilter: expect: replace call_rcu by kfree_rcu
 for simple kmem_cache_free callback
Message-ID: <Zw-u_56SSySvioJu@pc636>
References: <20241013201704.49576-1-Julia.Lawall@inria.fr>
 <20241013201704.49576-17-Julia.Lawall@inria.fr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241013201704.49576-17-Julia.Lawall@inria.fr>

On Sun, Oct 13, 2024 at 10:17:03PM +0200, Julia Lawall wrote:
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
>  net/netfilter/nf_conntrack_expect.c |   10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index 21fa550966f0..9dcaef6f3663 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -367,18 +367,10 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_expect_init);
>  
> -static void nf_ct_expect_free_rcu(struct rcu_head *head)
> -{
> -	struct nf_conntrack_expect *exp;
> -
> -	exp = container_of(head, struct nf_conntrack_expect, rcu);
> -	kmem_cache_free(nf_ct_expect_cachep, exp);
> -}
> -
>  void nf_ct_expect_put(struct nf_conntrack_expect *exp)
>  {
>  	if (refcount_dec_and_test(&exp->use))
> -		call_rcu(&exp->rcu, nf_ct_expect_free_rcu);
> +		kfree_rcu(exp, rcu);
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_expect_put);
>  
> 
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki
