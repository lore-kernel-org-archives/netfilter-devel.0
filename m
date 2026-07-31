Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA9A3115BC;
	Fri, 31 Jul 2026 02:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465592; cv=none; b=OP0IHcHlo7OfQrZ3s0AbZOcRvFlTjgObSNdGJx4ssw2ioJJJQ+ZXBqTVtM4+mOi4DDmOSMraq4kvWq9zl2iM5dwqRQonW0D6lsoe6xUeLbVwEG4Z/Y0i07ZD8G9XcUtDdoOJKk/YTD+OyL3mvvB+f4W+fyTrW7GFZuMMH8xvIrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465592; c=relaxed/simple;
	bh=pyoHqUJEWcSmLzsg8i5K+4HRRtkJ86Nw59aowG7iOuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5I27jKcyJ6KyMIJqSxlHO1l2mbkJvcsxa7KpdK1U6XohBQUGRNoCjFKqz8gQUlFFl9uy9TLe9jASYZOl8A2yKZhEd1xVldRVNNJfYKAN3rdwBktAvU0yqNvuRj5deuPb3nwVvLV+9mNYHVGfoh00ZQo7FptsgWZlxPB1JNdjHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IU0K1+4s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IU0K1+4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB23C1F000E9;
	Fri, 31 Jul 2026 02:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785465591;
	bh=W748aPIKPoXcDI/vKy7AwxTs3P5v5fjfe9yp6Aj9dMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IU0K1+4sW+Zpv1C/J/L/dGm1SO/jCcCevWj9HIYwmGLTUM+ff7VqVD1JPfFDKtsc3
	 8mxhKK36bcFnpw11pvEAyM9kHW9nja8Hut4MU3uSfXtGfPfsmehbd13YTOvDY5TIi1
	 iefnF7L5jp45fMqsrf/ab7tHdTue5fGWKSVVMgSoXddiIix3b0fUQa4mSR++jOcjSR
	 LSC85BWIPuOaARJGmfuVoN7dPKninS6TaeP18gayPDt2LEi5QknmxEf1iShXsLMcTT
	 WAMN2tOMrap96hzr1OJTTFZsn1wWXyy7JvINtddztgQQwJUHuqP4QKoJ5xVui72PH8
	 OqjowzdO5rZjA==
From: Sasha Levin <sashal@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Ilya Maximets <i.maximets@ovn.org>,
	stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Greg KH <greg@kroah.com>
Subject: Re: Backport request: "netfilter: nf_conntrack_expect: restore helper propagation via expectation"
Date: Thu, 30 Jul 2026 22:39:44 -0400
Message-ID: <20260730203650.stable-0006@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026073054-certainty-reapply-a613@gregkh>
References: <ee95f6ac-181e-4315-a2ae-e4d1388c5e69@ovn.org> <amqHu5H6xu02Izo8@chamomile> <2026073054-certainty-reapply-a613@gregkh>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Jul 30, 2026 at 04:09:06PM +0200, Greg KH wrote:
>Great, can someone send us properly backported/tested patches to apply?

Queued for 6.18, 6.12, 6.6 and 6.1, thanks.

-- 
Thanks,
Sasha
