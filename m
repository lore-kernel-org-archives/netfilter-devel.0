Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD2D316195
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Apr 2026 09:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775987095; cv=none; b=ujLdJUYzK8I1IHzsSid4f8URdkyj/OmTP4QYNIkKmFzygCdwRJgHUyfxt0eXv8qlDjAeMPt53pprJdH5IF7xL5Iq6mwFwJgCXrhfU2CISIAliTZXDpYnPHGaI88O4z9xgiRycEkexRjCrHc6Ys4x4C+qyqW6RGuXZP7rjtYjA/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775987095; c=relaxed/simple;
	bh=9dZnCngk6nv8OFaX8Wuqgh1Nukex4TyJRWzjHym+8Ig=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Date; b=lHtPqxyj20hZr2GhmGuG0gy26Np3MxFvRoeUDPeV7YZ4WzuEFjrXEHZnRSnf2JfkSkK5S2eXHNm3tBRYjrWtbKRFHZdkdxYHracL2q92TBqxY64Ykt31i0iJ2UNOi9gE5SioFBoh3lXQl6+9Y9Q9hF8Y5KCaC/IPx+jr3jXfnhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jas1Pq3i; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=clIGrZZC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jas1Pq3i";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="clIGrZZC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775987092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A4sKFCF5W66OqgBxtLW62iU6K10kMQHClgOf3NdlWqk=;
	b=Jas1Pq3iLM81/Yg/6oWSTr/93cAG4SbixfC/5EJhR5Y3FHLJZ9zNj8CO2cw+PTpWD4e+0g
	/qWjs2wrMP3L8xnG2jnEW/hL8rqs0g7vAXsz+V761Xgs6bvHVLzDpu7S/KyG3od/xbiV9G
	kbJ026Mk8RB0xFZC3HRVoboRzUi3AYw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-vGv-H-RpPX20iTj3PNCr1g-1; Sun, 12 Apr 2026 05:44:51 -0400
X-MC-Unique: vGv-H-RpPX20iTj3PNCr1g-1
X-Mimecast-MFC-AGG-ID: vGv-H-RpPX20iTj3PNCr1g_1775987090
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d1bfbd219so2494404f8f.0
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Apr 2026 02:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775987090; x=1776591890; darn=vger.kernel.org;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A4sKFCF5W66OqgBxtLW62iU6K10kMQHClgOf3NdlWqk=;
        b=clIGrZZCJqiT0rINZNgbSQfb8walz5XMWJRhL+Nspcq58O+dUJu9tL2/VTORmbrpxh
         eCntgqxGiBs7HDYn+ETEcQnRXcd1GaQizm53LydfAFaxpNVYZwYUhm4TLXOoS6+lT+nw
         eD3/JukGUGE65V+ccC1c11NtL0MXsUiKr+yTANCoGdz/9HYaJic28rH5uH/NEffsEIbW
         C55QGM4DT3iYQXDjv0a+5mTNkEr+xmmj1UxEedgrs2AcSpZIFpNblZOG5z/mlZLMwa22
         fAP78d9k3pY4u7A0aS+4VLVXmEgk3iHBJm9/qkxqF43Rwu5K7Fm8GbKORolb19/psANo
         ohhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775987090; x=1776591890;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A4sKFCF5W66OqgBxtLW62iU6K10kMQHClgOf3NdlWqk=;
        b=YSpT5vYRgfRy2yNet3oY3gHg9S7qARBvJb8Ms6SWrx/DgKFYZBGOwzKAuCbok3ay0J
         kuXh+E7CRygTzWYb40IjtP+UDKmi662aP+JJNNFhFSrXsX4ejwSTczBBALLuvnsFAVpf
         X/BkXrDDGtwdff0j6h+ffuEDGtgcHD+yl23vOWG+AZTb3uP3DDq5tAZrFrnh+FcDZHDk
         6/souHMJZHvnU+iqRywi51UoOM+9/gtzoR7fceptnbeUdQ3+XJpbzOWJw8186DNpuVk2
         rItgan3c7nCRGpQeOuV1GlQ9UbuHwYqcpkWZ6gBNSSb/lq8Sihbr8q8oYFXDHELy2CBO
         Dbow==
X-Gm-Message-State: AOJu0Yx1Z1nicX6rDbZ466b2dDRfykEYO5wWjfniCAJbBrSpk3UX55t5
	CpY1DkHJDen8RgRfJTVcMQevwlwllWCWf3MK52eYejlLEQkPizhg7sLEQPvm8CG2PcbfSC6YS4B
	PQiaBM9tnWnwYPhkUQYLIXEmkjkaD8Z8QXhfJiuWy7uSTRhhd2459XB4P7U+TJQxb4AkpxA==
X-Gm-Gg: AeBDieupbjnaSKLgOu3vBH5ZxZSfoFbKtx2V9AK3Ms90Mv8k7dFz/qO4e7hIvPRmI7J
	b7rKy9pm7qRTOcHryB1Xn0ght1xqqpB+GsW0dSJPm1rkHNXmvVkU/HasTckAhZ4QCSdq4i4sEY5
	p/gCRYbNlycOMrXiSuc4rb6f364z2JlZ2Ctnt6cwf0BdGNAENHD008YPHJVBRa8WiINVyPBvS30
	6ujonrUkZB9vE7+y1u4Zbb9dhSK4dZjx9ru4s0C8H8l8LbMpmq5wk9NUX0XREoZMjM5uAXN8zmF
	3lJ4Ll6eYalJb5Dh+bms3OU8JhocKHXz3SGmYYHbLq4G6flqxM8tceCa0Pu5BMuuzhIIOfDmPRh
	/iW9Uzhb68v3/i7lp876uZbQ1ubKQF9ghCPdDIIBHqywBWg/aHA==
X-Received: by 2002:a05:6000:605:b0:43d:73d4:b1d with SMTP id ffacd0b85a97d-43d73d41748mr1982974f8f.11.1775987090077;
        Sun, 12 Apr 2026 02:44:50 -0700 (PDT)
X-Received: by 2002:a05:6000:605:b0:43d:73d4:b1d with SMTP id ffacd0b85a97d-43d73d41748mr1982953f8f.11.1775987089585;
        Sun, 12 Apr 2026 02:44:49 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63de2e4csm25063084f8f.2.2026.04.12.02.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 02:44:49 -0700 (PDT)
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nft_set_pipapo_avx2: restore
 performance optimization
Message-ID: <20260412114447.7aa0f97c@elisabeth>
In-Reply-To: <ado7NVm_yFVwASx-@strlen.de>
References: <20260401110230.19226-1-fw@strlen.de>
	<20260411123015.4a78f491@elisabeth>
	<ado7NVm_yFVwASx-@strlen.de>
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
Date: Sun, 12 Apr 2026 11:44:48 +0200 (CEST)

On Sat, 11 Apr 2026 14:14:45 +0200
Florian Westphal <fw@strlen.de> wrote:

> I've sent a v2 that moves the LLM report ahead.
> I hope its a bit better this way.  Actual patch is not changed so I
> copied your RvB tag.

Yes, I think it's better, thanks!

-- 
Stefano

