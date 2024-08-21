Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBAD5FBB1
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 14:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724251600; cv=none; b=X3Ir19q99+89xIsHYzeDK7qCZnkK3r0b1NbdjGOumPSRVUnqUsH7nmBuwxb1JQjh0WWmMHhONCsjFjgTj3JptaPxg8IB32QOprKEiHv4zlcJrgpPpUshYxNdil/X9ShvuyEICY300D8g83HL2c0TjxMErrrXLBOd76KiFfsUwu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724251600; c=relaxed/simple;
	bh=6xdt2jDZXSBwFTljtG80OL2SpBvSmFFJQpZtCWyxgIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tU9G29yJk+QqFXEQwH+mYRx0HkH179o5n9x3w4XVSznupEqj1wvulLLCZ4cy4LAE9cOfQmq3YYvhUu+A+qUhsNnPcRVTdO8lC2HRbLMvaRXWGrdbTEv98HUVWGcfAq2u0M8nh5tXBFdcp3xUCse7fqL9B7zSDeozmAoGBd1AGX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HwkHkIau; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HwkHkIau"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724251597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6xdt2jDZXSBwFTljtG80OL2SpBvSmFFJQpZtCWyxgIo=;
	b=HwkHkIaulNLq7P1KsoKxBRlFjUSrLiITJyIM8L+ui8ra7GDS+KBjmVhfy9a3L4KlsGMjZz
	p9r1ztp0U5pxfZWNalImrj4kqrF/mOSZKj2ewmEhB4v3sWG2mnERE/xwLCvSB+x4fREQAf
	JB+StP+weC7zRp3CbTVS7pET8SI9Ky4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-140-X4aHqhlrNmKLwEjTqHnEoA-1; Wed, 21 Aug 2024 10:46:36 -0400
X-MC-Unique: X4aHqhlrNmKLwEjTqHnEoA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-367990b4beeso4009943f8f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 07:46:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724251595; x=1724856395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6xdt2jDZXSBwFTljtG80OL2SpBvSmFFJQpZtCWyxgIo=;
        b=j844Slybde3lsFZkR5vXLkEilnvORiJdeMEXew0Li2KYG7e2eiUab0AevzD+xq7veE
         ViWoeCGU1CLrpDAFpaYtj3KHgixycJXY/LcyOT6rS0AD8XGPnr74eqJGL6pRxoQZAC0u
         l0Zu6v/mAn7oAXSQiuhcMRxtcRmUHiOI9LKkF8YYaYUFej16QcABEJby2ot08yPv2ZpS
         BHCRCqb8yVwNNjXXLwb2XM5URSuDyhddpYf7YSZWvnzxSXOUXAJePZv/za+9B7CYwVNM
         uv4Y79iUFiWK+O0LRVqijkGixXykiQbLa6mFS5MBCrVqTUNsQiBXtGNJ+DJQRZVYsOLS
         JIhA==
X-Forwarded-Encrypted: i=1; AJvYcCXpqgtKRieNlqKIHO49U7nbBPJCGWOxdTk+g+/g/qydOP8ATKq9I2r7vZj95V5voqDgOOBObFGrR+UhGR5vRog=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+QVm3WqsZ4jgKP0hg9DWTIm3jXaWCoKrKOGraM7DKW7wZ6DNQ
	3N2ybcJdD+/uCbD8zRWXQSvA1LIoH5lv9dny6xObqD8+VS1u6m8L/qD+qDdO2NUhwIHk2rFYsQi
	+VmpUpyAfc1YjyMiivn3TVja24zXk/C5wbkFL03UUu+IP1aJmXfe5JkGsDtQyTNf2ww==
X-Received: by 2002:adf:e9cb:0:b0:366:e64f:b787 with SMTP id ffacd0b85a97d-372fd57c8f9mr1579789f8f.8.1724251594803;
        Wed, 21 Aug 2024 07:46:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbLPnszvW1b2ldVOkF9ZIUwdca7WTLBwLo/0pq1z+jsL2swELRra5Q+Ml//UK9bmMhggFv3g==
X-Received: by 2002:adf:e9cb:0:b0:366:e64f:b787 with SMTP id ffacd0b85a97d-372fd57c8f9mr1579748f8f.8.1724251593939;
        Wed, 21 Aug 2024 07:46:33 -0700 (PDT)
Received: from debian (2a01cb058d23d60064c1847f55561cf4.ipv6.abo.wanadoo.fr. [2a01:cb05:8d23:d600:64c1:847f:5556:1cf4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abee8bce1sm28211825e9.16.2024.08.21.07.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:46:33 -0700 (PDT)
Date: Wed, 21 Aug 2024 16:46:31 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
	fw@strlen.de, martin.lau@linux.dev, daniel@iogearbox.net,
	john.fastabend@gmail.com, ast@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, willemdebruijn.kernel@gmail.com,
	bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH net-next 03/12] ipv4: Unmask upper DSCP bits when
 constructing the Record Route option
Message-ID: <ZsX9xyKUa8pYEXVo@debian>
References: <20240821125251.1571445-1-idosch@nvidia.com>
 <20240821125251.1571445-4-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821125251.1571445-4-idosch@nvidia.com>

On Wed, Aug 21, 2024 at 03:52:42PM +0300, Ido Schimmel wrote:
> Unmask the upper DSCP bits when performing the lookup so that in the
> future the lookup could be performed according to the full DSCP value.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

