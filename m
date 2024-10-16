Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAAB20F5DC;
	Wed, 16 Oct 2024 16:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729096474; cv=none; b=dkjyM0imyrJnW1r3a58I602YK1QT0kwmZHaIjPYf9w2FTcQ0Sqj6SNOmF7OBja9+JlewNj45I1Tx3WLBrim15lyLa13O13mPq5cGdjUnutxI/OmQxLjLb9APPqW5qU9w42Ri1zMKMK8mWpyBTegku984OU7waTTFR86Y2oeIm80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729096474; c=relaxed/simple;
	bh=vI1JDS+I2I/+UNdsQnivzPnw3lB0zMrKhTjQ4Yyhb+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ACUgNRI4phTW9nssvzyVLsK74nblPY6enUl0+M/d5XK+IB3pv6pKIvh5unAuEm+hyyTNQqL2uPJ4XtqBHlB71LraPvIWklZTBvE4h0YsWsDT5bmVqgRaCvUB6uVgMX6hDfp8TTyB760RCRhhrMW2JZL0wHp6eVKKkMqcwSd8AbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t16yg-00036e-P4; Wed, 16 Oct 2024 18:34:26 +0200
Date: Wed, 16 Oct 2024 18:34:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Rongguang Wei <clementwei90@163.com>, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Rongguang Wei <weirongguang@kylinos.cn>, kadlec@netfilter.org
Subject: Re: [netfilter-core] [PATCH v1] netfilter: x_tables: fix ordering of
 get and update table private
Message-ID: <20241016163426.GD6576@breakpoint.cc>
References: <20241016030909.64932-1-clementwei90@163.com>
 <Zw_OXzBgfFULaEzs@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw_OXzBgfFULaEzs@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Oct 16, 2024 at 11:09:09AM +0800, Rongguang Wei wrote:
> > From: Rongguang Wei <weirongguang@kylinos.cn>
> > 
> > Meet a kernel panic in ipt_do_table:
> > PANIC: "Unable to handle kernel paging request at virtual address 00706f746b736564"
> 
> This patch is no correct.

FWIW I do not understand this fix either.

I applied it and at least on x86_64 generated code is identical.
Can you show objdiff on your platform?

Maybe that gives a hint as to what is happening.
