Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D92BA31
	for <netfilter-devel@vger.kernel.org>; Wed,  7 May 2025 08:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746608065; cv=none; b=hrH6mA7ImY19X2iCrlQ70NOvXE2QldI0XoBrBwTcrGcQ6cSCCwBRgA6yAz65JnB2kk2OobT/dWqSmOQNLpeNEfMnW9xa4j3XcHLPeo+o1oipuak/ZjKEY2BcsHtlt30HSy+y7l0XPR3n6RpQXZlJzo/KJoIenPKLDomlwIcJqLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746608065; c=relaxed/simple;
	bh=6UKIvagpRYysVkV+d9XN6Migmpt7bLNVBqdojdNtSx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QETvD1PMLFpWYNDBaM/JUjwL+296fVk5uh/t8RP+E8Y61t7rJBDr185MPn2RCDwmjMfZgBJ5nZifhfwjGniPHYvMKXQeXo7Seb52rbVi7A9qii7SYa6W6HrVE929mOfHwSWWErGLDraJVOayyKYEmAqeRK8eyH9OjHUlzHV7ybU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1uCaXk-0001n3-2a; Wed, 07 May 2025 10:54:20 +0200
Date: Wed, 7 May 2025 10:54:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] selftests: netfilter: nft_concat_range.sh: add
 coverage for 4bit group representation
Message-ID: <20250507085420.GA6009@breakpoint.cc>
References: <20250506130716.3266-1-fw@strlen.de>
 <20250507105206.04eecc5d@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507105206.04eecc5d@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)

Stefano Brivio <sbrivio@redhat.com> wrote:
> I hope you didn't find further matching issues with this, but surely
> the new tests are better than hoping...

Tests pass, the register-tracking debug patch finds issues
but so far it looks like bugs in the tracking, not with matching.
