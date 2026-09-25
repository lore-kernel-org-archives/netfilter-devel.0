Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3BA25A645;
	Fri, 25 Sep 2026 14:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790346257; cv=none; b=UIMHwEkwzD/f1dAnxCluBvPUcEE9gL9OnfWZ4bnwlvF/68DU8y6y8Dl9A1H8fyOUffihyxtGdeMCU514erfOVe7OK2nwI4YSrqF5WM7UBNcpYmPcehZhksY+Blju822JqacRtDYu0eo1qLPl0w/TVf6IH8E/6SUrTOw2b+CNQjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790346257; c=relaxed/simple;
	bh=AmOt7srfsN4col0DOnzjyPH6aPF03diVX5dxoLkeOWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KM5HqTTwIna4Nyx84Pzujd3kn6U+mfm7E1OGwzAb95v1lh72wO9uJ0N4J5XDja3CesDDza79DUet+sFeeAzVNFeqjBkBw2F79sBviV9UF88YSbuB7E6msWkJPJi1kDnzTgyDKLlELX4YJB6B5Q8MD8jkk8S28ltDsCK95G+KCdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5OAsv4k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5OAsv4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0C71F000FF;
	Fri, 25 Sep 2026 14:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790346256;
	bh=vULyxcrwIr4KcwQ7oLTDTwGJ+5VC3JzEkmvnLduq6Rc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e5OAsv4kfaqsx2bEEECmBmAtocvm1t1fU1PBSGxMe1aOPtY0e6qPjW5a/8JEI9dRj
	 XFoEfq4JSVmwr+Z/s7DJt/oigiy3wTgYMJJM+m0aL8CGzpQomRxmlUr8g/zBIdrHr/
	 Y95O8CEeWvZw/KyrORyGvk0G+NFjDeg4AY3Td2QQ=
Date: Fri, 25 Sep 2026 16:24:11 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Cc: stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, miguel.gazquez@bootlin.com,
	thomas.petazzoni@bootlin.com, rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18.y 2/2] netfilter: nf_tables: join hook list via
 splice_list_rcu() in commit phase
Message-ID: <2026092556-puzzling-urologist-0848@gregkh>
References: <20260925-cve-2026-52988-6-18-v1-0-680b24895415@bootlin.com>
 <20260925-cve-2026-52988-6-18-v1-2-680b24895415@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925-cve-2026-52988-6-18-v1-2-680b24895415@bootlin.com>

On Fri, Sep 25, 2026 at 09:52:24AM +0200, Benjamin Robin (Schneider Electric) wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [ Upstream commit a6134e62dba2ea4f760b29d5226907f447c92400 ]
> 
> Publish new hooks in the list into the basechain/flowtable using
> splice_list_rcu() to ensure netlink dump list traversal via rcu is safe
> while concurrent ruleset update is going on.
> 
> Fixes: 78d9f48f7f44 ("netfilter: nf_tables: add devices to existing flowtable")
> Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/netfilter/nf_tables_api.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Again, no signed-off-by :(
