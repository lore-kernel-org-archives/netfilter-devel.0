Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F783AF676;
	Tue, 10 Mar 2026 13:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147752; cv=none; b=qab03xdwsfKRlmWvDfxNDAQncjskzipkN1zlJNIsE6F0XTff8CTSzI90ObjEaA7pjTf51GPeoZjHbuWya7VKqBrzpiVFgTMP1l0FnAjib9G6IymhQSqkR+zLGtF19WeelyrW3AWmYpxe78kOJuxtLE4HYgXXAl35xZ445c0gP0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147752; c=relaxed/simple;
	bh=afRCAYoGeuZHemp9YAFSF1Yx3hea9mFsyXp4q3q9M7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A4zr5q1K697w09i0sVBSQtddesu3TSaJ/cO38VJkvY9IoOs1Zhsj1O4gRMHXxety8Q5ym5e+Z7NzYjs8BlFLYI5SULku/g8qQUUg1q0LySuKQhhRLTUaZjNKDOqtQNBc96jG6J5NkMEEbOFOTzk577ABtLzcE8u+cISY5vA2vh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 09B956052A; Tue, 10 Mar 2026 14:02:24 +0100 (CET)
Date: Tue, 10 Mar 2026 14:02:24 +0100
From: Florian Westphal <fw@strlen.de>
To: netdev@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net 00/10] netfilter: updates for net
Message-ID: <abAWYL0Jn8yh0osI@strlen.de>
References: <20260309210845.15657-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309210845.15657-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:

I am withdrawing this PR, will send a v2 without patches 7-9.
Expectation infra is very broken and has design issues that
need more work to resolve.

This sucks, but I'm out of ideas.
