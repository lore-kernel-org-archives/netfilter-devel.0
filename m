Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A78920330
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2025 00:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736814608; cv=none; b=spVVAlP++7TzhUfSzEFM9IEGbkAVkt9sdG+M4wztDpO0L91u2OFci0Pc2gAfQESGZJuowhFqqezjj3mEefEyDinFm6vzBTSARCMPkD8jrlEKRpX0k4l+JKVBiRJjGcFf0xWcc6yAoYIlUmFzfMDwNK3W4FAgphMwr7WwqzzlyyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736814608; c=relaxed/simple;
	bh=hIeyY5zYHEYMvXrwI1lmr+yCc7xFI5/ELGHKeRNLBAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXayb+c1vvIBi4RCwF1xvxuU5NuCh9z4fr7vvRezMbOLpVpXNvcq1uPmC2WeWXkidU1V/B7nuaiUfX/gotXud8ay0gm/TMV4tt6+iK79jcJDZANPrwVssxSoS55sXGJuxZ/7lv/9p7DsVSK5u9XxavWt5d+4uS04v+kSy+/S+bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tXUob-00056M-G7; Tue, 14 Jan 2025 01:29:53 +0100
Date: Tue, 14 Jan 2025 01:29:53 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: James Dingwall <james@dingwall.me.uk>, netfilter-devel@vger.kernel.org
Subject: Re: bugzilla forbiden issue [was Re: ulogd: out of bounds array
 access in ulogd_filter_HWHDR]
Message-ID: <20250114002953.GA16179@breakpoint.cc>
References: <Z4Tr5p19Uoc1UEcg@dingwall.me.uk>
 <Z4WSe2kF_FGbOJp4@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4WSe2kF_FGbOJp4@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jan 13, 2025 at 10:33:10AM +0000, James Dingwall wrote:
> > Hi,
> > 
> > I've been given an account in the bugzilla but on submitting:
> > 
> > Forbidden
> > 
> > You don't have permission to access this resource.
> 
> This is an issue on the server side, would you please provide some
> information privately to debug it?

I can't log in either, just tried.

Its enough to enter my username/password on
https://bugzilla.netfilter.org/index.cgi?GoAheadAndLogIn=1
