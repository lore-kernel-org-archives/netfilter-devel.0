Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1256443ABB
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 10:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319443; cv=none; b=ER479jOCbAlOoipsEmQc/fIBVLXv915LrZoVYXn8rUMv+nv9AB2yDbYh3ExXMCOvq8Yg29ho3aLNal0scSFCBcSwANPVWWqt4agHQ1MUazlxvZVPZnwM7DAWdUyTBiHd5vPfgJylLrb+LS9m8XOmShY1fSqPA7wL2WR0l5cuYr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319443; c=relaxed/simple;
	bh=T5t2nxKcew1jUfrEKoo2t/h6sldUALGrayJCjjMpl5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMsSiF4anZ2jzNLIH0QgPJbSLzPVsbNUuhiu3RUTFZRedcFd97PamhmB+SxjbvjaDL0d5GBJTGwUofmSq9NTzgTAnL4uX9Jq60JjPBTT26XDp/GYf7QgGkd8JKIs/91JWtMiQyUCMJaO/bAfR88vD7kXa+bZEHshl6EUMbdVoRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cgxQgCzu; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cgxQgCzu"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso730912a91.3
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 03:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785319442; x=1785924242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T5t2nxKcew1jUfrEKoo2t/h6sldUALGrayJCjjMpl5w=;
        b=cgxQgCzu3bbMf9gW7jjCjIEn+LTgB1/NjnYfCxYlTUlYmDpMJMGTxTlm3Ic+6WhEY7
         pFCcxwZf49xOY/767GH4adX9NuNAMb8vO0giR7GSXJj1xrrql9wPAYBqZVWRtWt7mffU
         kzvTzx3yzemjC2bzdRD9FITjebXFDLGIhU3reLLXqIBpWOvT5HAkoZTAAeRHNtQ1BIiB
         l6goF3SV1f+u2pQwgSW6o1jHaWhey/RrWGBVQF8BYOTqZvQhNiOvuxHKIoYxxexfQnkU
         v+Il3VRI2bdqjnmB8BeJtrlLFtfgaVWnHwDJ0NzX/M/9X1z7jhWz7RsyhO1z/xklNiLt
         6mnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785319442; x=1785924242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T5t2nxKcew1jUfrEKoo2t/h6sldUALGrayJCjjMpl5w=;
        b=F2H3wkpnlKd5V9v3bqIJ76UmVBryAAR+w3jCRzSIbUv9aQB5xAuoMhohN9+MB73eWH
         ZSu6ug6tjXA1wga2U2kDtdCEgHVBikax5rFkA8IE6hNbJpa6nXwqIuWSd7gcIScnzfWP
         nfpeiR3wjpy2klekDkbyHXKi07DrRjSuEQFBbgD3dufSzl/9WNHKzKuaaI0xUzeJckTo
         sU3owzvOZDmgx86dcEKznG1v4M6bcovKPDsSEVjNOthxHvRTUj6Fmm9aOLkQdJG+ta7e
         wFk9JS1BUFfyhTMRG908iz3MQVOQNkHE31ddolAIXZRQ1YXLjGAhh58eVXNDzE+eInc5
         x6xQ==
X-Forwarded-Encrypted: i=1; AHgh+RoZm/Q6KP36aki4wcYGN7ttSYnNfBsL0R42Gl924aSOtyj5cg4lMcIMSZqImrLe5qfUyRIIEQuaLwV4KfEExsU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPxFEi5z+WmzvBQvgX4DEzBYQTh+P6EaDRtg7ou0BC1LVOLJqv
	cFxdtPqDH0VgtiJ4C95cH4AyWS1H2EL1FDyizyWqJYnlXLfzwUov8lfj
X-Gm-Gg: AR+sD123+JmfMLOsv+mGExdSjmTV1wfKjxMBhAFtr7i5YR5r3z/6emnTJ/uS4vG6/vm
	8ghj+KaL9g8rUQH58JB/zhLA6U+2ua5QwwEb4wbM03VBs/AM5Whbcb4Gjedashg/19KP732O9ur
	KqKSXQRCkmLEd7t/n/t51Lw93PpVO4AR2D1Mv5LPFa0OQnZ8U9bhujEHWtzwWrwpEDy4G3OWQNx
	hCDAgRHFfYHrC4NADojnhEKHmzjRcTOigwp3SznveNo/pKxuDEBN4wdHDVu0gu4ulZeOPnocxM+
	Rc3lPjghBiLe+FIDh8jr/1LBJAe88lHc8ev5mPgrtd9QkKm4fkEd0gMq3IJiJwFKFA56bgoaKc7
	tiMBvSrdvvuc4rZJulMpvM3zXTxqHzEz2nY0WPph2sfNbcHH+6XDKgVia8JWoPHiLQd6am3/4wF
	3HOJJSx5cyPieYZg79fPA6z+TGSs+hlV/sBEN/B8e0NwLODhzo5ZhRbtv1ycH9rx7TVM8oH7kzI
	g4KHuIG55FFf2IWM3HR
X-Received: by 2002:a17:90a:d888:b0:38d:f096:a1dc with SMTP id 98e67ed59e1d1-38f6a40bd71mr5803571a91.11.1785319441868;
        Wed, 29 Jul 2026 03:04:01 -0700 (PDT)
Received: from r912.4v1.in ([160.30.85.32])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e7265010esm8224912c88.6.2026.07.29.03.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 03:04:01 -0700 (PDT)
From: Avinash Duduskar <avinash.duduskar@gmail.com>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] datatype: accept a numeric cgroupsv2 id on input
Date: Wed, 29 Jul 2026 15:33:56 +0530
Message-ID: <20260729100356.387951-1-avinash.duduskar@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <amnES354HC-zVZJQ@orbyte.nwl.cc>
References: <20260727082427.740789-1-avinash.duduskar@gmail.com> <amjWjTkt1Dsh66Xv@orbyte.nwl.cc> <amkAJuVZmpGy7pvY@chamomile> <amnES354HC-zVZJQ@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 11:13:47AM +0200, Phil Sutter wrote:
> Is it true that integer_type_parse respects negative values as such?
> Because that void avoid the mentioned issue of '-1' becoming '1'.
> Negative values would just not match.

No, the sign parses but is dropped on export: "-1" stores as element 1
and "-2" then lists as "cgroup.procs". Garbage in, garbage out either
way, as you say, so v2 delegates to integer_type_parse().

For the metainfo dump test I will take the jq route, as a follow-up.

Avi
