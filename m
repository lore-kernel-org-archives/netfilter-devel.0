Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AACD26AF6
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 16:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743437737; cv=none; b=gNrB2IMyqEKSb1YOHSrZbJldL25KS9kkHPZ2PznCvZe253AqiOZLa+HrS86GSQlwjk6IYw16yqW+0I3nyPmF6mUsL0EerBRoEiIm5yOjs3PqJkolJ27W+8bYA5xtPq1MS8tS9HzesEckCY5jnGZC7o9ko6yj35GfcK1PQ3lH9V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743437737; c=relaxed/simple;
	bh=I45q+sPP3YfWTliuZSjrH5JIRfyyHTO5lH2vVibpzDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJKv4UWGJiq2ixcgwq3pasketXuijehKliuAEzpvJJZigUHlMYCtgHOlREtGsS7MxWzyetzXLWuLyIbFoauVhexQxOV6kpzMrebPRyhTa2Pr8nJZhFqGiNGPdZqwFRva/qETZ84DZPH67jm0UL1UjXpf1T5ADsZKHxvAxERW7Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tzHnO-0005cz-Dq; Mon, 31 Mar 2025 18:15:30 +0200
Date: Mon, 31 Mar 2025 18:15:30 +0200
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] evaluate: only allow stateful statements in set
 and map definitions
Message-ID: <20250331161530.GA19247@breakpoint.cc>
References: <20250331152323.31093-1-fw@strlen.de>
 <20250331152323.31093-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331152323.31093-2-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> The bison parser doesn't allow this to happen due to grammar
> restrictions, but the json input has no such issues.
> 
> The bogon input assigns 'notrack' which triggers:
> BUG: unknown stateful statement type 19
> nft: src/netlink_linearize.c:1061: netlink_gen_stmt_stateful: Assertion `0' failed.
> 
> After patch, we get:
> Error: map statement must be stateful

On the same subject of 'do I fix this in evaluate.c or parser_json.c':

cat bla
table t {
        set sc {
                type inet_service . ifname
        }

        chain c {
                tcp dport . bla* @sc accept
        }
}
nft -f bla
BUG: unknown expression type prefix
nft: src/netlink_linearize.c:914: netlink_gen_expr: Assertion `0' failed.
Aborted (core dumped)

I can either fix this in evaluate.c, or I try to rework both
parser_bison.y and parser_json.c to no longer allow prefix expressions
when specifying the lookup key.

I suspect that fixing it in evaluate.c is going to be a lot simpler.

We can't disable prefixes in concatenations, its valid for set element
keys, but I suspect that we can use recursion counter to figure out if
the concatenation is on the RHS of something else (such as part of
EXPR_SET_ELEM).

I'll work on it tomorrow.
