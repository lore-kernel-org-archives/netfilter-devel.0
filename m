Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7897EFBF6
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Mar 2025 00:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741651239; cv=none; b=qQ43waTcLNVh7jl7AZJpy5sr2g/h+5RwSO8tBFJhkRjGYRnl82xs/bedUBkpMnq+KGfPC/AnPCnwrzNSwMnKDHrIvbByoPuIgsW7hIOnvf/G6ifxkQXMWoimLiXvsxJyBRrESlvMJryX20A9UhBEI1+lEPEHF9GXy9QDmVdYVZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741651239; c=relaxed/simple;
	bh=9hqD0D73HX4hk0Y8JNRJAQiP5uKb0j7DzpRK2gxnJKU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B9dpTM0GGzuxYixQ9BQi6JWfrTi7bQ9d7wyIbj0Uda3ybCLi+BmGhW72pJpFDqW7gk+cWtCTGlZDfT7uRiY8atV3ITviKZftkhfVUWiKA3Cp0wDIiz0az0Bo/v5QsB++al+5uVLtiRqOdfLRWqPQ2VMNRNvhLRjhua+rqwjIF6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nfKuCIpW; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nfKuCIpW"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2241053582dso81727935ad.1
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 17:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741651236; x=1742256036; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9hqD0D73HX4hk0Y8JNRJAQiP5uKb0j7DzpRK2gxnJKU=;
        b=nfKuCIpWVdK8MhZgMEgcQw/UOT6lHvoEj1+A/G+FLw1AqDEApy2b+WPTlFpSqSHFSQ
         T8rtLYfs+GXafrVuLUOwO+KpUuRpr1QW+MTSYrRZXisd85p3PvBMKpzrm0jhUomFFAcT
         kGOS+Hl/NHm0AcAsKssYY/W42KbwAiAkvIRkrP1d0UY3XRVHraszAJUlliEWXOwaRMJL
         eMGvantdSLUlQjsAdNrLsAJT+Jw9tXIH6mzdZ9Z1dPA9lYE7cENU16ZPpzHfKTD5aQWe
         2vyUuef7TLNPMawPaWr1EX242vwIwDFdiJ4MKnaCd/eN+erxKdjbgtzbDTPJGTjVo3g3
         dwGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741651236; x=1742256036;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9hqD0D73HX4hk0Y8JNRJAQiP5uKb0j7DzpRK2gxnJKU=;
        b=n8kwqfbG8ti8isDYRYrbWkaT/etVl7I4YNQN9M4GJklZwh7jORiFjKTtgEYTrQww7Q
         fc96q+N7TC58SYik09Il0dVa886pb5bPfTlmljaaUCWXbuw9rM1mawkdGgtpmvStO7dH
         NYNSwTuKk2BoDhFJmZpIwgI/TUDsSY9BA/LiANO5nJrgjN8nRHjCqYxGUptmiX4d1zvV
         exaujwI/F9RnX2TzNFNCp8ys1mX5jWed0oRu4caFclyJ23OHkImtB9GmueaYoervltJh
         FwjSkT/bp2UM07Q3ZYYu+L05J9lPu+WDTYveP/snDFbZpAJHrvRJB7yQRIoTV62oxY5Y
         dwbw==
X-Gm-Message-State: AOJu0YzLAE+sja/vybz7lTomLb4YAK7OL5TN3JJvhNLZMhbjMn3fXbg7
	Qw+lFrG89AliV/WFqthMUyAwfPJ3d/nONRUaDF0gyl8VQz0IRj7F7URc/g==
X-Gm-Gg: ASbGncty55+pYXvYEdVHYh836iVOvR3KubXLoO42MO2jhAxf57dQaxykPNBW1MNfASb
	p5D5r+01c6CVvQexahPrTUqprYupRfH/3eohtAi6U0sAB0Ps2biS5elwaFrT9FDEs5GJLUTjL8R
	zB3xoel8gQ9KB64kYuEQ+x6yD/yHCaSqWf3rxh+HwnDyAkI0P/7CZqZ8R81LVtrqyvu/rdp1rDg
	XiLNagmvrdAOzbAsEddFlZAM37HMNAkVTXsZNuF0BS4BtICUvIz/Yn9hZCVswB08w8RF0QItlTw
	tp5/5Sf6tdR5XFkr4RGXsjr9RLNYtBuuzUaX/c3b6+mzXpnqDeFZqeQH2uPCyfhEDBLiUtYBtA8
	c57yccbSmv8tV3IioVelFJw==
X-Google-Smtp-Source: AGHT+IEeeyQaRDQ3onfOKWGPxXsz41XvOTMUj23lZmWXidx+A5YzpLcIiO8CvLX5VSGSuIs7GeMqqg==
X-Received: by 2002:a05:6a00:4b11:b0:736:42a8:a742 with SMTP id d2e1a72fcca58-736aa9fe534mr22348759b3a.11.1741651236558;
        Mon, 10 Mar 2025 17:00:36 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736be0ae3desm5627690b3a.12.2025.03.10.17.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 17:00:36 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Tue, 11 Mar 2025 11:00:32 +1100
To: "G.W. Haywood" <ged@jubileegroup.co.uk>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Documentation oddity.
Message-ID: <Z899IF0jLhUMQLE4@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: "G.W. Haywood" <ged@jubileegroup.co.uk>,
	Netfilter Development <netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
References: <9190a743-e6ac-fa2a-4740-864b62d5fda7@jubileegroup.co.uk>
 <bda3eb41-742f-a3c3-f23e-c535e4e461fd@blackhole.kfki.hu>
 <4991be2e-3839-526f-505e-f8dd2c2fc3f3@jubileegroup.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4991be2e-3839-526f-505e-f8dd2c2fc3f3@jubileegroup.co.uk>

Hi Ged,

On Mon, Mar 10, 2025 at 06:00:40PM +0000, G.W. Haywood wrote:
> Hi there,
>
> Another one for you.
>
> In the docs at
>
> https://www.netfilter.org/projects/libnetfilter_queue/doxygen/html/
>
> there is given a command to compile the sample code in nf-queue.c.
>
> The command given is
>
> gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
>
> Here, and I suspect almost everywhere else, that doesn't work.

Works here with gcc versions 11.2.0 and 14.2.0.
>
> Should the command not be something more like the one below?
>
> gcc -o nf-queue nf-queue.c -g3 -ggdb -Wall -lmnl -lnetfilter_queue

gcc doesn't care, but the conventional order for command arguments is option
args first, as in the docs.
>
The -ggdb argument is obsolete and may be slated for removal. Can you please try
this:

gcc -g3 -gdwarf-4 -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c

If it still fails for you, please let me know at least 2 things:

1. What is the error message

2. The first line output bu the command "gcc --version"

Cheers ... Duncan.
