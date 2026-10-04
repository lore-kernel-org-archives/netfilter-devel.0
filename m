Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D0B3B14BB;
	Sun,  4 Oct 2026 21:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791149356; cv=none; b=t6WGoucs+ZdvWvDOz95HbTE4QtM5wpxFYGVCO7XiI73ucA7CU0Xra+yOuQ+atjcLq6vMTigWXk0ageePgjYQUGw2we8ALU2GoR+ffzqL9e2aaAn3C7CaMB7xL7fMaSEuedlayatIlCALR8mO5KehZgAtRgGT8+YYhRS186RGjYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791149356; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VXDzqvrnvOVzpRWJFImbMKYIw89kx3TM8ttfdrBHAaSGVsb7rYsv032Ns+iOZAyZRZigNIAbSXrQeKvFzU9feCK8JOhR2QbqNH1frgeeHH0BWAMzwvT9cBy8IO4w2ZPCbwsxyW5rZk5jDmXI9hzdpkK2IxYgMR/FAI4VL/hoUXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hp29ENO9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hp29ENO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20961F000FF;
	Sun,  4 Oct 2026 21:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791149354;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hp29ENO9c/wkhvfCZBKU9cp8njryNaAc/sbYO91Jws8yX1WfNrP1GpqXFnEcGwT1Y
	 0TshX1qr3CFNTlzXySL+rAvVwRZVT6NpOs2uU4/k5bVYRoaFOlcMgtpXAyUkpPwsPg
	 FaXP3ZAE38GTNCT8OiJ2Xoq8huein8RWt4fBece87G4lw323OXfIPhJUJduiC9XnjD
	 3KXUyuv5DCRLhDuhfH6y9rNDbLl/SGbJf8MnkgEPXTi7ZWN0+rYNLq6MnFeN7DiF5n
	 qWZ2KwrvQmZtMDLtp+DjSYMmx+x6XByHla+Tauv1hGsBaYkqKu5x68AULUe3Iz0VHo
	 YDdpTjl5p9jXQ==
From: netdev-bot+sinfo@kernel.org
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Bernhard Thaler <bernhard.thaler@wvnet.at>,
 coreteam@netfilter.org, bridge@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf v2 0/2] netfilter: preserve bridge egress VLAN tags
Date: Sun, 04 Oct 2026 21:29:13 +0000
Message-ID: <179114935323.1402591.1020652042294576959@kernel.org>
In-Reply-To: <20261004212429.3648-1-parri.andrea@gmail.com>
References: <20261004212429.3648-1-parri.andrea@gmail.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
