Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D0230C606;
	Wed,  5 Aug 2026 17:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785951573; cv=none; b=krbFaNyg6CssQsLaRpXVEY08iqdJu++X7oQFbxiVAdeYAq3k20QxWPUpQbFbPW4M0QX/XhITsWjfXrrHVi9Psc13I8MPeKxUJdSY0VR2MTaFLWT2XE4tddq5DsbZ/Rgqi0jzb98rhLCnNXPvjQsGWQG5PSDKoZeetLasRvkjdr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785951573; c=relaxed/simple;
	bh=SJUk1IpIC3UU0S6EJhoOdt+wIGttHshPZ9yx307T0T0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qmgNPc1qTVbLXZB3FlKZOO+dV+HjY+P0ghDeG3yTvjFcNglwb9bNJ55fpcWRbTmZRJvlcnWBxlbZwmT50w7sDFyHGrKqs0GyN5nHQdBmLze/K+FjljAQEAc4RkIed/tJpXyYof57Ec0nayJqsjzCS4QWpqPHQwG/BXvvfl5Lu0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Z+paxt9M; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Z+paxt9M"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id AAD9F601A2;
	Wed,  5 Aug 2026 19:39:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785951567;
	bh=SJUk1IpIC3UU0S6EJhoOdt+wIGttHshPZ9yx307T0T0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z+paxt9M45zuaARX14r2zwUtXsq34gEsMtFVF26vLbcmqpV6g0JsRvqf5TadJee81
	 TmPAb5mvjazXDXQ3hmMRjOkbeaUE9TheYbXDeTgmQ/DY3eFuhDrixU/iM4shfWJIOI
	 g7tnPVZp0lao+EqZZkLAtAw+RZ1SfyAluFGnV1oiQIaMmUBYhvM9z/EdxEq7RW5qNc
	 +2Me5bb/7URrdC/50vEIGs50CPZofADFBcC5yv1e3+8fxQiCK+4bP9ovVotipf8Oqn
	 aR9MxTLp/J9Kmlyzmgvh6Ucl2NNGNQ8W45pW6XgE/yFDYdQ4GEDQ41cu7zfigOujYZ
	 iytmVciVQSX1w==
Date: Wed, 5 Aug 2026 19:39:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, fw@strlen.de,
	horms@kernel.org
Subject: Re: [PATCH net 00/10] Netfilter/IPVS fixes for net
Message-ID: <anN1TKrRkGTwPXIQ@chamomile>
References: <20260731151806.849724-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260731151806.849724-1-pablo@netfilter.org>

Hi,

After posting the review of sashiko's comment my proposal is to
integrate patch 1 to 9 of this PR upstream, just excluding patch 10.

Thanks.
