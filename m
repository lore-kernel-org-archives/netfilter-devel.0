Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EA521FF37
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 06:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751954962; cv=none; b=QZxj3nrhnEm0PKCLL46V7rufip2OP7G39EBjLrwRtrOAf0ZBdXKTEWOca6cFciQvh5EH8ciKdq8YFNXx6tleQx9E4Z8UYnuQ9Z/1N2KNLiMmzy59FIwgl/0e214LrdRigKkJMo/WCp2tfAry+nB+iz/KkXQgx09paSqX9hBma0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751954962; c=relaxed/simple;
	bh=hQK6Yh+hwBkt7HC/valBGquD2sF2y6W9EW6ZhBKTvBg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d9Bs3UnOYukvp1KL+INHIhPozyxRzr/NTbJUdFGW2dPVNKgoD3ccZVJwTvsx7GV2eujyfGC3PjyDSKeEYCF4CobhvfHXOU0XSejSY8GT0pg7yq4GUcP4c6Dgl0DN734Ui4mkjJiYAdduYLILF3X6kevGjpWwWZKadCecUxRTFzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TMU2nhMy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TMU2nhMy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751954959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lWFJVae8Zb3zj6dpY4YGKKbDp5Q5s0XMR4NFZ8aeJqQ=;
	b=TMU2nhMyOovl0ZW640khiJ5AKG6pHc6uRTiq6/8vg05zkadEKMkrZV5VCCmemz51HV6TSv
	lml3Bsvi22AXqM+GLcQVWplB7FrswILlbEjKQDNhFMa+luF5Dzn+6GKdzdrNObEIAkxwgQ
	ApbpTWzIZUAswqLQT/6fHfDqjLkyjFQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-4sZ9XSeCM5WwaBPCSaJUgw-1; Tue, 08 Jul 2025 02:09:17 -0400
X-MC-Unique: 4sZ9XSeCM5WwaBPCSaJUgw-1
X-Mimecast-MFC-AGG-ID: 4sZ9XSeCM5WwaBPCSaJUgw_1751954957
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b20f50da27so2274298f8f.0
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Jul 2025 23:09:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751954956; x=1752559756;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lWFJVae8Zb3zj6dpY4YGKKbDp5Q5s0XMR4NFZ8aeJqQ=;
        b=m2XFA/hBmOE3YDxE16eXABCiC71u0JkKjoy+EFOxUiSDHkhHXE6Ikv8/mr1VO34tE5
         a+Fs+sjjrmH82QtuRCQ9WVRDFIOY7GEjEo/x4z2Dir28IMGj+xgR6DfMopdQzC0wuHML
         0KKYCZ+gVoA2sVqnZWJ6H3i1j86iVC9Tq+V0f68LsPUAgvIXKv09cTwdypHxyOEnUYUE
         arSHG3USdZycdiIavq/1SKkEDhKdl5PPv9lwkActf82tSlQwqn/xe5Ob+OadnQd1lwEP
         sH2FYapweIMuvrt/Gbo8xgSoqdb0KkLahJv6YlrOw4ZVPJ0cpcO7jPzu/cExR3YwNQu8
         KTFQ==
X-Gm-Message-State: AOJu0YwG8yv9u0KLUki7u8XW1qOfAx+z2OeOZZTpx2gfV+x/W15/CM64
	5AyX6G52yPLO2+BBj/lFajCQTsmqKJmtP7Wen8hKfhK/ZkEVD4h/f4mQ8ZitSvrOjP/UPkmTwZm
	A5uNV2fL8/g9dhKufarMjDWo/gmgV9nWJ6nzltQIjGqwgcU5CqNpUjuGTHvaAfOA+yZbuZ0Xg+V
	k03g==
X-Gm-Gg: ASbGncuaMpowdv/qcrTu22FjTuZeHYJdgyvAsJq4F2dGPdg6kYhUS0uHppb8b3aBIYl
	PACSpHtukB0UTYbMYTwf9CXQQ60JpWXXhcVxHPOvYk/r+cxNZWrxd/cfTcZxGYZNWncEVI9MKNs
	eStJPEWifKp+8g28z/d9qLjVSkRDRjRMb8ZoKNmpkcIIVMq6rfgCl1ViNQVs3d1OfHRpEXZpYDe
	Ltf1YECQoWuoXB7v1JwSm6jd+Ov2yKDEZiGU6/veWOlPBXOF+hMusu1J8VZLokQaCLWgHFjRG0z
	F32jmQ/hxv5w3ReNIr7rcLBpuGB/bjTURtk17s3GLsmX1ko9puE=
X-Received: by 2002:a05:6000:26cc:b0:3a5:8977:e0f8 with SMTP id ffacd0b85a97d-3b5de11fc9amr987380f8f.19.1751954956170;
        Mon, 07 Jul 2025 23:09:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4kbr1XjEBP4vSzLAMARh63fBNdHf29ZG+HFdHljLoEfOMZqm1fJRI/6B1k/2EDVU5Ys+x6Q==
X-Received: by 2002:a05:6000:26cc:b0:3a5:8977:e0f8 with SMTP id ffacd0b85a97d-3b5de11fc9amr987352f8f.19.1751954955667;
        Mon, 07 Jul 2025 23:09:15 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b470f871casm12056095f8f.45.2025.07.07.23.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 23:09:15 -0700 (PDT)
Date: Tue, 8 Jul 2025 08:09:14 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 5/5] netfilter: nft_set_pipapo: prefer kvmalloc
 for scratch maps
Message-ID: <20250708080914.18baefce@elisabeth>
In-Reply-To: <20250701185245.31370-6-fw@strlen.de>
References: <20250701185245.31370-1-fw@strlen.de>
	<20250701185245.31370-6-fw@strlen.de>
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

On Tue,  1 Jul 2025 20:52:42 +0200
Florian Westphal <fw@strlen.de> wrote:

> The scratchmap size depends on the number of elements in the set.
> For huge sets, each scratch map can easily require very large
> allocations, e.g. for 100k entries each scratch map will require
> close to 64kbyte of memory.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

