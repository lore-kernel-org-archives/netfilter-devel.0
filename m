Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B478A3FB2E
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2024 14:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710166921; cv=none; b=Piui4BuDZjX4tG9oO7Xi6LLaUzreFeJ0MqR7V8BJcfavORFGI19ml9I55njT+aS7ABMS99tKvY6/C7iIl+1uWFlxmzMDHS7UtpayuNbCevgeHVCbHk0c0CWw3RmvrE5Fjs0qWQBB345Z4Fhw1kCjoJjbYnzugAM/CzKmlw7BRxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710166921; c=relaxed/simple;
	bh=0Vo8G485tZHN071U++4CbOj6DieonWF8FnebRr+8nbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CzJEie1sVgWJLY/IIasdTWVJr0xDXua2Y+2YnCLE+N22N62Gwg1BhjIQ5rLMiygNcMkJSxYhGosCq5saTxr3NaNCc+LdpAETrWRJXF687OFiRdO3EzEWNhnq4+RBeOkSqbVTSRWVwYulM1Y27UZ56T6kzyfCB5PogWVos8oKMNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WiZmhh+X; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WiZmhh+X"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dd8f7d50c6so8281685ad.0
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2024 07:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710166919; x=1710771719; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x/I9xwhpMN6MJEBUCsx1WNIBSVVSB78z2ngbsrUQcIQ=;
        b=WiZmhh+XrQ4d4C5k8Fad/muhrTZe5PURqsnX9n1TqqyOyUhFfBZOZ2/7furhoYRj7x
         DzPCCwHFqi68gnASQG4lvRYhR+rMI722F3XdqjGLcHoEcnNniGv1KWPIKzg9+vPWjo8q
         LJBK6/VOU8JstmxieHeZvnDZSLdLzgtr4Kx3/lwtd9KV0KgAO5sw2MdcGWR91tXHxRH2
         CThGCFLp2Jgd6hW41DxyYDDpxbV7aQZe668hXCq4PT/757DR3ioQBXIg/bfIIS1YKrK5
         SzQaye6n4Tg400drx3ixEqqzhb8kDduT4YGTpVtHApGV2oXCP7sRGsvYtJ+3x6tsw5AB
         AGcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710166919; x=1710771719;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x/I9xwhpMN6MJEBUCsx1WNIBSVVSB78z2ngbsrUQcIQ=;
        b=eI23PYTW2wRt+oG2xTCqxG/U9nqmHFTJ5K788Gm7eSw4y98bqUr3V3fE5oiLBwon09
         8WyY/hIy7hSV+02haCOnuoG3WA7R0xW3SOf5ENTC/b4Ia1952oGlLQux38H6UASxCLtw
         oL5iCUKw+k6Zb2OkcdrVGhA3kxdT9j2MU9Skg1BSZX2qGv5TQI435OFbtc9GVSQmAl0L
         XudZZtPL6hLxFA/buJ+eHismyzb6IjsGQA8zm6DXbONItGQ0NlXha3XLbE5V9TA8g1nL
         IbzhoRnhN2G1dhewHVWPy+eknfu596bqRo3def4mvL9riRMEO7AEt6ldgVxg8BUC7U0M
         Yp5g==
X-Gm-Message-State: AOJu0YwPWyKPtWLNrR+Tu2trDAFYIk2K++nbFh63lm4Kge2/pBX4Fgph
	mb88JG2xFG0k6FkjxfVn8sCm4uDbE5NQUnbsA5wPf3QNhCY2dQYjqWSiubVi8F829wtL
X-Google-Smtp-Source: AGHT+IF7e+VBF1opYlZvR2oCY0qHq0xPQTSStAsHowHTK2MDUofu59fpYhWkfXKn8o+lFqWzU8kjGQ==
X-Received: by 2002:a17:902:ea01:b0:1dc:b6ef:e237 with SMTP id s1-20020a170902ea0100b001dcb6efe237mr8958161plg.31.1710166918914;
        Mon, 11 Mar 2024 07:21:58 -0700 (PDT)
Received: from ubuntu-1-2 (ec2-52-199-81-84.ap-northeast-1.compute.amazonaws.com. [52.199.81.84])
        by smtp.gmail.com with ESMTPSA id x12-20020a170902ea8c00b001db2ff16acasm4723619plb.128.2024.03.11.07.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 07:21:58 -0700 (PDT)
Date: Mon, 11 Mar 2024 22:21:52 +0800
From: Quan Tian <tianquan23@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org
Subject: Re: [PATCH v2 nf-next 1/2] netfilter: nf_tables: use struct nlattr *
 to store userdata for nft_table
Message-ID: <Ze8TgMaRLfFKsYaj@ubuntu-1-2>
References: <20240310172825.10582-1-tianquan23@gmail.com>
 <20240310230923.GA20853@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240310230923.GA20853@breakpoint.cc>

On Mon, Mar 11, 2024 at 12:09:23AM +0100, Florian Westphal wrote:
> Quan Tian <tianquan23@gmail.com> wrote:
> > To prepare for the support for table comment updates, the patch changes
> > to store userdata in struct nlattr *, which can be updated atomically on
> > updates.
> > 
> > Signed-off-by: Quan Tian <tianquan23@gmail.com>
> > ---
> > v2: Change to store userdata in struct nlattr * to ensure atomical update
> 
> Looks good, one minor nit below.
> 
> >  	if (nla[NFTA_TABLE_USERDATA]) {
> > -		table->udata = nla_memdup(nla[NFTA_TABLE_USERDATA], GFP_KERNEL_ACCOUNT);
> > +		table->udata = kmemdup(nla[NFTA_TABLE_USERDATA],
> > +				       nla_total_size(nla_len(nla[NFTA_TABLE_USERDATA])),
> > +				       GFP_KERNEL_ACCOUNT);
> 
> I think its correct but it might make sense to add a small helper for
> this kmemdup so we don't need to copypaste in case this should get
> extended to e.g. chain udata update support.

Extracted a function as suggested in v3, and also used it when
duplicating the userdata when preparing trans for table updates.
After this is merged, I could extend comment update support for other
objects in the same fashion.

Thanks,
Quan
