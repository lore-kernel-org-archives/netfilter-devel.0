Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7311D5CFE;
	Wed,  5 Aug 2026 23:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785972113; cv=none; b=PkmiHS3FB6b83fDS24TdEDSGsdzOGEIZP+0z1jy0PUUWKGccdZ3AnrDTPJNoyN/LALnKuVRrzPJ019MnLFtugRrXyRol2FeBVQTJpsbsfXcYlwKaHnNJhtPIN0uS+p4oI8rkR1xxdd73fN812n/UhOnObaE7qK1ldcdXxWAs7cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785972113; c=relaxed/simple;
	bh=CEeCA0TcjO8Mt9ztazo+gZ7DpbqQG2LaV4tAgv8oS6A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OJ5qj41nEl+LCD9HssiJlkY4+aYLo14HIzDSMFDRRVPi4q2GlPhxj0wKIHxemnNZIalpz3iHwfvj4sGIgVt6+P8q5WgDuBKVnptfQgaHfRVUGOwDfqtn86liR7u2g98kDczZfEvRfYk1zECNPRWrBcCDjMWV4l0ewMuThTCrl04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D83T66ao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D83T66ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9B71F000E9;
	Wed,  5 Aug 2026 23:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785972112;
	bh=2np7lwzZ6nBJQum/B98LRSV64G/fvJ/ncAO/BNMZGU8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=D83T66aofrXHdomSVcn7I9KvzaZz4uALU2JYqxuXo4GKcKyGXyxke8q8LVnqWuW/7
	 v7Sq3FpVzmB8BAyX3iTCRigdBYslh//9AoPbQ7xmynNqZSHmXdD//hw89KVeD8GN4Z
	 PX/mz5COE/2cO5PNpFgJgboz7Xlzr9kKGyIEh95HPU/WCK0p2emUqYH/CfehRHXlDO
	 AnNHmFQ2GiklUeA84HwFp2hCatYvTRTpbahkJ/VAfuz5ceedNi/2vI5pN0drOJzmoR
	 nAWQZwqKKrPpDinFdqyMWIYSXX85jbpXDG5nACHFM2d84J6xIELlLjRgJkBuqqeF0P
	 9ELgiIVKDEkZg==
Date: Wed, 5 Aug 2026 16:21:51 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, fw@strlen.de
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 horms@kernel.org
Subject: Re: [PATCH net 00/10] Netfilter/IPVS fixes for net
Message-ID: <20260805162151.251485df@kernel.org>
In-Reply-To: <anN1TKrRkGTwPXIQ@chamomile>
References: <20260731151806.849724-1-pablo@netfilter.org>
	<anN1TKrRkGTwPXIQ@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 5 Aug 2026 19:39:24 +0200 Pablo Neira Ayuso wrote:
> Hi,
> 
> After posting the review of sashiko's comment my proposal is to
> integrate patch 1 to 9 of this PR upstream, just excluding patch 10.

SG! Whatever you guys prefer. Sorry for dumping the reviews on the list
without much discernment, the netdev queue never dips below 400 patches
these days so when we can depend on other maintainers we'll just do as
told at this point..

Will pull the first 9 (and the -next PR).
Thanks!
