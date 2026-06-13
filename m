Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FA131F9B7;
	Sat, 13 Jun 2026 14:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781362304; cv=none; b=qX88f26avn344gD6Qmxk41dzzw/DOt7TEoMU5kJWmj2h5/1a97/o6LsT/kc54/hQbaS2KKo6j6b4Gb2hIPXsOPXAUbJ3wPI1ULtqrEp/3KslJfHPnszZrL/1s9LfmzT8pHXL7gvQo+FgiFgNoOWjKh65IrKGYI5591mMl7a0h10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781362304; c=relaxed/simple;
	bh=+mzCkrPeOkAvwKjhFQKRdI15toB9RxRz9EPGwvt0ovg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rj5ebGptWHrBLCA0QDRZLA1FJb4WVdQrVpM5aTz56xmRTVda7tSnH0GgyrqgEbJyX1qZPWHeKGV6y7aTe93CZRZjv51cBoQAKxHVLkKqeTURdlUCoyeekqn3++FxxPJ5fm74fl7PqJ4mOvMnWGgHUU1LYlysMNMZw72PzKed0cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2OTvTBH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2OTvTBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DDF1F00A3D;
	Sat, 13 Jun 2026 14:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781362299;
	bh=+mzCkrPeOkAvwKjhFQKRdI15toB9RxRz9EPGwvt0ovg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2OTvTBHMhIa0SIQEQ3JP4plP7n6TV/yDQJqhthEc0j/cK/d4NYKI/d0kZiyO6KWt
	 j4bJdiDYVHRFF1Gkl86LWbWd2WFAqX/sY4PzMNeWTKYj0EyF3N4MiD92PWA2wGtv0o
	 O8CTHV6EiOe3QipHzJ2KR+8p/qsOJjqNtfYv7Qe/8Z+K3fJkf+pKrwCvOhFnKX9e0B
	 9WnE46lYaWY9+FjdfbdD1a1zlnKwknskYjmWPiuu/8B5mmq6YAyC7C5N6F3CH3A2+F
	 I60ogrjEJkAEErCrI1TPj7snEh9e5ccXjXJqeJD2EdVtxCLTma21a1R7fnH+IxX1FI
	 oy0lXBdkmQrfg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Mark Bundschuh <mkbund@amazon.com>
Subject: Re: [PATCH 6.6.y] netfilter: ctnetlink: ensure safe access to master conntrack
Date: Sat, 13 Jun 2026 10:51:28 -0400
Message-ID: <20260613143002.0003-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612202408.1045757-1-mkbund@amazon.com>
References: <20260612202408.1045757-1-mkbund@amazon.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Jun 12, 2026 at 08:24:08PM +0000, Mark Bundschuh wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> [ Upstream commit bffcaad9afdfe45d7fc777397d3b83c1e3ebffe5 ]

Queued for 6.6.y, thanks.

--
Thanks,
Sasha
