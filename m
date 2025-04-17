Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC39A1C3C18
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Apr 2025 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744903933; cv=none; b=kdgyIP1dPj13+ZZeIQ7RnckFsEv8jNqQy+akeW2zoxskqUcDGC1EYJ6ph1gcblYrGvJKMbMtDqnxRE3POUnwkURrNeYqA33v+JxYbnvQRYa8KA8EZCsgnLL6XCY+iDL1POMhKetC5HKoUx5vftCWcHvbKhkntO7Tw/z5DLpxdxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744903933; c=relaxed/simple;
	bh=TlCFjKURkRvfQZuLFpneP+wNX7J/GXabVVtqf6p+M44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=JLtNr4a5A/nQcK2wsaGx2rQyF+RwsMqBwdfb2ljj6v+TMyvoduAJDsTg0hK1zdlYS28X9LF4Fy2hMUUf0qzCEkYrvXpZ+013AKBKq426NCjfUbshPo5dU39Xs6NkvQ+4o10qQQYT7dMsHap4o5xqhUyP3rnZer/LmyVufms82vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mp+d2pLJ; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mp+d2pLJ"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-306b6ae4fb2so937298a91.3
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Apr 2025 08:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744903931; x=1745508731; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hLEpzfO7uEjjnk2YLYynQ7I0wlM2lyx6lorp0NlE//U=;
        b=Mp+d2pLJCUYdWdrxsrXVXyazO+VxOKsXFuixypeoz/epjLUIAoQ3+4bnap43IJ4BkV
         apGTSEFMld5Vwx+vyvOjn3AjFiJHxOu6YPF6lProbXmI9UTiM/se4CXQBDq7liXE3yRB
         UF2TGm994ov2kJZaF/+c86jhUX7U6Inl1ZLB588YuxtKcxAEZEcCiKrfuvua/sAsmOwA
         B/BLspjJCfZVlrozzLmVNxaFbNPwvKvfq1GkWclE9BNBG9Rzxazj3oIAgLlj+6syuJ+Z
         p50MYPJQJavp60/b3gC1P/RwqsX3DG1Ae2sdsQcXzVZ5MWNYd45ly7C83ymp4rzPSdZZ
         St0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744903931; x=1745508731;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hLEpzfO7uEjjnk2YLYynQ7I0wlM2lyx6lorp0NlE//U=;
        b=snGXjt7jyYnP83er6u/SPLSfMiyImBElB7+Rg9wsSyb05LqbrcKIQNfWdv38ilBLxv
         k+dbtrdBJQFr54/5N4O9l63oP7+jx5Q/HCbM/vNFoFt9Wfi/qlWzuUiHPlYxgu1fmSzm
         dGRLK/0XqeL2uRS/vRoQWD2qRQKkKWP/z1axDY3SmWg1DvMSHi2khZnQ420lU6scX8Pc
         P0Olb1BZBEhEriACSEHlJ0taHOoiHnqBrR7apwXrCelkFRCFDUF1YSiXA3tgEwofpunc
         zOZnRtke1el4GZlOq6WqpeeCmUkdn6TKUEendfCiirOPtOWnWZlJXacUizRRZq744RCH
         ZPug==
X-Forwarded-Encrypted: i=1; AJvYcCVBzW5SgLiJjRERHXIolF2u5qdHEiNwlZbkwAAs7OCsiaT6Bq9v06aASmqpMCulmwG67NAZbOjA9G869/0Hb5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX85JhEHE+UMGQV34lJvHPTywu6LGDPiHqYljS/qfs6ARi31x/
	70DbLGl+3tRtR1YTVzJJ44CtyB3Y6I7eBIj/0xuKnnQZaES+br4p
X-Gm-Gg: ASbGncuiPpiWFXGY3mVBJh0ci31IAINNdAvXh4qgz3+ji8T8Sfhgo1umsRVQiZgNGVk
	RCqkdlWL1bo+0BAWRrGIoqJCRBg6iPrqMYs42HeFxPush3BZDgU+BCbcjRgV4UreK7c1iEQBsSc
	YIpS5MG6qc/kNB+xp8T7okGhl+PEj/hKjbdoV8jQ2SKhob9gbdWNji4ABDfcbr7V/SrNRmv49ia
	hJ+DrOF1cMuZvmygHUhrNqtm6kQnianS0r/7m7XhZKX0Ve0Hwz+3tHwufe1PELHEgynRG4/fb9V
	Hn9nZ7OfQXAZXrKSBRmqrpNi
