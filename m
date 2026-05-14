Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4C9367298
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 10:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778754239; cv=none; b=sBa9yLqoyDEx7DqwX48Z3Kmbd7Z1n+0gJw0ExNB1RhCWcwHEWRkg+m8Qb/e5w7rGV6uKYK/srLjtQfGjzftwTe4KHXWPRsrvnEvZtfVRphn64VrOW/NuvkNtrlxG5uUsioaSDR5KebNBz2w3nWb5w2f4PyXyT6XJ9fp/15IEqu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778754239; c=relaxed/simple;
	bh=yGYpu2Et1dPvI7HYRxf/Z0bQqMUkfcUrnmr2qle4p+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=actIYhrulYXQcbrK7MyNEeg7UyFYaJvhdQvg3y2+YpS3wbHuLw0M3Fy0er+Eizjf7Jvr+L5ShCLo7je7vF4t1EwZXx6WPEjDmhmKjqBgtNrZ8VwftzkTPZLlFHJ1hkWjWJIKWeDbCiozvc3SJDvI6G2baE4IdfnItYdaFkjFBtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 291C06099C; Thu, 14 May 2026 12:17:54 +0200 (CEST)
Date: Thu, 14 May 2026 12:17:53 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	luciano.coelho@nokia.com, kaber@trash.net, yuantan098@gmail.com,
	yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn,
	royenheart@gmail.com
Subject: Re: [PATCH nf 1/1] netfilter: xt_IDLETIMER: scope timer reuse to the
 owning netns
Message-ID: <agWhUUyIy4JZlVlq@strlen.de>
References: <cover.1775353240.git.royenheart@gmail.com>
 <9c5661fad291777d8e998e23f3cb27cac37aa607.1775353240.git.royenheart@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c5661fad291777d8e998e23f3cb27cac37aa607.1775353240.git.royenheart@gmail.com>

Ren Wei <n05ec@lzu.edu.cn> wrote:
> From: Haoze Xie <royenheart@gmail.com>
> 
> IDLETIMER keeps timers in a module-global list and reuses them
> solely by label text.
> 
> The existing rev0 ALARM guard avoids the panic when rev0 reuses
> a rev1 ALARM timer from another netns, but it still lets same
> labels in different netns share the same timer object and the
> same sysfs entry.

Isn't that by design?

> Track the owning netns in struct idletimer_tg and only reuse
> timers when both the label and netns match. For non-init_net
> timers, derive a namespace-scoped sysfs name from the netns
> inode so non-init namespaces no longer collide in the global
> xt_idletimer sysfs directory.

How can that work?  How would userspace daemon relize that the
name has changed?

> This keeps init_net sysfs paths unchanged for ABI compatibility
> and preserves same-netns label reuse, while preventing the
> cross-netns timer-object aliasing that caused refcount, expiry,
> and teardown interference.

I don't think there is a bug here.  Two netns using same
files having same sysfs mount should naturally "conflict".

Maybe one could make a patch to force-detach an idletime
in a non-init userns if init userns asks for "foo" that
is already claimed by different userns (to avoid the "Dos"
angle).

But I'm not sure its worth it.
