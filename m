Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443641A4F09
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2024 09:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718876439; cv=none; b=EKSOV43CV8DtEOUKm90AbUYG8vPMx3C2K0n61TDV7tiWsXiKZhQ6Dr1EztpMkdIU/aAOBs/B+TvzMj6FSoI7nhx6mPVAL4L+odnBAEL1zMq0BJKz+mo3EBmA9Ta2CVhUfLoi247z6pTuEiHVUxipGeaMKiyKt3yBCIESvsw2X/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718876439; c=relaxed/simple;
	bh=KIfNt1QGxmQOwjeFJlqkiQWGjyux5g2qZqevxXwvfOg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KWPJrGYM2mFK9N47f7JS9NF3g26tn4rwcnAHGNr9FtKHpY4UvlDwo4JD+dORem2QAgL+CmudDK6sJgj2PZ8V05ISXkjIm5ayCrOrJkRuZJQEKi+Idv1wvJn9b11uEdiFjooT8ZpCt+ueZV97GGmG6SVza+seWGOi6xo1JQz2IoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZpxDWJGg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZpxDWJGg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718876436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FCDnNrLNWMU9Vh2OS+L9tNbUggsEdetIwOwbT/RVGNc=;
	b=ZpxDWJGgRIFoFDEoLkm0CkBqV3vES7E6q1K2Rm6jnkTRFu0PxdGaLNE8wwr3i7eOUpsvsS
	pc34qNdftyxjvBvZ9oOj8gV95RT9O36pcMRVd5ayPNgkMF5cDvERq5Hf+XOBnJYVJkwJ4M
	eJ4c6PDjinB8ON0Bzxsy3OMHgzPLB5k=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-QtElUwxaP8-nF7ghX3Hcgg-1; Thu, 20 Jun 2024 05:40:35 -0400
X-MC-Unique: QtElUwxaP8-nF7ghX3Hcgg-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-48bd4902d1fso89559137.3
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2024 02:40:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718876434; x=1719481234;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FCDnNrLNWMU9Vh2OS+L9tNbUggsEdetIwOwbT/RVGNc=;
        b=MofAkbHOKHxqdcDuhq+m6H3s9zR0UFJXmfgTqCGikz7Xoe91uEoT6TxIt56fWCfeBE
         N3kZbuqg5EmGH8CkcKABIW2CpksniakjqQyYKvHfGUQCoAithAnyxrty/6PDNiUs7d2w
         sM4qJKgTy4/v0thOQm96d/XUhHOoB6NXjQ2JGj/Zc+aGfe4FCSHqO38WPlUjvRwj6nuZ
         GQGc/mMlLd3GjrlNQJapiXSDP2BQ3NZEW0wGjXZbRAmsuda1mQW3/APidhooTHza2PBZ
         IcD4wSfvu3m3x7tOeRFsUs7DL63x27nKiWY4uJ2vISXJXPbXwVu/hpS2uZ87eMk9a+QT
         OIfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUw8R5vzO2JGbgHR4dkZKRCYWHmgrQYBqruMC6U1c4EHvTLE0g9uuqQlsJDZFYe6kkFpD4nckcfH1PaOKbL/MLG5gDDLce6GAGcvx4XpdQ7
X-Gm-Message-State: AOJu0Yy6Gh6+O2NNl6LiCE6VUeRjwYPJMkpNvGsLCyvlgdvtqEp55QeB
	6DXfbj4RaH8UrXrvODNMSkOnXaYClNIm3+d4nil1FS+kebCvePX5OOhi/Y9uR6cSyo2Dv5f2tmP
	gAJG5N4I4gcVca6PyCi5V8Q0vBOqEuwgM0kEWzfKYi5gI8W1za2ewhpuEcCHqFCx7UGWIgHRBBA
	==
X-Received: by 2002:a05:6122:169e:b0:4ec:ef7d:b99 with SMTP id 71dfb90a1353d-4ef2758261dmr5309674e0c.0.1718876434024;
        Thu, 20 Jun 2024 02:40:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8Ab5SLuThw6qjDLtLVmsa3Zt97I1LGYDQyFLZBxUB+r++2dRTz4kaLK25T58o3pLboLH2fA==
X-Received: by 2002:a05:6122:169e:b0:4ec:ef7d:b99 with SMTP id 71dfb90a1353d-4ef2758261dmr5309666e0c.0.1718876433698;
        Thu, 20 Jun 2024 02:40:33 -0700 (PDT)
Received: from gerbillo.redhat.com ([2a0d:3341:b0b7:b110::f71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-798aaedbf4esm680868485a.38.2024.06.20.02.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 02:40:33 -0700 (PDT)
Message-ID: <3d0635da6ea9b3a6445c5e6751ec0cfd024a08e1.camel@redhat.com>
Subject: Re: [PATCH net 4/5] selftests: add selftest for the SRv6 End.DX4
 behavior with netfilter
From: Paolo Abeni <pabeni@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org, 
	edumazet@google.com, fw@strlen.de
Date: Thu, 20 Jun 2024 11:40:30 +0200
In-Reply-To: <20240619170537.2846-5-pablo@netfilter.org>
References: <20240619170537.2846-1-pablo@netfilter.org>
	 <20240619170537.2846-5-pablo@netfilter.org>
Autocrypt: addr=pabeni@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-06-19 at 19:05 +0200, Pablo Neira Ayuso wrote:
> +setup_hs()
> +{
> +	local hs=3D$1
> +	local rt=3D$2
> +	local tid=3D$3
> +	local hsname=3Dhs-${hs}
> +	local rtname=3Drt-${rt}
> +	local rtveth=3Dveth-t${tid}
> +
> +	# set the networking for the host
> +	ip netns add ${hsname}

Side note for a possible follow-up (_not_ intended to block this
PR!!!):

If you leverage setup_ns() from lib.sh, you can reduce a bit the code
duplication, and the script will avoid any possible netns name
conflict.

The same for the following test.

Cheers,

Paolo

