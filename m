Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3A4380FCE;
	Wed,  8 Jul 2026 14:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519633; cv=none; b=t4es52mms1vJ4a3b9rlNg+s+yYsqNHgN3v/36iDmuXi8KNaZtqIc3R+2bIhfnu/yZ2i6Kt4ee0Yv0845aT3s4CurqXJn6xSy1jdVvDi++7pY4LN+jnRvyXLXb8qXiT/mPfH9Sv+epl3TBR+D2P9YL4yPunuFHx6vwHWBHuYwhHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519633; c=relaxed/simple;
	bh=O5vhrXD//CdCW3GRndVtoG/T03EbREdTGHTbE0SorTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHV0XGGh89jCOzZ8CbpOCkwrZmBWHK9kGjhCK6O7EKAKUNFsYMbzvX2IgvCdRnyOgjFGYIQC4h6GgDt54+GkmGHk4f39/4x47YhkEjpwcW1ClrMuNj/OaIYuhFLDbvGUShgs66T7wVx981H2K7en67iFMI1m480OMgtkIlDWVGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=y2yIlIxd; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="y2yIlIxd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=Z6OwcHjGnPVZnFThOc0FM6ldsN6O58E7FKit7r1HTQw=; b=y2yIlIxd5qPqJ3SGXBVE5DNCiC
	G7J7cVQqk1Pj/7JiDZiu3R8fl364ct4VkwSmNJTXOn1T8e2klZ2mGAPH6Q7N8jqws7zwrUcbx07In
	FsmZYcS7x4+DQ0WIXI128EujSWdO/dSXJiZRD5ycFfF+0NYhmEB/Xsl3iJQR+7bR+Iyg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1whSvc-00BKQd-8B; Wed, 08 Jul 2026 16:07:08 +0200
Date: Wed, 8 Jul 2026 16:07:08 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Yuan Tan <yuantan098@gmail.com>
Cc: linux-kernel@vger.kernel.org, workflows@vger.kernel.org,
	jhs@mojatatu.com, gregkh@linuxfoundation.org, sven@narfation.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [RFC] VEGA: a syzbot-like workflow for LLM-found kernel bugs
Message-ID: <b392a243-7fc2-4fb6-a264-ba1e01891e30@lunn.ch>
References: <20260708092247.4188498-1-yuantan098@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708092247.4188498-1-yuantan098@gmail.com>

> The rough idea
> ==============
> 
> VEGA would have a public dashboard, similar to syzbot, and would
> send selected bug reports to the relevant kernel mailing lists.
> 
> The goal is to send reports that contain enough information for maintainers
> or other developers to pick up, understand, reproduce and fix the issue.
> 
> For each public report, we expect to include:
> 
>   - a description of the bug
>   - the tested kernel tree and commit
>   - the kernel config and environment
>   - the crash log
>   - a minimized user-space reproducer
>   - the suspected introducing commit
>   - a suggested fix patch

It would be nice if you could try to parse the git logs for the driver
and extrapolate its age, and if it is still being actively Maintained
by somebody.

We see lots of LLM generated patches for theoretical bugs, mostly in
error paths, for drivers which are EOL, and it is unlikely anybody is
still using the hardware. Such patches waste Reviewer/Maintainer time.

Maybe even make this part of your triage process. Prioritise issues
found on newer, used drivers, over old likely unused drives.

      Andrew
