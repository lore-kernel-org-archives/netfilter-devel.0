Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A841482ED
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2024 08:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732781896; cv=none; b=d/zxXr4bpZ3VxkD1k6kE8TZjoVOhdZJlPJGXMmnBG13t4ADH1FpiJlSABzuO5wzOVin+lDPdCNZi2tWCfJpt3rzX8z2904ILmbYF4yZF1uoGS/IkAcpg3XoETaMQXI9Iele5FZWuql58hyej2WFPLGQn3yI26ntPiKovvkAVc74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732781896; c=relaxed/simple;
	bh=yiCeSBGXf1KMxfhU21keDJvktNwDMa5XEoSlV3Nu0q8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f3Z1oYRwLRH2ghBduGPmyqnk/XxpYALXQRXnRlcniF8JDwQ91+Jwehk9rV0KskleR2IOxKRY5mOsVWBo3FeQK13rGo1nx6nMLZDugN2hi8fgNe48ev7pR2YnQ0Byex6RL4RM6UlDaS16unSClR6PgMfnr0V7t8FooZ5ym5VcKSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Re6N1lCB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Re6N1lCB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732781893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nk4a1vtkFew5DHjLcy2S4AhcY8OdDJOXsxrrwd1OkwQ=;
	b=Re6N1lCBzOrKgbXPSoaZFiWNSdXTeo2UBM3dDe7hovW9U2ufSmMOH7ii9NsOa+Tq8H5ZiX
	HSagb8+1eM/32LHQ6Ezmk9gWP5lU6Cz/aNUkkPqROEUK4qySSYwtDmlRUr2D1lvTluwm7n
	qUdAP9bVhE4bjKB9GFhyAnBqjX92XuQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-q47DWgzGNxifsnnb3_a4zw-1; Thu, 28 Nov 2024 03:18:11 -0500
X-MC-Unique: q47DWgzGNxifsnnb3_a4zw-1
X-Mimecast-MFC-AGG-ID: q47DWgzGNxifsnnb3_a4zw
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-382440c1f83so862476f8f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Nov 2024 00:18:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732781890; x=1733386690;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nk4a1vtkFew5DHjLcy2S4AhcY8OdDJOXsxrrwd1OkwQ=;
        b=JVcUU1jjuf7joTJGCnJaEKfBgZBn8xLAAZlBDPbRE8qQ/BsSCJRrThhoSiUEXrrQ8R
         xp/POnZBre6G4jpGw8uGhE6BTfhXhizVjAGFpc9T4zaC8h5jWCG3rozsa6QDZu/risxk
         0taHDBFcyaYN3PBeloduOcnARO6TH6KK2sOlMdLm4hG9bWZYev8bt6j4x+jbDKbXrDBj
         I7iE/eoCa6Qz4YQ4L2pI/qpOd8CRpBC8g/qrnPsS3KWzid0ZX446vsVDnNk4jUJhflOI
         sVJM2rjtF4pEr1QXBRoSsq8YHCg1nRzji3PSvOfcxEbINEy9NKmawvC5nX0+AhETCd5P
         xr4A==
X-Forwarded-Encrypted: i=1; AJvYcCW2kZdZ1m7i4bq905VEDTzAnMnaoJsCDSSZBnp8BAvoo0BXRzXA2LLJeLw+Es/zkIJOrxdhqFfDIZc1Iv1WSGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2QWRYt77QmdwhYFCvoVtSSRN65pGtEfOiRW+QBtTipcozmTKF
	Eh/V34L0x8WsCwQyP1gE4GDy03PbFjeZipnm10R9ycRwl5H9Fjy6f10DXHPKMBHlcyQzgRP11Nu
	bm2/jKAz48uUjD/uqGDd9+fMYZyG74ln6eAsemWg0oQaYGdb/aF6Jrj5auK5R57xt8w==
X-Gm-Gg: ASbGncv/9bXR4krnSHWOssNXwk7rP1p4nmpe4wkncPQlXyUb4xAZPRfADjj5XsXnE9d
	USnCHkQEtSNHEKlfxt2xAskpbIoLggqXmvAzgdha0F/L++8uuAG0ssS32a2mY7mowfNx2JvU6rU
	9lsm+ewNdX/HjzeiC12Bwwdbxt8vlDVtkR8wcQlYfocX7XFjrFGaL4Jn4zZTdtxZs72dSt3yhFF
	DuqXlXS4ytAwKt1zY34QOQUxE4nP8wzFXz+ZJI595NcqE1XJHH0aeNdnN6LutDQJEkJ1WZN4Efw
X-Received: by 2002:a5d:5988:0:b0:37d:46ad:127f with SMTP id ffacd0b85a97d-385cbda2969mr1891958f8f.26.1732781890472;
        Thu, 28 Nov 2024 00:18:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHiB+KlnNgeGF4jukNPYnw3UquzlV4c1ZjkZ443v33BuNe7GO30hwqhse5NtZ7b/vbBCoAnKw==
