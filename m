Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF6212E1F0
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2024 13:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712668298; cv=none; b=BEXy3PoQkzcyUomKx4bTdXc2O48qChhz5JNLxHOqVg3Z6pU3c1DD7VZETrzYj6CgluoFrUgzoz5oPhJhHF3Itui1GS0gDcbQMelrFhEwmzKcDUha8uUy+Mr5U6CqMxP/iesl+LGNp/3VAelhvlO1IEDqLjJR0dHh29o5w/qJocc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712668298; c=relaxed/simple;
	bh=/lGQ8O9C4IZj3rDAYazoqY/MeNxKi1HXvYxTmiz1V/w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xi2Jkt4kShd3bLZFcLaAtGQ30lSq8XYnihq7+AfVKEhdfYWkLWdSX3EsFX/1WgPzRJPO/hvjQc0PtoXyslxSFjSDF6eXm8740nFzpbYxXhMZUFu4tfQkQfOsOxEpouCEb7gJd7IpBg8rjoUXm+ZPHrnzX2kOFzWWTnj0n8/ipsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h+XpRmfc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h+XpRmfc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712668295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AhxjNbhJRXKkRGpYqo6sHz/HP7bxwbGocdJYl4PvF4o=;
	b=h+XpRmfcpzZ3sdNJMkwVS2ibmz6PuiFVus1Cah3Kk3xykxidwbzoSKqSy87SV+7kuod0uo
	l1FMBwdJ7SbXDWMoe6kb9s5Vd++bjooSuNTCclm7VDGp4s701pNp6uEuGfBsNO/d2KKp+S
	0yrIHhsVQG3oPWQXanfutOJr1ujkUQY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-HM8aLtgdODi_igoe0JXxSA-1; Tue, 09 Apr 2024 09:11:34 -0400
X-MC-Unique: HM8aLtgdODi_igoe0JXxSA-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-56e7810e57eso259894a12.1
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Apr 2024 06:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712668292; x=1713273092;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AhxjNbhJRXKkRGpYqo6sHz/HP7bxwbGocdJYl4PvF4o=;
        b=XeWJsnH69DQsaIf8i9AdLRkyvvhoLfpCFjTQ3Uo13j6zPWapncYr4dQMAC5GGUwJ6o
         M4FalkDdyJq8Mu3QW3s36u71sA4mtqcpYKqFNV9B+Wa6nEZy1wsCsVxzqBkTby3Z82hm
         71WyqRZc9obRjxP+9l3NtY7BeHy/p49u33zel1mhIpXp+TtgkgYTQXwfYwq5+UrpfpZ3
         MuCcWKL5OAPAg+S8D0c2QmyAnUJvm4hg1xXuc/pHLeFebEd4i6Og5lwnXfwZ6mtY+B3q
         Ia7/qsQ7hW4gDwH90De2erKEsMKUXZVywwpjGppAz3RfL6qWAUh/NoN8yaCVKHpe6ui0
         OrOw==
X-Gm-Message-State: AOJu0YxmMCPxCn0fVjdEbv7/O1V0TF23o9RgbcS/mLy15EwF0SRd6FFI
	TTPO3KmGtHl2pkS2rhCDylEESZ4SekdRkyEfG9oBn54KaEXnZyOCZ1aXUsUaRh2RXaxbWXksx4H
	ObnjlMCCmIIKACpCHAnS0YoIxcEd1Uxc34M2qjC5znkBTY2O/0K+ASm8mViPwLe/TqPFQL17Mqm
	z5
X-Received: by 2002:a50:9507:0:b0:566:18ba:6b80 with SMTP id u7-20020a509507000000b0056618ba6b80mr8208361eda.31.1712668291553;
        Tue, 09 Apr 2024 06:11:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5wePA++2eSpAFCFNAnPpZX4Y+2CE5PVrFAMaSZALLYz0L7DDWxy4U6nBz5INbJKHaEZe4IA==
X-Received: by 2002:a50:9507:0:b0:566:18ba:6b80 with SMTP id u7-20020a509507000000b0056618ba6b80mr8208334eda.31.1712668290822;
        Tue, 09 Apr 2024 06:11:30 -0700 (PDT)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id eh15-20020a0564020f8f00b0056e67f9f4c3sm1748985edb.72.2024.04.09.06.11.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2024 06:11:30 -0700 (PDT)
Date: Tue, 9 Apr 2024 15:10:56 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 3/9] netfilter: nft_set_pipapo: prepare destroy
 function for on-demand clone
Message-ID: <20240409151056.6a7526db@elisabeth>
In-Reply-To: <20240409130402.GA20876@breakpoint.cc>
References: <20240403084113.18823-1-fw@strlen.de>
	<20240403084113.18823-4-fw@strlen.de>
	<20240408174503.0792a92e@elisabeth>
	<20240409110704.GA15445@breakpoint.cc>
	<20240409145440.5b72df13@elisabeth>
	<20240409130402.GA20876@breakpoint.cc>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.36; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 9 Apr 2024 15:04:02 +0200
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
> > > I do not follow.  nft_pipapo_destroy() is not invoked asynchronously via
> > > call_rcu, its invoked from either abort path or the gc work queue at at
> > > time where there must be no references to nft_set anymore.  
> > 
> > Hmm, sorry, I was all focused on nft_set_pipapo_match_destroy()
> > accessing nft_set, but that has nothing to do with
> > pipapo_reclaim_match(). However:
> >   
> > > What do we wait for, i.e., which outstanding rcu callback could
> > > reference a data structure that nft_pipapo_destroy() will free?  
> > 
> > ...we still have pipapo_free_match(), called by pipapo_reclaim_match(),
> > referencing the per-CPU scratch areas, and nft_pipapo_destroy() freeing
> > them (using pipapo_free_match() since this patch).  
> 
> But those scratchmaps are anchored in struct nft_pipapo_match.
> 
> So, if we have a call_rcu() for struct nft_pipapo_match $m, and then
> get into nft_pipapo_destroy() where priv->match == $m or
> priv->clone == $m we are already in trouble ($m is free'd twice).

Ah, sure, you're right, they can't be the same instance.

> If not, then I don't see why ordering would matter.
> 
> Can you sketch a race where pipapo_reclaim_match, running from a
> (severely delayed) call_rcu, will access something that has been
> released already?
> 
> I can't spot anything.

Me neither. Sorry for the noise. For the series,

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

