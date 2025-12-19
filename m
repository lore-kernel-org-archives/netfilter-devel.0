Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8052E717B
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Dec 2025 08:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766134230; cv=none; b=nbUyLsdFx8QnJDV6kmZBJNTm1oEtgi739lLYsNqua2CanQVjIBDUcRUn+Sy7fS3Te8BYy9GuTa4PYzi0sK10bpxAcSnf94RnVlCEc1F0LAXGwmgTSJVSRYoXeOvr7mDatkinmXer2ZQg9aJ0Caz5kCD3x50FdrwoFLFxfqgUTLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766134230; c=relaxed/simple;
	bh=RLALCsoe1w3XD3naM+vu9TepI4hTgU4yd/3pARzoNms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pdP2uqlsh8dtcs2gwJQjkXu/JgSH38HxpShZLkEHnCpfDXSfSX5RHrK3jdoB4QBVSbkTTdP+IxCaOgTMlWW3Irfaqv+gbAs3FFlHIwRZHgGWCkfXmmDkcxC3a6MjjmLKLFJyrWtfx2YFREvw9Fsg3KcyCncZM0w6nzi58dY5jjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=REF2B5pf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aQMMZ4Qa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="REF2B5pf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aQMMZ4Qa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766134227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J2K24You3Kfo8F59LNIwUD/2pkFrB/SR5T0fDa72reg=;
	b=REF2B5pfwn+ZKNZlyLpS1CxZZslmufzvY1r4W4rzV6iyG0uSRUqoAU+7njDcKRVY9qlFWk
	1hbEn2hXRqJKtTx685BpOj4uOLjO827UsyigePtrmuWQCb8qZl1MNE5APfom/TixDCfy8q
	4MB2Tuor1VoYSNtxAID1ZvX+9gJLh88=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-vQS-5QExOfWkYlcApdz4SA-1; Fri, 19 Dec 2025 03:50:26 -0500
X-MC-Unique: vQS-5QExOfWkYlcApdz4SA-1
X-Mimecast-MFC-AGG-ID: vQS-5QExOfWkYlcApdz4SA_1766134225
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-430fb8d41acso713567f8f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Dec 2025 00:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766134225; x=1766739025; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J2K24You3Kfo8F59LNIwUD/2pkFrB/SR5T0fDa72reg=;
        b=aQMMZ4QaFOnIGPCBBXvggXo0UhbzlchUj7NRDwAhDhBs2rPhTRel5qf3UOzFyV1kCy
         m1eVkDbyg/a0ipWftDvXQfNisb3+pciZssUhpxmSxAI3LKKjn8QMxK8P5L7AR7K5lLt9
         vQfv1mj4VSvB+IxukNEFFmk5Qqa00DkW8by0326dpn834SSoHmJHYtOg1jdHHxjshIX6
         TGJjGgKe8phBPZZ11Kte6byoH7X2TOQFUMFJCvOP/86n0ADXna8sXoLM4Kh6dtPvVoQa
         JGLGALsPVMMvL0SmUI+5owohpOaW6r9gsliLzXR/4ehcG/uiWIb/POoyRESn5OEOqDP9
         GmWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766134225; x=1766739025;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J2K24You3Kfo8F59LNIwUD/2pkFrB/SR5T0fDa72reg=;
        b=APZ0eqfdWu+SuYRPSew58qE+pzELiNQVz9Lpdusxj5PKhVG1cGAMEOUFe57+svZbF/
         xUloSbAWkB+KDG3lpJhjp5Qr/CJNIvsdafebflQRsr/QIWpa6IxhVVEKFfYWNU/yYUjH
         aI0q5wbHDc/WPceSXeTS3iNwFb5YDfkqluNpV/7j92/yb4sI91l2YZ+9T07jhkJnkf57
         YIxcnXrt+QZMj9RVtX5dkZh83rhXsLnJe+/Xkcae/EeYgDZt/5g1HOd49R9/Umroz+hK
         CAEi/+DEBQteTMcCvEcIlYTuN16vx/ylA3Q+pkPDFWTI0eyvROmDYEYBan7Kg6wfEEVq
         SkYQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+q8PBictKtrVdddm4CCutRycMWWkAnqqOGfc3XOm00Amjk2yircJn7Ih9Btzp+ud9wyOJKnvVm/5yaZw/lvI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyRq+c+Eefc8vPaJBkc15sDCy4KWmxdXR1xqIg50WdhrHVnjBf
	AaRbgBbOCbC/bfhDFk8COGcoax5YMjoZhu2rM5jBaZZAPDrXGnQe08BDdj2bj1kh5ZQwukt1CeV
	Qfeock+BUDHrEK33RdTI4kqjGZjNy8JzgfFzW4gssNNsAbIXRlm3Y8eJusMIK4+0yO1BDRQ==
