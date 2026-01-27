Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019262E0923
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 09:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769506854; cv=none; b=WQho32QquPonFafJgRlyYi1HimnmX755eS+5YiJXmec99baIfwL1PN3d7sbbJ5LL0easY19LCSptcTLi/yJBWmo8IDsAifqo2YZIPCZFSgfhxL996zPS9QqviAE0UzJYdSrIY2HjoqvCN3Ml+ucq8APHMe9JGCfqHLYUD6clPzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769506854; c=relaxed/simple;
	bh=TaCylpJ3oBWXtsgydAsq+xnzjouw/VNwJPzJMQjLhvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NY4Musmpa6gYZMFPI0z7enmHx+vU7ORKsVAGTutmTwlRm92oOBzBmeW2QB9lHYaLuEkIR7WMYkV8ISXKObJ61YxH934al/YBVsOMFV8OpIorQJpoopnalqLgCnNDBO4UJ7PvBaKGK1QmVDEO7XaBRTQbEQxIGlWc9Ylp36xJpgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d83ufEOl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FrqF3LPp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d83ufEOl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FrqF3LPp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769506851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaCylpJ3oBWXtsgydAsq+xnzjouw/VNwJPzJMQjLhvw=;
	b=d83ufEOls8NDWWJaHw0faKzlydx1GWPUluKdMMMFOaD9gjth2QrhRz/H1jom803eLKn6Z1
	1sIXdAHGrYD2epKQwfkIV4tWu4AhiauWvuwdpzEzjdzjHAXzALrRsbqCUtD5IHDDOXq6mP
	gFobLY5budxpo7o5+9tHot5NSgqYM9c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-NTON09RWPx-DSRynT4qK4Q-1; Tue, 27 Jan 2026 04:40:50 -0500
X-MC-Unique: NTON09RWPx-DSRynT4qK4Q-1
X-Mimecast-MFC-AGG-ID: NTON09RWPx-DSRynT4qK4Q_1769506849
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48066dbd873so4207095e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 01:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769506848; x=1770111648; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TaCylpJ3oBWXtsgydAsq+xnzjouw/VNwJPzJMQjLhvw=;
        b=FrqF3LPpcdy1gCE3UdRyAbioJMVggmdXCSTWmSbOUMFya2p1MRHsCTGKPMaFGGG9DW
         VkNy90BaXKKLYQGfwVTF+lHad4Zzt2bRwOGKYYFZjdFzJyLY5VAtoa3yv9p6ftHlL9Z4
         VIqOJ7c/LyJ1xXgdVVg4DppxVdujph2evebKJTugm0n3hlGHKUaNxJst48EKTWoG1HYq
         l9aN93bszOtE2ujw7J6D44xR7iQ8D3yUFGisLLKhJc3aQZVcs/R5Awnx/QeXIfLRlg/a
         7LD4x4eWGdC1TffcwE4nJnAy5MepX0bxEEOlh46LIVpl9gQtEVbpCtjAv103Gy4rm8nc
         WvLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769506848; x=1770111648;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TaCylpJ3oBWXtsgydAsq+xnzjouw/VNwJPzJMQjLhvw=;
        b=lDlrtLaXaLT9Udxsa4wmFqHoLz7dpI9jRxQsd7qf/g0lMU0r37HCv96VqJwy4E3/Os
         iDx2Dov7PoQBPl95OYOVnd+pZbgCpC+65OpQrIrHDz/BNiVbZzT71n2uOP2+5rturjA6
         hXKmr8oqc+gwkBXNzVpHQVfhNN1z5OfVZ+xeXiGNZA4MpS+XRS6ODl2RVmgx2CfD1aTO
         kpU5yWYNnE4rimlFBbgh2FjvVUc0QmX04dRGEH7edo5OTgsSSWQewieRYw1iJeUCo8nb
         Y48eugyaNlLlZpA7h6S+Rkw7GRr2PRTdBad+L4ah6+pOx0C3vyHRssSvAFz1Yts4fm7T
         IY7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWAjxYSK6cmxgSIDQM/XN/rreDv17q6u4Hd+epWJwi7R52Tf+PPH/Tjf4vUZMqcT8284zku4Y1sbJo4L10rGqg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr4e9LlQi9e6JOJ0j+SeKqgBryreNUqmtcqBeYbljr22LNF0JZ
	jsb0KdB6YA5cOW//ibgjZg993UOoALqNdjmZeNe8dtVCd6O7PwF27WT0jZHXUsAZyACftlaw/kt
	aWrNKDu6M0mUAhR7htHfNTiybSGgb6SLBj8sDRsPaozVT9CpXrRTbDHomlM5FrdxSl92rj/C70o
	ixAw==
X-Gm-Gg: AZuq6aLVlEI6M45tAcksxZzfB4q1BnJZf7PCHbzNfpn4WX4fiDsP9fIGrOaJhLP3hI0
	lH95AoSZxocWbtxG8WeqskCxfkHnFUFcijjuWzh2yV7acvs3ekhuQ2nRv2JJIAemY62YaU8N0F9
	9XzkeWn63+mLYm+++F7jNjouFkD4SvY+6kzlsMggHK2mwRiWYe1rjSYlgVPhrM2Yjit2Fbb4p1S
	jSORnPKkXJWIVR/m5aJImZUlKMS701SU1sT33d0F0P0e76+OZhHUqnncRMX8GgthYKVJD96dv7M
	W/GPyjEPkm0ya3kLK610sfJydXO6dZMTzr9wvIDM5Qiy2eyx2uzVx2NLXaqhuXNQG2vgt6I9HEr
	xVuhn1Qsp1bIs
X-Received: by 2002:a05:600c:450b:b0:471:114e:5894 with SMTP id 5b1f17b1804b1-48069c9620emr13219495e9.25.1769506848571;
        Tue, 27 Jan 2026 01:40:48 -0800 (PST)
X-Received: by 2002:a05:600c:450b:b0:471:114e:5894 with SMTP id 5b1f17b1804b1-48069c9620emr13219155e9.25.1769506848117;
        Tue, 27 Jan 2026 01:40:48 -0800 (PST)
Received: from [192.168.88.32] ([212.105.155.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804d3ae17esm130747395e9.0.2026.01.27.01.40.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jan 2026 01:40:47 -0800 (PST)
Message-ID: <bbe37fa4-aa44-4200-bd97-075772498485@redhat.com>
Date: Tue, 27 Jan 2026 10:40:46 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/6] doc/netlink: nftables: Add getcompat operation
To: "Remy D. Farley" <one-d-wide@protonmail.com>,
 Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
 netdev@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
References: <20260121184621.198537-1-one-d-wide@protonmail.com>
 <20260121184621.198537-6-one-d-wide@protonmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260121184621.198537-6-one-d-wide@protonmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/21/26 7:47 PM, Remy D. Farley wrote:
> Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>

Some (even minimal) description is needed in every change.

Thanks,

Paolo

