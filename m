Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BB01759F
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 09:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710493611; cv=none; b=q4nititdNqdN3mXM5tTHDXnNsZf71R2HiJtIHKPQwK4BKAB+JVl5uIIyGAB2inrqJCatelaSFplcJc7u/zzeoPuwYEFCGj7vbWjNQDkUuKUPeyqHaf5iV9q5zcaGG76/KO/TBZH4IBSjbIl/9QAFXtghLl5tN56izhnk7Nwqu3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710493611; c=relaxed/simple;
	bh=K4dDHB74PXfvNCVLoYdLVA/VEx73fqWBIX8jIgvxpL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KH+911HUD0thiwfGYyEe4EJeedAhYbNiIzZiY89bimxppa1HMHNPDpp4PjG0JqHYZLPCz8pRCy1w8E0+1Qfj6ybvqYBeDVyUU6T8331j5MUD6lOQfgZ5MsBjNA1yWs+kRFxLAOW7wEq+cM6fdyFiKOQ3AezuLyApLBVFAR/VNh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SFHIEsR0; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SFHIEsR0"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e6b5432439so1904762b3a.1
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 02:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710493609; x=1711098409; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=quLYJEMYJ9VNe9qpO0Vx31fTORna1o2bb1uYBff+Eps=;
        b=SFHIEsR0APqixqobQV2GSzGdgBbpKi2zlzRBRJvV5y7WeNRRNDkE3mB1oHSvgboLG7
         r+FdwjKBdYyDS5HaGmWCDc0M+sZZYkkC1vGvuFx4l5XWEAIORIzn99ndFInPwC/oYCwe
         NeyfLXXxCpWbGFMZNhTQw2EkFB/bmFMOynqsEX+ptwkLpPPob3znLCXkcqXprkAK3fiw
         d3LxvZVFRcKlpdl+7hkncNzgUInqJwvPKbtg+68JrN+Zr40JZRCBtBeH4nsbOCJ6EBsr
         BLlj4rXbCjti3FYO31WR2AACtn0YHX5u221QlDPUiSLjVbTdOUMw69N6LNu1nmS19enY
         co8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710493609; x=1711098409;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=quLYJEMYJ9VNe9qpO0Vx31fTORna1o2bb1uYBff+Eps=;
        b=lhwGzepMshcuhjqtihPMfTecglCndcrxecQeSpo+U7rvJaQfyxXZ3xjw5Shwl6/CM6
         D4mqy++TpniLcgGAw8m723tRf/Nd2qDX11AaW0vopcMBD5i1+94oJiOzH9u1CnAGtThv
         apf8/aIiARuxC4DCxi0ssMt2uwi4PVIjZFBWBkreHNh3wOXM/SMv1pFLVSBKB9IMgky2
         Q/kX8yhV4I8uqyU+/I9TnBIziUqm0+fks7aok9lH1KtwuDQAF1RIYEDC5jRvCD2PCPDq
         OjsKltWR8RcAaX/2/EoQ8vUwISaSoW4nN0bvqOgaC0EUw7pdWeMVWLDMk1RE3gdxiX4U
         PcmQ==
X-Gm-Message-State: AOJu0YxcAZsr0xOzGOppqkBOCyRSK7FlqUAhkSfO12y5KCd2GuBJgzt2
	otyWAa5NOVxY5d8/Pme0qi8L9xhHg+b4aFmvm37M0f7FRe0CqMD9
X-Google-Smtp-Source: AGHT+IEzrXr38vpUl3Hh5vyqskbzNXvDVcdvWC7qYWZuRVmdqkcdVoG0XKO9GHfCIk9QdkIeVpyIgA==
X-Received: by 2002:a05:6a00:234c:b0:6e6:ade7:acec with SMTP id j12-20020a056a00234c00b006e6ade7acecmr4786923pfj.31.1710493608603;
        Fri, 15 Mar 2024 02:06:48 -0700 (PDT)
Received: from dev01 ([43.243.14.10])
        by smtp.gmail.com with ESMTPSA id fb12-20020a056a002d8c00b006e4f644dafbsm2879237pfb.129.2024.03.15.02.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 02:06:48 -0700 (PDT)
Date: Fri, 15 Mar 2024 09:06:42 +0000
From: Quan Tian <tianquan23@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, tianquan23@gmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: do not compare internal table
 flags on updates
Message-ID: <ZfQPooVt0Ey+fIl9@dev01>
References: <20240314201602.5137-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240314201602.5137-1-pablo@netfilter.org>

Hi Pablo,

On Thu, Mar 14, 2024 at 09:16:02PM +0100, Pablo Neira Ayuso wrote:
> Restore skipping transaction if table update does not modify flags.
> 
> Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> This restores:
> 
> nft -f -<<EOF
> add table ip t { flags dormant ; }
> EOF
> 
> nft -f -<<EOF
> add table ip t
> add chain ip t c1 { type filter hook input priority 1; }
> add table ip t
> add chain ip t c2 { type filter hook input priority 2; }
> EOF
> 
> after c9bd26513b3a ("netfilter: nf_tables: disable toggling dormant
> table state more than once") which IMO is not the real issue.
> 
> This provides an alternative fix for:
> [PATCH nf] netfilter: nf_tables: fix consistent table updates being rejected

The alternative fix definitely makes sense. But I thought "[PATCH nf]
netfilter: nf_tables: fix consistent table updates being rejected" also
fixes the case that two individual updates updating different flags in
a batch, for example:

* The 1st update adopts an orphan table, NFT_TABLE_F_OWNER and
__NFT_TABLE_F_WAS_ORPHAN were turned on.
* The 2nd update activates/inactivates it, trying to turn off/on
NFT_TABLE_F_DORMANT, which would be rejected currently if it only
checks if any flag is set in __NFT_TABLE_F_UPDATE, I thought it's
not the intention according to the code comments.

Thanks,
Quan
