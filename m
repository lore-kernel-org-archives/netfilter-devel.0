Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6FE7B3D6
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 14:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710253862; cv=none; b=CgCUMlQY3iy4JCVdHXU3H8vhjWTbQ4jgTpG8FtksqU8BjaUKARryCc0WebGGqYHM2vThhy9OXSh1jg+1kEp4ek13ZIZMwzM892zKuJaQMPG2qofo5bur5DNbgL738YuaNUwUzSBZfFfHo8uR074j6hhCF2xNtMqWDiPABl6iJKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710253862; c=relaxed/simple;
	bh=kvJM1MAnqeywTQfmYfJhP2W4MDvRFNPcAj1N0/aJo6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hgSk0HS0F9EupThs7Jb5CZQoOnFJ6xYsLvacgb3w/gAaFYgSjAW10dao04JS+CHt+MluX618SlXPmCL4yPvXgdFq7z1QbdNPDZrje/QuwLJnnQzRbA/OGDz7IzcxWRA1HbOFkBiX5X7EG6NnHq82rp2BknQdcI+K7YZLAzBD3gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ohs1N85R; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ohs1N85R"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5ce9555d42eso4163640a12.2
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 07:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710253860; x=1710858660; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CaZcpRUOK6R+r9TrWxKbmBTcbs1xH06UjPhMMsvb2W8=;
        b=Ohs1N85Rc7AIjvNCh/jywKxG6WTSgBUX4GRn/wtO9GaSEhlgSulDSg4sg4qbDz47Sq
         X2IvVdzHRUpbBb4BAXEpXa10uVJy3i6gc0OqMuyWfDMSD8jhOIxoVjE+UXSTARS3HFEI
         mrYILIBeZiQ0QXw9CP/R4m4pTKM7slzRyXPtF/6AXT7VFNU3pcPdlUhCm9ssYhIokVaF
         lIhGEHAbJjIvY/0WgNN7QwOX4PlKeCVvVDHsgPSh0tryRL2YfNp96XSceWAdl7DsLr7u
         HPeMJgr2iAXbW5bjR/OPrTOfb48CpjlRCz7LJylwNAiYZgbYTvMJghxwTtf0WT0Rl0t7
         tPrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710253860; x=1710858660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CaZcpRUOK6R+r9TrWxKbmBTcbs1xH06UjPhMMsvb2W8=;
        b=NnNhC+GGuqH2j0yNxonzHLhl1LTTDnsT0jagvrpRyJ3NKPJcHwN12tlekK+x9msF0n
         kch/qOb60vc6ZA0g19vcOKgfg7qVdS7dgFWLJkEjKlybmp1Fb8FfINqBGyLd8w+3YHCN
         NRyYCAtZL3j1ripZOFuUpzTiT008aTL8IBt72QGjAmBX2BXvSfZXlUx/v1UHnxCC/X2L
         doshddV6b1V+5sxas2kIHFXXi86j4U5jXaIY42kgD8S8qFJhmwT1nXDWdc1sgEFYsO9R
         ZOYrdF8bGa7xGWIJ2dFBhYUaDtt19yklNqFH5S5J8eSxgmzBTGyNBwnlcsPxOOTz7Oiu
         XOUQ==
X-Gm-Message-State: AOJu0YwBuYfbGJ6mXtxUT+v/f2VHowrfdMEypsSoLrmRr8aHlG/6l+mh
	E1VaduxyCoZlbBd3TGHlN21m0wmIxqz0b+uSc6nmC2X11Jh0BIZFdzHFp6rW+O4VMQ==
X-Google-Smtp-Source: AGHT+IG/k96q40wXK7QCmOqjmBt/fBPz8eeshuslgcbILvCd0txuoQbPV7ipLrh8be7EtlhOgzQ2ww==
X-Received: by 2002:a17:90a:c292:b0:29c:14b3:51a6 with SMTP id f18-20020a17090ac29200b0029c14b351a6mr4111092pjt.28.1710253860173;
        Tue, 12 Mar 2024 07:31:00 -0700 (PDT)
Received: from ubuntu-1-2 (ec2-52-199-81-84.ap-northeast-1.compute.amazonaws.com. [52.199.81.84])
        by smtp.gmail.com with ESMTPSA id ju11-20020a170903428b00b001dd675cb6fbsm6754966plb.298.2024.03.12.07.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 07:30:59 -0700 (PDT)
Date: Tue, 12 Mar 2024 22:30:54 +0800
From: Quan Tian <tianquan23@gmail.com>
To: Florian Westphal <fw@strlen.de>, pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, tianquan23@gmail.com
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <ZfBnHgtMNY+sKrXr@ubuntu-1-2>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240311141454.31537-2-tianquan23@gmail.com>
 <20240312141046.GD1529@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312141046.GD1529@breakpoint.cc>

On Tue, Mar 12, 2024 at 03:10:46PM +0100, Florian Westphal wrote:
> Quan Tian <tianquan23@gmail.com> wrote:
> > -				trans->ctx.table->flags &= ~__NFT_TABLE_F_UPDATE;
> > +				swap(trans->ctx.table->udata, nft_trans_table_udata(trans));
> > +				nf_tables_table_notify(&trans->ctx, NFT_MSG_NEWTABLE);
> 
> I missed this in my review, as Pablo pointed out you can't use swap()
> here, because table->udata is rcu protected.
> 
> Something like this should work as replacement:
> 
> nft_trans_table_udata(trans) = rcu_replace_pointer(trans->ctx.table->udata,
>                                                    nft_trans_table_udata(trans),
> 						   lockdep_commit_lock_is_held(trans->ctx.net));
> 
> This will swap and ensure all stores are visible.

Thank you Pablo and Florian for pointing it out. I will fix it following
your suggestions.

Thanks,
Quan
