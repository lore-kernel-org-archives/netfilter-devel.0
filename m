Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE29DDAA;
	Fri, 12 Apr 2024 02:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712888212; cv=none; b=qz4n4bPiaj/184dFOq1ZScQONV5Ryer5KC9YU3dL1l0t/J1YNXohsIRzcvhrRvdtQrShfYf/kA+cts0IDJA46UbCT5sBRdfcT7ivUuW/nxF5dohB5JFt6UHZqYkLxZSfuke4ClOy/B3/cUOQ5c95W1wAXY6O6nCGZkE4pzNO1UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712888212; c=relaxed/simple;
	bh=hjq6KWAGXCi/vXjVk35RFkpnXQE4A5wyLzJTa4uGCo4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OOSYKxT79ZCcp6qabkh71I4xCdEKAdwYS3zB5hiNu9+Tu1U10TvYlbZzgk11EJQm01a3wvvW9TzKnOTL+0F118n08+XVIqSvViC6oBfPQZ2IZV2XxA4FtEMkoInvbkw3XlNfn8ScfucfkdUAbej6BafK3T1tVuoKGotpyTG3J8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nnJCiXxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnJCiXxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230A4C072AA;
	Fri, 12 Apr 2024 02:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712888212;
	bh=hjq6KWAGXCi/vXjVk35RFkpnXQE4A5wyLzJTa4uGCo4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nnJCiXxW588TbzKAMJbEIAFkMjEfsu+XuWkeTOPe8cYgSyx4+sqxL/Sa+aZD/R3fi
	 UTiA5iRlNcP/19cdle3IWCpX6GddNvcJMq57lgrvwvaH4SNIvA5mwI3pZiWEIj62SO
	 QA8eJqnbg26NZYGT2WraeUjC5MTBhFnAtNaTKeBxBkMMf9n6t74vpf/vzysci2+nuW
	 rj+0qCowYTlrzHDcrqHEUW0fCtNDUlqky477ZXuV5iqK4mspTOcLXMaNlJmEIVBvPo
	 C6MuVA7nMAi6mv76+UwoO0QTnCnA6+oXYcy/OvjORbh4DK/2N6/O1POr6nhjsavaNu
	 LSOFbqlfOnFnw==
Date: Thu, 11 Apr 2024 19:16:51 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next 00/15] selftests: move netfilter tests to net
Message-ID: <20240411191651.515937b4@kernel.org>
In-Reply-To: <20240411233624.8129-1-fw@strlen.de>
References: <20240411233624.8129-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Apr 2024 01:36:05 +0200 Florian Westphal wrote:
> First patch in this series moves selftests/netfilter/
> to selftests/net/netfilter/.
> 
> Passing this via net-next rather than nf-next for this reason.

Either tree works, FWIW.

I presume we should add these to the netdev CI, right?

Assuming yes - I need to set up the worker manually. A bit of a chicken
and an egg problem there. The TARGET must exist when I start it
otherwise worker will fail :) These missed the
net-next-2024-04-12--00-00 branch, I'll start the worker first thing in
the morning..
