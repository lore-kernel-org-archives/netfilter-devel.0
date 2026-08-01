Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75071361DC1;
	Sat,  1 Aug 2026 01:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785548414; cv=none; b=CQwCxNrzy7VxuwnCO2j0zDJtxtitLqg9tMZZCpdK5AT3DxdpJAfViyXd6fYGyd4I5GeJT0r4476CQpyelKv8eiqnsRuRdLyc2GYnZ3OWRzRfxs2TCiQN71/p8X88NvHyeNclT/mX2xqnemheg0klKOO5BJrs1VmU0RRclBjCUuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785548414; c=relaxed/simple;
	bh=x4m97vEjsdKwEf7fIyBRMfLC0vWAxfjysQvklgv+njs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMf46NOwQxzybYo5ILbvKo74JiBlYwMoVikbSaU6l7Ms20NvfB3ckFkHEJ71VyYBd3B2zZfd/81b/Wl5Ya4IqLKXoyOmFDPbMmG8DYFJoEIfUhRbnB9bIzRIrPzG/p5zrk6WaPTQgNhgQP0WFzvlyshfMEYx+RvivM5HslZHOmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frGfb6sP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frGfb6sP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235AE1F00AC4;
	Sat,  1 Aug 2026 01:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785548413;
	bh=50nXpwtaKroXQYpsVLf8UQKn133xXT9BwrQ6e00QwPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frGfb6sPq81U31hhHDmeprL9YCAG8BUGktMQJUNjCSDdXnCOhZedXq6IigfFS9MXh
	 zzzIiNyTCSuYdi1Q4o1IPjobm+vC8RS4sjQuPvuBTC/QYFXl/JY0wPpA+eSiGRzrQR
	 FsImyB+1WEYnFZNNxqzmZbwrqjlkdo4R0lphB7jghf98Wv3+8ZAS74XvVqQAYWPzOI
	 cYgxdsY7f7L5iQ/0ybXZwoxK1iI+asqUHnnBky+FmoHX5zu/bchCRhELrlZ5eZW4on
	 NebxYUQfe7aQiLDpRHAz9uYN9cfl5xDbmZ/kpGtYnbIUlc50/R+HpJZsnvCbZCSYFt
	 cJUMOMkb6mpaw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	lorenzo@kernel.org,
	idosch@nvidia.com,
	pablo@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Smit Patel <smit5292@gmail.com>
Subject: Re: [stable request] Backport b2870fc21601 to 6.1.y, 6.6.y, 6.12.y, 6.18.y
Date: Fri, 31 Jul 2026 21:40:02 -0400
Message-ID: <20260731211000.stable-0001@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAM5kW9DyDSJz+W70HhzQL4TeY28GTcOxDvkPHnFBh7TotqiEVg@mail.gmail.com>
References: <CAM5kW9DyDSJz+W70HhzQL4TeY28GTcOxDvkPHnFBh7TotqiEVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Jul 31, 2026 at 09:18:37AM -0400, Smit Patel wrote:
> commit b2870fc21601db9133bc70c48c603b487614fa3b
> "netfilter: br_netfilter: Reallocate headroom if necessary in neigh_hh_bridge()"
>
> Requested trees: 6.1.y, 6.6.y, 6.12.y, 6.18.y

Queued for 6.18, 6.12, 6.6 and 6.1, thanks.

-- 
Thanks,
Sasha
