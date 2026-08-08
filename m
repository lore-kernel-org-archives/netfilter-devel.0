Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C743C2E762C
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Aug 2026 06:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786170403; cv=none; b=NSH3jyUBRz4+O7W+DguaER3kaK/zOkLL7NVRIB73apPuCda4pgZglbOk65qC4GiuWSJQ17gJMp6iPJsySWZnzl/cntxcO1rh2Vew640W5mFQD3gfPL3PgObI4fIFAzdRGIW5N8VfMb7cy6eqKuqntyIxeByCb8leM/vyW6etzjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786170403; c=relaxed/simple;
	bh=qtBFllAz+p5PJC/LQ3QUUdjCCSGJucmC1kQ61oLXxio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Igf1fE+i4hizjMLYkoxm9xeHjKyHViM/5cGY0hfWXsMBP82SoIu0QLAHz8fZ0tdG/Usm/IIK5GUOu6r/hZ8rG9zSPFCU0lFA6BSrMsPOT8y0ak/6o0j4/EhkpOGyrXiwFGN7LIhWctN2MA0IrB8aA+MUzbHCORYf8M1V2kjG4v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ayPlr+/4; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ayPlr+/4"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cf27856f9cso3453015ad.2
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Aug 2026 23:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786170401; x=1786775201; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NIaIillW/ES5KIua50EkDl/Ri/Ln0jxYV+0KVd83QO0=;
        b=ayPlr+/4k8Omm7f5exWi1le/vvvcx5Dkv5XthOXuNngZDA5qdYmTEPI92Sdt3+lOFh
         GW+6XB/P0sd2vZvXqNCJ1qm3/NvydKwCO26BGbNCX5sXqlsfHG43nmce9dCgCobvKzRN
         M5K16BgfhxA8Rkpshru+ngjYIWW6+zdxF0a0uDGwnFE0gTNPDgffMzOiwwchFgQtpjWB
         vftjHfFafewcrZW3BfOPFSV0ZzYuEfusWpj6jHszCqS4+g3lK/UxlCWwW40e80TQKFLT
         ATKXiy19mA5xQsxC4STdSSp2+zzW//0kevyrcmPjZz0ASQ4TPZ93lHE7gD6D1+PhfOFD
         7KAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786170401; x=1786775201;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NIaIillW/ES5KIua50EkDl/Ri/Ln0jxYV+0KVd83QO0=;
        b=jOxVV3rgb4VCRMjyPsNRiLsnsXyUm4wGrQ6j+TmSPVWHtiHPxkNj0Qx8FXrnWO/iWb
         sM9Ktmzi/2/Xe18F3Sa+WPKa5hrvVDmqqTgFVQOTAIQ5s3vmzKtBsrSviWdi0eKN8AZ/
         rqLBt2+kMWs5ZS5GExIPeSxFA7w/UUazGOWw/N77dJ/ym54dlqSCPNlzc7xk/rnFd1OR
         n0urfbeGILfiUwHO6jBIr4yt/lqC6u5zQY6ksv4tlfqVQxwzEftvZvDNPZ9MgjclDouk
         gEXMDvgEJTTp3AopDY5F8g0QS/mPfj+vtVPhNPrc5run94kDec3/MT36/CbciznmFQjo
         p0Ng==
X-Forwarded-Encrypted: i=1; AHgh+RpV7UTOehAEhe3cwz1dyAriMvJP/+vjYLglW3yXX/fiNTSlotJHHyubAymz5zUSmDJjuIByyCfCW6V4S6Y1ErE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPcGk7ufxYfQuBViOf6ZJTSpDVvXbZyZmZcrnvk+0ruJsTLjwd
	xqVrRcqgSyGS3TK0yCozzEyRyDb6TvjqufUchVAIPIAvwhel5gx+6aLA
X-Gm-Gg: AR+sD11ADe/YusKAyYV0aWyYVwJkyvGvIHdgsYhFANCLZpMpykkBXoDQW8lKJKG6rn5
	YSDt5lHvqsSFmUUZrxvXpVpWAytMLPOfXJAlOSFC3Sd4fHcvzYFgUdxRtYW/SkbI0qmJ0CrK5Qf
	fJ5ghxMuFDIKLPxB/qJPyRQLyHafS6bAZZTvFbRIh4aRWUt7oqX+OO4YfN1nS3xXtiRmCTEL1pt
	OYGVTv14YVVJwG9+gN4DRCS8S/hPDGmwpMyMK7UUHtCbCXvmXxBtdKM+AZE/WYP5lEqYxMSivuw
	cVofD4M3tA4TSq85EyslnCb44lXgQ3YA9e14ba5F0aSs0GQlN3FytISfXJnrDysJ9rGMF4IJ4ye
	9l+qe+N33Ax0Dmp54rKS5G28S9oApeNiaI4GX2K3c0Bgw6bPjNgEwDFot8bA6CcTQQ61YNmDtJs
	OwPuPIBMttPmkLNOe0TPfTvHn1kyxJdNuFQhEx038UZ5sY2LAqXr7Hg3w=
X-Received: by 2002:a17:902:f54a:b0:2d0:cc92:f7ac with SMTP id d9443c01a7336-2d0cc9302b2mr308403715ad.14.1786170400784;
        Fri, 07 Aug 2026 23:26:40 -0700 (PDT)
Received: from fedora ([203.175.12.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d16c4fc743sm15991535ad.80.2026.08.07.23.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 23:26:39 -0700 (PDT)
Date: Sat, 8 Aug 2026 14:26:33 +0800
From: Hangbin Liu <liuhangbin@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Qingshuang Fu <fffsqian@163.com>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: Re: [PATCH net v2] selftests: netfilter: conntrack_dump_flush:
 remove unused variables and fix typo
Message-ID: <anbMGS9TFOEUUWu-@fedora>
References: <20260807075928.64326-1-fffsqian@163.com>
 <anWgQSbZWK6D2ONg@fedora>
 <anWyMUFvONx6k1d5@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anWyMUFvONx6k1d5@chamomile>

On Fri, Aug 07, 2026 at 12:23:45PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 07, 2026 at 05:07:13PM +0800, Hangbin Liu wrote:
> > On Fri, Aug 07, 2026 at 03:59:28PM +0800, Qingshuang Fu wrote:
> > > From: Qingshuang Fu <fuqingshuang@kylinos.cn>
> > > 
> > > Remove unused 'rplnlh' in conntrack_data_insert(), and remove unused
> > > 'rplnlh' and 'nest' variables in conntrack_count_zone() and
> > > conntrack_flush_zone(). These variables were declared but never used
> > > since their introduction.
> > > 
> > > Also fix typo: rename misspelled conntracK_count_zone() to
> > > conntrack_count_zone().
> > > 
> > > Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
> > > Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
> > 
> > > ---
> > > v2:
> > >   - Drop Fixes tag as this is a cleanup, not a bug fix
> > 
> > If not a bug fix, you should target to net-next.
> 
> We will handle this though the nf-next tree.

Oh, good. That's more reasonable.

Hangbin
