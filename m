Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4891B40D581;
	Tue,  9 Jun 2026 20:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781037892; cv=none; b=bjo/GO9JXrOjnIcw9wrkKJzw2H1HLhSyb4WbOPvpqpGKvQBLfSxcz+XA36Tu4gRET4uMi57/Zxxz3WXcnMHBe3+hK3imb3tc8qRspGbUNjnuLnBLc3TZVrB4ClwVq6MBoVGv9ALt+7vE9oaL/nMytCCxEdCXKrLPIUVYpYkPPsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781037892; c=relaxed/simple;
	bh=LruAFwnl9IzeFmjN9T1TBRP9TLejxxC/9JIDivm25W0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lv702+F8LbyAe5AatPE4MQrOn4GIygD5/RzmURJ8NIP7dXA7eR7pCS/qvmEbp15YLyaR7KYDDZjZXSUHbEjgxx0azYhBMSPCzkvD2BSKen4vkdKFRLCZqH5pja00QVgjXacsM1ZPiKdVHV86B1pAWDaZlHmvTqG27mBWOy+Vr00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pLIe1PYo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pLIe1PYo"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 0537060190;
	Tue,  9 Jun 2026 22:44:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781037889;
	bh=XJegGKvD19n7Qjs9LBr/MLKvK/0Bu2AAOfkrTaY9FyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pLIe1PYo7ULOsQseeoCo4f/bOb7g66OG6RrjTc7ZVOZndtZQpFxMJW/RQz59q2E18
	 92WT6p19Ao2isackMhWDMPj9SzL6eykJjB9xt2onSkK3vLugRhObKL8LlpjEIo8X9k
	 jiN2F5gqBwINdPXsKdTWxvogl6ukoLFqTQ7FR4dlQ+dNQB7LFsRXCggptOnRNk+7pr
	 3iA92HiFWEpyaUDw4U4948bglWuWSZqU02bdrDJr8kNpK+plypp8IChlvrku7brzLn
	 6bqUBJ1xayBxRhd9d4vwLoEbkuppZH7FPiwEcLyIRa9br7z7lKqdqMkaNKfhfvfLfn
	 7gb/1+YmGj/+g==
Date: Tue, 9 Jun 2026 22:44:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Longxing Li <coregee2000@gmail.com>
Cc: syzkaller@googlegroups.com, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Kernel Bug] INFO: task hung in xt_find_table
Message-ID: <aih7PqPryonzP7cI@chamomile>
References: <CAHPqNmyfm4j0Vy--8rpYMEY1wOP-TgmnRWYd=7ragj1Z29=F7g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHPqNmyfm4j0Vy--8rpYMEY1wOP-TgmnRWYd=7ragj1Z29=F7g@mail.gmail.com>

Hi,

On Tue, Jun 09, 2026 at 07:55:34PM +0800, Longxing Li wrote:
> Dear Linux kernel developers and maintainers,
> 
> We would like to report a new kernel bug found by our tool. INFO: task
> hung in xt_find_table. Details are as follows.
> 
> Kernel commit: v7.0.6
> Kernel config: see attachment
> report: see attachment
> 
> We are currently analyzing the root cause and  working on a
> reproducible PoC. We will provide further updates in this thread as
> soon as we have more information.

No links to external web, please, inline in plain text to this email
the description of what you found.

Thanks.
