Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AF9226D16
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 22:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760998854; cv=none; b=DG6I68PhPJg2niclrEyFO0aTL4Ky19PR9j8aTZhzZyLoKTaMdLo86i2mIICCFNZ7aykDsRoKTaToUqGZ3jjCO27Hr1LBc727qhZ6ep81rty7CwuDNdsFwx/mcoTfKLY1Hm8n2Zmv7gs+aPXsSXBs2t9bNYOtNo9L0PI09PNWaYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760998854; c=relaxed/simple;
	bh=yUU482oi/mfX3tYC3PQMRqEt4Rk4+cZSda5ydtC81Bk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sNeeg0+GMqdXnZj6nQO2ZXj/S/sc5plKMXipSjqHwfzEN7zPW0lEYUj3ys3TPJFsh/VeFX8RFqkKP49HVt45lfL+13ueiX0cZbG+r7OPOPoTWU7sB6bnvNQFBSJfS1aOwOSj5Gkjnkoqgj0IHr/ktr8NBwvo61BW8LhuHOkrD9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 39FDF6031F; Tue, 21 Oct 2025 00:20:51 +0200 (CEST)
Date: Tue, 21 Oct 2025 00:20:50 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] support for afl++ (american fuzzy lop++) fuzzer
Message-ID: <aPa1wsoHHKjZ89hG@strlen.de>
References: <20251017115145.20679-1-fw@strlen.de>
 <ddf0bfea-0239-42bd-ba1b-5e6f340f1af4@suse.de>
 <aPTzD7qoSIQ5AXB-@strlen.de>
 <a2686aa3-adc4-4684-9442-ab4ad9654c69@suse.de>
 <aPZGOudKuDa5HMmS@strlen.de>
 <a641ebd1-c2de-478d-bbba-68eaed580fd9@suse.de>
 <aPaA8itLIaGqDoyM@calendula>
 <aPaIepWRL2u1HsLb@calendula>
 <aPauJ9saxZ-Mn3bZ@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPauJ9saxZ-Mn3bZ@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Can this be controlled from control plane instead?
> > 
> > Oh well, you refer to the patch that checks this from control plane.
> > 
> > I remember an issue with abort path, has this been addressed?
> 
> I think this does not handle rule/set element removal with jump/goto
> correctly.

I haven't reviewed it yet.  There are buildbot warning reports and
submitter seems to have abandoned this patch set.

I will review and toss it if needed, this bug exists forever so its
not like we must apply this right away.

If absolutely needed i can scrape time next month to work on this.
