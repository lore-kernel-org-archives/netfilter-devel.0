Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794437851;
	b=P72WMro9yFhwnOJ5p+7UfbtNS7QR2TNPB/oZcdutycQDog0VLYSUp1kFXnY7nDNYnNE6
	 exiz5CILnn51Zjkb8BhOSFst/w2ixJ3h9OvYFAR2Xae6YT1jDiJlNTEuV8/lbLB8VeWso
	 6JAh3D2aaZn8yzEu0Uh344g+JY4EIG8ybJl7HrzcXoRNtjcGnGqNXuYPSUjwiXvFixHNB
	 F2PIBQf4Fy4fFscKW4eqr0LOl5SUmmuSIBmRfu3NzVMfP90pKbu6NvxC73wU5uH9uoYHh
	 3KqRf0mAFvfZUi99yra+z0BFr9tGh+u9lXAGyMJfZiil8qGu5Iv1Kxr2GKrcsaLKz+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794437851;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=vVTNd2GHud93OtQnmzc+GTAxaEAE78WRijdTd6vc8c4=;
	b=feu0zNNDtpekrqM7ygpWUZCw2vznbS8ITp+mrTv3PNmSy3e3PKsyMORIy6wJB60kPD/6
	 iksVkOaiy/LP7TDk/Dybaqo7bZs8dUcPS6WvaxgtQuQLYzETrfRpjgQtJy1AhY0RvBvyJ
	 SMHb4Wa7pZ366tJ+wmcFn2rrrHrB/loQpVczpYtm7P5CsdgDia7hi32OJrhThZO+RsZMI
	 G/ew/udZGscKmsNwGpZ3jZ13dlYzNhjJZ6PXPQ3CHgrYqQ8tbck+xKcZd0apa/HY8Nqrf
	 Ccu3HmeQ5JmbyLhRKUqNmA4PI92u7MUt0qcOynbhd8QMmy0xOK5gPnwdmOhe5QkTVdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=AuFVfI2p;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8A1606A893
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 22:57:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E8A1606A893
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=AuFVfI2p
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vVTNd2GHud93OtQnmzc+GTAxaEAE78WRijdTd6vc8c4=; b=AuFVfI2pbIB+7EmyAz2YDuDXvV
	3L7MpgkYw3F4cFSvPBuNPuxRlpHKIKTHkj4YOf40eKPZ5G1YNVFmsDkrNHIRFcB0f6E5Cfl6e3b38
	pIzf1qAL0sRkUwB2PWazOmsFezZFYUd4tbWFw6UBg03JGkeHFRNTZEAarN57MoYFz3gjgpIUUGbvg
	bWe1cRplXGUjMEUDC+AYT7EyhxNlLX9AyXk/ED4mjvg/H+pLBjEeuX54qVJFNOduGvBJyX1Y1AvJG
	/2mSIDGVxPT1gl/eJs8jkdAV2ijhZVedXxCgTcpJT91+Id1UGUdjlYu69dVXLngQMMdvvZe0FO/Zc
	NQxLSFCQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xRHFw-000000002ma-0SiI;
	Wed, 11 Nov 2026 23:57:28 +0100
Date: Wed, 11 Nov 2026 23:57:28 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/3] Fix two leaks in error path, one extra
Message-ID: <avTy2DnUK7Mkv8hX@orbyte.nwl.cc>
References: <20261111170147.47501-1-phil@nwl.cc>
 <avTKOyPy0mnDSXEZ@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avTKOyPy0mnDSXEZ@strlen.de>

On Wed, Nov 11, 2026 at 09:04:11PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > The first two patches fix for a recent Coverity tool scan. The last one
> > is unrelated and not worth sending on its own, but matches the other
> > two's severity.
> 
> Thanks Phil.
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>

Series applied, thanks!
