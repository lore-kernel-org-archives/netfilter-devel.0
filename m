Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782CA81724;
	Sun, 15 Mar 2026 01:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773537830; cv=none; b=Rr+2/ZW05ACMl0mph0tAvUjHfCcwrQtr3Rz0indddxAThsQHD+pGU1782t2wADbNwgL128aUtcaT9dOcCQaubmgm7iPmjvN4MZ7Zqa2lh1Jzqpk9QFzo0WvvjQXWo1nr0UrHWkeim+IHwzG2UInhWyLYPnUxQMO9e7lYwlTW/+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773537830; c=relaxed/simple;
	bh=Zx/eaKzR8bD4ty14wh/bXpGxxxhRt2BR2O6nxbMASR8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=naInCtOJNATeR7m+oGDWOWXi30a/NxCSxny4q7GW7rAXw7ltMsLsw2wK1dG9W3JBTl/rT+68y7yDKRwDCJcmqJJ+q03V9DJvchB9GvUhpGpk+Z+84ERtZ4B4Py4YsBiAQePIbQ4FL8XsBsUOrJw5UwEEnm7fmN6sPEPqatRdqik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+FmiUCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+FmiUCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8B9C116C6;
	Sun, 15 Mar 2026 01:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773537830;
	bh=Zx/eaKzR8bD4ty14wh/bXpGxxxhRt2BR2O6nxbMASR8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=W+FmiUCFaNqUzMQN+zH59URBSugW/UyqrcR7k9iI358ZQBAZg9wdA/2kSfF2zklUw
	 /mpITEtKYxecZmcD3x1zVuPsIgNk4X0+PSqa0XVvdME06VeuGE45UydsV/llJoyU0g
	 VnBYoXv/U0+6WUVNDYJY7C92i0GLK0e+aJQa9zEeZTM47d3XlkM4Sf1LsrTXvmtIIt
	 jYA1eA+4zVmiMTYVpDwbYw5izGTsTMl9X5+Ja6Uz77E4+c+H0L45kfhc8QEWwQ13kD
	 2bBjPy2ehamfs3p23DD8jP1Dig/aJ4O4BmYsXRIDLvzI8LqOF9pld9md4gprzQl988
	 +BbE2CE4erukQ==
Date: Sat, 14 Mar 2026 18:23:48 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Guanni Qu <qguanni@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, edumazet@google.com,
 pablo@netfilter.org, netdev@vger.kernel.org, davem@davemloft.net,
 netfilter-devel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [net,06/11] netfilter: nf_conntrack_h323: fix OOB read in
 decode_int() CONS case
Message-ID: <20260314182348.492f2240@kernel.org>
In-Reply-To: <CAFzOa16enGosPApaXYmypkUb8JK=SMsvi2XMSrDP+DShm=GMLQ@mail.gmail.com>
References: <20260313150614.21177-7-fw@strlen.de>
	<20260314161236.2454291-1-kuba@kernel.org>
	<abWph_Nu9TBQ4r6I@strlen.de>
	<CAFzOa16enGosPApaXYmypkUb8JK=SMsvi2XMSrDP+DShm=GMLQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 14 Mar 2026 15:16:37 -0700 Guanni Qu wrote:
> Confirmed, the AI review is incorrect on all points.
> 
> The UNCO, SEMI, BYTE, and default cases all advance bs->cur without
> a pre-read check, but each has nf_h323_error_boundary(bs, 0, 0)
> immediately after (lines 358, 410, 483, 512). The pointer can
> temporarily overshoot bs->end, but the check catches it before any
> subsequent dereference.
> 
> The CONS case my patch fixes is different: get_uint(bs, len)
> dereferences *bs->cur++ inline (lines 258, 262, 266), it reads
> 1-4 bytes from memory before any post-advance boundary check can
> fire. That's the gap the patch closes.

Thanks for checking / sorry for the noise ;(