X-Gm-Gg: AY/fxX7V8LJ/kPAOoOuhMiShL3yaKRWmmQ0ac8M+FLxdf7hRbfDsYR+6zhJdthFMgNT
	M0ipGVfoU26M1U9KA6SAoiL+xN9p6LKPXF9BmYG3v5j8cvM2yJF8ppGaDp2C8N4+Gzo7KrGn967
	dq4XvdAlUh28q4JYwX1jDEg6GYo/NgrllfL0ZjoBBTNWj5qZfbE8PLzIvXaFPHyNrjNAdiazvMn
	l7gN4EzW5N+P1aJXDxWNU0kSq3XFr9UaGrKcYz4o1XGYgFJUkct1QRGG1IBdRP6wUO8C+PE59LQ
	1SR0otIpbi3+HeFU3I34gd+1dhIkjBXZy04xQDbI24QLG7TnqsbYCOx+FczlX/L/EmLvnTR+OM+
	foKV77x2nl5d6
X-Received: by 2002:a05:6000:2907:b0:429:b751:7935 with SMTP id ffacd0b85a97d-4324e704a80mr2514630f8f.56.1766134224875;
        Fri, 19 Dec 2025 00:50:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHt/CfVvLNdIq+TM1T6BQhBqxVPih7iUEVrqrCXF3wQwAR+Q36BoRwUoHyrhDWqs9SKEnDvQA==
X-Received: by 2002:a05:6000:2907:b0:429:b751:7935 with SMTP id ffacd0b85a97d-4324e704a80mr2514594f8f.56.1766134224471;
        Fri, 19 Dec 2025 00:50:24 -0800 (PST)
Received: from [192.168.88.32] ([216.128.11.227])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea2267fsm3591620f8f.12.2025.12.19.00.50.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 00:50:23 -0800 (PST)
Message-ID: <6d244984-ff8d-4226-a5d0-49b0547eaff4@redhat.com>
Date: Fri, 19 Dec 2025 09:50:22 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 0/6] netfilter: updates for net
To: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org
References: <20251216190904.14507-1-fw@strlen.de>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20251216190904.14507-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/16/25 8:08 PM, Florian Westphal wrote:
> The following patchset contains Netfilter fixes for *net*:
> 
> 1)  Jozsef Kadlecsik is retiring.  Fortunately Jozsef will still keep an
>     eye on ipset patches.
> 
> 2)  remove a bogus direction check from nat core, this caused spurious
>     flakes in the 'reverse clash' selftest, from myself.
> 
> 3) nf_tables doesn't need to do chain validation on register store,
>    from Pablo Neira Ayuso.
> 
> 4) nf_tables shouldn't revisit chains during ruleset (graph) validation
>    if possible.  Both 3 and 4 were slated for -next initially but there
>    are now two independent reports of people hitting soft lockup errors
>    during ruleset validation, so it makes no sense anymore to route
>    this via -next given this is -stable material. From myself.
> 
> 5) call cond_resched() in a more frequently visited place during nf_tables
>    chain validation, this wasn't possible earlier due to rcu read lock,
>    but nowadays its not held anymore during set walks.
> 
> 6) Don't fail conntrack packetdrill test with HZ=100 kernels.
> 
> Please, pull these changes from:
> The following changes since commit 885bebac9909994050bbbeed0829c727e42bd1b7:
> 
>   nfc: pn533: Fix error code in pn533_acr122_poweron_rdr() (2025-12-11 01:40:00 -0800)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-12-16
> 
> for you to fetch changes up to fec7b0795548b43e2c3c46e3143c34ef6070341c:
> 
>   selftests: netfilter: packetdrill: avoid failure on HZ=100 kernel (2025-12-15 15:04:04 +0100)

Pulled, thanks!

Paolo

