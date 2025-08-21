Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A082B283FC2
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 14:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786148; cv=none; b=HMKfqDX97920ZyRMh9hUmrONf2cPLdqBCABZgGoWhzCAYlMEW1jy/zrYLimKv1ze+MAhMKq/5V12rMHUI9UKwAdZvewZeFo8kD8Mj4glHktdKaQYKPXyCO5VTKdgJS5hknEbp+pTfIbcOx7vcwkpFlUZ4CeBUg8zORJQtPXgM2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786148; c=relaxed/simple;
	bh=t5YjwIHd5X9iaM3BqVb7VpbHJVTfTPQ5VeTAJ2qq9Gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOdXYNemns2JGopJhONQiPOvEFcBWv36h67TpunsmU4be7uLATDptZ3+NdmhrN4d422p+nPk90nMs7XOMM7YN2LUYlqs0lW8YfOnCEF8WQHo501RuKdCh64Stxps9TJY2D83my9072Ji4RSXy1ywCUyKGRuKcdfzHj1lrcp7psk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4213560298; Thu, 21 Aug 2025 16:22:23 +0200 (CEST)
Date: Thu, 21 Aug 2025 16:22:22 +0200
From: Florian Westphal <fw@strlen.de>
To: =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc: netfilter-devel@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] doc: Add a note about route_localnet sysctl
Message-ID: <aKcrntPWXv4LfRay@strlen.de>
References: <CGME20250821103902eucas1p106756dd599b2e77f0fdd468d694e94f0@eucas1p1.samsung.com>
 <20250821103840.1855618-1-l.stelmach@samsung.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250821103840.1855618-1-l.stelmach@samsung.com>

Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> See ip_route_input_slow() in net/ipv4/route.c in the Linux
> kernel sources.

applied, thanks.
