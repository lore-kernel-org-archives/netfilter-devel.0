Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D371514ED
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 16:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724258820; cv=none; b=XBNNE0F8BUtYOpx/YJAMP85ySGTnIJpr2TUOTLtpAcZg3UbV2kuE7qREPIZgjkbf//rJzhvR1MQrb0GpEl4XNZ+8i+baHzIg1N8F4AGbCaKxA3rZtJsdXk5IBxvH3EUjfiWCvAKT8binaJDfBCL2p/yr9emn7mi2Saq4lodEMGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724258820; c=relaxed/simple;
	bh=f+vuucxLAED5W3z/rb9SlKuMT45vcRMYwbh+kcs8IAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Crm7W8+qHcgXUBPnay/VXnhE3pxRXG/8SpOqkTu0KeEwH6OXs/PWKrnIO3uU8pZaRK4v3l3CSgdTdByCmilql5Z7fXxTeaaVMfcl9guZAri78dIj9qxrgiX5jx3Ab4FueTp1cN7Rv9J1haLorDnPM7oy8X0BrzOnSNxf0pzJekY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hanbpWg9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hanbpWg9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724258817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f+vuucxLAED5W3z/rb9SlKuMT45vcRMYwbh+kcs8IAo=;
	b=hanbpWg9HJyoQIiDKZl/8ZLumfKONEskHx/bH/s28Wi5rKgd4WAfUrN8JdAiYGamq2iz9+
	+mDKQssLJ8jiwjdgG/XYN0/25yofcC2BiLPaifHtgboa1Y7ncx1EAC7jcYE/e5/BFDk+D/
	6dfGA8elyeN603M1p+d5dcWZSiqe+6U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-_97KydtCMB-mv8_ZYsOVig-1; Wed, 21 Aug 2024 12:46:56 -0400
X-MC-Unique: _97KydtCMB-mv8_ZYsOVig-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4281f8994adso60090595e9.0
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 09:46:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724258815; x=1724863615;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f+vuucxLAED5W3z/rb9SlKuMT45vcRMYwbh+kcs8IAo=;
        b=cZWlVSjyldiTAdtu6cwlJRgyJHgaqEImVluLrGDmV5WufEJufoweAvaCdCr5YatUPd
         8p5+lf5oDlqSWzO0v68OV//inP4ZdcYDHP12k4L6PHwqrghDkBdS10WN3m6Y9dk62K8d
         X2IP05xPGFz3ZaVHxS4oSCl/h8305JR/GRmvBC9aBUWoTifl0R1FawYCJ9YAoHeNg/R4
         R7c/13a7G/BCMz/1AhRC2vBXtx9hn/uYcx6e2msLFAyIO5WSPu0kEZT4l9UwEd8mTRkR
         /ZS0jsr2Y0ROcztFr3MfLOkaDVCAjd6KeNkpFQyFop/DxbMnK2JI9CT75xG7mia3/x5f
         hjig==
X-Forwarded-Encrypted: i=1; AJvYcCUpBnI3ZEJGoYUc0Ua1aPS4AZeRxkj6uqb1qD37WXEbCjwthXlaOaSpjb/MBgmh/qOhlx5iPC0OgKLeEO41C2o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDbFkYZFLEU67prwBuW6uWLDyOlPle5ROCWxubodjXgkjCKM82
	qLfCTWmSo1IcJag+drfouMDMqkg67/bXS08S5ctSqBqGax1Rgoc1PyOUsLR6WTzrXml4b5VRlb4
	5Ukr2ioge6cXcKfPd9dhBZDADe0+Q+Y6W1irZ16nhsS5r+RRrzF7ZdhQ45aLbVXJ0jw==
X-Received: by 2002:a05:600c:4e93:b0:429:a3e:c785 with SMTP id 5b1f17b1804b1-42abd21f736mr22608115e9.21.1724258814885;
        Wed, 21 Aug 2024 09:46:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+7ndXO7p17x6jiJjkerLBS07RQUf5DqDJRNUzQnYm9da6dNkYwy11xXsLMYPR7RQfvAw24A==
X-Received: by 2002:a05:600c:4e93:b0:429:a3e:c785 with SMTP id 5b1f17b1804b1-42abd21f736mr22607695e9.21.1724258814073;
        Wed, 21 Aug 2024 09:46:54 -0700 (PDT)
Received: from debian (2a01cb058d23d60064c1847f55561cf4.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:64c1:847f:5556:1cf4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37189897128sm16122725f8f.81.2024.08.21.09.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 09:46:53 -0700 (PDT)
Date: Wed, 21 Aug 2024 18:46:51 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	fw@strlen.de, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, willemdebruijn.kernel@gmail.com,
	bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH net-next 11/12] ipv4: udp: Unmask upper DSCP bits during
 early demux
Message-ID: <ZsYZ+1PsNUMcT9Bp@debian>
References: <20240821125251.1571445-1-idosch@nvidia.com>
 <20240821125251.1571445-12-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821125251.1571445-12-idosch@nvidia.com>

On Wed, Aug 21, 2024 at 03:52:50PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits when performing source validation for
> multicast packets during early demux. In the future, this will allow us
> to perform the FIB lookup which is performed as part of source
> validation according to the full DSCP value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

