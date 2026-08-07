Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F84397B1C;
	Fri,  7 Aug 2026 10:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786098234; cv=none; b=C3ny/8jcbr818BVxvnpDm8v55AnI9FJaZmq+WQN/phTwd6Xw+0WNVRr86dAO34wKGc/I/L9dPJMMNp/qPINm8kJyS4Bffyg/fh8LdobmwO+ymDqUsS9Ra6BbZlWeCEXzrhRZdspnUUwQ6GcLBSSeFMRmMJH0jTiHup5qLoXgYUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786098234; c=relaxed/simple;
	bh=bIjsHrwrh5cGKWtGNy+OBCSSmpd6L7S7wDE2PEYU/7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A2F4OKMaw5+ngjFwWTvE3oxPebAWCkA/gCyjVoeaaRKpluVCIv1Dj5JSzAJhbpGezYMI/gqofsJG33XIZ28CbutQKnvZSIrft4muOgwqrFVuKQgiNeq6tX313lnM8hqJd9S/QTtViRT+5i+yJ3xBQ5Ojnngqq3lAIGNGBHPYM4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Cj/E7RoJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Cj/E7RoJ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 53E3D60192;
	Fri,  7 Aug 2026 12:23:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786098228;
	bh=vT5puZXX1TYP7PjTvIrBrI5uYYQP6KI812jYIqWywPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cj/E7RoJYtYfQj6ZTc5DgK47kMe4cxNMTBRLsbCMb+0Nefih1/J0mJKAscbb8SKYR
	 JjdewAMGN4yAo6o/hptvNexeB/30dTmmM54rR4+RASZ6JklxFg82Ld674BK9tl9f8s
	 yTkNPPgBLN5IYmkJ8/2b0qRvFhsHP5YUeNgpWAWZR0DS/NYhNM4/T+O6m80Z7ewwlG
	 8Z756J2MWOY3itz0kYyvqN0bMB5UxCY/t6ryJWGOl1r952nAcJ/fZ5qLt4t+LpPhIh
	 SioUfUfsB5Wv6P9vzt05vf2E3+R8dUA69OHl3RFk9Elwu5v2oS8B34nk8cY/wqE8Ku
	 XUgFX68P/JdsQ==
Date: Fri, 7 Aug 2026 12:23:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hangbin Liu <liuhangbin@gmail.com>
Cc: Qingshuang Fu <fffsqian@163.com>, Florian Westphal <fw@strlen.de>,
	davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: Re: [PATCH net v2] selftests: netfilter: conntrack_dump_flush:
 remove unused variables and fix typo
Message-ID: <anWyMUFvONx6k1d5@chamomile>
References: <20260807075928.64326-1-fffsqian@163.com>
 <anWgQSbZWK6D2ONg@fedora>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <anWgQSbZWK6D2ONg@fedora>

On Fri, Aug 07, 2026 at 05:07:13PM +0800, Hangbin Liu wrote:
> On Fri, Aug 07, 2026 at 03:59:28PM +0800, Qingshuang Fu wrote:
> > From: Qingshuang Fu <fuqingshuang@kylinos.cn>
> > 
> > Remove unused 'rplnlh' in conntrack_data_insert(), and remove unused
> > 'rplnlh' and 'nest' variables in conntrack_count_zone() and
> > conntrack_flush_zone(). These variables were declared but never used
> > since their introduction.
> > 
> > Also fix typo: rename misspelled conntracK_count_zone() to
> > conntrack_count_zone().
> > 
> > Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
> > Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
> 
> > ---
> > v2:
> >   - Drop Fixes tag as this is a cleanup, not a bug fix
> 
> If not a bug fix, you should target to net-next.

We will handle this though the nf-next tree.

Thanks.
