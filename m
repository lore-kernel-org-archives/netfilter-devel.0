Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA51D17A2F0;
	Fri, 31 Oct 2025 23:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761954600; cv=none; b=hYAmJli/dGJMCTz60tPd77XHflY38G3GyXT03pvQ6mc+jwo1S/J7/Np/rqfeGF8SrMkzWdpV9WlOzgOuiZn+3n4QBkcRJbfDChxZkQ5Gjc9dh3XHu/4B79v9mSDG7Q5ha/HUHE+564w7wuCz8dhvmofXs2llta3VYAR1pCAEIRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761954600; c=relaxed/simple;
	bh=nZX5tS1tXPuRCqWFG9SL8xYo5+hc5KgXS1X0YbBBRss=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FN9gZcgD6mGtZ9VUKfdH02T2jguLR5ipE6a0SPu6SSOwk5nsiHq0Nlwh0lA9wO7fA42EIB1xx3er/1kZhEAPUSNRCZLmH3VTC9tcf8/dH86LLFN/EQY1xqhXaoOiZCrSc/2h33lOJKqxPwhSLeY4Ia7pVIAPrV36zCMMDLHrGl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a6WdUmFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a6WdUmFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEADC4CEE7;
	Fri, 31 Oct 2025 23:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761954600;
	bh=nZX5tS1tXPuRCqWFG9SL8xYo5+hc5KgXS1X0YbBBRss=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=a6WdUmFBFKmM+JCCebjFrJuP1xMmII6iRm5IkJNoy+adEsXtj0qPDpA2qlxhsJHJj
	 cHoXbDj9fX34mwRDxdvmKS1+S9kvoIf0PnjqppdoQZLmgOsVmW4iDZaUla7hSINST6
	 037T5d+PjPBYt+ua+AecXcPmDLuqKsPiLxmHi3SP5T7KwjoILe1TDRUgVxBv8plVHd
	 xCdde+QdHm0B9nlkOC7Yb0mCWwABgvnbex7S956Gv1gDX6PPB9UKaOIJ43j66d+u+v
	 EkyHENe1rgYyXTeUYhOQa5hnVjxjKVngVL8YkRkTtVtPnKrIm9progavEgqtlWU4kQ
	 lZhJh6PeQ/lBw==
Date: Fri, 31 Oct 2025 16:49:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Raag Jadav <raag.jadav@intel.com>, Pablo Neira Ayuso
 <pablo@netfilter.org>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de
 Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>
Subject: Re: [PATCH net-next v1 1/1] treewide: Rename ERR_PTR_PCPU() -->
 PCPU_ERR_PTR()
Message-ID: <20251031164958.29f75595@kernel.org>
In-Reply-To: <20251030083632.3315128-1-andriy.shevchenko@linux.intel.com>
References: <20251030083632.3315128-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Oct 2025 09:35:53 +0100 Andy Shevchenko wrote:
> Make the namespace of specific ERR_PTR() macro leading the thing.
> This is already done for IOMEM_ERR_PTR(). Follow the same pattern
> in PCPU_ERR_PTR().

TBH I find the current naming to be typical. _PCPU() is the "flavor" of
the API. Same as we usually append _rcu() to functions which expect
to operate under RCU. All error pointer helpers end with _PCPU().

I don't feel strongly so fine if anyone else wants to apply this.
But I will not :)
