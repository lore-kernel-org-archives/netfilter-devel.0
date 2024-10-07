Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA4618BC19
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Oct 2024 22:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728341447; cv=none; b=VMUNoVvbM35BNvjqw5GFOs3iamsT2iDVdWX96qa6I8NXR9X7HYnBytyP/cXrOAlbvw8ALGSULOjuJdkkKRhjaYAbPKWZNfh4S/TdwMv0468AFihYt+qzcBC6sBWeUIsN5WWgBJOC99Dwn27jwAXNZRHuf9/5gpNgsIuGuBtAIfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728341447; c=relaxed/simple;
	bh=916ByeMBhbwhUpLrqm9a5f7EyTxTlZPsB/rJDe71CQo=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t8i8WH+gEO6BZ5KCDAcrhgoVPus6ebCD5CcIDaDuzs9iaQJFmSf8VIoq416uBZrqsetIBz0n1F/JFBCuGPV72A0hx9iHg0PqzLc0b2VfbEN5NDn+rdUX1FV4MzpgX2yqwHgo8P0wOw6ZkpCupLNPlckBi/ESnWvl8rbq+/IaLco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XU5Ld9au; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XU5Ld9au"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2e0af6e5da9so3682218a91.2
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Oct 2024 15:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728341444; x=1728946244; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=916ByeMBhbwhUpLrqm9a5f7EyTxTlZPsB/rJDe71CQo=;
        b=XU5Ld9auocCj/SR+D58UQoaAckHuZW8PZ1FcL3x6hbNZEuJMvHS2AJbui3sLlAFQ9Q
         GZOfHDTcxGGven1k7ZxYaJo+OuWghaAu4s1t41b0ERl1L2fcdXwVRyVpDpCGJyhcSH5e
         2oKueibiSnbvSeafPmoRfMlxYuPfNMrQCsTZDqUr6qrfiSNVk8LpJNj4Xn9JHHuQEvoR
         e8wuHPWgHoD8t9LYi5DCx4lRKJxd/GNvzIcdNo4D1z973NGH41NVpLkV4tijxm1SdvvS
         PxWxWwjAupwq+hjwZmz8hXAHf9sGrKS1aH2+ZM8mrURwrLUcvssxY1jCQE3jEKqTSXuP
         z3Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728341444; x=1728946244;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=916ByeMBhbwhUpLrqm9a5f7EyTxTlZPsB/rJDe71CQo=;
        b=rHSKUYfeQT+RNRkGsS0b4hJnq9G0PYJFMyRTgNGsD1BNmnmMz9cfzYTFtI/s4QYT6V
         C2WzOAgpFZrqchJrcNP9pUbuMQi/C/pCVyj5ba4zdyfb6yR+fhxuMUa6aD1c+cgQi9kz
         vnwQwQp6PsTgBlLVfPKP4+a7Tf7th6Eyovd9hntwJKcUZg9IMO6ZuAHSb5EgLh7Juql9
         cQLrB504aZSJK58MwKz0eiCPyH3e0kEHuAEi4JpJ3KI8el/HuMLe5PvGFGy73VXFTg3C
         5MxaXL8G5/wL9co9xzrxAztXAzPKsCGjHBQOvxz4b0zVWfH0to4Nr8BgYLMuGDQevtYn
         j7yg==
X-Forwarded-Encrypted: i=1; AJvYcCV0LN/JiXx8FQS+WBDF8iEIZqrI+tiHaxVWZsMfnPVQVABCuYTyMhgQnpcUMY3b/gM2rfq2tB0TyMvSWAGMQ+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNn4keH6nsncVscnFi4sBiQp2yNncKGIh4ICXWdBrv6l4tPb6w
	lcdBjREGi7SerzdlyCvUe75ZNg0IngpFA/rO8iHmUpmxmR09qcYHBk/WwQ==
X-Google-Smtp-Source: AGHT+IGYfSX8Ud1aUDOMN3ESWhsRGEOyr9VnTxlLlx6XxNdPm+DO16+GYAyj5aYW8Lx6mU3S9Qg7Sw==
X-Received: by 2002:a17:90b:294:b0:2c8:e888:26a2 with SMTP id 98e67ed59e1d1-2e1e6224842mr16980341a91.13.1728341444141;
        Mon, 07 Oct 2024 15:50:44 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e1e83ca284sm7767201a91.11.2024.10.07.15.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:50:43 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Tue, 8 Oct 2024 09:50:39 +1100
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] build: add missing backslash to
 build_man.sh
Message-ID: <ZwRlv2f01Yl8osav@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20241004040639.14989-1-duncan_roe@optusnet.com.au>
 <Zv_rJM6_dyCVA7KU@orbyte.nwl.cc>
 <ZwMi1knK7rqs+iEy@slk15.local.net>
 <ZwPS-3s2-wUcVBzU@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwPS-3s2-wUcVBzU@orbyte.nwl.cc>

On Mon, Oct 07, 2024 at 02:24:27PM +0200, Phil Sutter wrote:
> That's odd - while the shell will have to unquote the delimiter, it
> should have less work with the content. Are you sure this is not just
> noise you were measuring?
>
It sure surprised the hell out of me. I do know a bit about eperimental
technique having studied honours physics, so I reversed the test a few times.
The unquoted delimiter was always faster. The difference was very small but
statistically significant.

Cheers ... Duncan.
