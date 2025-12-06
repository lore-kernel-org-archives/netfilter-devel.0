Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE71914F112
	for <netfilter-devel@vger.kernel.org>; Sat,  6 Dec 2025 16:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765037854; cv=none; b=fxZfA8M3hGGekHAzdJuIsvExytCZ/Lg3U1f/TRSLqfxvcdTqmD/FJtB2gPFn/wCsHOR/YK5GlB0D9cgC9S68lZSffMJSgJOTPeuNC82rC976+XF6QKXjQaR+1YP8+mZssIiI/a7/rExKeC94hDFRHEXRLyFOukrVZC7UZIvpEuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765037854; c=relaxed/simple;
	bh=sONB1DFYWhHWVPvb3/qyAKp/FWwCSH4Nn5YxoiCxSVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gx8GHwNMgktzdCi+nJgaib0cfA8+aviEzHmAr9/BxGTWDIjh00mKsILcEdMLFcNBt39n4mPViiO5F0/AyMcrhuPHCg2ikAm1wZlPoF4MXHAl5IMyFayNsWwgnAXG2P8AmwJ1xnvndhpHa89o4rVFQcq+RaFycGge3jcUJhKUkM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rIBJsMGq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rIBJsMGq"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B3FB96071A;
	Sat,  6 Dec 2025 17:17:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1765037842;
	bh=sONB1DFYWhHWVPvb3/qyAKp/FWwCSH4Nn5YxoiCxSVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rIBJsMGqUMYoIa7B+OLUFxcnWl1WMrWjJT6SSVXTVku2kOTY/nx94xaWG5VT4HUzD
	 b4/msSfRfyJCZRCLsW6IoyQ9OOokptOFQQrYa0l9yv1cXlRHU5rKfmRXbYQww7Y/cm
	 HZF27kAIKVzrJhB+FMDcLfzSIAG4gt2tWUTpd8GGmZy8OEYW7U0bEMib9olzcZLpxr
	 jKn7/PiiFFMsj764Q/3usgMf6GGUkOO/mIDMC7QHZirZu1Lq9QoH/I4dLmeirJKK2z
	 77IyBAeQqt/SMLnxqEXsWbGY/zmW9StMng5sqBwEiqu4sHLeSxrlzBCT4N78o5Yq+3
	 1G/GME2lSSBCg==
Date: Sat, 6 Dec 2025 17:17:20 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Palus <jpalus@fastmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] build: avoid bashism in configure
Message-ID: <aTRXELjuDNk058l-@chamomile>
References: <20251205234358.29622-1-jpalus@fastmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251205234358.29622-1-jpalus@fastmail.com>

Applied, thanks
