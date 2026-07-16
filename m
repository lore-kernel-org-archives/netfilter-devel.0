Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0DB38F65C
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2026 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213578; cv=none; b=DysnKwC950Zxs1UqJ9dKdp3sGhgTHnLUjiIpsLIRni9s1kDwUGmjPP44FIbY/3ryZxX4jipha9q4sZDWxw45mYaLk3shbsMHATeJ1mY4QjzhLu8JyV7pxSm4ANgyTh3zxJe0+TchaedeSe0/Y+aJvvrKj0FgODl6c1hrHC0AAls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213578; c=relaxed/simple;
	bh=cv/+Z1DJ/R+85YV4EhP9zp1lHOj2qZHD2Ceahgs0Wx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zw3hQW6AQl/CNA81Yj9TjpRevOtFt1/5kjMLaqDLnXS2FAQkXR1M5oT1P5TTXayLyyN3aFSa8FzArogw71IJV4lA4ARtvOrrvQTeKJ76X/8RgmebZGIL6UuNNN9FbSJTFSWS5t1Up/jQosF+HJrXe8fDpEYoHvMxtTgyyafm+VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2F6B26055C; Thu, 16 Jul 2026 16:52:54 +0200 (CEST)
Date: Thu, 16 Jul 2026 16:52:53 +0200
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH RFC nf-next 11/12] netfilter: ipset: remove last region
 lock usage
Message-ID: <aljwRaHZ75rpRVIN@strlen.de>
References: <20260714131828.10685-1-fw@strlen.de>
 <20260714131828.10685-12-fw@strlen.de>
 <6111cb97-d92e-814b-3224-ba7b42bdcb5d@blackhole.kfki.hu>
 <aljl4IafjFKZpMDy@strlen.de>
 <9350a546-bde0-e858-f034-9b16e651b072@blackhole.kfki.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9350a546-bde0-e858-f034-9b16e651b072@blackhole.kfki.hu>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> The comment string is kept in struct ip_set_comment_rcu. The whole mess
> about the extension was due to resize copying the pointer of the wrapper
> struct ip_set_comment while ongoing gc could happen. However resize is gone
> now. Re-add from userspace can change the comment string but it can nicely
> be handled with rcu. So as far as I see ext_size remains to be solved and
> the hash types could remain lockless.

Great, thanks Jozsef.  So plan is to make it atomic64_t (which obsoletes
the _slow()) functions added here) which also avoids set->lock for hash
add/del.
