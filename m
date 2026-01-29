Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9356A224AF0
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 10:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769683257; cv=none; b=DD7CItBVwUDqEASOnsBPHBzfIiAiY1lrDJOYl46CkkvcC6yd2wUyyYf5El16yRC3q5Cxr01LP0rE3ewcVSp6delC7XiajG1c399zaNRdZ6inZ9kJIPjnaFZQhu27hq6r8xik5yY+Nawm3ibADIx1YnuXVJ8XeiSspFgYKvyARHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769683257; c=relaxed/simple;
	bh=EY7ZZODRHs6t4AqR0EKeIIKLzssqQhMZPQBNOuqt/pQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AP+GOfu646FHBTaYMrg9yTkiq4BlfYkRy60C4Q/hURqR+IOlS7UZVbzRfmPxlCP5pKoQOt4mcnza5XDYr4l/J7WboOKAsLNU1d2y8N5Q+wo4gNA5BR4YRUtiOruoIhrtFvANyRLyAKmrGjXPCCDQQp+Lkh9Sp0xTCSkFzewyvXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DH1aAduv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BS1ER0eE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DH1aAduv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BS1ER0eE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769683254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iQTltzdGEETDMvC1aosQeu/r/ya637/iAmhGi/CVLVc=;
	b=DH1aAduvDVcPbNopF0pNTEmwSvK58I6W7U9DmoN52oWK7m7uos4nsBp0vtnJgXMc30DjJU
	vcYpEl6u3pIfkqD1BeRu+FwENZ+/iYHl94hFNVmttWgIKacY3fjoKqwTBcbhj2GWgrdpdn
	wk2R/QGQSfyS4ePDT2NR1b9mzohhrCI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-Dxc1Wvq1PcSHmwF8wolbqg-1; Thu, 29 Jan 2026 05:40:53 -0500
X-MC-Unique: Dxc1Wvq1PcSHmwF8wolbqg-1
X-Mimecast-MFC-AGG-ID: Dxc1Wvq1PcSHmwF8wolbqg_1769683252
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-435a11575ecso952639f8f.2
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 02:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769683252; x=1770288052; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iQTltzdGEETDMvC1aosQeu/r/ya637/iAmhGi/CVLVc=;
        b=BS1ER0eE5xBjzzO3dg6lS29/gB3H66lgOa4S1lFhMsNuvzYiT2bzhFmmRa5CXlxts4
         axbaHQgn+BT5U1qFoC6ZSyxFYoDQ4+WfdTrmc+uTIBvWjpI3iLCDkmrmuJQRlyEPcwDR
         +e0o1Y/mw+uXdX/0hxIS5ZPmTo7V6WMIQbS9A5GSrc2QYPQ8VWIT6i8ifzBfaHVLTpi2
         gh/3Bjb9k3+Q2ze9J+clQ53PlhKkKqUYvOgv9jYGS4PBjSo4xEVu0+hqXbR2P0QGk2jF
         x+2iyt8KsTTN1sIMbhOfwN9voEr7hHzw85tFzPqrfyv5aQuklA3IeWk0J2HZCP95KwRO
         HtBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769683252; x=1770288052;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iQTltzdGEETDMvC1aosQeu/r/ya637/iAmhGi/CVLVc=;
        b=c8Jn8YeQagza/4qFLo4GkSSsiI2ehMiXNmKa/Ys30qz/ENr0mjFL/S+Bze/CGXbju/
         yJ//lA2OCoLttVxx2i2Ue6q2enI27qZPAk0t9D5aOyohU/73GH3KNtPkB4uQ/cGuWbOE
         +DEIiuLhWcxgro9S9G/LPhWFBvCCZNmz+MpNBt8Fd8Yk99ypFTlEg6OioS1AGpZr1xaD
         bEORsZ1OnaExtvvYt/nQ5p+Z7tswAxECPZ2qDkFMQfLgtUSLA0kjuWWpWBsl2ufovwHp
         6VJYWCm+igRNAcT5Lj0WsahRAiEMZMP57oO3PPv2LdJRIyZZYq1i9IgGPVdwd7LUHD/n
         dkWQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5QtU/G1rtbaWjWAjT2OajXlhsRUtb2FoTtI3TVmCQ+pITbLx30G4LvXVinx5/FMxEBOEjiPR6JSDNCFneLxk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx+04xIugMXB7nkP9ofl9s9MC1YDjUIZMxLCSNpgwUDYI9vfYM
	YWtZdOsdWKWkGpSVl+bF97TeVFk12DvCFybEn+FUSCE2R2g5F65QSJoKRBRpngrQaX/GFpvYgA2
	wT3XWEJlYDp7o01qosOPXAYocHAVA6NrRMH5x3kaKHE6EOWsJiMxV+ivNB4BKYj6pHoS45w==
