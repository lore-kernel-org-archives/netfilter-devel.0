Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10EF1E0B86;
	Mon, 17 Nov 2025 14:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763389016; cv=none; b=QlHxbM/Ja/qYVPSi+QGhsTc1019hDc8mttdGqa0jpaZO7x/26++PgBGAtYz2od61mWyG6YUpraYR9KOe5/00VWQoqFe0PjN5QX5QtAnSc5h2m26D8RkTH5Lx+s06O1v76Mk8jBx/YXluW9VWtg4RCNcdRIUYo0jeAcKR65K8GUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763389016; c=relaxed/simple;
	bh=iYqpbK+tjN4Z57t/v6+dpfuESBU19HyKtbsiKeRt7Rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=brrTZaev+r8ABG67vqfIBnM0GGOXWPTjdcI30g3GTKfUMtH9AXht3qlCH2jQSnGVCVK7THBnLJIju503N9dBb6xNZ/PoVnHNhWo9QC3dhPTFVIclGog96ImoPn5/FeWJh4XWuiUN+vgPBMBhGkB+lN+iWwP9mHBR/Zd3ARRhCMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 74957604C1; Mon, 17 Nov 2025 15:16:51 +0100 (CET)
Date: Mon, 17 Nov 2025 15:16:51 +0100
From: Florian Westphal <fw@strlen.de>
To: Vimal Agrawal <avimalin@gmail.com>
Cc: vimal.agrawal@sophos.com, linux-kernel@vger.kernel.org,
	pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	anirudh.gupta@sophos.com
Subject: Re: [PATCH v3] nf_conntrack: sysctl: expose gc worker scan interval
 via sysctl
Message-ID: <aRsuU57juCvsMBKE@strlen.de>
References: <20250430071140.GA29525@breakpoint.cc>
 <20250430072810.63169-1-vimal.agrawal@sophos.com>
 <aO-id5W6Tr7frdHN@strlen.de>
 <CALkUMdQmHAoJ8dQGi9qmwOw_MbJin1oKr3rHpH8OkdfkC0XtQA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkUMdQmHAoJ8dQGi9qmwOw_MbJin1oKr3rHpH8OkdfkC0XtQA@mail.gmail.com>

Vimal Agrawal <avimalin@gmail.com> wrote:
> How about we keep only the minimum expiry time out of all (one which
> is going to expire next) and if there are listeners then we just
> schedule gc_worker to that minimum time (and do this only if there are
> ctnetlink listeners in userspace)? so that we don't delay even if
> there is 1 such low value timer expiring in the near future.
> Do you think it will cause too frequent wake ups for gc_worker?

Yes, I am worried about 1k extra wakeups/s in worst case
(we always have exactly one flow which has 1 jiffy remaining).

Plus we might have per-net workers in the future, so it could get
worse.
