Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com [209.85.210.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F4228504F
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2026 17:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646659; cv=none; b=dJLIA0cFeFDqQefB63OqWvy27Gc7GIo8YId+IaEM6R9s9qwgWJE6fjJMv2n0u1zAyw8N4y96PZKbGmefkZg3ja2FgJ3Drab/R94Y9B+VAH1mrmH3/wC6z9y1xHzHboLJfIqq2Q/K2seUrh6O/V8jNXjH7qzfrL7qDFk0fN0qPcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646659; c=relaxed/simple;
	bh=2Mvgz7k4MBiBihmZ6pwsyf3yLPFdtGpxts4opu+Urhc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qu9cNpfXyHZeQALUdd2+6ijOoiffkthW+zqZaPCROOgpiVinC996x+hQoPo98pMISrbSUYDjM5Ld9yXGXu4yB+iBQkc9eesup2MKUM9fhukFGMC/jmAoib9UxfpYvJsFCDjz9l4e3JmAWfclm3jShtddGrA9ohfFfHb2QA0Okfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=Jj5yJcfG; arc=none smtp.client-ip=209.85.210.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="Jj5yJcfG"
Received: by mail-ot1-f65.google.com with SMTP id 46e09a7af769-7d598f60eeaso5116437a34.2
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Mar 2026 09:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1772646657; x=1773251457; darn=vger.kernel.org;
        h=content-disposition:mime-version:reply-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WNMYYOJfjMKLq9zkyVGgSwjqMf4o4L892jbKOFVkLGk=;
        b=Jj5yJcfGd6YfE8j9dPMK0uQP/S4LJKknSdI+oP/6HEDa0drHxa17k+pc3fQ3lIFTLn
         2cJ4ph7OCRpTFrsu/QOvizcz64eqXkE05nUFv4ySFEtRAzyswxAm/HOXeWj8phapvH3k
         kjrp/gTgS/NoeHauR0D5QFcCuI7Qsv3zgUqIjsri6la4yMehPa31+TeHC6vV/OTXCird
         /V5hDW2Ee5KK4QEFm5hhNz3fOuWXwyigMd3RfmB2HrZn3vMrGPLvJWLg2UukZup4YMal
         6zqMtvews5Vz+R6WSZLTSIWk3Oi8Q/xHww/Dr4jULQtfmoDJnxvcSxdtqFzlnuzcVoI1
         srBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772646657; x=1773251457;
        h=content-disposition:mime-version:reply-to:message-id:subject:cc:to
         :from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WNMYYOJfjMKLq9zkyVGgSwjqMf4o4L892jbKOFVkLGk=;
        b=vvhaoSCFD2LTHzRHiKbF2TMOmx7DrWPgpVYdb2K2Vh9EBc7A0GCD9wSXn9NiritveQ
         Lmz4opV/KpsMy0s7p6H8SgLArg5n0s/wW3VGoJ7fT4/HdrMQQxXLiIa9gV9NhN+mFxbY
         gdXfd2LfjCdR2gWAePjLAohxMZAIRwStA1qfzgs2cz5K51dcmC2HnuvnNgqsQt9RnoNl
         iDRG6ab+jCCMlLyT1IIrTyDO08U3tU0xJNF7rgqkiS09X8wQzyt5y0Ok9mFhfciDpqLn
         CNASjVtA2uFJLXgqWGWhnKpYAtFDxlTn812x37WsOsOqq8xamSBzgW/YWI42HwM7QJXG
         fJHg==
X-Forwarded-Encrypted: i=1; AJvYcCU5kIp9RclBtDqd7PKwUHDzAYc6nRvBBuUQJ1odKhTkW0ggieLs1bsRKnC9fFADvM4sF0FYGkorqJw3kFWd3MQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4FawdnV8eIIOV4mmxsaKZj41er3pdfrH34ZFyTqe//3O5vgdi
	3YHxthqdRPCzfFOZzeeqMsCYAiG4CuP5eNz3F1WdteDD5MTINejbWalDK7bmV8GXnoc=
X-Gm-Gg: ATEYQzz+BIL4fr8S1DzzeOEvDFkWCm2PTN2bzP84s77ndJkHK2r2gpcvFORb2UnISLO
	iLVtQ8PP3lK6d54/EWINkN5w7Kgwsry0HDIpbK7xBuzT5muwV0WUCeVQ7DK7eD5b6Lqv19YEMKX
	qsyaXFS/3F45Oj1PGsmsH+5jN8ZPGzrrxViSZcLBzXswZhzTvyROI/LpLjyForYaDH88ch6XpUn
	fL1ADOUZy8Xha1+ztqrJHarFti/J+9AhlT+pXz0KnRpPAGGyaeSzozM5Z0CL8IZBfitXDVr8Z6+
	jT/eYmP8DGfvsixHEr+djRQvzhMTuUxzaZeqfDuGcA6NvMTjCXrVHj01H1LRyYjpN75jLBbvJ5a
	lDj6iFdFQHEXn8JxRy0jyJk6PZDyHr6c9/usE6LLDtIPlK2ftgJwe59u1cisDLV46fP/Foh51fY
	N8JIJJCg==
X-Received: by 2002:a05:6830:3901:b0:7cf:d1ed:f9ff with SMTP id 46e09a7af769-7d6d38f9810mr1782147a34.34.1772646657516;
        Wed, 04 Mar 2026 09:50:57 -0800 (PST)
Received: from 20HS2G4 ([2a09:bac1:76c0:540::281:54])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d586626abfsm15735411a34.14.2026.03.04.09.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 09:50:56 -0800 (PST)
Date: Wed, 4 Mar 2026 11:50:54 -0600
From: Chris Arges <carges@cloudflare.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lwn@lwn.net, jslaby@suse.cz, kernel-team@cloudflare.com,
	netfilter-devel@vger.kernel.org
Subject: [REGRESSION] 6.18.14 netfilter/nftables consumes way more memory
Message-ID: <aahw_h5DdmYZeeqw@20HS2G4>
Reply-To: 2026022652-lyricist-washtub-eeb4@gregkh
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

We've noticed significant slab unreclaimable memory increase after upgrading
from 6.18.12 to 6.18.15. Other memory values look fairly close, but in my
testing slab unreclaimable goes from 1.7 GB to 4.9 GB on machines.

Our use case is having nft rules like below, but adding them to 1000s of
network namespaces. This is essentially running `nft -f` for all these
namespaces every minute.

```
table inet service_1234567 {
}
delete table inet service_1234567
table inet service_1234567 {
	chain input {
		type filter hook prerouting priority filter; policy accept;
		ip saddr @account.ip_list drop
	}
	set account.ip_list {
		type ipv4_addr
		flags interval
		auto-merge
	}
}
add element inet service_1234567 account.ip_list { /* add 1000s of CIDRs here */ }
```

I suspect this is related to:
- 36ed9b6e3961 (upstream 7e43e0a1141deec651a60109dab3690854107298)
- netfilter: nft_set_rbtree: translate rbtree to array for binary search

I'm still digging into this, and plan on reverting commits and seeing if memory
usage goes back to nominal in production. I don't have a trivial
reproducer unfortunately.

Happy to run some additional tests, and I can easily apply patches on top of
linux-6.18.y to run in a test environment.

We are using userspace nftables 1.1.3, but had to apply the patch mentioned
in this thread: https://lore.kernel.org/all/e6b43861cda6953cc7f8c259e663b890e53d7785.camel@sapience.com/
In order to solve the other regression we encountered.

Thanks,
--chris
