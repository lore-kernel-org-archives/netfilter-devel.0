Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DE01DF247
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Apr 2025 10:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744193588; cv=none; b=bOAaggxiWOwRQyUaGx5eHUcpUXQU8PjmFij3Gkqt3zNGeDw/jGyM6maD8OHdreRtHisrH9AmDIVY0Xgy0uQpuqT36mcnV2Qr+5CEAqJJ5V1Q1lLLxGjWUCvSBLzNB+gh3l/GGjavcgHf6BPoR+Sbc898ap+rfyKSlk9cGqmkXjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744193588; c=relaxed/simple;
	bh=ZGP3wlKf5c9P0JARy0T9r7+mgMmyXY2RhFjqBqQQxDc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o/tl3Oj85uHyNxG9+7z0Ukg+x50GlNafjbqZL+nNICJsjNFcONumN7ATjR6nzvAo5NpVp6D9v+fMQ7B3Vf2JASqKJg1/jWUgm58qN2+xLLgvTPc0ZJMavwQ1JrDYn8I7T76NsQe+sXV+wEFDyq8fOXKLOH5xaLcxUDwkL4Jeg08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q75Y5NCx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q75Y5NCx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744193585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GQCS3d4+O7pMphs0KHT9XUtDYDU8flfHyIhEGMSv88c=;
	b=Q75Y5NCxYAMhLZ+uCkz+k2Kz0XSSViVbrv/ch5mHmCcQC81/R1J3VgjaZ3fGnuZRI/wPVb
	FKQwcNwallwT5dvcKOGLfnX6mgLJmglSKNcnqZ82gKwBPcQL4v9jkhkzjJQHZdmQmnb6N1
	qk7YThk4FKAPld1eiSrPh6cooo3MWeI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-7e4Z5s7dMvuQverWYGJn7w-1; Wed, 09 Apr 2025 06:13:03 -0400
X-MC-Unique: 7e4Z5s7dMvuQverWYGJn7w-1
X-Mimecast-MFC-AGG-ID: 7e4Z5s7dMvuQverWYGJn7w_1744193582
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43f251dc364so2155485e9.2
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2025 03:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744193582; x=1744798382;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GQCS3d4+O7pMphs0KHT9XUtDYDU8flfHyIhEGMSv88c=;
        b=MMgQYzdJboU799qYA7Wwx35kXm+p3aoyuUjyhzgNnEjaJL0skvVhrsWGqerNDqgYrn
         aj0SjYedatI087z55YCEwcEiehQmU6X7C+t5WmlSRyuVfiq1WYMLl6o5CcMJDu30PEkV
         Z8p0fcezpHaYFAgP+hnKIprJLpqgsdoreKlQLo+tt0vyO58P6KNdp59uGXYuNxs6aztS
         pNxplg93/Vm/JiijaV7eIxVy6t1GfOghQJ/vjIUpp7Wf5Uy3K5jSi5AsXGOXcrEMlWVK
         chXFU77lEjbY2qepgwDBuxxak6v03lexIPdTFYE4X32bXyvvydKVq7Dt6C4gJcZ4cM3B
         xPeQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0ipgSrZ68xWQ/YLJw4bctD+c+gEMXUDy+hEoy5jGowo3xRjpEUu0ZDBLtykx9dF3RtqP0C3NmUWr4TncDFDw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIX8CFVAyeSJ3tb2zHh8WBB/cNX/cOwtXSXbAxi+2FSuFgcwwX
	xRoQ30XmtXmfuw5Rigmpc9qVxW9aeT8HYoLeSTPjHFHaXKeTwjQKknPQEg5ov9lZlILCKLCW8ME
	g9JI+0zOK7SJl2Pybn/MplImScAqb7pHGefyhwD6v63wjwv09slSgAtMMR7BRkdwbvg==
X-Gm-Gg: ASbGnctmExFr8oDbxK1lM/N0BzKuOcLhD/5zYfxDV05Xk72qElPHb0JFpkqBe2NiEfJ
	9JNAqxi4tWbtSlgqwUo3bwX3fE60l3n19ox2MlcIbFFuuaakKGY4Jgprtpz5VJK8z+d9sUXoMaQ
	meBawgo7DQG1t73eqxLG2rxraFd4Mle8L8t8lei8NF3IZmqY3k2vOrXa4FWx4GOozmGoLGRhkcN
	qUFBfOpSILeAsskbh17b3eFc83HvEn7EnuSuPMbr80LQrUiqhhVZMwnnUD231yuy/EC4tZnPlwm
	7MvnRvYg8j5JxnTaYWLhGqI=
X-Received: by 2002:a05:600c:5704:b0:43d:fa59:bced with SMTP id 5b1f17b1804b1-43f1fdc21bcmr12324955e9.32.1744193582502;
        Wed, 09 Apr 2025 03:13:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNrj6T8JxHdinKfVzgVPBET2JKYQTD6tkWY5xb68i8JM1okwjrr2Kv/Wwk/1Qu1dwhCM0iOg==
X-Received: by 2002:a05:600c:5704:b0:43d:fa59:bced with SMTP id 5b1f17b1804b1-43f1fdc21bcmr12324825e9.32.1744193582155;
        Wed, 09 Apr 2025 03:13:02 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f207cb88asm14736745e9.37.2025.04.09.03.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 03:13:01 -0700 (PDT)
Date: Wed, 9 Apr 2025 12:13:00 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: sontu mazumdar <sontu21@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 3/3] selftests: netfilter: add test case for recent
 mismatch bug
Message-ID: <20250409121300.6032c69a@elisabeth>
In-Reply-To: <CANgxkqxfxzJdE2h1R=boQkAFQB=35EFYQ5fQ734nvaciSyJpow@mail.gmail.com>
References: <20250404062105.4285-1-fw@strlen.de>
	<20250404062105.4285-4-fw@strlen.de>
	<20250404135129.3d0b5dc0@elisabeth>
	<CANgxkqxfxzJdE2h1R=boQkAFQB=35EFYQ5fQ734nvaciSyJpow@mail.gmail.com>
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

On Wed, 9 Apr 2025 15:21:33 +0530
sontu mazumdar <sontu21@gmail.com> wrote:

> Florian, do we have the same test for every bit in the ipv6 address
> both matching/unmatching ? If not, would it be possible to add this to
> confirm that we are matching all the bits in the ipv6 address.

The equivalent testing, in more detail than that, is implemented by the
patch (under review) at:

  https://lore.kernel.org/all/20250407174048.21272-4-fw@strlen.de/

You can add more tests on top on the new one in nft_concat_range.sh,
but it's not doable to test every single bit, because there are 2 ^ 128
possible IPv6 addresses. I guess you could add a test looping on bytes
or groups of 16 bits.

> Also, a general question, where is this netfilter code maintained ? I
> found this github where the code is present "GitHub - torvalds/linux:
> Linux kernel source tree" but couldn't see this fix in Pull request.

netfilter doesn't use GitHub. See:

  https://www.netfilter.org/projects/nftables/index.html#git

-- 
Stefano

