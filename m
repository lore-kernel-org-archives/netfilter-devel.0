Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D483627F754
	for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2026 23:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774999984; cv=none; b=uZc5ljM/9IwZhg/e+PeaII5PEjBbhOo67IX/A7plCFtOTHRgGf5GqbuLfxGNNH2HaIlpslluwVQHmYQb7KsGAf9vwcS8/AkXLWxyphClEOiiQLEDGu7pNUtu4IcjmpRv/N1XjtyN2E0adZNTTekLYSWR1x5pAE1p+4YOxmT4UeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774999984; c=relaxed/simple;
	bh=M1ji8Pke/B0Ll0RS5tbxjwiMG+jW5COppt0UpoixNSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q61izK463ARv8CR1JVqzcPJDiWsdqy7hxBfT4IwH7RnCk2rkQQrJGbNVnYGvIVpiZeFjT2BQJiAiIkcg64LYBsydgj0d8a0XIiraQANxpPUyv1YJBndstAiWF3ozbzCK36vngsQE33heWYvdj3LTQdv/WO6yoYceeew5Rs2jcZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DXGJfs+T; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DXGJfs+T"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9AD216024E;
	Wed,  1 Apr 2026 01:32:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774999979;
	bh=TXlp0mdGE94zFgAXhh5MDuOlrtry0RQVsmcQVlV2gyI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DXGJfs+TfOhGO0htffDW+0xojgbxcPTPIrEb0T4blXNg0O/sgWJo5WBMUOHvuy+E/
	 VVsCCGDOBIjC9VXvjfJ/bMAB8avHDWvNeiG+KKo3OuK6DqGg0P2xO2mtrJ9muQGEGy
	 sfYGfKyMsQipwdTFJ6IawqRSKvi76rZ964Tn7COK3Bbr888tPVtOaGihhLW9vdsbCH
	 V8NwRtGyF1u3vLBRio4zIslo6I2e49LBj3ZXmTD84y9OgOs7xdnpApKSZXv8xfGbIt
	 mHRPzKUUOlUn/NLJbD5S1hcxapBJKKIZRQmjayu9UOXWbLyJXv0IqZXVXmc8/qOdrn
	 RLovnS0adSRMw==
Date: Wed, 1 Apr 2026 01:32:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jenny Guanni Qu <qguanni@gmail.com>, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org, klaudia@vidocsecurity.com,
	dawid@vidocsecurity.com
Subject: Re: [PATCH v2] netfilter: nf_conntrack_sip: add bounds-checked port
 parsing helper
Message-ID: <acxZqXOhFDulHuqS@chamomile>
References: <20260313195256.2783257-1-qguanni@gmail.com>
 <abSfgVpCQcFWwNEs@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abSfgVpCQcFWwNEs@strlen.de>

Hi,

On Sat, Mar 14, 2026 at 12:36:33AM +0100, Florian Westphal wrote:
> Jenny Guanni Qu <qguanni@gmail.com> wrote:
> > +	/* reached limit while parsing port */
> > +	if (dptr >= limit)
> > +		return false;
> > +
> > +	if (port) {
> > +		if (p < 1024 || p > 65535)
> > +			return false;
> > +		*port = htons(p);
> > +	}
> 
> I like the port range check, but should we make this universal?
> 
> 	if (p < 1024 || p > 65535)
> 		return false;
> 	if (port)
> 		*port = htons(p);
> 
> ?

Can anyone have a look into following up on this?

Otherwise, I will try to have a look for the next PR with fixes.