X-Google-Smtp-Source: AGHT+IGYuX6DEVvux9D6we2SiyjcWB9Wzlhs2PSZFmrr9xCNLsaTcfFGj1Fx7uNY5ElMSYCVEi+MGg==
X-Received: by 2002:a17:90b:50c4:b0:2fe:b937:2a51 with SMTP id 98e67ed59e1d1-30864173434mr10200925a91.33.1744903930933;
        Thu, 17 Apr 2025 08:32:10 -0700 (PDT)
Received: from fire.. ([220.181.41.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30879f9dd79sm52496a91.31.2025.04.17.08.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 08:32:10 -0700 (PDT)
From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Zhongqiu Duan <dzq.aishenghu0@gmail.com>,
	coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Simon Horman <horms@kernel.org>
Subject: Re: [PATCH nf] netfilter: nft_quota: make nft_overquota() really over the quota
Date: Thu, 17 Apr 2025 15:31:10 +0000
Message-ID: <aAEamcS1xBIGfJ1i@fire>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aADkVkvVHlCpw061@calendula>
References: <20250410071748.248027-1-dzq.aishenghu0@gmail.com> <Z_2EYV1JiDkgf3gm@calendula> <20250415140401.264659-1-dzq.aishenghu0@gmail.com> <aADkVkvVHlCpw061@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Apr 17, 2025 at 01:21:58PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Tue, Apr 15, 2025 at 02:03:59PM +0000, Zhongqiu Duan wrote:
> [...]
> > They behave differently in the case of consumed bytes equal to quota.
> > 
> > From nft_quota:
> > 
> > 	overquota = nft_overquota(priv, pkt->skb);
> > 	if (overquota ^ nft_quota_invert(priv))
> > 		regs->verdict.code = NFT_BREAK;
> > 
> > The xt_quota compares skb length with remaining quota, but the nft_quota
> > compares it with consumed bytes.
> > 
> > The xt_quota can match consumed bytes up to quota at maximum. But the
> > nft_quota break match when consumed bytes equal to quota.
> > 
> > i.e., nft_quota match consumed bytes in [0, quota - 1], not [0, quota].
> 
> Thanks for explaining.
> 
> > Also note that after applying this patch, nft_quota obj will report when
> > consumed bytes exceed the quota, but nfacct can report when consumed
> > bytes are greater than or equal to the quota.
> > 
> > From nft_quota:
> > 
> > 	if (overquota &&
> > 	    !test_and_set_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags))
> > 		nft_obj_notify(...);
> > 
> > From nfacct:
> > 
> > 	if (now >= *quota &&
> > 	    !test_and_set_bit(NFACCT_OVERQUOTA_BIT, &nfacct->flags)) {
> > 		nfnl_overquota_report(net, nfacct);
> > 	}
> > 
> > Should we report when quota is exhausted but not exceeded?
> 
> I think it is good if nfacct and nft_quota behave in the same way.
> 
> I'd suggest you collapse this patch.
> 
> Please, route this patch v2 through the nf-next tree.
> 

Okay, I will send v2 to the nf-next tree.

Thanks for your attention.

> Thanks.

> diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
> index 0bb43c723061..9fd6985f54c5 100644
> --- a/net/netfilter/nft_quota.c
> +++ b/net/netfilter/nft_quota.c
> @@ -51,13 +51,15 @@ static void nft_quota_obj_eval(struct nft_object *obj,
>  			       const struct nft_pktinfo *pkt)
>  {
>  	struct nft_quota *priv = nft_obj_data(obj);
> +	u64 consumed = atomic64_add_return(pkt->skb->len, priv->consumed);
> +	u64 quota = atomic64_read(&priv->quota);
>  	bool overquota;
>  
> -	overquota = nft_overquota(priv, pkt->skb);
> +	overquota = (consumed > quota);
>  	if (overquota ^ nft_quota_invert(priv))
>  		regs->verdict.code = NFT_BREAK;
>  
> -	if (overquota &&
> +	if (consumed >= quota &&
>  	    !test_and_set_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags))
>  		nft_obj_notify(nft_net(pkt), obj->key.table, obj, 0, 0,
>  			       NFT_MSG_NEWOBJ, 0, nft_pf(pkt), 0, GFP_ATOMIC);


