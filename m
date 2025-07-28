Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E9E1DFE26
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2025 04:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753676017; cv=none; b=dSGiAH4McXE301bOuR7k0tdEcO1bNnbasmWSBbqN9FWAKZY1mmmWx/sONAx/xR9aO1oTiJtanuAVuowgcjCtSGTBYcnnlOngPgnQmXy0erCu5dVX063xTGGaZzYJhDYUsL2k7SlgWsF056bVrbZQLZI8zOd8n/L8zs6a6ZvGMBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753676017; c=relaxed/simple;
	bh=fNfU/keZ1onWD+VqeVOo7T2p/U2G+cVeyiWbFF4A9fI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=okAMF27NSZe75SEEE9U0wO7XhdN1qb6JvBqYR2+84v/rA5a/6MKaHuER3V+mDDMC3nMBYWM84rXaH6y8V1lfsiPu4aGsINAtE6k5n6P1/GRGDdVprTnjNME90/Idq6eZKrJtAFu6dbmgZMERltIGT6EkGTeIg7srMO9y2uzwIAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R244QhZT; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R244QhZT"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ab6b3e8386so42508681cf.3
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Jul 2025 21:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753676014; x=1754280814; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jTAJQkchRGvmmjR4kkge95z0weV8RYa+PjNBS+woa5k=;
        b=R244QhZT/fIuntYm1ixPTtHGWnACfu0jdMTzbpVcgBye9xfxACXJ9GMn3m4iEJ05nF
         cZVWl9vgTTfzKnUZl7XoBK9EtGE0xWiM5NjhdqqPKxDuFYzQ/lTIr/Qi01F63meWL8B/
         0OVI451LWZ6cqSfRbZOYH6QtQ5KHqGa3qH4jOYJWq+xK0lqXh2zbqbLAydNVqc/Cehfr
         bPFgdWvI6Fi7BcBu5jm3TCpkecTYCcdqnkzOt+8KoN6ViXlQQCV9TVJ0XwHgwzaDbswp
         2cnvhFiVWY8iiplA15DulSKCNXcs3LjnBWQ3FDeN8R5/dOCXCdBZau02qKls/LQ4qTs7
         H1LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753676014; x=1754280814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jTAJQkchRGvmmjR4kkge95z0weV8RYa+PjNBS+woa5k=;
        b=sQ3fErAhbyX4PBIoZAPoUTULuwNgeWs0Krl23T0aHXT+oO34nOHXTh4/p27tTQ77QP
         2THIpzSFnafKxJwqgomBx/zVsTT8wAf/0+OXn/Z61dnsiJD1glAnw9WA+Q6lPGVpBqZ+
         zxT7eaU4GINLUXActUEMSGlO7PETawCoGv4Jz7vrn3DXXqBdvNJaf6P8j8BwAfAv3e5x
         dDUF7/MMr7j30UpNnLvybkWa26JAkdn+yYShGSINcIwwV9TPJRU0YtR3A+sSyoEMLGQb
         fw9sFm2CelJC+B1JzRM4hDDge/8JeCusJHsCgVKrJfOKI/JRi/b2Sa07QVGvufP742or
         xkVw==
X-Gm-Message-State: AOJu0YwucO7mA0dZ/DNJ6QfkONgowrQNR5N4ZL7INpShTPcN167I8GMy
	DkDhgLGHOk0drIOEV1/e1myt/V54OFw/opEzWZcFdwnpxMGYmq3tyAEECpAl7A==
X-Gm-Gg: ASbGnctVw9bpJ3hCapa7p4ugmfco5mjK9lx6eoLvBFe+BgyFGrPI2CLVTB6zzB8rCAd
	OHrNxSI213vrEmjdj5sRzU042EZm4XtFhHw8XvFbSIeR4qzXUcm/15HrqnjC+NlG3ea9atdNeRN
	xx7sSu6vqlKjBk+ZFq6RGPH8v/BjAKLt3SyFrUTFS5vp9wOrLbl5UlLGjEDFLiuRKbA0K0tiRV5
	3m7pzBwviAOEM9BHvqwg5Y1LsMIIYyOFtYGdhQgTMWvvScWKH1Wiugs2zJvFSXIjKlFQY5HwF+Z
	KKdMh1d7nFddmWI88H8Wzpm311XESfSMyg34FSQG4WvlMPVr2nxJ5xsLN5TZ9Kvk4EWb/5FLbe3
	xPq+LBnwa6juXyRllEXQgSVn+G7aIRuv07fwYSw2ZolC+X2zRyPE2evS2vgmGbCcyqg==
X-Google-Smtp-Source: AGHT+IGX7ZmgcvkY4jghbgNimJj9MR0ho1zEWajaW+DsEF4Pnctbrsv7eu5sLcokZrSOQ80GAvsv6g==
X-Received: by 2002:ac8:58d2:0:b0:4ab:608f:6d0e with SMTP id d75a77b69052e-4ae8ef7569dmr118391951cf.22.1753676014319;
        Sun, 27 Jul 2025 21:13:34 -0700 (PDT)
Received: from fedora (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ae98dcd600sm30875411cf.0.2025.07.27.21.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 21:13:33 -0700 (PDT)
Date: Mon, 28 Jul 2025 00:13:32 -0400
From: Shaun Brady <brady.1345@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, ppwaskie@kernel.org, fw@strlen.de
Subject: Re: [PATCH v5 1/2] netfilter: nf_tables: Implement jump limit for
 nft_table_validate
Message-ID: <aIb47BFO38UZGGWI@fedora>
References: <20250520030842.3072235-1-brady.1345@gmail.com>
 <aH7zWPAVRV8_1ehk@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aH7zWPAVRV8_1ehk@calendula>

On Tue, Jul 22, 2025 at 04:11:36AM +0200, Pablo Neira Ayuso wrote:
> 
> This function is called from abort path too. I suspect total_jump_count
> for this table will not be OK in such case. And this selftest does cover
> many cases.
> 

Your suspicion was correct.  It took a bit to run over the abort path
that used validation (I think it would just be userland sending abort),
but it looked like it updated the total before the roll back.

My solution was to send in the abort state, and when
action != NFNL_ABORT_VALIDATE, we don't update the totals.

Another alternative would be to just run validate again at the end of
the abort (after the rollback), but that seemed wrong to do the costly
validate twice.

See v6 patch (just sent) that also addresses your other feedback.



Thanks!


SB
