Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EDE2D8399
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 19:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776972160; cv=none; b=oE5CqpsmEqLm4aVWUjrtyjoZcfTIXc0+m5+wBl2c6PYOfejmDSqrPH63GTs+crIWgfTwIJsldyfsxBxzbppKcs7jjZh7qYhPWo4r3MGjFzxF0wks9oZ3OXIN86Ox20hc0w0H1Y53vHBZlh8csJr+36HFVUa2lJxybOmug/ZfQro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776972160; c=relaxed/simple;
	bh=zI/kkJOJfuaZsrfnnoIv0cGU8kd1lq9PH462ThkW+SA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TbENf61rZcG41yYgt6qwt1+5Y3S0lXjrNzPBSh9wv4h9z5PVOR41OzhkFXroOdjiUHE7pXmaVdUrNFzt9xX0e019xpjKXtUAx++ETayXUiHwwpluZuGDM0vkzQ4+JIbFs4I5Y7sUkv9TQG9OMuJU4m+DTYdkDkigns198MbcotQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8CA2C60780; Thu, 23 Apr 2026 21:22:29 +0200 (CEST)
Date: Thu, 23 Apr 2026 21:22:23 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Ramesh Adhikari <adhikari.resume@gmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/1] netfilter: nfnetlink_queue: fix missing padding in
 NFQA_PAYLOAD attribute
Message-ID: <aepxb7oWbcjAvxZ8@strlen.de>
References: <CAC-THR9QmgG9Vnhjw0YQUE=YSZ8GuPi7HbSKW_YA1FnUkDzQOA@mail.gmail.com>
 <aeoHL2ODYU6Xt28h@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeoHL2ODYU6Xt28h@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Apr 23, 2026 at 04:54:35PM +0530, Ramesh Adhikari wrote:
> > IMPACT:
> > Correctness issue - violates netlink protocol. Could cause userspace
> > parsers to misparse or crash if they don't check message boundaries.
> 
> I see no issue at all here.

Me neither.  Userspace parsers cannot call 'nla_next()' unconditionally
as they might be looking at the last attribute.

NFQA_PAYLOAD is always the last attribute in the nfqueue message, due
to skb_zerocopy trick. Existing code is correct, and nla_len must be
the exact size: its end also is the end of the buffer/message.
