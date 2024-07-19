Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B288288F
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2024 13:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721397302; cv=none; b=tg2m+dl3XxEsaCmKHsKBcMTTj/P8dAN1HuapEfbbCmvXNW0pxoQQcr0VtyyHFCfwmbf9SIEZAc7JOtjs8/RGex6Vh34Z51+uwCO/sAqNeZdRskDvPRg1eR1mAIFMQcKPUnE6Wsqf9K8FbnJNda/nO5/4i9GbiarW01lVR/FQEIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721397302; c=relaxed/simple;
	bh=dQd70NzIUrUi7u0+kH12tI1IRcYbpFmnGej/zSdmF7M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rSNRdh3xIAJXG/UL70sqtEdZ6haVIn9rvife12KrnS2rwc3gHGEOeKryHbSk+XLzDBBohpigytJPisOhRTi3JM2tU9DJ0UySneCSBIdP5cieB/lnxz4TqBPqDQSvxPlhPDcAwKBrEZ11sWiX3TWQTQHShtz5P3JB8OSOwwb+ulk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aklc2OCo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aklc2OCo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721397300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8GDVb/Bq9S0UZyBvXx6VysQ0/m9CQOKc/kx5yuaVuYg=;
	b=aklc2OCoDC44shLsBSj4E5ShCrs6HlcDxpcx8tB2264ps761gCBTwaj4sEia+8WT2urX9W
	D8UTrs9M+bBL23jdLLTAFwj7ZGo2fMZCICkP3IPKgwp794QeBqsbYcmJdL/SwFhBzTHBSR
	iTfMySn9ZSu60amuby2NCT9CxFxiH20=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-UBYaqhy6PuuO05C8NTgnJg-1; Fri, 19 Jul 2024 09:54:58 -0400
X-MC-Unique: UBYaqhy6PuuO05C8NTgnJg-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-44f104e3ebcso17957121cf.0
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2024 06:54:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721397298; x=1722002098;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8GDVb/Bq9S0UZyBvXx6VysQ0/m9CQOKc/kx5yuaVuYg=;
        b=S5pqTN00hfxtSgoeeYYU5x3HQLTpGzhA1lOKudiMdGF4RmTnKJdECsfgNqZ6ajcj5c
         GQTaJY5vZfL8RzL/3QMGcIye34W1MIxbbHgvjEXPQBcs/Edi47fMyhIHsMdu/0JH6f4U
         X7ZMAiQvLCBiw5GibHorWaqbNINdohsaslDrufQ+NRb/zm2uH3Mq04iwXSwUIG6tfR0Q
         ngN1kHmykJwdYyQ4+MNDm25MUBclAS9W2wJm38L8Pk9TGv1m0G/b/T9wZ68W8iUB72eB
         00NrczC+WrTS7GfV6FEQB0OMI0F+62oiKGDyAH91AaMXNyzJm+AhnvcbwUpx5mcoEeTi
         Ge2w==
X-Gm-Message-State: AOJu0YwuNVtuEIzjEQb8MCgxKfN1TQO6QrvGFiUa380aztpw0Aa5Mr8f
	6o+Nx8WASQT9CWaLh5MvyLZEv2FRjdMQPjLWKgugnCcYZcx4sSJT05JuP7fuEM5GiR0DkNMCmoY
	GeyJaqnjAhQ5CuH67HohZrZBOFN9CHcojeE4foi+hMQhvjifALvf6OS9pBhWjD9HdLDRLlpwKmO
	wz
X-Received: by 2002:a05:622a:5ca:b0:447:e8f5:b2d0 with SMTP id d75a77b69052e-44f969715b2mr52752201cf.10.1721397297832;
        Fri, 19 Jul 2024 06:54:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmKYJu+joDq68Y4I4zn8s+E8A6Jnz0JNa9qC3YoaWP4uTuLlTkLj5qI7CXNWvSq/35aectQQ==
X-Received: by 2002:a05:622a:5ca:b0:447:e8f5:b2d0 with SMTP id d75a77b69052e-44f969715b2mr52752021cf.10.1721397297476;
        Fri, 19 Jul 2024 06:54:57 -0700 (PDT)
Received: from maya.cloud.tilaa.com (maya.cloud.tilaa.com. [164.138.29.33])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-44f9cd2824fsm7438721cf.41.2024.07.19.06.54.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2024 06:54:56 -0700 (PDT)
Date: Fri, 19 Jul 2024 15:53:56 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo_avx2: disable
 softinterrupts
Message-ID: <20240719155356.17ca5d1f@elisabeth>
In-Reply-To: <20240719111930.3050-1-fw@strlen.de>
References: <20240719111930.3050-1-fw@strlen.de>
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

On Fri, 19 Jul 2024 13:19:26 +0200
Florian Westphal <fw@strlen.de> wrote:

> We need to disable softinterrupts, else we get following problem:
> 
> 1. pipapo_avx2 called from process context; fpu usable
> 2. preempt_disable() called, pcpu scratchmap in use
> 3. softirq handles rx or tx, we re-enter pipapo_avx2
> 4. fpu busy, fallback to generic non-avx version
> 5. fallback reuses scratch map and index, which are in use
>    by the preempted process

Oops.

> Handle this same way as generic version by first disabling
> softinterrupts while the scratchmap is in use.
> 
> Fixes: f0b3d338064e ("netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() check, fallback to non-AVX2 version")
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

