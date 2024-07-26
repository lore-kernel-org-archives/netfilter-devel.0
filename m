Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C71F17B50A
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2024 13:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721999537; cv=none; b=i4y8p7jJTDR3smDN0h7XEB1psBK+GuqayNcr9m3UtC6lucMl8wDKxisivzm5QOZZ92iJ25eUH/nMPYOXLgQuShzLyAC5ibDeXDOLqhKMcCV8/22OUZnWFeKSkHuWXnkRbnW/cjqhiZ4zYgDbwne3OKmGLDUAJG7zWLc7eUi37ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721999537; c=relaxed/simple;
	bh=h72+a98KprrWyPci+WolzqJ6KSeDATMGbgOUIBmI8cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rEn2TvXMPocgBb3g1/L2Quul5Xodjf+YgNd8Zr2kc3puBZxHDH/7IFqCX/UPcghtWg/H059+oxI2Bj9M5A4GrcX1j7iFAIBWDga/vawnU8LlSsZ7tS+vHHncLPlQjlWtZXVfaz0do1hwsPZTnnpW4yQT3Kqki+ylV9lLF43trm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M5b+kJGV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5b+kJGV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721999535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lsFdNBSg3GvSCBXb3m0nQOmqj5eLSOCce+7I1qVBgnc=;
	b=M5b+kJGVPv5fEh4CE4rlTsCGzsGlYv3jt1Fdx3o1bum72jxg1niZWy46qMOK8MxAnm4y5D
	/7/Cx5g7MKpSsQBZZCuSWWBQFEi6EMUFFXgdnmeIJ8o/YfZT2ReGmptTOiumQR2Jn7Ta6l
	dMiSUn6ZHzJLQ3vlrRJvoqbLy8HDcws=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-kuo4AvnfNO-Qrxuw9Wn5OQ-1; Fri, 26 Jul 2024 09:12:13 -0400
X-MC-Unique: kuo4AvnfNO-Qrxuw9Wn5OQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-36831948d94so1294005f8f.0
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2024 06:12:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721999532; x=1722604332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lsFdNBSg3GvSCBXb3m0nQOmqj5eLSOCce+7I1qVBgnc=;
        b=Zl0O589tlJHG/uxlnMP2OjScvB8w5VmiLSuxAKomTQVUAERbT0iHJORG5LXNILRb32
         y/QTmPh4bql/YuU7iKkdWiYgT0YuD3ONX/MNtmW1fWZfn2BsNBNzoUsguquTqQYnLBsE
         vJDM4pz/b0fXmuQq9zrn4pnBXvOGzVNHsh1m+Gkk9/6c1IdEaF9Ga0sVp96wHAzqQZrr
         NvGB4fBbqrV3PtCY+r5r7TZiCm6hR9qW2TQT9v5CzItfE5y6p8vwuMlK4lDuct2enR6e
         aXUKv7HXamP33CTUNlmkhaEZarYZCaptPoU0U8KWsm1QlePXznt0pDyD9mX8cgu74AnI
         UDcg==
X-Forwarded-Encrypted: i=1; AJvYcCXRqCpTKh8XBqnoRupiC5q/Nnnzp5j64WtUA9PwCKEeLs3k5rV8dQ385FdenTgAFzKMWJueYgEq3uNqMD+H37HnwXqow4fcXt6VX8lRvvaJ
X-Gm-Message-State: AOJu0YzDge2MbHsHzrU+yQPmk+KV7HxIqYpb2SiARfvjTRGsR5UftV8w
	zC6t31KFh3W/O62ZQYDJn1w4lj/PnmrWeV9sGjE8H4EUkuVhLmmf/bNyLC/OljDmtdTSXWz3FZ9
	rIJxVfhxcW7hp44pCgQbXsNG1toleqLdrc8FWzkXxP/BQbDCAW/hgu3T1Ml/uOc9evA==
X-Received: by 2002:a5d:4c86:0:b0:368:65a0:a423 with SMTP id ffacd0b85a97d-36b319f26b3mr3693023f8f.27.1721999532337;
        Fri, 26 Jul 2024 06:12:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXbBJu1f7PaSWFiflUVfFPnDcIdALL9LcSAKL69RJROgW1jJl3MeNJ7yWaxIhL6qAgjduClw==
X-Received: by 2002:a5d:4c86:0:b0:368:65a0:a423 with SMTP id ffacd0b85a97d-36b319f26b3mr3692989f8f.27.1721999531622;
        Fri, 26 Jul 2024 06:12:11 -0700 (PDT)
Received: from debian ([2001:4649:f075:0:a45e:6b9:73fc:f9aa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b367fc873sm5157425f8f.60.2024.07.26.06.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 06:12:10 -0700 (PDT)
Date: Fri, 26 Jul 2024 15:12:08 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, dsahern@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [RFC PATCH net-next 1/3] ipv4: Mask upper DSCP bits and ECN bits
 in NETLINK_FIB_LOOKUP family
Message-ID: <ZqOgqJWJ9cATghR/@debian>
References: <20240725131729.1729103-1-idosch@nvidia.com>
 <20240725131729.1729103-2-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725131729.1729103-2-idosch@nvidia.com>

On Thu, Jul 25, 2024 at 04:17:27PM +0300, Ido Schimmel wrote:
> The NETLINK_FIB_LOOKUP netlink family can be used to perform a FIB
> lookup according to user provided parameters and communicate the result
> back to user space.
> 
> However, unlike other users of the FIB lookup API, the upper DSCP bits
> and the ECN bits of the DS field are not masked, which can result in the
> wrong result being returned.
> 
> Solve this by masking the upper DSCP bits and the ECN bits using
> IPTOS_RT_MASK.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

