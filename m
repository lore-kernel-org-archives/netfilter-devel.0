Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE4133469C
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2025 16:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764175447; cv=none; b=m2/4eyMaXr0PrLu3hqzvJHB/LX5OKNy6wVQyijCGxdijBLgJNjrb0STCX45ZW+7Bb1wwSF/XMqrtslNHQTVDaSTx4AnRPnLFwgZgQlIhkcdg9x+CQ5nLwkoTY5Mb9aRHFEgEU5qgnq7LH/Q+BRvyoLo1sVEOvlig1HH52BAyPnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764175447; c=relaxed/simple;
	bh=O8GYmXQ2pMlGHY8XRnruC03YAhoDps0uLSAKDzrjuZE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=tBHZLb8xRq/MQUQIVfl13aFoX3FeqDbUW8aN/NC2ty8yDEIibMmMwPSD+NMnXZjv+G/0l+L69Pa4rozB7p8Q8pLsMwNwv2G4QqQfJBRDmZJoJZ4ok4xbrTofjyJb5EleFaZi8ZE9C8f0XCCPNGnK+hkbDJnroDG4JTFIvkmnfSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hpUUzUIY; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hpUUzUIY"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7aad4823079so6145964b3a.0
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2025 08:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764175445; x=1764780245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O8GYmXQ2pMlGHY8XRnruC03YAhoDps0uLSAKDzrjuZE=;
        b=hpUUzUIYGvHlm8IFOXuvS1lCw3XzFaBMrR2u3LNTmHCAZ+bd4sXElL4K27Pg4/W/8m
         ClXVC/ritJVDFVAaDnM01WZ8ZOWrzgG/iQUS7t0nHKQOZYWxY0wZlTQLQI/8AKFm68DY
         siFtqAfsSu3UWO2qzvmOeWh8k750C0TH+s+AUZ8F2FfFm6oRUW33o1xk5cGKSn8ZAYdP
         VGZtd9f5bFli6UCikvaZhVgwuW3ubhQqv99yG4sORlr4oefr8uzisSAprvI426wVjn75
         wMcg/lwEF8n2TbZt70SgRTsVtdDIr9gohE+ZXw4SsT9HkuKCTTKLo9DAhBhKMxRdDWU+
         5QbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764175445; x=1764780245;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O8GYmXQ2pMlGHY8XRnruC03YAhoDps0uLSAKDzrjuZE=;
        b=FHxrpgCsIZ5ucZVNioUTv6G22Qph/CfSFgac+7ZvOPJ4MCbhS7kwYQOo0Dh6DpIndk
         4Y2QhDH03rKEfBMYwmRL/wV5f8gU1CKA8rTYPxEFb9HG7HX3qQ/UB0DeWVuGLBJrF5N1
         3rf1QYr0q5fME9ALhci986lK/WkiXlhRMbfO8pXGw1P9Q8PYHP9u61cuCF/lzdFnF9Wv
         b2UunWabJOtD1z4AW8H4mwU9mZSAcKnk8ghjj9+5qqJDrgBMkSHh64yS/VYeiN5csYdU
         29zofSNyDkXu3b11YskRfMxU0QlQ3Reh6wg4JHwHn/YaihuubY1YMmIG6ImuFE802GTm
         1dKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUURDVhjxgLydRcctFzdNXeFpN4OGrGts3SJ/rhsaisp/lg2OJX6MP2OrDFKcT529Ekpf4KHIp3wA+Bi8rxkmE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyamxX9WPS4zaoPE4wF5sP6WuspYPBYYd1jX5KzfrqjYJY4TiO1
	3IG6r/6v/8fvc2XS7T/2j5StnUz9Ra+ToVqtavFUs6Hn13kRI8bhfo2o
X-Gm-Gg: ASbGnctcMhSkrSi7AwzgvmIqoQqvfobV/O2758MHu94OkFJt056NkZE07tYjZSDfGoV
	1PTCGtjVNyD2kR0HGVGq1l9qKMA6wSYDObRqoN+Sml2bT7f5YGfN4SeBgw/DC9ARhQNNZ5Q1HmV
	80vie4hUpcneHA9D5M4JdZAcGRGGlm95nGIc6qpNPxq8aoS/ARgSMi2ZzwwzTxNNdVjkjpWS3iF
	ctknvHNtmqc36gxDejK+0rUvQ0z3t0b1ik6YbDPn9OE9MO8GJ1cxGb0iAqksSFu7CtsatZY8rr5
	Ydp0O1IT6UOcrn60a3Hi/b9SOZUOEyD8RD7qm2zb0ILSrTlxPOCCR9D/qPajjnNgEua48MHI20A
	dfKFwduWv+aOe2JT5Tdfwtz3V1yKoNy5ZQJaNpBi+FX9gIGpmfqb3y6BtXNj8Eu7+nlvDGuqRL9
	i6ApdnozyXlLs4iIyiuZNI7ib7tY1hVtOm5FROrY6TX1ifCg5QCQ==
X-Google-Smtp-Source: AGHT+IFqyC0YAm+3UTdOiSmkLaC/3DzXYr7V5WETgZEnjW1RFe3ymI3RPnC9W5gCj4bP8BqTujmFQA==
X-Received: by 2002:a05:6a20:7fa6:b0:35d:be42:92de with SMTP id adf61e73a8af0-36150e60244mr21725301637.21.1764175444660;
        Wed, 26 Nov 2025 08:44:04 -0800 (PST)
Received: from ehlo.thunderbird.net ([2401:4900:1f33:7df3:e8c8:e94f:8d37:8e16])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd760ac62ecsm20162173a12.26.2025.11.26.08.44.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Nov 2025 08:44:04 -0800 (PST)
Date: Wed, 26 Nov 2025 22:14:01 +0530
From: shihao <i.shihao.999@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, davem@davemloft.net,
 dsahern@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc,
 ncardwell@google.com, kuniyu@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ipv4: fix spelling typos in comments
User-Agent: Thunderbird for Android
In-Reply-To: <20251124193121.6f9eab3d@kernel.org>
References: <20251121104425.44527-1-i.shihao.999@gmail.com> <20251124193121.6f9eab3d@kernel.org>
Message-ID: <5C021872-7092-4965-BAC8-FC76752F8045@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hey everyone=20

I accidentally added some texts at the end of the previous reply subject =
=2E Please ignore lines from "coments" =2E Thanks for your time=2E
