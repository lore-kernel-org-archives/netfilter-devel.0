Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F133818B499
	for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2024 09:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729935551; cv=none; b=Y+A/+2Nu3/voi9eItbfNGJU/1I07wnfqnewsNO1HfWT3uGmjw9lDmthFZNwCHDsP/mBUKabYO8P0MnKN3zCSD9fao0a3+iY71/fDIq6ezgGnAuJFjZadZ8h+W5OHKEcrqc59bK17yhPKF3Yh5y6QYLL2n01K0vsn7K+wPEUW7e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729935551; c=relaxed/simple;
	bh=Km2x5SY5WRKTkOOWcmACPRLB7QEMBOIhwArVG4dsirc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xuo2Co3xwWaFhoiZhKA7+vkkw/3NsgAflZz1oZxwQ+OYOweZM8FWNcXPm0TeLinA4/ANJTlzjazpBigMd+fEqRBz9na8HIbw7XGK+OfIu0521YJGEBtdGf61Ex3XoqqBJ6ehEdsl0QTiS9BK1OAE/kJqY0HiISx9OqIpGxKnGS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t4dGF-0007Z8-7P; Sat, 26 Oct 2024 11:39:07 +0200
Date: Sat, 26 Oct 2024 11:39:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 6/7] netfilter: nf_tables: must hold rcu read
 lock while iterating expression type list
Message-ID: <20241026093907.GB28662@breakpoint.cc>
References: <20241025133230.22491-1-fw@strlen.de>
 <20241025133230.22491-7-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025133230.22491-7-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> +	if (!type->inner_ops || !type->owner) {
> +		err = -EOPNOTSUPP;

This is wrong, we need to reject the opposite, i.e.
if (!type->inner_ops || type->owner) {

NULL owner means its builtin, and thats what we can
support at this time.

I will wait until Tuesday before sending v2.
