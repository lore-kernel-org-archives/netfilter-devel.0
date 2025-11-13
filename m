Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE8D357A31
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 17:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763055886; cv=none; b=qNJCcexX77d11pBdoYO1QBuVCA7t7gifz2uhXJ1eM3UqaojVr7TfDJunPSb3uyzNnmCq+JHM8aXnUNtpYJg2Xuxtyu5KnMBMWWFfEJe+/lSZKTpLNAbi6s+6kmbUg1QAc7+Ys7MgU7UKgg2Wr/fQ+4rdaUMRFrY7wXo6ncW4McU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763055886; c=relaxed/simple;
	bh=F59iHaLVlGXUBLHLMfCK4CLJvoNZzUlDIzXrN20PFe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=syRBkMOjIBNsChedDzZnfkbIctvJdgUVdEh6ZKADrFTuO20G1xlS8P6OOvGzh+COgemn4452l+HfBUxWRD/SZCQIgpRV9GHzJikCBCYfBifEDJLObiBRhx03pm+6W8iyZWQ+1lulX/Mg29VWKW6/uGMCIvKJxz09WLqET88f5Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZZPd5vfn; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZZPd5vfn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=46pFG5QRm6VtrrlNxZoI8MmKgzoxbdz6ftRChNim47A=; b=ZZPd5vfnQLB37hu6VfjQtwRFck
	db/STuzT0E1IxHgBhR+Xhbc5uGe8DD6l5uBlAFm50T2RsxfCumt6iFxayaGDFVfasPC2fkNz2zMTt
	V8XdfvVykW1aV+2vrAiQ53zygyQKNF8vnVqLh8xKU90+FQ8wefgC2Tadl8uSTPz0C0eqRkH62ITVg
	bpAI6oz4iCIXX6Yj305wfQh11+tZgx+XMfH6A3R+CfAIzr4o3duvhTK5z9gn9JwyMnaiVRr7INMA+
	R5kGuTn/j0E+syWQ874rJWpxYeBKGd3mT9sBPzYs2jFmrsgu9zY3dv9WXlsW9ju6JZiuUtPMwXZbv
	GpguTkrQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vJbN5-0000000031p-1AsB;
	Thu, 13 Nov 2025 18:44:35 +0100
Date: Thu, 13 Nov 2025 18:44:35 +0100
From: Phil Sutter <phil@nwl.cc>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf v3] parser_json: support handle for rule positioning
 in JSON add rule
Message-ID: <aRYZA6M9lVLyBZ5l@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20251106083551.137310-1-knecht.alexandre@gmail.com>
 <aQxwwwlTFj12H8TN@orbyte.nwl.cc>
 <CAHAB8WyP-eD-v+zkO5xuNYRwkQyNTwwYhZ2j7+WMDj+-SJ19Eg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHAB8WyP-eD-v+zkO5xuNYRwkQyNTwwYhZ2j7+WMDj+-SJ19Eg@mail.gmail.com>

Hi Alexandre,

On Fri, Nov 07, 2025 at 03:19:27PM +0100, Alexandre Knecht wrote:
> Before submitting v4 for JSON handle positioning, I wanted to share
> the design approach and get your feedback on whether it looks sound.

Sorry for the late reply!

[...]
> Questions for Review
> 
> 1. Flag approach: Does using CTX_F_IMPLICIT seem reasonable, or would
> you prefer one of the alternatives?
> 2. Expression mask: Is CTX_F_EXPR_MASK acceptable as a fix, or should
> I refactor to separate expr_flags and command_flags entirely?

Yes, CTX_F_IMPLICIT is a good idea and CTX_F_EXPR_MASK the easiest
option to avoid misinterpretation of the new flag bit.

> 3. Test coverage: Are tests 0007 and 0008 sufficient, or should I add
> more edge cases?

They seem more than enough to me. Extending tests to cover for newly
discovered cases is also not a big deal, so no worries here.

> Ready to submit if design is approved !
> 
> I have the complete patch ready to send if this approach looks good to you.

Cool, looking forward to your patch!

Thanks, Phil
