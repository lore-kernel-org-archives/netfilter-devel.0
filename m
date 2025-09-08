Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A952FB99C
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Sep 2025 12:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757333036; cv=none; b=SBpiXvg88+DS5ayPmfLV2HWkEeQyFOU2jGYWqwO0uQ2orb/SZ2DAAThkhBTTK+YFHxULXksvYxOb8MQO8w8kj84sKA1NB+UdCxnEZo1ajbrdvida0Y4Ss1Au5oWNERtB8SSTAaiu0NwqhL/IoXVlj1cgmaGNDcZmwm1tnO0gzNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757333036; c=relaxed/simple;
	bh=M4Pk5ITObM11gZktWDaunT79kzlZDAGSB4HC5nrnGVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r6q34I/HGnT0AOJ6/Gjr3dsplwBcalK/hnrhJXWwXbTiW76YqrcmO4bkHinF73NEyWaX/eFZhVZwHm+JdAJLkTubv6xcXAlWClWvQabIxMP7c0sJoZVHu0uBkGQDTOeCuzwzpywkZAyb7MNDmOtB2/NRAMMMQhFJ8Qhzw4xTc58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=arqXOGfa; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kKMKklMx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="arqXOGfa";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kKMKklMx"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 70E8660718; Mon,  8 Sep 2025 14:03:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757333032;
	bh=r2cfvtSFRfk1UxBI0Wi2SJIWQ6LLaCtojF6oAMK2RDs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=arqXOGfa9hdxCYZQZsTzGyG8ahoDpA9oRW7oJvLaUO5PBa0IiO9S/xBk/23sRgyc5
	 1jvPRTycW6MyfST2jY60sk3c9btcyx0Z1AJ7YPPgdeurwB5gKiw5YIjJk/XnOXG960
	 grq7G407rZbmjjuT3qPOYcO1fB6+m+mq0IYvo2gzPWc8aTna6JGgLA39gcknDsttiD
	 lTEPifSwf7SO0O0nx/kqt9ZDNJlG0mSL+1hzrMzmhPkrLqRWa7FSBp2tGbfJnNcWmT
	 QNRwhw9KBI4l4Gp93uC1EL314ggFBsHnL9SGb5YrLQmZEC3H3L1KEQzPT827HfFLn+
	 JurbpVNK9iaUg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6ECF960718;
	Mon,  8 Sep 2025 14:03:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757333031;
	bh=r2cfvtSFRfk1UxBI0Wi2SJIWQ6LLaCtojF6oAMK2RDs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kKMKklMxbDp5s8CSlcdmQWDmKmKRbvX1kDNeSw1sF/xI2fBJ6d7KcvbBlmpkU+wKv
	 WrS8887DO4sInBIwsXG3IpiLcV4SYmzu+MgkY0td8hxOogjRzCc27+oFkKCZgQmHgl
	 X38RztLw5a/EOZTdk4nCkov0OeiMTUHzPq7U6DNJTwML6mokAmet6nekTRSuE4WF8j
	 OTOtG9SGHGy62uxjpPrbiEQGzlLA+hCugsc5KWLcw22x/ccwH9qyl/bGNvn+S41KG6
	 Wm13qmRRLqPh++fHlGmxoHr5nCXbydXpoMfk0QGnWq/PQIrjWwbA8D3iQ0lGlH56UP
	 nDXfFFZqde19A==
Date: Mon, 8 Sep 2025 14:03:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
Subject: Re: [nft PATCH] table: Embed creating nft version into userdata
Message-ID: <aL7GEObOxcH1z4Rb@calendula>
References: <20250813170833.28585-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250813170833.28585-1-phil@nwl.cc>

On Wed, Aug 13, 2025 at 07:07:19PM +0200, Phil Sutter wrote:
> Upon listing a table which was created by a newer version of nftables,
> warn about the potentially incomplete content.

Compilation breaks for me here:

In file included from src/netlink.c:13:
./nftversion.h:6:20: error: 'MAKE_STAMP' undeclared here (not in a function)
    6 |         ((uint64_t)MAKE_STAMP >> 56) & 0xff,
      |                    ^~~~~~~~~~
