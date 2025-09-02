Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D912DC32D
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 13:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756818191; cv=none; b=qb3eOSkf0T2ENXe2DJnskkP/G1rvmcK7/yPW29JV1UpVIz3/9x+6KpQjn55/S8btG4DTKtOCCp4EOib0aymJx50mIxSUDIgofO1nEu+EaIBjDgOJv3QJ9rmdgYrelu9ZMEOjTDg1DGwV/t7dPJBMgVCqWbHKRfeTQRp6vpwDqks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756818191; c=relaxed/simple;
	bh=uIQOOOowz4CN1rhTTJCbXQVsq6MAI3mbDvWnQhC9OPU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AgWngeb2HPLYWCWYOnmMLbqQ4ZZUH+DQ3i6ppTvoqVnf0XcoXmrOsfP7H9YgW/xROuTT/EI910tkJseWVyqQ9nRDopWg3W9dzhQnG3jg2SfbzhNSVXNQNYMbRQSJWduJ+PFZmALthFxjnfO0dt4J4jwRgjG9kG/o4AASRdL2p5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lr4Fpuxd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lr4Fpuxd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756818189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FqKOZ77CDWS20D6kmfLQTPPlNJdRjsyD/W9G47iuzwE=;
	b=Lr4FpuxdFZoozDp9V6YVtLdAEd3QsHYCD2n1S3xlbNG+CJ1/5Nftc8zfU0NA3T+0uwgzrA
	MqZ0YorpHBG/L+CBlQjCRqyGHGKl2SQV4c82EQmwVQzvK3On7MU04QqqCRpKSXxMz6hMgx
	6aXADpJn7Zjqm/RlXyFQlDjlo5ByzSo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-t2mT55XAMCevnwJNMZnqEw-1; Tue, 02 Sep 2025 09:03:07 -0400
X-MC-Unique: t2mT55XAMCevnwJNMZnqEw-1
X-Mimecast-MFC-AGG-ID: t2mT55XAMCevnwJNMZnqEw_1756818186
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3cceb92ea73so3127467f8f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Sep 2025 06:03:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756818186; x=1757422986;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FqKOZ77CDWS20D6kmfLQTPPlNJdRjsyD/W9G47iuzwE=;
        b=D4S3ktyed+SZmwJN0gnqaPktVfBq0Kl5XXedL19zGN6t30g1hvvb+99+1P1n6GxsrH
         DLbZq8pAnuXlhYPugl3TKdtpkcNsJuNuuCH/+hpKZN1DzhxfeG2CeP+46RU2QP7puQhv
         6TsFzYbcMIK8+1SvIpyHMBmAnsMdp8Ioc63or+DUnlh+lo1p8lr2oBfjCNsITyq4wJ8P
         9Tul8rBTsCs4t0Mm+htH/bXe0HDC8sdfDTXL/GXs/oEciNnfBp6CVnInyVMOpbvP6S9A
         hUZmqDfXqWT9LHpQX0/jaz2wvhtYDATjRlFw2v8mYZAaP75wGI7zavQd65pBnf1gNjEw
         ud+Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3ADrs98fXjJ5+ssRMloeRrAWOEXn/81bdTPlsGLcOfk2ZnEpcXOsPLn6+Ybnu6YW1urWiqDsuc7u7UhHfm/c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9jSEZgEjHtKr6X/X84eE395XvgBB6g79BPWloJX7MjjMlL+Y+
	BQ9uuGind/zE3ITlL5LMN48Rod38oo9hfRxQjLzZvEYIZIXTvYhU/nNENuaLhI/abGfQVI5Lewq
	S5O47zccYvc1K0gTELIUtS+abQIcoXAERzeVKsW9Ayx7TZVAi5qyLkW6gx+9iztI6hcUBpw==
X-Gm-Gg: ASbGncvvsKf0OKI5jwRDEWgVqz/e3xqTQDMADJzH1+yWZjkiuA5LM1BKviEviCLZk5O
	DPkejEuoGUKEXuGVafUlsD/A3pdx+JkbPxxkoX/Fe4kNXrkXNhG5zZKqBncMNnWFvmkl8RiRQt/
	IskGncwtmyuxMepJjEA5bgUcHdcUexlFrV+kotBdPOWlHKSwcuu00hRvDdPikaWj0sKuAk956Bx
	GjdO9GD78M5+KVKHDp6Wxuc7W1Ci4EeZxcg/cKv64OkCinwtz5rAVjvk7w6S+UZ2Zq7F6p/bJI9
	c/Pk8qhCOVoqyMkswMDZDEiyhusku6tUvRPpBkAja2We/kPd9ec1SrD55a6+qw5th/jepEbz0W9
	AONTzag8Rstw=
X-Received: by 2002:a05:6000:1788:b0:3d9:70cc:6dd2 with SMTP id ffacd0b85a97d-3d970cc6fe7mr2689082f8f.40.1756818185543;
        Tue, 02 Sep 2025 06:03:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0SOySbfKyKJPc+bfs6kR2/ZvH7s2l/8gDpjVSDxCI98orw6qI9d9Ef04CuWtGtZyJJaoVdw==
X-Received: by 2002:a05:6000:1788:b0:3d9:70cc:6dd2 with SMTP id ffacd0b85a97d-3d970cc6fe7mr2689045f8f.40.1756818184939;
        Tue, 02 Sep 2025 06:03:04 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e00:6083:48d1:630a:25ae? ([2a0d:3344:2712:7e00:6083:48d1:630a:25ae])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d66b013b7dsm8838574f8f.28.2025.09.02.06.03.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 06:03:04 -0700 (PDT)
Message-ID: <e7665da6-5aa3-401f-ba1f-b2905f9821b5@redhat.com>
Date: Tue, 2 Sep 2025 15:03:03 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 5/8] netfilter: nf_tables: Introduce
 NFTA_DEVICE_PREFIX
To: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netfilter-devel@vger.kernel.org
References: <20250901080843.1468-1-fw@strlen.de>
 <20250901080843.1468-6-fw@strlen.de> <20250901134602.53aaef6b@kernel.org>
 <aLYMWajRCGWVxAHk@calendula> <aLY0hh8aBWJpluMI@strlen.de>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <aLY0hh8aBWJpluMI@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/2/25 2:04 AM, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Mon, Sep 01, 2025 at 01:46:02PM -0700, Jakub Kicinski wrote:
>>> Why is this not targeting net? The sooner we adjust the uAPI the better.
> 
> I considered it a new feature rather than a bug fix:
> 
> Userspace can't rely on the existing api because kernels before
> 6.16 don't special-case the names provided, and nftables doesn't
> make use of the 6.16 "accident" (the attempt to re-use the existing
> device name attribute for this).
> 
> The corresponding userspace changes (v4 uses the new attribute)
> haven't been merged yet.
> 
> But sure, getting rid of the "accident" faster makes sense,
> thanks for suggesting this.
> 
>> I think there were doubts that was possible at this stage.
>> But I agree, it is a bit late but better fix it there.
> 
> Alright, I'll send a new nf-next PR with this one dropped in a few hours
> and a separate nf.git PR with this patch included.

I agree that this latter option is preferable.

Thanks,

Paolo

