Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C2D12E57
	for <netfilter-devel@vger.kernel.org>; Sat, 16 Dec 2023 10:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rERe1-0008MI-HO; Sat, 16 Dec 2023 11:11:41 +0100
Date: Sat, 16 Dec 2023 11:11:41 +0100
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/3] src: make set-merging less zealous
Message-ID: <20231216101141.GA23061@breakpoint.cc>
References: <20231213170650.13451-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213170650.13451-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> I got a large corpus of various crashes in the set internals code
> tripping over expressions that should not exist, e.g. a range expression
> with a symbolic expression.
> 
> From initial investigation it looks like to root cause is the same,
> we have back-to-back declarations of the same set name, evaluation
> is returning errors, but we instist to continue evaluation.
> 
> Then, we try to merge set elements and end up merging
> such a 'redefined set' with an erroneous one.
> 
> This series adds an initial assertion which helped to make
> crashes easier to backtrace.
> 
> Second patch adds a 'errors' flag to struct set and raises
> it once we saw soemthing funky.
> 
> Patch 3 also sets/uses this when evaluating the set itself.
> 
> Alternative would be to make the lowlevel code more robust
> of these kinds of issues, but that might take a while
> to fix, also because this oce is partially not able to
> indicate errors.

We need to rewrite it, its too picky:

nft add rule t c  ip protocol . th dport { tcp . 22, udp . 1  }
nft add rule t c  ip protocol . th dport { tcp / 22, udp . 1  }
nft add rule t c  ip protocol . th dport { tcp / 22 }

In particular, there is a lot of strange code that causes
this to be evaluated in very different ways.
