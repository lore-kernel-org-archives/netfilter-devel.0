Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDA32EC57A
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 14:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786159; cv=none; b=TNUSfRCkXU9aVNJyepFC4sud7w3pZPCOuTtQ3hbaRnRW3hAc+B+6j48HQ0tZmA4azSOuCjQyGNSYWed9SVwZgh+0LW9REgRSzum8c+dbWbEt5T7P9Prm9O1YAe2avUeRlHNWo8vrBl6wDBlWMgMFANLGd46x7GqzP1UmBD9GO6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786159; c=relaxed/simple;
	bh=I3NdaYBI+Vn2oMhKnb6VR4sk9ZdOItm8Wbt9tbmL3nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c0YRKNGBhhgEsr0ZFYdE6IVNLwGobbwHHD5z4CvxeIq/UDCALHBE1jylMUexiZYLdJt9A95DX8YUPZbu2ma3sihTJehKajLNuspTdeREfATy1WizK5FDyJKpYJYE0Xcpn1eaezsMxmJdm19YxpWuO1SbQOlIj9vkPmEQzC7sJV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9940360298; Thu, 21 Aug 2025 16:22:34 +0200 (CEST)
Date: Thu, 21 Aug 2025 16:22:34 +0200
From: Florian Westphal <fw@strlen.de>
To: =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc: netfilter-devel@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [iptables PATCH] extensions: man: Add a note about
 route_localnet sysctl
Message-ID: <aKcrqtU4HvTgO__C@strlen.de>
References: <CGME20250821103945eucas1p211e02560c0125f4f0eddae86798b9a01@eucas1p2.samsung.com>
 <20250821103918.1855788-1-l.stelmach@samsung.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250821103918.1855788-1-l.stelmach@samsung.com>

Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> See ip_route_input_slow() in net/ipv4/route.c in the Linux
> kernel sources.

Applied.
