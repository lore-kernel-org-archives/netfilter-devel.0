Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CACD18F2DA
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2024 14:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721053886; cv=none; b=uR8CYMwGlhsyOvGYRqRaTsUeHwZEbQhURJk7Day1nI6AMZC/0EAbBKdr8jsCCfHRJT9REBwhvDSRy9cQRjg9TD6saMBi4SYUNT0VGuXsYXnMax4qxzfD1iKku72fxhhEuKdvZO8hHtPypJHG3fJIDPbJoblQK+miQm2IASWnCvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721053886; c=relaxed/simple;
	bh=3Tsl/9TmsJz7W29NkAWnZffwk1u2Ng7yR8t9yIkFwbA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M2xUvBe0zuykuGm/FNLrIQ75eBqKx1ybOctiql2DCEJPkAYe+X5AunqCf29lgeoBD1SrvXh2R0Bdjh3V347EQ4vx9bd+B64qNF49N6ADTKL1zRVZdM5KCsqKcmRCSxQGdkXCQQ9XLxxS6FOiNs9Rgpzxf7IgesfHjwEuPFDg0e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pi+V7ggr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pi+V7ggr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721053883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jyqlldRpDVf4MbMIMdQg6uH9H6epKniNJVbxxEhL7wQ=;
	b=Pi+V7ggr6tyYLE0xkiL2Vt6eqyEI39mH7/F7UHVKBi3fbluwsZaxAbRQtLCGhOzahpeOv5
	cbkcwUw3q6Mv3Tqyeq4VMp/9YHByBHiV526yVGTId3FCIgN210EBADEsZsmUDtI4QL2yXh
	Acp7K8ntaHENx4wOy6A4sSj09vpK8PU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-140-CpbRYg15ODmgiHyBncjCHA-1; Mon, 15 Jul 2024 10:31:22 -0400
X-MC-Unique: CpbRYg15ODmgiHyBncjCHA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-79f1bf8ad5eso710093785a.3
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2024 07:31:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721053879; x=1721658679;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jyqlldRpDVf4MbMIMdQg6uH9H6epKniNJVbxxEhL7wQ=;
        b=dE61aMpfKUzkn77xYczvxzv5c2y8zVME+WAJiqv+quqodHL6LH7GBf9501X5AXdOoK
         dASQKSvQm2dNXazNbM16XelBQLv5rvk1kulcwbBHTudoOLDfOxTadMJwY6WWHuRUNoAQ
         I+6VeOcaXEdW0DSDZ1BrOOH+joO53C4Yv7JDFpCisDKD/gS1zaHzHKDaZDKjkj7uCUfJ
         fHL30bBE0vBgj5quHT8LkgOvhdKay3x++Iit2T8f8p9s+Zlf9MiiGSqRzv9ZMrIRIpvI
         z+ybx/7NcTTHjje32CHseGGYHoKYN91lQV2skA11/m6SDaW1wAli6CQesxejIQahyp4f
         T1QA==
X-Gm-Message-State: AOJu0YzbPgWObaGy9l00EPeLoM0FZpwbSQaV3LR0nimOr14zLp2t422Y
	DacTZLPQ5GQ7PS6a6+I6aV4cWlbYahqYIMaS7B7jHxt2LYnCtt86UN9wkTwnDXXapMDk/K7EpVK
	aPn3Jy2oHWTIOYSbK0SgiVWd1f3+UmkT9ggt7tzX3t3i7lm6mKsDXfZiPn7oIUnGEIA==
X-Received: by 2002:a05:6214:2687:b0:6b5:dc5a:ffe0 with SMTP id 6a1803df08f44-6b61bf5d571mr272514366d6.38.1721053878661;
        Mon, 15 Jul 2024 07:31:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9Ili14ciSWRbtBOJL1aUbDR9DNeR8Q9911VH3feLkKCm9oIedz4+cp6CKKpPk8C+MjCtXbA==
X-Received: by 2002:a05:6214:2687:b0:6b5:dc5a:ffe0 with SMTP id 6a1803df08f44-6b61bf5d571mr272514106d6.38.1721053878204;
        Mon, 15 Jul 2024 07:31:18 -0700 (PDT)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b761a5586bsm21835826d6.124.2024.07.15.07.31.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2024 07:31:17 -0700 (PDT)
Date: Mon, 15 Jul 2024 16:30:41 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>, Yi Chen <yiche@redhat.com>
Subject: Re: [PATCH nf] netfilter: nf_set_pipapo: fix initial map fill
Message-ID: <20240715163041.60249207@elisabeth>
In-Reply-To: <20240715115407.2542-1-fw@strlen.de>
References: <20240715115407.2542-1-fw@strlen.de>
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

On Mon, 15 Jul 2024 13:54:03 +0200
Florian Westphal <fw@strlen.de> wrote:

> The initial buffer has to be inited to all-ones, but it must restrict
> it to the size of the first field, not the total field size.
> 
> After each round in the map search step, the result and the fill map
> are swapped, so if we have a set where f->bsize of the first element
> is smaller than m->bsize_max, those one-bits are leaked into future
> rounds result map.
> 
> This makes pipapo find an incorrect matching results for sets where
> first field size is not the largest.
> 
> Followup patch adds a test case to nft_concat_range.sh selftest script.
> 
> Thanks to Stefano Brivio for pointing out that we need to zero out
> the remainder explicitly, only correcting memset() argument isn't enough.

Thanks for fixing this!

> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Reported-by: Yi Chen <yiche@redhat.com>
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

