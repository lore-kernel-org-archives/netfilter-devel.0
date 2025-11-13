Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAD330E828
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 19:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763062842; cv=none; b=ZSNklULksFz26BEwIyVUMaXyehnsJOPqSSNjLu/CjDMSrDOCxDct4On+YbBhKN1mr6djyQMviMUGUadMqWc0YiMbV3XJ17/sKwGwQeLxgNQ5Yfy4yuzbSbTqs5BdA5JSrJtDYEvLuXxj5VUg+PbeLXDh64nnBknFYH72d6KL1YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763062842; c=relaxed/simple;
	bh=8D9ndGRNEkl1RqTloTob3duuw/bnmw/Zkg69UnKPhKg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=toHZ2mWeYZka7WGppNFfCrDs3eYX/Ewgg2jaKyMovL0HP0zLZN9YUFPJ5vvVWf/Zgah9IXFz/GGHr8qHhSvQXvd8nEGeNEqZzbHcghdA6v200rkCXxZ9IObDs9EgYAvYaqntQ4ydfnUfvnoJtZ5oOqtuX0w5W/DhPLNhHz8cEuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=apJt380X; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="apJt380X"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47778b23f64so9653605e9.0
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 11:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763062832; x=1763667632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7/U/QcS+GCOoTMvpa+RqVAEgG1WX6woJ+60ecohtLo=;
        b=apJt380Xs+H7FeopVNA9UhPu8Rg+lQUkg2rDojqg72WN6Rf4XDrhLVZX++C38ptiL0
         9fywEj1xRF42GnDMXZx/EngLCRIOv6Un4TDSUTiF1EH/+rJB+dZNaCYTz9Cti44aeiK4
         RgaoKz4Fnzobkh9+b5A9Ahgvc4wElDriccgEJQQmoS5Zh62fbuKe9a5Xd8bXqW6gYbyH
         XcudTVP3V2dgjtd7+JMUBwRXgL2ykqp8krXYwbv/6n3bS8dZAU+B6u5O8aYTN6w/lxir
         lFXaOYgZ8zprPG4p4dEyMRaNi0IcuxBxY7I19KrcXq9/liVdYCPeKMhThrP1tCvC6dse
         BmYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763062832; x=1763667632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T7/U/QcS+GCOoTMvpa+RqVAEgG1WX6woJ+60ecohtLo=;
        b=SkOK4bR2yFDy+XWJv6SdEeuhq8rCqVveGyRMsV+eHt4HWbSqdacuOg22sbrhTNgzlV
         TObtIXkGIRUd4RDpf5z9ToAAPNMhcBuaJs0Xo1ye/fCFCiz3sw43Qic8haMYkLjHpHr9
         awO4Cw+NOlE582aouIYwU+RNt6fc6AkE6lpq4CNq05pLe5SaMC3e7urWfxdp//lyZIo/
         kt3+pRBRsK7YxjBtb3ea67BzWVYSB1+jfTrYOr8aoSxcN/P+d1Hlq5lRnD+39jgnS7kb
         pJ42f/ue6FyG8E3t6MKldB9FzAT6GSLacOYTE1P+LwJylgVXvTI9shpe8Ohnr5a+OKmC
         HkNg==
X-Forwarded-Encrypted: i=1; AJvYcCX+lPS+zlmr5QpCHC0s2pyf0LEIQZExHx2JO1Z7/VfUkn/FiztDSYnxCOQz7iVYdkxuEXftc9ID2lk4VsUZp0c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBXibyPq4kmHIEJldy5n9U8ll7NQjOBpjvyxYRLjAeB7ve1sQ+
	QEmhg7yulIdXaCQTpnSHlsjPVncoDphCwBuqpcnY/Lzhi6DikO2xqkLN
X-Gm-Gg: ASbGncvsl1C3npOFDEPtcBsHKibaPTPuRcElxf/oEubMGgHAqDCTwtMhdI81ln/X+ti
	OBvYmGoiYm72x1ty9JM2jYl3pWYmckQ1Qu+SqqyLbyxReusfyhgn2mKh5PuvO/+tKL/fy3QyVP0
	T4PvQ5GlKLsTNcK1wj0B7/HSQCEVWW1/xeYf/+JgZ8ThTg8MMi2IGrrqJ3m4mvxQtxAPgQFlhJQ
	wuBKhlzBZx/R6UO4In6aGUewAwK5dtIjmdFx6ZcnvJJXQybI64Gk5yXH04ILwahLBhdVypcsoNC
	pOFxRo7f2KkiGU4iag5i84RZwBNSjzMlAWuetxI2RphXGurgyUI3DkmUm4Rlz2XlfnNkSfjHNv7
	N8ZN73JZNNFhbo8HGH4F8dsKH2l9QMBdes/v6OnDLCJNhQnLIfkCJ5WgEM8lPTBMNyG0J4F5Iop
	lGkaISUh44eTM3shhyTh8hiRnfG3TK7v80LKN95v1ZdT5nOo6KAbjA
X-Google-Smtp-Source: AGHT+IENcCGkJ1HSrwt2e6IXzxZefrC/yqGwehFDalfk59L9dLVxWyncqxmuN4tp8L7WKYVEr6E1qw==
X-Received: by 2002:a05:600c:4f93:b0:45d:f81d:eae7 with SMTP id 5b1f17b1804b1-4778fea6decmr7634155e9.28.1763062831746;
        Thu, 13 Nov 2025 11:40:31 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4778c88c068sm50044105e9.9.2025.11.13.11.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 11:40:31 -0800 (PST)
Date: Thu, 13 Nov 2025 19:40:29 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Dumazet <edumazet@google.com>
Cc: Scott Mitchell <scott.k.mitch1@gmail.com>, pablo@netfilter.org,
 kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Scott Mitchell
 <scott_mitchell@apple.com>
Subject: Re: [PATCH v2] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
Message-ID: <20251113194029.5d4cf9d7@pumpkin>
In-Reply-To: <CANn89iJAH0-6FiK-wnA=WUS8ddyQ-q2e7vfK=7-Yrqgi_HrXAQ@mail.gmail.com>
References: <20251113092606.91406-1-scott_mitchell@apple.com>
	<CANn89iJAH0-6FiK-wnA=WUS8ddyQ-q2e7vfK=7-Yrqgi_HrXAQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Nov 2025 02:25:24 -0800
Eric Dumazet <edumazet@google.com> wrote:

> On Thu, Nov 13, 2025 at 1:26=E2=80=AFAM Scott Mitchell <scott.k.mitch1@gm=
ail.com> wrote:
....
> I do not think this is an efficient hash function.
>=20
> queue->id_sequence is monotonically increasing (controlled by the
> kernel : __nfqnl_enqueue_packet(), not user space).

If id_sequence is allocated by the kernel, is there any requirement
that the values be sequential rather than just unique?

If they don't need to be sequential then the kernel can pick an 'id' value
such that 'id & mask' is unique for all 'live' id values.
Then the hash becomes 'perfect' and degenerates into a simple array lookup.
Just needs a bit of housekeeping...

	David
