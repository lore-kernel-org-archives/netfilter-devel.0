Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCBC7352D
	for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2024 10:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716286756; cv=none; b=CgUjq42OfZ8lx+4sp+N+EOrdiE9f7a8QAT44ULtt1RktTH8TM+l8dsVSY5iK6iEZ4xW36Vxa+FgUcXvrxIaEnz25azDNvBpwhpE7CfRj6r8xASvK4Xs9VBeXr6MWhagnMkEnpGn7ic3rM4q+quJwijYyprc8FuIcbZS1dD56sbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716286756; c=relaxed/simple;
	bh=m/BnOv9IyIknk0taxfZ9in2qMKbBmTm62BEIyazTekA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=e7XClTAL0/bSDtXrUlVR8jDciZWsKzxM6pb+nlbsCZSKeXhu9Jkclibt1eTESRYBXXORDrCT7QF++aqQ826V3kTmce7BxcP1Y3EH9dNvKJ+twPXu8btrVpN/2UKGeRtltGDS30DN2B6e21Uj/gdS5tO38/elJugZfNaCF2hgtlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZH/sUGn8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZH/sUGn8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716286753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GDN4wBeS+zyaK3mckFLu3ekq1g2jhLMHXCljitfNdOI=;
	b=ZH/sUGn8K2YAspUoGR+gQSTolGOc20+vCPs/g2soRpUTAaYRQTtWGt0sUOfFtHHFiT+epV
	MAJjlG3sJYvYRws0G+0WYPi/1SCd6EC4LENX8YpITH6ZQakQkTkuRoQiJxoXmiSefdSs/h
	hHM5L+Jxs/eLI0ugbu0pGP2KaMqYVGI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-skKDkR9HMcuz-OVRp5lytA-1; Tue, 21 May 2024 06:19:12 -0400
X-MC-Unique: skKDkR9HMcuz-OVRp5lytA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1ec263943d0so113545525ad.0
        for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2024 03:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716286751; x=1716891551;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GDN4wBeS+zyaK3mckFLu3ekq1g2jhLMHXCljitfNdOI=;
        b=GPAO2CP4eVN+j91ewLuCKlsTlDOxcYoT6/v/8a5gnKSuAmwvI4LCF/EroielBzwBvn
         YYwYKFF2UswfeyXaNxHRNn1e+WqSZFuMP3BLb5i5PrnihxzzymTFdG+JSWqM9rxerr8G
         54Mmf+G0SdpvVFbVNEqwW1fF81hPP45ABz1zvYzgMLiXC+k83890BT9ESsI3uOSk9D68
         aM6u/f3eSKuiu/PjpqSSAv04NpGIp6Iyy40FlcfiE9gsPFMlW4jG56zZoSyzSg0PfFYm
         wQMt/WLxFX5ab8uy02QUgG1+wQ7rrs86PNs01W80GvfIO3fdDPd/ko1VRaXa2UiH74H9
         t3Lw==
X-Forwarded-Encrypted: i=1; AJvYcCUfukZQmn8kOl3SRNssdYsIHXb/QYGkNlQhDca+aFTqBN4naDrgzvw1ItD4Wcp8YpCrzrEs0x6VubzYo9Qhhq4IGTT0HvOG5WAGzyLtrgR3
X-Gm-Message-State: AOJu0YzBR/3kCUmRoBiSBOdkf5fBzEhaW5SRIYRMLlqjo+12bd1ENyCz
	bgZgwaeR6rLs3BiSSciBmc21uZJPfIBw230tJn/tmDSCCY/7MWa5CTiySdo1765Ner6Wc7KsQQi
	lSx3bFFaC12BlRfUdEXvxTZpfCTWZ76WCuyM1dmaAMUOa7HL5pn7ko5IFsKkgEDyxjw==
X-Received: by 2002:a17:902:ec83:b0:1f2:f0d3:db30 with SMTP id d9443c01a7336-1f2f0d3e367mr98973215ad.64.1716286750933;
        Tue, 21 May 2024 03:19:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvvHcjqOjtYCqzf1Shk/DnxCibhC9dkl7mU3+4cXSE2zbcJWmISDdAei0dLnJPKrfutGYx0w==
X-Received: by 2002:a17:902:ec83:b0:1f2:f0d3:db30 with SMTP id d9443c01a7336-1f2f0d3e367mr98973045ad.64.1716286750535;
        Tue, 21 May 2024 03:19:10 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c2565b6sm217542135ad.295.2024.05.21.03.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 May 2024 03:19:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id B10B312F75B4; Tue, 21 May 2024 12:19:05 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Lorenzo Bianconi
 <lorenzo@kernel.org>
Cc: bpf <bpf@vger.kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netfilter-devel
 <netfilter-devel@vger.kernel.org>, Network Development
 <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, Florian Westphal
 <fw@strlen.de>, Jesper Dangaard Brouer <hawk@kernel.org>, Simon Horman
 <horms@kernel.org>, donhunte@redhat.com, Kumar Kartikeya Dwivedi
 <memxor@gmail.com>
Subject: Re: [PATCH bpf-next v2 3/4] samples/bpf: Add bpf sample to offload
 flowtable traffic to xdp
In-Reply-To: <CAADnVQLV4=mQ3+2baLhfJi_m6A72khNxUhcgPuv+sdQqE7skgA@mail.gmail.com>
References: <cover.1716026761.git.lorenzo@kernel.org>
 <8b9e194a4cb04af838035183694c85242f78e626.1716026761.git.lorenzo@kernel.org>
 <CAADnVQLV4=mQ3+2baLhfJi_m6A72khNxUhcgPuv+sdQqE7skgA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Tue, 21 May 2024 12:19:05 +0200
Message-ID: <87ttira2na.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Sat, May 18, 2024 at 3:13=E2=80=AFAM Lorenzo Bianconi <lorenzo@kernel.=
org> wrote:
>>
>> Introduce xdp_flowtable_offload bpf sample to offload sw flowtable logic
>> in xdp layer if hw flowtable is not available or does not support a
>> specific kind of traffic.
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> ---
>>  samples/bpf/Makefile                     |   7 +-
>>  samples/bpf/xdp_flowtable_offload.bpf.c  | 591 +++++++++++++++++++++++
>>  samples/bpf/xdp_flowtable_offload_user.c | 128 +++++
>>  3 files changed, 725 insertions(+), 1 deletion(-)
>>  create mode 100644 samples/bpf/xdp_flowtable_offload.bpf.c
>>  create mode 100644 samples/bpf/xdp_flowtable_offload_user.c
>
> I feel this sample code is dead on arrival.
> Make selftest more real if you want people to use it as an example,
> but samples dir is just a dumping ground.
> We shouldn't be adding anything to it.

Agreed. We can integrate a working sample into xdp-tools instead :)

-Toke

