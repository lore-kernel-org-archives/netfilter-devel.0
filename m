Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A681FF1BF
	for <netfilter-devel@vger.kernel.org>; Mon, 26 May 2025 12:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748261688; cv=none; b=G6WykWPu52IGhP8I2hBlVkI+icfRr+9HAnG+gsuZmhiHVxnyHulLcelsz+pYCtSE89M0cvOb0LQo42G8uxVjD8xzjrSReSxab8ey5z/DgyyK0q7Qwo1QalyM+EHLjtgzr1Cz4C7qBEauboNlhJ1+5XZGGCdglMyFllty8s1fZpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748261688; c=relaxed/simple;
	bh=SEY6DZVPctMO3LH26miPWNQyrT9UzEd3+ZSvbKzw7wQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HuBqZsCL/DnUW0t5h9fQX/6YLlfQJdkKULuUmV/l+MX78GVvLHW+NjI+LKcPSYtgV9PwBPDdKlyQz22tDALtCDfO1U4ASPn3+q108deAbM10ajgng5QmOCneeMH4zYXZ/Y2v/LSvIBeinOFnJTcUXs5nqJHfsH0d9BrUTG3sGlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I9cbeMgW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I9cbeMgW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748261685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YCgSpvo1x0f64X0S2PxaPQmnNW8MgYEVIuleLYXtHPs=;
	b=I9cbeMgW9bQ1gK/YJTdOb288Odp9GzeTAymjS0ygR1Mooc3m5Cnx6sTBOIkC4k69fqxhco
	6uzhp4pkfwYkOweCNZutjMZv4BGToE2EcCt1J1mLUR1t7voFj/h6tSN1Jd+xU6FSxCLbSS
	/zu0X3XBCrGFyICjVQkfn9pw4yNNfxY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-BHYPiPPKMg-_VtCS3zN4iQ-1; Mon, 26 May 2025 08:14:42 -0400
X-MC-Unique: BHYPiPPKMg-_VtCS3zN4iQ-1
X-Mimecast-MFC-AGG-ID: BHYPiPPKMg-_VtCS3zN4iQ_1748261682
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4d95375c6so358437f8f.0
        for <netfilter-devel@vger.kernel.org>; Mon, 26 May 2025 05:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748261681; x=1748866481;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YCgSpvo1x0f64X0S2PxaPQmnNW8MgYEVIuleLYXtHPs=;
        b=CzzeYtdm0i2XixPmCsz4p1vPZqQ/GOjUzeYPwsb7eTwbxTTYz0Bm/YVrybRCGH74iL
         am6Ndav6jOUDMqfMHJkgfUn+glJrfeHUq6KthYEzuBX6PlLTv670UDN1H1aO3XDaUfB3
         NS/Iurpw4qK2xwc2LLpHFyr/U1h5AlSAd2pqnDOfBVX7E5XL/P9JqY/FUfhZt6Jg7eEq
         mPD8kR7GL9uNA49QvOGuLjsl4AK4j7B0BzTu4UnyP10uy2a9Wf/etotyddrXdm2o74x1
         LXDLd2/BlQvcDy3iNU3v1l4YMmq60rzxIPeoGTRqvs5mKkKTrGiIsmgGgOBj5ibNaaV9
         vBOQ==
X-Gm-Message-State: AOJu0YxART62hSzqy0hU1nPLbk3vpv3aP0djVleao6yEpWY3bkKvLx9/
	2Y7VYLDyfhGDog/mB2i/hncN2oU5Yn1tGhFEYT8r/p9dP+cLnANG2zjPYctXmc1mJCTK8BhYbcA
	NMrxNIErzedyZOX3GjFBAAMNf8KU2DbRmIxpcCKbeQ/yTX0+oCt5C5CXIWnrnaYHs3MMHlLfQuR
	p15w==
X-Gm-Gg: ASbGnct5X8Lll99gUy2aAbdVIcXnamTJP3KV8BmsuLrtGQ2OT/e2oDrEEnYmhEQtiMh
	btqSUQZ6ip3LrLahUTrJPAY9/tIb28waSlDlqloahk/U+kGkHLTMClIF2RNP4SjsVMWNpSIMdqE
	KOoN0CI7pzyz6W4k/j5T46K3LVFbr0Se8RN6MRlwDj73nHGPxHysJmLfA8ItAe8mSJascmVKLZP
	1sg5n7NpGzkChQbQs4TRMgd6vq9nAwpr87pDBAHTB07lFuI2frYixLirCLQpGZy26XWEIdmi1Js
	Z9+FfffZ6iOtlnEA0g4OiI8okUWtKY1x20IqdI8T
X-Received: by 2002:a05:6000:248a:b0:3a4:dd16:a26d with SMTP id ffacd0b85a97d-3a4dd16a2e9mr1615647f8f.38.1748261681389;
        Mon, 26 May 2025 05:14:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNK/VxT8tamM+WpEYeVAKLnzoKK/2eGFsEQrP1gTP1qnBomp+6Y8eTjsSsypty9Cj9Vf4WNw==
X-Received: by 2002:a05:6000:248a:b0:3a4:dd16:a26d with SMTP id ffacd0b85a97d-3a4dd16a2e9mr1615634f8f.38.1748261681035;
        Mon, 26 May 2025 05:14:41 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a37fb452e5sm17140233f8f.20.2025.05.26.05.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 05:14:40 -0700 (PDT)
Date: Mon, 26 May 2025 14:14:39 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 0/3] netfilter: nf_set_pipapo_avx2: fix initial
 map fill
Message-ID: <20250526141439.28a25297@elisabeth>
In-Reply-To: <20250523122051.20315-1-fw@strlen.de>
References: <20250523122051.20315-1-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 23 May 2025 14:20:43 +0200
Florian Westphal <fw@strlen.de> wrote:

> The avx2 implementation suffers from the same bug fixed in the C
> implementation with 791a615b7ad2
> ("netfilter: nf_set_pipapo: fix initial map fill").
> 
> If the first field isn't the largest one, there will be mismatches, i.e.
> a wrong match will be returned.

...weird that we didn't catch this together with the issue described
by 791a615b7ad2, I guess it wasn't found on x86.

> First patch fixes this bug.
> 
> Because the selftest data path test does:
>    .... @test counter name ...
> 
> .. and then checks if the counter has been incremented, the selftest
> first needs to be reworked to use per-element counters.

That makes sense indeed, I didn't even know they existed. Actually, I
just learnt about 'nft reset element', that's quite neat.

> Otherwise, we can only differentiate between 'no entry matches' and
> 'some entry matches', but its imperative we can also validate that
> the lookup did return the correct element.
> 
> The second patch does reworks the selftest accordingly.
> 
> Last patch adds extends the existing regression test for this
> bug class by also validating the datapath, rather than just the
> control plane.
> 
> Florian Westphal (3):
>   netfilter: nf_set_pipapo_avx2: fix initial map fill
>   selftests: netfilter: nft_concat_range.sh: prefer per element counters
>     for testing
>   selftests: netfilter: nft_concat_range.sh: add datapath check for map
>     fill bug

For the series,

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

