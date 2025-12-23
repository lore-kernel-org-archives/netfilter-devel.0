Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B0F3376A2
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Dec 2025 12:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766492615; cv=none; b=j/5vGWL7ssCXtbz6DuXZnYCoSW9ldFpHNR/gDCv8pZwlU5H8SHnIxWmBzP6WsbeurwfhUiguZQYgkkbSDeHxGVce6Yd30iValIQ7XsguVPcrdFGaxUexBbSTEVNJzndsV2tOInLvCv3dvpxsxHmE3WDQWqQteUf3mteNNZRSHn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766492615; c=relaxed/simple;
	bh=MVlBrjrPcPwIWfv6L13h2KlaLI8KzT1J9jjqV5JDGOU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AGFP8xzvKj7StuwOuFIVHoWw6Oa/tN0yzBn5QLsDtcD5YNYVwExT4kFONpMw+nKtaWxpwv+pKvCohlJsmEkD8gk1xOTB+oT/cf/ofEQMbuTiFAl2JoJK/62AKa3/0VRq44HkwT4Dtb9gwy/ieLQESxONat3NkoUELGIpEtIVQWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h/owcI5q; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pHsALsah; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h/owcI5q";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pHsALsah"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766492612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nU8xEIjNZqJDeeOHludMlgwIxfO4ZwIPoCfJLQR98KA=;
	b=h/owcI5qmFUEq0cM8uOw2AtrRLp5N8hlg68mz0UPs8IDiu9oiautNj7IxwoTy9kPyzZtlK
	U55NFwUG+69t9q5i23tzDa9oYNVCHYGdFKTNfWWXG6+tpU5G+Yu5mcrwKk/ajx8liyTfTx
	BCM6BWjZqp4Oy/tmMmh+mNkinb/LVcA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-eLw3hz85OimWPYgXRkKoUw-1; Tue, 23 Dec 2025 07:23:31 -0500
X-MC-Unique: eLw3hz85OimWPYgXRkKoUw-1
X-Mimecast-MFC-AGG-ID: eLw3hz85OimWPYgXRkKoUw_1766492610
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477964c22e0so34945815e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Dec 2025 04:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766492609; x=1767097409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nU8xEIjNZqJDeeOHludMlgwIxfO4ZwIPoCfJLQR98KA=;
        b=pHsALsahp02BACZu3A9S1PhvYzJbTV0o592LVdNE3rYr1TsMePfCwBY3eGCEn+qGVK
         CAjg9+6oHJaGSI6BKIRTIYjp9rBbexMFj+cyKaYV13JTro4tCupXRYRzTex1JW8nKsGl
         zQIhswr12BMm/ZIfVWRTG1DxJu4FlRJr7LXGTTe9BV926+2juEc3VxXUqUQ5pwhWUT1d
         Jb7+y97U4jcuNq7nf4An3bVawd0p5hfVTwP+u0kHtEjKlYM+opNzLuVJWEWes47PUcYo
         xrLaL6a/6imBrplemC8UMK7NZo0aAgvgcTU4NQCQhGoAQwH/O57VZoKZV/JVqq6ZCA7U
         wMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766492609; x=1767097409;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nU8xEIjNZqJDeeOHludMlgwIxfO4ZwIPoCfJLQR98KA=;
        b=YuiIby8igsv82JhQTWJZjSrh4K+BoIHhZUUJXzokw1XRJDB4bHtNRugct+tC2YpfpG
         g12fZCmlsbKd5rIRS72fmJEVH9+LHblaD9tKS9nHGBIfK9/2EEsY4z2nx+j+CAg08tU7
         pd+mNDfCYaLpnawg51o061p3bnTpUzyN/YIRRXKcPzXPJAdX40+nyOuj5wZBQ//cBjvK
         9Nr7V8E4Q0TOvfGcQ2iDXK9VT35f3ApGsh2d0KB9DE6WRnM7c8mkT8yHhfpSrbxSI+4E
         92zCIg9xozM77hrfOmLkc2p4HgXtzgTMQcfVdxAksdrQwh+RkaPPWplwzIV2miIEC3Tf
         ek7Q==
X-Gm-Message-State: AOJu0YysfERxrOjmuCqwIfoRjL1MKxNQdq4fBi/PucVwE+mYmFsH6iaD
	5bGpOElV9V6pF0CPyLhFCj6l+pfbsxOZQGJwW1gdO6hgWqTAKtvjgOMsvADdplxjVxJoUKAtfwy
	gvsLqzkVzzzt1+i5OWA3slq3fJjshSnccNJ8Q5Tjfpj1z/skVa0MZet8ch3qSaWNEA8jkdby0GN
	JtqQ==
X-Gm-Gg: AY/fxX6PgW2RorIVYrL2ERfiLeEKpYlh4lKtRPXfvo2ri7KTveXd7Nnc5kELBhxCD98
	MzkWj+K6DWJB32EzNzxLPBTrVFlJq7McBEzTt6fXLH7sn/ceLL1sbfIomk7d10qeYEbVqSazSDe
	ApROXirBaqC8HgtsqUkg1h7YBIJHSnove5A6Mfj9I+7rXdXGFrJwQWZ6WKG53ykZej2RSliACxZ
	c6yJjfiZFJeQrRF3lCaLV6IYvEiJ3zznlmpYQIYJ/f30D6aKchp32+RyoZZ7V7ARUi9Wepqdw6i
	m8BiG+imGXs88FFDu9nH+70WatdiVKydNmavx85TM+WLE6dyFAUJTXFJpsZHpl+/kll88i9/Q58
	BYyLWVqFPNkAvsjX0ePDwS+pomxpUNsGmFB5cbw==
X-Received: by 2002:a05:600c:6610:b0:477:a219:cdc3 with SMTP id 5b1f17b1804b1-47d18bd56b8mr140789385e9.12.1766492609539;
        Tue, 23 Dec 2025 04:23:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGwEz5AVCNfcnBOC0X0FAYcWgP+5yA//T6M5L5lkOtgJBRHk3JESWmRauhnFprQqjYK18Tn8Q==
X-Received: by 2002:a05:600c:6610:b0:477:a219:cdc3 with SMTP id 5b1f17b1804b1-47d18bd56b8mr140789165e9.12.1766492609072;
        Tue, 23 Dec 2025 04:23:29 -0800 (PST)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be2723b2bsm288632055e9.3.2025.12.23.04.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 04:23:27 -0800 (PST)
Date: Tue, 23 Dec 2025 13:23:26 +0100
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: pipapo with element shadowing, wildcard support
Message-ID: <20251223132326.3c9bdaed@elisabeth>
In-Reply-To: <aTBydxPbKZnh-iUw@strlen.de>
References: <aS8D5pxjnGg6WH-2@strlen.de>
	<20251203150849.0ea16d5f@elisabeth>
	<aTBydxPbKZnh-iUw@strlen.de>
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

On Wed, 3 Dec 2025 18:25:11 +0100
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
>
> > It might make sense to change that, but that's not entirely trivial as
> > you would need to renumber / reorder entries in the buckets on
> > insertion, so that more specific entries are always added first.  
> 
> Right, it needs a reorder step.

Perhaps too late to be useful: if you're trying to implement something
like that, the stand-alone prototype at https://pipapo.lameexcu.se/
might be useful to conceptually try out things. This could probably be
implemented as a variation in unmap() from set.c.

-- 
Stefano