X-Gm-Gg: AZuq6aIoH4bbh9xXqSx6oUhmAS9vXYYoTgrGXxx8PfBy9EEeKOY+95rcgxkBhbIPtOg
	qGLLy77sCJgqXQzf4xlNPSgt31ceLLcfEd1xOn6ALz9N3oPUf46obPaQ9Y56dwJXWtmSU2u0ioB
	K8rind/1AC6wEXA/nq3NDWyvVJTx/KAKDUHJg7Qo5Vkoq3rMmBxM/rZ0blgmfr1eRwraS6YnpWm
	t2MhXgoeY7K/JMDpZ1UwsxoUcqCuVuSYViSZrY/IbTcsOY/h5XpAm5Iv2hB+98uf/LlKvB5ukWl
	lpW8RGyzUVwQ7Q7z8zY+YdzWO2xAHwoUYZYtxAUjQUlneSsIPqLZYBQ/IscSH0zS1Qo8kOeUP3u
	Nj2D321/II3iI
X-Received: by 2002:a05:6000:2386:b0:431:38f:8bc4 with SMTP id ffacd0b85a97d-435dd1d913emr11847910f8f.61.1769683252021;
        Thu, 29 Jan 2026 02:40:52 -0800 (PST)
X-Received: by 2002:a05:6000:2386:b0:431:38f:8bc4 with SMTP id ffacd0b85a97d-435dd1d913emr11847875f8f.61.1769683251529;
        Thu, 29 Jan 2026 02:40:51 -0800 (PST)
Received: from [192.168.88.32] ([212.105.153.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10e46cesm12955210f8f.7.2026.01.29.02.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 02:40:51 -0800 (PST)
Message-ID: <490eedd3-bd04-48bc-9526-09a5a786b667@redhat.com>
Date: Thu, 29 Jan 2026 11:40:50 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 0/9] netfilter: updates for net-next
To: Florian Westphal <fw@strlen.de>, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org
References: <20260128154155.32143-1-fw@strlen.de>
 <20260128210313.787486ba@kernel.org> <aXsgxfHxTEU1_k6e@strlen.de>
 <aXsxr8KQGFOhnLIa@strlen.de>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <aXsxr8KQGFOhnLIa@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/29/26 11:08 AM, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>> Jakub Kicinski <kuba@kernel.org> wrote:
>>> [  580.340726][T19113] sctp: Hash tables configured (bind 32/56)
>>> [  601.749973][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
>>> [  601.985349][    C2] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
>>> [  602.191750][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
>>> [  602.555469][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
>>> [  602.895890][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
>>> [  603.226543][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
>>> [  603.435907][    C0] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
>>> [  603.569421][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
>>> [  603.672454][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
>>> [  603.821679][    C1] TCP: request_sock_TCP: Possible SYN flooding on port 127.0.0.1:23456. Sending cookies.
>>> [  618.553975][T19316] ==================================================================
>>> [  618.554200][T19316] BUG: KASAN: slab-use-after-free in nfqnl_enqueue_packet+0x8f1/0x9e0 [nfnetlink_queue]
>>> [  618.554424][T19316] Write of size 1 at addr ff1100001cc9ae68 by task socat/19316
>>> [  618.554600][T19316] 
>>
>> Did not occur here during local testing :-(
>>
>> Should I send a v2 without the last two patches or will you pull and
>> discard the last two changes?
> 
> Alternatively you can also pull this:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-01-29
> 
> Which is the same series but without the last two patches, i.e. up to
> e19079adcd26a25d7d3e586b1837493361fdf8b6:
> 
>   netfilter: nfnetlink_queue: optimize verdict lookup with hash table (2026-01-29 09:52:07 +0100)

Would you mind sending a formal v2 of the PR, so that the CI catches it
up and it's properly tracked in PW?

Thanks!

Paolo

