Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98EF422542
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2026 13:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784206964; cv=none; b=aVQzywXlY+aA4FAof2N+zlPY+BFHgDPbwchHnQR7dx1wdjQegG7EJM1hyRvPWGDKhCKeF0omj4kgoBcifs0jYwJO1n0Vs9nXUltqm0uRvX7shrxilkZk/IzgGi3tNRm+gsyBE5WP0w4U3cpdy+/YrbDp1ypbKvgJC9h0N1k0S4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784206964; c=relaxed/simple;
	bh=Re/Ziuc2K4TywsoWO+HBnSsNLRQQvkXuUZFnJkTzdWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6LftFF2vDFO9CiT4ZgHBDcPzyu7tV5ixN+kWUt5rLSMKocB2DOipUExAtSTHuvlDC4PJ22WIXWfEAip2ZXWG93yw5xFGNjNYYsPwhpJKfj+mPSPr93YpSTFeOM6Oss6OLAvuGMszW+sINYsRysOQJVWuJU3NbOxVKX0wpqlHRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2E72B60613; Thu, 16 Jul 2026 15:02:36 +0200 (CEST)
Date: Thu, 16 Jul 2026 15:02:35 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Cc: kadlec@netfilter.org
Subject: Re: [syzbot ci] Re: netfilter: ipset: convert to rhashtable
Message-ID: <aljWayNyma1hMSoW@strlen.de>
References: <20260714131828.10685-1-fw@strlen.de>
 <6a5720b2.c90005c7.37d349.0042.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a5720b2.c90005c7.37d349.0042.GAE@google.com>

syzbot ci <syzbot+ci0695f40f43c0e2d7@syzkaller.appspotmail.com> wrote:
> and found the following issue:
> BUG: sleeping function called from invalid context in irq_work_sync

.destroy will need to support schedule for rhashtable sake.

I made a prep patch to convert from call_rcu to rcu_work api, this
will also allow to move cancel_gc back into destroy callback in
a later / future patch.