X-Received: by 2002:a5d:5988:0:b0:37d:46ad:127f with SMTP id ffacd0b85a97d-385cbda2969mr1891928f8f.26.1732781890115;
        Thu, 28 Nov 2024 00:18:10 -0800 (PST)
Received: from [192.168.88.24] (146-241-60-32.dyn.eolo.it. [146.241.60.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385ccd36557sm980405f8f.24.2024.11.28.00.18.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Nov 2024 00:18:09 -0800 (PST)
Message-ID: <70cd1035-07d8-4356-a53e-020d93c2515e@redhat.com>
Date: Thu, 28 Nov 2024 09:18:07 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 net] ipvs: fix UB due to uninitialized stack access in
 ip_vs_protocol_init()
To: Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
 Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 "David S. Miller" <davem@davemloft.net>, kernel test robot <lkp@intel.com>,
 Ruowen Qin <ruqin@redhat.com>, Jinghao Jia <jinghao7@illinois.edu>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Kees Cook <kees@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>
References: <20241123094256.28887-1-jinghao7@illinois.edu>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20241123094256.28887-1-jinghao7@illinois.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/23/24 10:42, Jinghao Jia wrote:
> Under certain kernel configurations when building with Clang/LLVM, the
> compiler does not generate a return or jump as the terminator
> instruction for ip_vs_protocol_init(), triggering the following objtool
> warning during build time:
> 
>   vmlinux.o: warning: objtool: ip_vs_protocol_init() falls through to next function __initstub__kmod_ip_vs_rr__935_123_ip_vs_rr_init6()
> 
> At runtime, this either causes an oops when trying to load the ipvs
> module or a boot-time panic if ipvs is built-in. This same issue has
> been reported by the Intel kernel test robot previously.
> 
> Digging deeper into both LLVM and the kernel code reveals this to be a
> undefined behavior problem. ip_vs_protocol_init() uses a on-stack buffer
> of 64 chars to store the registered protocol names and leaves it
> uninitialized after definition. The function calls strnlen() when
> concatenating protocol names into the buffer. With CONFIG_FORTIFY_SOURCE
> strnlen() performs an extra step to check whether the last byte of the
> input char buffer is a null character (commit 3009f891bb9f ("fortify:
> Allow strlen() and strnlen() to pass compile-time known lengths")).
> This, together with possibly other configurations, cause the following
> IR to be generated:
> 
>   define hidden i32 @ip_vs_protocol_init() local_unnamed_addr #5 section ".init.text" align 16 !kcfi_type !29 {
>     %1 = alloca [64 x i8], align 16
>     ...
> 
>   14:                                               ; preds = %11
>     %15 = getelementptr inbounds i8, ptr %1, i64 63
>     %16 = load i8, ptr %15, align 1
>     %17 = tail call i1 @llvm.is.constant.i8(i8 %16)
>     %18 = icmp eq i8 %16, 0
>     %19 = select i1 %17, i1 %18, i1 false
>     br i1 %19, label %20, label %23
> 
>   20:                                               ; preds = %14
>     %21 = call i64 @strlen(ptr noundef nonnull dereferenceable(1) %1) #23
>     ...
> 
>   23:                                               ; preds = %14, %11, %20
>     %24 = call i64 @strnlen(ptr noundef nonnull dereferenceable(1) %1, i64 noundef 64) #24
>     ...
>   }
> 
> The above code calculates the address of the last char in the buffer
> (value %15) and then loads from it (value %16). Because the buffer is
> never initialized, the LLVM GVN pass marks value %16 as undefined:
> 
>   %13 = getelementptr inbounds i8, ptr %1, i64 63
>   br i1 undef, label %14, label %17
> 
> This gives later passes (SCCP, in particular) more DCE opportunities by
> propagating the undef value further, and eventually removes everything
> after the load on the uninitialized stack location:
> 
>   define hidden i32 @ip_vs_protocol_init() local_unnamed_addr #0 section ".init.text" align 16 !kcfi_type !11 {
>     %1 = alloca [64 x i8], align 16
>     ...
> 
>   12:                                               ; preds = %11
>     %13 = getelementptr inbounds i8, ptr %1, i64 63
>     unreachable
>   }
> 
> In this way, the generated native code will just fall through to the
> next function, as LLVM does not generate any code for the unreachable IR
> instruction and leaves the function without a terminator.
> 
> Zero the on-stack buffer to avoid this possible UB.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202402100205.PWXIz1ZK-lkp@intel.com/
> Co-developed-by: Ruowen Qin <ruqin@redhat.com>
> Signed-off-by: Ruowen Qin <ruqin@redhat.com>
> Signed-off-by: Jinghao Jia <jinghao7@illinois.edu>

@Pablo, @Simon, @Julian: recent ipvs patches landed either on the
net(-next) trees or the netfiler trees according to a random (?) pattern.

What is your preference here? Should such patches go via netfilter or
net? Or something else. FTR, I *think* netfilter should be the
preferable target, but I'm open to other options.

Thanks,

Paolo

