Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2C7BA42
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Jul 2025 10:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752573900; cv=none; b=OtaguXsn5+DydqtEksq01gOFACVCOrvRrFt7Mu+aOqbELcg2aaLktz3A7iOtQOUWmvVfI2piu0i1XPpYrzcBT0+esQ1pAO4+awL3uoLe0VeceH+LbiKa1/uQRUwnN3LHrNWQqs7qMTpg8iftagYOPC5s8da1NQdet2jjJdhSZ1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752573900; c=relaxed/simple;
	bh=6Yk/Y/3NBTiie45Ic+oLb6+B+4s2uP+4jO7lnXMH1lU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WeR6xVCubQjmEzYSvx4BrtJdVff1cJOFbMDHSYtPVWvqQD+XQiVOiAY89g8/upECNLp1l3qOvR0k1Wh1+pTUxOg5QDFNZxUF692tGSF5eoYh8YY7IlWkNo3R486/SSXHoDrjadQxvD/SsmM8luFb5Yml8jf0KL55meoCE4U2k20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 43AF660020; Tue, 15 Jul 2025 12:04:55 +0200 (CEST)
Date: Tue, 15 Jul 2025 12:04:55 +0200
From: Florian Westphal <fw@strlen.de>
To: Yi Chen <yiche@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] tests: shell: add type route chain test case
Message-ID: <aHYnxz6VKF8P34f2@strlen.de>
References: <20250715091916.24403-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715091916.24403-1-yiche@redhat.com>

Yi Chen <yiche@redhat.com> wrote:
> This test case verifies the functionality of nft type route chain
> when used with policy routing based on dscp and fwmark.

LGTM, thanks!
I'm not applying it right now to give others time to review, but I will
apply it tomorrow if noone does it sooner.
