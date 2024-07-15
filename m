Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1F418EFD5
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2024 14:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721053907; cv=none; b=UWBCo5lehoW+hYh4VaMVRVK9mEefeQkLEhSBR66gQciDTR2BgygwDolOfxPU+gqYK2DXsWPqaP24WaOefWMoITMl9IAcruw/rN5fFFyD9689ODTJpXvxavnWNJ0VHYDJLIsnGg8Gu4fFuJ0YZBFuY1i947umaY/gAH5tKHV2/Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721053907; c=relaxed/simple;
	bh=9Vp138a/Qsro7Du5nj3crYP1WQr81PxKr2d20Noksf0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kvOp3nomv0bfK378znuKfTYBkjDZvtXgraF79h9QeT+7F5VFoBbGkeyPrzCWbEHH3oDBPvbjNt9AQsRegqv+P9tz1ClB3YkeX4kHrzvm1xjaCFPZAcEdqmN6OkBXJAKO0dhZZEP7e3jbkMnaoP/EZ2N9s27uR59agq5xsRjkZ2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fXuesm5U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fXuesm5U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721053904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jc0/wxHE1HxlsUbeDA6CvFNCh9k8bqbX9tsnb8jpHVw=;
	b=fXuesm5UifZ+MIx3jCMiQxS++7k28gGY6Z/Bk8quCvoNglCRnCcSSqMLV2OZLqRE5gYND5
	BNd5PMmggZXpu4zJZ3o5YRCONJfA97tkqiWTS3v8PQqIq4A0Iop3c1FlohsySlrHLmECxZ
	G8yp0wgxYjRTUEQ8v8bDSJsx+qMy1FI=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-srdq66fDMRSrFp4on6b5tA-1; Mon, 15 Jul 2024 10:31:42 -0400
X-MC-Unique: srdq66fDMRSrFp4on6b5tA-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-65fabcd336fso42023607b3.0
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2024 07:31:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721053901; x=1721658701;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jc0/wxHE1HxlsUbeDA6CvFNCh9k8bqbX9tsnb8jpHVw=;
        b=HdRhiBEEhxaCHNVTDzKu0+uF95dDoeaNHYRprlfMWQZYvtw+sa9F5kZ4FFtnMsdDDD
         cIoMVA2PgQUW637s8XevKU8Dbv97jAc4h/ULEyoitGoEwFYTX42ynJaz4RHptD5/mham
         0YRyJqoDCQnt3kTz/asSZjqlamZxVUmNemndsHHsGqg3iIPguxqi7aiqzQ4xNTSlJLPS
         iWEB2xWfTVyaUTZjqZ7qFid3ghegC9zS5+1sg7fump3rJiW0/tafGqi9KDpJBoQkMN2j
         1YodO6cV3N4jRpEXGWYrFKAeDkVA89DEcCyyYIfZl0ew3DrGk4YE/mrGbTBiO2SEhtk5
         rGSQ==
X-Gm-Message-State: AOJu0YxFUkhbvSMqqgPAHFM5aNQpzUST6BcmE+jfDCDd1V86d/Z+UDVk
	NCCYtDJl10svEYDH9nXR5UuIU/DOV5oZHr+NOEZjamiYhyPXva//7dTRnx9cixg3uFlljIZMy+X
	sbercZfob4ueoW6wHmCRIEpr/sUNAhE/nX7QijmPQQMD7y1Hqn15p9nezp4IoADHnjnWx1b7znx
	/f
X-Received: by 2002:a0d:f942:0:b0:615:bb7:d59c with SMTP id 00721157ae682-658ef153014mr206232397b3.22.1721053900923;
        Mon, 15 Jul 2024 07:31:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrAgtj3YfUKmqKPDpqRR13mr5NbHHf9LpDJ8HbpSA+tHRVufP/RGpYUSlVCoZyjc1KnLgh7A==
X-Received: by 2002:a0d:f942:0:b0:615:bb7:d59c with SMTP id 00721157ae682-658ef153014mr206232187b3.22.1721053900600;
        Mon, 15 Jul 2024 07:31:40 -0700 (PDT)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b76194fe1bsm21730646d6.11.2024.07.15.07.31.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2024 07:31:40 -0700 (PDT)
Date: Mon, 15 Jul 2024 16:31:05 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf] selftests: netfilter: add test case for recent
 mismatch bug
Message-ID: <20240715163105.2571a92a@elisabeth>
In-Reply-To: <20240715115532.2758-1-fw@strlen.de>
References: <20240715115532.2758-1-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jul 2024 13:55:29 +0200
Florian Westphal <fw@strlen.de> wrote:

> Without 'netfilter: nf_set_pipapo: fix initial map fill' this fails:
> 
> TEST: reported issues
>   Add two elements, flush, re-add       1s                              [ OK ]
>   net,mac with reload                   1s                              [ OK ]
>   net,port,proto                        1s                              [FAIL]
> post-add: should have returned 10.5.8.0/24 . 51-60 . 6-17  but got table inet filter {
>         set test {
>                 type ipv4_addr . inet_service . inet_proto
>                 flags interval,timeout
>                 elements = { 10.5.7.0/24 . 51-60 . 6-17 }
>         }
> }
> 
> The other sets defined in the selftest do not trigger this bug, it only
> occurs if the first field group bitsize is smaller than the largest
> group bitsize.
> 
> For each added element, check 'get' works and actually returns the
> requested range.
> After map has been filled, check all added ranges can still be
> retrieved.
> 
> For each deleted element, check that 'get' fails.
> 
> Based on a reproducer script from Yi Chen.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

