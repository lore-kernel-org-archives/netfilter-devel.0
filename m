Received: from wilbur.contactoffice.com (wilbur.contactoffice.com [212.3.242.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5136A13B58A
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 01:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.3.242.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769734975; cv=none; b=Hw2UEZ72TBQE6vwFm1CVzRCzMqYG7RLPdawo5nDDsn5GHj2C7ouiSMoUaAjBnkgXePGs+E3iMYStDdGsMGbeHJY0EqjLf3xbHTL9FqDLh7IBWrj6hKBeu9455cJnhqnrFSozxbRtXFqpDYNjR+prMkoHCkqMh2bXlV9b34Y852g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769734975; c=relaxed/simple;
	bh=YhzWNTJ4ECH0R6xhuEJPy6FvRckMcxZYag8627L26i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llkttJCPbfxv7/2R3U9mQRWuPzyNijLZVXh10IHU0hiNqxyFCNNBFGD2D3rCBAi/6A+iPUMFC8r5ozigVWmBo/qgta+10jo8EWor0vex3QoIk23U1hMdED8Wi9nfheOhngnWE3tDf66mby19qJc+D9GnldU2WDXnL7kS/22fe90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com; spf=pass smtp.mailfrom=mailfence.com; dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b=ndTYWSA/; arc=none smtp.client-ip=212.3.242.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailfence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b="ndTYWSA/"
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
	by wilbur.contactoffice.com (Postfix) with ESMTP id 31D2C482D;
	Fri, 30 Jan 2026 02:02:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769734965;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=YhzWNTJ4ECH0R6xhuEJPy6FvRckMcxZYag8627L26i0=;
	b=ndTYWSA/UZLUI1x+zX3SUEYEcZV1nW85D0B90tyoqKdgkrz4V7RJnwM+YiMU0vzv
	jAvghudpQY6SBo/4iJ4cm9gJT97fOde9mK9+D44iy3VERA7Mfwmd/iVwu74U208vZja
	YEh8pURxUx0igmN1UYIrAbw08vmS5SCXEMlfKCU9X3G17YeTjYXFfVaQIPVtf1Ll3/U
	LKbaiSiplhV/Xrhn1kw5EpQEGig364lbImNpmLvrO7hJ+aN3fT9NFSSYJTlr5jR2bWg
	A0sD9zAqtI9huSmIG1tnYScN/d55CAT9iNGhsQv9EIud9Sy98GH7hkFB4uzVJpV1yVA
	j0CbDcl6Uw==
Received: by smtp.mailfence.com with ESMTPSA ; Fri, 30 Jan 2026 02:02:42 +0100 (CET)
From: Brian Witte <brianwitte@mailfence.com>
To: fw@strlen.de
Cc: netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	Brian Witte <brianwitte@mailfence.com>
Subject: Re: [PATCH nf-next] netfilter: nft_set_rbtree: don't gc elements on insert
Date: Thu, 29 Jan 2026 19:02:25 -0600
Message-ID: <20260130010225.37162-1-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129172842.6310-1-fw@strlen.de>
References: <20260129172842.6310-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ContactOffice-Account: com:441463380

On Thu, Jan 29, 2026 at 06:28:39PM +0100, Florian Westphal wrote:
> During insertion we can queue up expired elements for garbage
> collection.
>
> In case of later abort, the commit hook will never be called.
> Packet path and 'get' requests will find free'd elements in the
> binary search blob:

I ran into this issue while testing another problem. Applied this patch
and the bug no longer reproduces.

Tested-by: Brian Witte <brianwitte@mailfence.com>
