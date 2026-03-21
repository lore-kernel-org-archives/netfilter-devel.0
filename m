Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFB1192590
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 14:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774103118; cv=none; b=lxHFriW2MK6Y16PThEddhUc6A6gwmltUSg3MpzXkosfZB8SbnSWAMDabV+4ZqHvAzQeSjCMYhrqRdhh0gzQEdDowF39BMlGPt6i0o8z2IIL4CdCdCUGA7JUq5b94afds5CUcrXCJo5GjEHGXqHOZGzUfwbaO418CAV7Q3TZhZ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774103118; c=relaxed/simple;
	bh=pXnCg3Gs7fLXYZyuHZsNRZ2luhfhJevzWU5E6rzIrdo=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Date; b=Cs4hbt+QjVV8kttBaMEL8NwA7DOUP9rNa1aama6VHNKdRuFkNskgfWLGchss4k4p/P4jP+tsMRm0N33fb7ltwEXsY6DDRc0SHWsmP8MJXtJdFeVjJQFIGTQsuVBt53SRHDkhKB9tpkcyXkn/aoFX2wpep9SHGLlS/GxQ8O+780k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aA8jKx2n; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bPFQI1hr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aA8jKx2n";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bPFQI1hr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774103116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9pVQ8fa68B/1oKdaG13ba1kHGEaib7D9nxvZZPSOSxc=;
	b=aA8jKx2nkT60QaMeQYzw1jJXU7W6KMaix9u12UWhoOAmanGgBNH77rGNCyRftlTvHdrCAC
	PPCFMtdrQCOM5hrFDCMBGj3VAGL15MWVyudlkpQAc4a+skoL17TvNtGIB3EACc1zykOJ9Z
	vH6ZrWseDyqwpU05xeRT4tbNnOjK3MA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-UyL0NX9UO-6-b9MoczF2mg-1; Sat, 21 Mar 2026 10:25:14 -0400
X-MC-Unique: UyL0NX9UO-6-b9MoczF2mg-1
X-Mimecast-MFC-AGG-ID: UyL0NX9UO-6-b9MoczF2mg_1774103114
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48535f4d5e1so30725925e9.0
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 07:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774103113; x=1774707913; darn=vger.kernel.org;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9pVQ8fa68B/1oKdaG13ba1kHGEaib7D9nxvZZPSOSxc=;
        b=bPFQI1hrJ25aaizC42VlAEdG33rXUkanBu2ZXR9bNM2ZtLwNZcIibns+V5H/PEI6tq
         G1NaOf8YJRuYOie9/gTqu5VRwD+0q8v9MxEuV8oBbzlLF+NTTtyXiVpsxgXJMogGr+SI
         F4Dg/m7PzzeAceUg02YNlufZ1uplPLerMc2WLl6Wq2FxePGMXxGiBZZyioyDS/4R6TBR
         jUEPRfagmkz8/hdk9AOngfcNXE7Yfra7pwwC1HdqWRTvsjdxdIZ/CohmR/8BmvFalUxr
         QnOysNBNgGzj6NKJxkm0b8EkpTK7dYLAWCIZUDTBSHQn8I8sekaQSaIUx8wm0Ci997gQ
         PIaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774103113; x=1774707913;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9pVQ8fa68B/1oKdaG13ba1kHGEaib7D9nxvZZPSOSxc=;
        b=dKIrBn3iYKHwmHe+lIa4W9oE31Jf8Ufiagj3kHweibzs0L8cXt2CxwpLLdRa/fqFyb
         x9Z5zmwM4LLzGWqknvwDsBvYQwaLhXWJyoVQUQSimDem+04Wp8k4cDJim/FaGpjXiXT3
         NXw+7i8r102MnCax6M0LNBj8g8p5rptEKfFFlvZlEG0lW4Pi/y9xBIToRTd3sxsqmru9
         HW82UwHahjZUjQAgXuhiU8XZ4dON7cjBiiC1YYZi4gC06Vlx/4KiOWBUEmKgA6M+YIQP
         bj7jJcClbt+aUsop7hbXKC1DNacve+bOGpRXXDk9zZeRXE1DP/hvhh3DrbusxGLRLAyN
         PAfA==
X-Gm-Message-State: AOJu0YwvwIhlOql+0PJgGFLG81WEt8eFGQkorq0v/EkFXR8XRkCJIkcE
	MouwydZSj/3IaXCuDyaPbkcb9BH3ewvYpQrpWjv3ymKAhFIajTMYlBpCQg2CwvZJIngZvaNZiol
	r+Q6UOUl0yYMmcYSz9FEKFR2ViYRigCSD4/oO7Km37f3C7C9izHp59F71/+zAvlUfp5452QUw5O
	HbFg==
X-Gm-Gg: ATEYQzwhduD0Am6rMOMz+x8X37DfYabxFFx8wl1vLNJB72+a6Ck9cRw3D94GzdXTz3u
	Js8jFxuPqKAKV6SAYCGXVsRMfa+hW5OvDFEa+vtXEVt9muHccsLeB7W6zpKXc7Swt0NvGR3PLmV
	dkWxvckd/HJqtbwMPvJc1yZUUzD4rK82xXfVpYBECne0BRrDbEYftACJml93DRLAYPsOAWafyPz
	1pqZa28aUpQz1TAosETohJBf+aPemcP7yKrXnBkCjl3Vchm51vU3FYg58iJbATCYUmXjt0JULdk
	pz4qcH7RTeprOb28vzqPgWu/gdG/Lb57GGVCBabEgkEZPiQmxKwt9HSJdBhLvwskF4gsi1432lk
	UXWBAYvisUcLex6iUMUSpBf/hrPvIFhjqx/rlghZctskpWlvyKg==
X-Received: by 2002:a05:600c:2d95:b0:487:338:b4f3 with SMTP id 5b1f17b1804b1-4870338b5f9mr20233395e9.17.1774103113071;
        Sat, 21 Mar 2026 07:25:13 -0700 (PDT)
X-Received: by 2002:a05:600c:2d95:b0:487:338:b4f3 with SMTP id 5b1f17b1804b1-4870338b5f9mr20233255e9.17.1774103112633;
        Sat, 21 Mar 2026 07:25:12 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486fe032a55sm264444565e9.7.2026.03.21.07.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 07:25:12 -0700 (PDT)
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf 2/2] selftests: netfilter: nft_concat_range.sh: add
 check for flush+reload bug
Message-ID: <20260321152510.629043bd@elisabeth>
In-Reply-To: <20260318132417.31661-3-fw@strlen.de>
References: <20260318132417.31661-1-fw@strlen.de>
	<20260318132417.31661-3-fw@strlen.de>
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
Date: Sat, 21 Mar 2026 15:25:11 +0100 (CET)

On Wed, 18 Mar 2026 14:24:14 +0100
Florian Westphal <fw@strlen.de> wrote:

> This test will fail without
> the preceeding commit ("netfilter: nft_set_pipapo_avx2: fix match retart if found element is expired"):
> 
>   reject overlapping range on add       0s                              [ OK ]
>   reload with flush                 /dev/stdin:59:32-52: Error: Could not process rule: File exists
> add element inet filter test { 10.0.0.29 . 10.0.2.29 }
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

