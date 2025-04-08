Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0BC206F18;
	Tue,  8 Apr 2025 12:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116005; cv=none; b=qcQZm5fAHArOwH7RnQjaLNGWpVoqj2KfAihhpEyMD4QbI/LqTozjSBUXv6buEz9ft9XR2S9pmY8VdZs22eTnSERWa/mUmRmZaYvMuFpHQ8r1ghTP9jjpJgZtjFFaqg58aPR7HTCdjZrDwCioPCExnJw0T1o9Bfk45RYcG6gmueo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116005; c=relaxed/simple;
	bh=W2T7YCdGADKb75b9b3DlWwavvOCPJ0/TwhvEwmQo7f4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UYRFFVmUQvWXyDWpa1/oBr7Thb8GZcdeYmcIOSsxMWIj8QIXPOqZJijP9Fh7lpL2HQA44JQi9mZNAwRyCJIcJ/a5eSkvy6jg4hkUuydWD35zCOVP62T74mnbnZF6qGFj/GjTEXkR/OWkYWd4jXvvImzEQnahT3nT+KWzrhhYg3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=TCaZdcmO; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="TCaZdcmO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=W2T7Y
	CdGADKb75b9b3DlWwavvOCPJ0/TwhvEwmQo7f4=; b=TCaZdcmOEC/SZynHAHLgD
	lCdsXB0IaOmQ0WUoOtRqdOPzO1I5js4hWQIu+Hbz3mD9GLipxDvvo7XXlTfdzTg3
	BQsTpn2YVHv021pE9euB414Zfl7soUMKBdIpWkd4xL4L4cjqzZgP4Bx3sh9FcABN
	7peCjWyNPtsstIBc0a+Ot8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDnpgLtGPVneK_AEw--.41217S4;
	Tue, 08 Apr 2025 20:39:10 +0800 (CST)
From: lvxiafei <xiafei_xupt@163.com>
To: fw@strlen.de
Cc: coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	horms@kernel.org,
	kadlec@netfilter.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	xiafei_xupt@163.com
Subject: Re: [PATCH V2] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Tue,  8 Apr 2025 20:39:08 +0800
Message-Id: <20250408123908.3608-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250408095854.GB536@breakpoint.cc>
References: <20250408095854.GB536@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnpgLtGPVneK_AEw--.41217S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw47XrWfAFyfGrWxGw43GFg_yoW8uFW8p3
	yftrZrAryDtan3A34kKw17Ca1Fy393Ar13KF1UCFy8Cay5KrnI9rWxKF17CF97Cw4kCr1a
	vr4jvr1kJas5AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUhF4_UUUUU=
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/1tbiKBMpU2f05gwTsgACsb


On Tue, 8 Apr 2025 11:58:54 Florian Westphal <fw@strlen.de> wrote:
> That seems the wrong thing to do.
> There must be some way to limit the netns conntrack usage.
>
> Whats the actual intent here?
>
> You could apply max = min(init_net->max, net->max)
> Or, you could relax it as long as netns are owned
> by initial user ns, I guess.
>
> Or perhaps its possible to make a guesstimate of
> the maximum memory needed by the new limit, then
> account that to memcg (at sysctl change time), and
> reject if memcg is exhausted.
>
> No other ideas at the moment, but I do not like the
> "no limits" approach.

The original nf_conntrack_max is a global variable.
Modification will affect the connection tracking
limit in other netns, and the maximum memory
consumption = number of netns * nf_conntrack_max

This modification can make nf_conntrack_max support
the netns level to set the size of the connection
tracking table, and more flexibly limit the connection
tracking of each netns. For example, the initial user ns
has a default value (=max_factor*nf_conntrack_htable_size).
The nf_conntrack_max when netns 1 and netns 2 are created
is the same as the nf_conntrack_max in the initial user ns.
You can set it to netns 1 1k and netns 2 2k without
affecting each other.

If you are worried that different netns may exceed the
initial user limit and memory limit when setting,
apply max = min(init_net->max, net->max), the value in
netns is not greater than init_net->max, and the new
maximum memory consumption <= the original maximum memory
consumption, which limits memory consumption to a certain
extent. However, this will bring several problems:

1. Do not allow nf_conntrack_max in other netns to be greater
than nf_conntrack_max of the initial user. For example, when
other netns carry north-south traffic, the actual number of
connection tracking is greater than that of the initial user.

2. If nf_conntrack_max of the initial user is increased, the
maximum memory consumption will inevitably increase by n copies

3. If nf_conntrack_max of the initial user is reduced, will
the existing connections in other netns be affected?

