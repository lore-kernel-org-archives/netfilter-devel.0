Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9171B2518
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 14:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724251855; cv=none; b=qX2jEsnoXhVBT4GhVRJqrMsPQNoBKVYPJBGNKZ9Kr3W7F7zGUDUQvGdLpaW1J2h4tYtCYuyHpfn7Re43jctYf4JM3TL5SEnFpDN/7rCLLT/tSzweAtYBatavP7b/ppJy/o7f8xrE981JFKMw3jr6tpTd3gkZDufDy5zQEkLLXZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724251855; c=relaxed/simple;
	bh=Lz4JP4RGDLHi9RLgMyWvSGuFnZvOp5ENEyuoAWs/zpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KTdM5UMy8mTwkDbENTSLMJgN61TDsRVhYzzH9PCXMuH+epj9lTU5E+va1b6cFRVrRZ49O7Pie5gmYx+UIbvwlhK0EjrYM6bhviXEj11eIT0UvrD6UbXN0OCkbj2uibb0kwK9v2hMfR3xdF2m8BQQwuWRRQUoCKE3J/+EK8n6G7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ecBKSrpl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ecBKSrpl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724251852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y6RL4UN+IajAch5jP7ub0jIzRqoNQWJh8Odhf9HIiPk=;
	b=ecBKSrplnR/wvN3lB+9riYvk83SHHxOC9IBW/HKylT+8dGdXrnw6GtDiqrHMYq7a3H6/qm
	cEGqExBxigadVITNFIh7Gn7q/ECooja1ppUpzUogsTps5cr00oUYFa/OUTAT0jnlYZkFK4
	BLkh+FyrvxOKIyn157yfrmarkpSUbws=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-dFOwTy6_PIyi6_VOccOfdg-1; Wed, 21 Aug 2024 10:50:51 -0400
X-MC-Unique: dFOwTy6_PIyi6_VOccOfdg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4280c0b3017so58730045e9.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 07:50:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724251850; x=1724856650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6RL4UN+IajAch5jP7ub0jIzRqoNQWJh8Odhf9HIiPk=;
        b=tQ9w39JN9/2ivL4QLe6x3SUT0Lva83hBH1zLdfcu6eGR3JoZDPvIQanq+qbRdyymQX
         eBm5Wlr1Rb0/cHNQz9o2wz/oVZtNTh3UcVNSnUGo+YIzBv6Kj6Fj1gefUaaUIYu8PVpm
         SsKa4nalteEzCHb4FgZALpuairf0erZS+doGA8v+u1hM8AI2WPjmnVGi0z4KE/mcmeKa
         TkAnpmeopcnuAOHnNJm7QifV1olSFKP+6Jr4fY+xZSnfzeDOfGkvJIPEMVOESoaYih27
         l/UTX9DV9wpJKaYWReltZe4c85CWi982zI+xqUUpTWENoFRKmx+SfcO8pQCDKZzgnVct
         okfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXp/Xm6B+hGFBvpo91OiJnklIrZKrWEZRVsntiYwW39tZG1/8UQz34mNLHFckeFad8okkvc+P2o9BJBTDOvj6o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyC+9soT2GBfmcRcrblEyFV8AM77k8mmdhsuZ5mw1oBvYRcHRqi
	SVh95grcSxgH59afIj+fxzWIqwAKoqO0l6Adrc69hIqMuQzRtLeYlkqLmAT/y0EkJy3a8aM6rLv
	NfNM6cQayEy5PdU2GBlyNzE10mYSz2B8XCrj27JghbqwGxET08o/Ad4cBTeuCZKO/Rg==
X-Received: by 2002:a05:600c:a0e:b0:427:ac40:d4b1 with SMTP id 5b1f17b1804b1-42abd244b8bmr17110515e9.27.1724251850378;
        Wed, 21 Aug 2024 07:50:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSJZTO+za0Tzl6ZmOTOOjQhPQJN9bYwFdrr8NJSzjsMoBaqfx4mSpjWqlRxORsBcqVfFoCkA==
X-Received: by 2002:a05:600c:a0e:b0:427:ac40:d4b1 with SMTP id 5b1f17b1804b1-42abd244b8bmr17110235e9.27.1724251849543;
        Wed, 21 Aug 2024 07:50:49 -0700 (PDT)
Received: from debian (2a01cb058d23d60064c1847f55561cf4.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:64c1:847f:5556:1cf4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abee8bd36sm27422815e9.18.2024.08.21.07.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:50:49 -0700 (PDT)
Date: Wed, 21 Aug 2024 16:50:47 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	fw@strlen.de, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, willemdebruijn.kernel@gmail.com,
	bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH net-next 04/12] netfilter: rpfilter: Unmask upper DSCP
 bits
Message-ID: <ZsX+x32u37WIYqVA@debian>
References: <20240821125251.1571445-1-idosch@nvidia.com>
 <20240821125251.1571445-5-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821125251.1571445-5-idosch@nvidia.com>

On Wed, Aug 21, 2024 at 03:52:43PM +0300, Ido Schimmel wrote:
> The rpfilter match performs a reverse path filter test on a packet by
> performing a FIB lookup with the source and destination addresses
> swapped.
> 
> Unmask the upper DSCP bits of the DS field of the tested packet so that
> in the future the FIB lookup could be performed according to the full
> DSCP value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

