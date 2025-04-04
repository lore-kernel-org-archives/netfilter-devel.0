Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AB851C5A
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Apr 2025 11:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743767497; cv=none; b=tSx1Q2mUR6Lb8T6i7PeMdoMKd/RLShAWpBe54jQQt0D2BO5aE1vzzDrVQcH2GjAsebebcO9a9JnLJzzFAJNFL1bYfn7UL0OCh1pDoGeRbTdLN/UyYLXJj7lG2uqzACtWg9vy9JPRT+fSctml+jjQTq9SralCcZ9Yseqo/Vm5AuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743767497; c=relaxed/simple;
	bh=eR02IPlSaqhqksQm/tQhZYZmL35cVR4kfvcrpd2Xags=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GsLco0raB/yfumJznwl9wJT3yb7ybEyjtWPJMrLJlh6KfmPDPnH40c4nQBM9Ri20KhPg6204WmorycpqR1kNfD/d12ZsiU92/Oquo9JlGuRms49ZXpk2w4z0vMc+bgScNJLtd9E3+zPMgaH3LUnHYq+VIHAdLZMBSSSIKnxscq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ClF0SJu+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ClF0SJu+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743767494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=voFlSo6cJJeDs5Pq2BzOsn/umAqMe4MGrm3bhP13d9M=;
	b=ClF0SJu+HgZ06ubqgjMguUV6N/4mOFZV/1iWHxd+5btTvsDZNQxLl4KTm4D/tcy8pZJsuj
	hpxelCS9gC1czHqptNoDHQSzhLZ79jWO8Th7/0HaaSevFz26w4gA1kp8VoBiArID5rWHJn
	Aqqg4oQZsIQ4yYVfMj6dNqUB1QK2e5M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-YNe0AI8mP1qv6b41-mwXPw-1; Fri, 04 Apr 2025 07:51:33 -0400
X-MC-Unique: YNe0AI8mP1qv6b41-mwXPw-1
X-Mimecast-MFC-AGG-ID: YNe0AI8mP1qv6b41-mwXPw_1743767493
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43d22c304adso14276855e9.0
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Apr 2025 04:51:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743767492; x=1744372292;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=voFlSo6cJJeDs5Pq2BzOsn/umAqMe4MGrm3bhP13d9M=;
        b=Wfsvdhg1k7v9LImXKVi7yG3Gqg46IM/BgkjsaBdXqdQL7gM2Vw01uwlf3XYzPcKs1h
         1hMLsV86ULAMVNfD3uX1eNhQ977jM4JAX5xIE7xFqLEH4cWornPe75D79OGjK0TaMPUY
         Q+vLD/SxSakjkBLHmm8+jqcCDcvtJTLWVX1EKMOxMDEhidzQ6qYwBEElmKtVA6o0bSMM
         9G4zYZVbWmcs5s+be3XIEo/QmY4d5lTXH2jW3hcCLWuZjzH80VbCluaFyPKCOgaDKaAb
         +CXw+YXxwc2wlTc+db/J23qm1kyKCkUS5iq11n3/VWQu//tPjt9lgHZgXmbd+U/oD3t8
         ODFg==
X-Gm-Message-State: AOJu0Yzkd/8SaoCC/RUVdRvVWbUdlNGshOorx8XMZQezWfjf3zP47VE6
	WgESU/TfpSGd+Zn82cFp6u7FAaP8d4QrzyEBh5G6e3mg+/dMZhgU6OnYEto9QO5SPTpDatMzXW5
	1h840rT6wLrD7HaDYlFYDbmM4HOLkhwraXRAOUB+IsoE3+thWFeHB+uF7Lv2afhQ2GzsUymC1Ag
	==
X-Gm-Gg: ASbGncuc0J3HYX9rVmaTAvD/SV+KFs++KHrBjh4CsLJkjWYBZFLsQ6Je7pQzi/oqCCp
	J0SIGkimu3tbwscwqEJdytSvnIHLopvFLvLV0IGympriQNTDfUkHD0vzzh8cfEy0/MhEme0hrIC
	x3kFMbpC4nb1ZSHFGk07eKXJ4pqySSCRSXzw4n3LHv6xS+DPZXFfLKhZuYjy9iHUTfyuRxP3mdg
	i44cziO0Cc7ZGZdOJLJYjT4AY2clRwDOINkHy/kzkZ7oXMp1Po7F4scYKzugVvF/hizYEsISiqH
	wplaKHHmG+9CJlbzaEMySjrK2nrh20OEPpEofDqHFv0g
X-Received: by 2002:a05:6000:2489:b0:39a:c6c4:f87b with SMTP id ffacd0b85a97d-39c2e5f4ff3mr6179744f8f.5.1743767491973;
        Fri, 04 Apr 2025 04:51:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKCdwwUfxPsUMMS3xX8U9/7ui5NE1VhZPZwHlc2sLtpEDmRwL4m+fr9YFtBwpcEBGrCBR8XA==
X-Received: by 2002:a05:6000:2489:b0:39a:c6c4:f87b with SMTP id ffacd0b85a97d-39c2e5f4ff3mr6179724f8f.5.1743767491593;
        Fri, 04 Apr 2025 04:51:31 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c30226f2bsm4193868f8f.96.2025.04.04.04.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 04:51:31 -0700 (PDT)
Date: Fri, 4 Apr 2025 13:51:29 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>, sontu21@gmail.com
Subject: Re: [PATCH nf 3/3] selftests: netfilter: add test case for recent
 mismatch bug
Message-ID: <20250404135129.3d0b5dc0@elisabeth>
In-Reply-To: <20250404062105.4285-4-fw@strlen.de>
References: <20250404062105.4285-1-fw@strlen.de>
	<20250404062105.4285-4-fw@strlen.de>
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

On Fri,  4 Apr 2025 08:20:54 +0200
Florian Westphal <fw@strlen.de> wrote:

> Without 'nft_set_pipapo: fix incorrect avx2 match of 5th field octet"
> this fails:
> 
> TEST: reported issues
>   Add two elements, flush, re-add       1s                              [ OK ]
>   net,mac with reload                   0s                              [ OK ]
>   net,port,proto                        3s                              [ OK ]
>   avx2 false match                      0s                              [FAIL]
> False match for fe80:dead:01fe:0a02:0b03:6007:8009:a001
> 
> Other tests do not detect the kernel bug as they only alter parts in
> the /64 netmask.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

