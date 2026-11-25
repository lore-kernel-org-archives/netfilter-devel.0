Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795604659;
	b=d/tz7H7vDmmDvWsUWlT+XmWwtx/NbWaaTSfS/EZEgZJ+CfFGhwmxbBEomTmB3KzBdXYz
	 10RzJdY3+fRQ7OSsyfmmrQ6uiq68cBXOhhJYlH/kQvPunEY+WkWphOJLCh85XvoOAsFCX
	 EvMKpFzaYuqaqnYeUAU5JMs6dRTerstIoH5/KwwHh0u1Fz6vE8+7ZXROKndntg7LojMuY
	 lyJKiMMtb+E4QlrFp4d8BaSY7pkB6BKMS8IQGGEFvdWDqYJubF0xQSepOCy1SKSuFqmIa
	 lrVeSLKijBfZWczfaMSPfotwi8Zyznb1gkBz/27GUN+VOFPKmi30QYWSo7AXkXAp/0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795604659;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=DHJfL/dD1ERFkBBS1lkopaaGwBwm10lzcCVKBIzqzWA=;
	b=CeeC/2C+f42Qh6PQCFlDtl9FIZjTx7rO0Yce115IHha6umkNUaW022A0XjiAiVL06VSD
	 aEQJ5Ex80QcQ8gj4EvimpUqF+SWCcqonuaAB2+qr6L+cC6IxkyO6PUnKnlx26v1wVIW3W
	 jWNpENXcnSE7dbq15u9fYaTSX2oRcIQtlAflz0Vhp2nM0MjbRzs9mo8qpE28lw7U31u/R
	 xJnbEqcRodTpD0yGefiVlWlmjJjXq/aBftQgFA8MNhSq7hoG/vZsYcUJc4r3XH8KhxHbv
	 qToYzmI2icRJdvV0skWqmwH4XWAgQKTqmpOqbtLlu3Zo/jlx1EWL6nut+Vk3ZwiUpqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yj9k4nhO;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB4C606A31E
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 11:04:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CB4C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yj9k4nhO
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b3fb193c03so2403857a91.2
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 03:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795604658; x=1796209458; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DHJfL/dD1ERFkBBS1lkopaaGwBwm10lzcCVKBIzqzWA=;
        b=yj9k4nhOKpW67OXuBsMDcZ+NX7Afud755eIMg0XJLKnGlWsJfQWhBB9kqRGHBOKLOm
         TZKsNH5pbs30cnsZ/jNOFo0T/fDeFwZ8AZhqyPlyOSnpLETe9i7S84hvDvFLylMaKNfa
         IEkQJZV9AW0uv8qom7ca2uFT0G1tXbaaXKVTpB5J5LxHTzr3laoCYmp/hYLjnB+tI2Jv
         9kHFMKt9kea544IV/KfRhIgW05sfY4HTRp8vbmHJn5/n1yPM2wMdAYORjDMSRGJI1Uvj
         6nRsXxWQr0lrHVFTIh9L3gQf1uJBNzn/074YPZHqCHtw9545Jmd3rKlMd0LXqkJrigTD
         1Tkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795604658; x=1796209458;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DHJfL/dD1ERFkBBS1lkopaaGwBwm10lzcCVKBIzqzWA=;
        b=U07u7Aceem3mFcXsgNlPOTnvcYWTF568X8SZ43wJifmUULRSp0qhVZgTaRPSU7OVp8
         cKo3f1etUQIcQYHGxf4VeneBWA/Nx3LZ5PBHpguUYgZhHz+V4HQHHw3jYU1Jrg+eVjnh
         PhudlUa6xhXF9zOhgn6MZUzhL3ABDTLmByQs4nD8eeLtZNoqm98kEInU0aZgwfd0ea8G
         5YpLHwNyGt2ECWxHz6yl8sQ27uG1LY0bIH5M+hjIMIFl7iUo1adXahPR4vgFrfhLFYeL
         9LkmK3F9+viBH2SFtZ/lUfXgdWpaMck6O0NxkN0HxksTfAufha9TRr3oE49yuV6vQw5C
         3a+Q==
