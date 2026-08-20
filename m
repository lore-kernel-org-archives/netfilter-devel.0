Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC86A2DEA86;
	Thu, 20 Aug 2026 10:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787222101; cv=none; b=PY7p7ZSW+ySQXl3BkYd0qfgLJ7GR+lwm28KsnvGbibP+z/t71rmVbg/ZduJZ6iIlZwceZllJ5Y4lLTmctT6BLvBDUCrFqN/GbVM722e9ojqyzXo0PPzuuY/F8pnXfLYXYiZKqQ5/0xwV07XZMS1hFbbMJiORt2xBUlk0IU9sj1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787222101; c=relaxed/simple;
	bh=c9u5pCCvXEdH2a5xC1x/9p0o3i3IsCHIIjPkBq7BcLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t9OCqJy1QKDEX8HJRyw9/akg0rnR0Fn7mFNIW6MF934L0jMqOIKZSX/Qjr5v6s7LVHlPrSjnsW1egI/bLrcfjKDmnwmKgx6AMir4utFEFi8ChW4cS6+aBsuWmlaf9mh/n8zlHOICGqDL7ItujT/iU8Usg5vkoP/5i1nowV/KO+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jac4XQkV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jac4XQkV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787222095;
	bh=rfFZbGyyye/E+XYJFY7hEc1bdglhDJEhf7sRgwDKayQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jac4XQkVRx2gFP6ejYyQ4GaJywHmvm3Cux5vc+XTGufJ8z4fqgU9RJKR6kosDBkUk
	 T0eY5MSZV8SEnNFKyoRBzpEb9ZMRB7/EiGIIuRbAzLvSlVzSvQ7nWcyueVnyEq6WFS
	 P15MMcYo3MklDGz88nakcF18WibeXo7RpgtVWez/iGMv4Hu77PVCs+725dY7oP0Wtq
	 370HhiQrAiX8ST52dkY9/ZOaOFij2+EgdT3Fhagqs+NOx9qaPMMwLXDkhV1rJuw5UB
	 lWbE6v+z7mu+a9R4B/KU5rCawv1zAaPn/0wxP9n0dxPYPRX93T7sP6M7QyrH31QVJ1
	 6yWC3SRLAKk8g==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 19D8A6008C;
	Thu, 20 Aug 2026 12:34:55 +0200 (CEST)
Date: Thu, 20 Aug 2026 12:34:52 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	edumazet@google.com, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net-next 0/8] Netfilter/IPVS fixes for net-next
Message-ID: <aobYTLPoIDiwLEhh@chamomile>
References: <20260817232957.1281637-1-pablo@netfilter.org>
 <aoTzAYyHk7E-HTE_@strlen.de>
 <aoYlM3J0SP51Kpoh@chamomile>
 <eeb04db2-3c08-4b4d-97a0-02e418ed2537@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <eeb04db2-3c08-4b4d-97a0-02e418ed2537@redhat.com>

On Thu, Aug 20, 2026 at 12:26:33PM +0200, Paolo Abeni wrote:
> On 8/19/26 11:50 PM, Pablo Neira Ayuso wrote:
> > TLDR; I can post new v2 for this PR if needed, the left-over of
> > LIST_HEAD(set_update_list) in patch #6 is a bit embarrasing from
> > cosmetic standpoint because I will need a oneliner patch to remove it.
> > And I can re-target to net.git as Paolo already mentioned.
> > 
> > Anything else can be addressed by follow ups.
>
> Note that we are waiting for Linus to pull the net-next PR, so we have
> to wait a little more to process this one.
> 
> WRT report, I think follow-ups are preferable where possible and really
> reduce pressure on the ML, but if _you prefer_ a v2 please go ahead.

Let's just follow up then.
