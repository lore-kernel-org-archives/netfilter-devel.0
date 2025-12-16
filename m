Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F66A33A9FE
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 22:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765922948; cv=none; b=TDDH4dU4rQtl/xRMfIM5g/WqAPvv7/nP/rKvVh3XXC5FLw5r2ic05yZPwsuLSOqY64/ZJmvTYknLtyGXyKwoMnIBkBjlehxylw+a69WSpFfOogFVB54d9ZCwu5xgLkDdpHFb0vo5B6xClwfKoO4rd64cJg1x/2jPK4AAE9aFZCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765922948; c=relaxed/simple;
	bh=qpgC3yyCDP76N/htESCWazmPfZ3E5Jf31zrj2hTIYvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eeGKrBtLSAVdMwobMDDDkaQKlOjjN+rXaZiWZIRRFZjXxRQHhrZhS9/nw1XwqMLzcvQ0WGvK/VqPXPp/24ki7f6X2kCjPCeBjz0tPhKy6q8Wx8cwhSncVCTUkAAYSZO7U/LdBaHE10Ug/pInJKWL+nmNRrWgVXsfeAlJSF2eD8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=B3Ogw6z4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="B3Ogw6z4"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 97ABF60251;
	Tue, 16 Dec 2025 23:03:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1765922580;
	bh=MWgcH3TA7XSGzTIsj8yY3Yt2ex3EaTG2I48xSEhHd8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B3Ogw6z4mROGbDmVBnQTI5spkHC8Kii4qZUamNWe/Nfq5r63nTaU8XGOKPha/GUNz
	 DEKbmvyOYcVffqgJoPrBtOLREiPWqH2XQVDFeDwdikwLbHBW934MeDY6ugAZ//hxO1
	 Ejxdiieu/7naPeR3xQkJPSmGz9Lxhp+bswjIpdF9slmbeH9QD3eiB3GFTbBeStoKVg
	 A5+GqJT6IVEJBT25lpM7YbV7zI3s4nXJn/+v2LNkiso7YsJ2pYWR9IXElKTnDEQfPW
	 2GjQG/+mJ3FxeMC85hcwqHWobd5QWGNYVWZ9VfKHVe2otWdOrL188o1T6LNSw7EJAt
	 QsMB3fLcDhlsg==
Date: Tue, 16 Dec 2025 23:02:58 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: New conntrack-tools release?
Message-ID: <aUHXEmNOo8WvQaa3@chamomile>
References: <20251212145754.GA2993022@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251212145754.GA2993022@celephais.dreamlands>

Hi,

On Fri, Dec 12, 2025 at 02:57:54PM +0000, Jeremy Sowden wrote:
> It's been a couple of years since conntrack-tools 1.4.8 and there have
> been twenty-odd commits since.  Time for 1.4.9?

OK, let's prepare for it.