X-Forwarded-Encrypted: i=1; AL+hErEwkVRBFYCrUGFwo1nEzfTkd4eAZwXhXbQ11JDBbZtV/f2/WwyEoXvZiGQxEgiupWcqZxePQ02tqPEzcA8Yzx0=@vger.kernel.org
X-Gm-Message-State: APuU4Z80Zhc1BPQ4YRj8HsKUUwuJWUObvG0hDPsf5TQYxpaKgL5+L7Fx
	CKj5xIOEmxGchY3Jm85Y3Nd42Ssk6DEyBauY/JD1XaHr9IBVV1k0zJ0m
X-Gm-Gg: AZFdTZeGfJrMDlhK1He1YDKiq2vpR+NInaNxMdt64ZBlPtub8G3cBiLXuEFo2Zwxd9Y
	j//PpRIs6MIZ8TexCQWaFlsausZ4J6gfe92srPkXdZYXQziw+MovoJhitAmYZfSX/5rHGt7DsuJ
	YMLSb1sSeyRDWyoLCggb/63fzqmhB7rmmQAMXknCBjVqIKbI2eFs4OnZ2ze4SMR+RGo/jIcNc3v
	HkKk1EpwiXF4RcNwouJjFcVYeSjuoYFVQypQ8ZfXbXU8Qgf/AutK4xTsTJfrBP0YWFO6Z6DHdXK
	XebhMMALYBriB1zwCJNZvM05XcLoT3e/XgBcGmZ2cyos6XOI0ppE/PRCXVjl3qkk7SqxA2u8ofK
	WuW0pOT+/spyHF5uL32guU66+ogjEZgoFAa7SZAzDuoPFdE6P+iPoRSySiUI6qEw/u6rakY4TcM
	Dwl9MZyZd9+h/DQRGsBJlLHteYM90Bo2qx6e5pUceU8y64l9LwGxZNgDQ3Ek81uXVyQG5gfeaW9
	0wTYqldsmvHQ02E9fkcZ1KyBofG3xOT2aH7lg6+stlH6PyoywvJE0Zm1179H/nRKjUSuAxXOURw
	biOShqmBkznUGCJh5n3iimtvMT/pvBnWpri9VamyvRypIGrcWMxRMZoVV611m+74wboMGBrunp8
	U0r4iHffTJILVzILWwX0OzTdDB9/O++FLnDcW
X-Received: by 2002:a17:90b:180b:b0:3b4:1336:4f53 with SMTP id 98e67ed59e1d1-3b41c7d5c11mr15131416a91.1.1795604657551;
        Wed, 25 Nov 2026 03:04:17 -0800 (PST)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b420e1307csm26291777a91.7.2026.11.25.03.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 03:04:17 -0800 (PST)
From: Qican Ma <goonsomeway@gmail.com>
To: pablo@netfilter.org
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v3] netfilter: flowtable: interlock NF_FLOW_TEARDOWN
 with NF_FLOW_PENDING
Date: Wed, 25 Nov 2026 19:04:12 +0800
Message-ID: <179560465233.45008.13158085455166110796@gmail.com>
In-Reply-To: <awakyVQMHrobvvAL@chamomile>
References: <179559147736.38007.14255585896242834600@gmail.com>
 <awakyVQMHrobvvAL@chamomile>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi Pablo,

Right - with 0abb54363974 providing the caller-side teardown check,
the work_alloc()-side check is redundant. I have sent v4 with that
hunk dropped, keeping only the GC-side half of the interlock, which
is the piece still missing in net-next: gc_step() reads
NF_FLOW_PENDING at entry before the teardown decision, so the work
item can still be queued and the flow RCU-freed underneath it.

Thanks,
Qican Ma
