Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793224194;
	b=kf7L03Cd/97IaKfQNMIrF1bCqmUweCHxVko20qrka6ayVugmSFmH/1Y80na7W3egJ4Q+
	 x+RCUkwaUYo+fCE5B0h3zD8/n/1JzV+fJ/m39VAFBvQSNyUoRveGDhxK+KbuhnWPtmWC7
	 svyjIhPR1DVZ2L5h6hFUTm85TlS7CpD1WnN+pf33AqXP/lrODobkt2c1HYiiwZe4H7/P3
	 4gVNfZZlgU0DQUA/ySDkMOwHHyvmWk5QRY4Qm2V/xIEtU7cXVw5xEBGAqXBLklJ/l/8Os
	 kGHIo61wcV0VmNGBop54wlIt8EoQjpXozc4w3hT6ThlNo9uX+fwmop8DkT+KDqJT3ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793224194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=s49VmnsMaFesiU5Mp8mIrDPrf1mDNZyUEmK6vIZiZNNip4yUX1NtYyKVlu4EEba4O91z
	 DYJNqyAkvebFIwdqNUW8aE8dRtrLaRnbNvNxThIn9yx1d569Q2jqqTbrQbKpaOA7Rch34
	 vhaZlD0SEzf8BcbixjKIgfGoMZRoTw6AbY6Soo2+uNsqlu0QMj54fMLPnj+LoIa9pFz2A
	 x6mc+d4TV9zT0o01ZUuGRP53Axj5OSE1ISUHFBvNUgYeZLsSpkD+mYmpK1664Pw1GTxWA
	 dYIgf8IAKm8e9ROB2Zvb6ibXWom7Erny1NZE56/S4+eVGHBzoyXiEJ0eOoEQETZD7nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IP9vmpT7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7708606A31A;
	Wed, 28 Oct 2026 21:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IP9vmpT7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8382B1F01825;
	Wed, 28 Oct 2026 21:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793224193;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IP9vmpT7iUkWEr/9y76Zc2knj8yEG1lBfb3Y7LEJSrdcJlO+S8fd7Rkb06WNgrJgR
	 ay/ZnwnapYoSLuUgTSkGPS+JxKF3LaOWoB4X4EOarMBF2Dn08v0xi/XcGVJLpbKux/
	 WQUvohZMD5yiR0bUxpV8H1G3nTMy++S3UQ/2Pd+ck/rW8RNqagQXHc0XbQbS1gt6Hw
	 /81VLJIr9B0eoJo2U9gupE9E03+alFswUZptocgGmG75ucoqkZTWZqzBRbBVHYCdTK
	 rCFV+YEeCmshnFxAtM6RL07/Ho1mVMs96PeI95eImfSBn8fsnheDUdO93mdvjQZANm
	 R2EVtvw66VFVw==
From: netdev-bot+sinfo@kernel.org
To: "Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 "Vitaly E. Lavrov" <lve@guap.ru>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, AutonomousCodeSecurity@microsoft.com,
 tgopinath@linux.microsoft.com
Subject: Re: [PATCH net] netfilter: xt_recent: do not call remove_proc_entry()
 under recent_lock
Date: Wed, 28 Oct 2026 21:49:52 +0000
Message-ID: <179322419201.3327.14972314584790214914@kernel.org>
In-Reply-To: <20261028214443.47335-1-cenzhang@linux.microsoft.com>
References: <20261028214443.47335-1-cenzhang@linux.microsoft.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
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
