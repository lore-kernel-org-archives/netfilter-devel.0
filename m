Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792568444;
	b=BzvRz7M2tP7TvvJykRV+9bI9BlSyeF3CIm+ZZtEHmytooVo3VhW0/eGZDlAKsKFdVEDh
	 tsC561JXUYmOzfDuNa03HRexRp+p+la1zldgFfNHXKMgvggukbfc5L5Tzuyq9knm95UNQ
	 ckUtFNC/HP1d7Ak0R4YN7rCJi0wOy2S0XiH8bfojBbapovUO8gZVRzlZMZSvfnu8LfYE6
	 nIMJOT/BKbIUy/YmciIzVv2uZ1nl62DCJ61ziAZA3WRZFmKLzTMowhUt8gCacZ5nuf9dd
	 GDnZYXRQ2bZpfD9vhfNrd5LdX+4gUwplAZsLG+Yff4YlU2mvHjdy071+afdfrwtp9ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792568444;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=K3XQsUuGg8krj1bv4cgI5VpD5UjDDiUIcgjWoVB86hs=;
	b=kkmyy1GXreWFz6Pozt1dkSGjw81CspfKUY/CECcclItXtV7VBi51EDUjakruqnud79/O
	 ZvpqmW+lqbUfNZZg9RRgLGGkee/DK/R1fHhGio6g21eLBMfguiL3nh3xbMCCxVJIj0ZDi
	 Qlc18u2W53auiB1VvkhucTJeezQ/32FOBRZ+6a3A+CEZITttWI62KW57a/IOBuzmG/TD4
	 EqUeSXDvsSVqd0NeAaSKHg/I6MFFvYRFNRHIDscv0ryNrT0/O0Id5ySRIEbhObd/pYooD
	 nQxr4386tRbemwpWXHIe1a267qZnZTeUcoxJ3GhxSAgnjpqmRqqZTO7pf6LQE1b0qYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1122606A319
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 07:40:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1122606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B89FD60460; Wed, 21 Oct 2026 09:40:34 +0200 (CEST)
Date: Wed, 21 Oct 2026 09:40:34 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Antonio Ojea <aojea@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 1/2] netfilter: nf_queue: limit the hook drop
 flush to the unregistered hook point
Message-ID: <athscka5B9UmNsJz@strlen.de>
References: <20260928185803.335307-1-aojea@google.com>
 <20261016133304.1755951-1-aojea@google.com>
 <atfxlqHrKr3n3Qy3@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atfxlqHrKr3n3Qy3@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Oct 16, 2026 at 01:33:04PM +0000, Antonio Ojea wrote:
> > Is there a chance to pick it up for nf-next before the 7.4 merge window,
> > or do you prefer that I resend once 7.4-rc1 is out?
> 
> This is now in the net-next tree:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=5d1b850ea3f6e6ba2090ebc437e9bbec1d7e5ae4
> 
> according to:
> 
> https://lore.kernel.org/netfilter-devel/atXgURtsFB4UFXES@chamomile/T/#u
> 
> this needs a follow up. Florian, please, confirm this.

Yes, this needs a followup, both br_netfilter and conntrack should
flush nfqueued packets explicitly.

Antonio, could you make such a patch?  Thanks.
