Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09171E0E14
	for <netfilter-devel@vger.kernel.org>; Sat,  6 Dec 2025 11:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765022157; cv=none; b=hs0AsH4hiWozo7BJkaFvp3SIa8urSPmB10xoICQ9a3I1LIHw/+cQUDvhFDIItOYRJ/Ovez8pIqUm26QN0tdFKvhAYEUv1JiHoTqP83ySjJY9NkYhKCAYdcyoMAZvHN3d0OYccnUMEcS9a1DIQmzsBTLbPDp/ItzOoWl4IgG2p1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765022157; c=relaxed/simple;
	bh=Rv2Vj7ddmGTFJq57eUutPt7zNS1RG9Fj4TTvhhAbGDw=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H9G8sSKFdCHEZ5s/Efk/xFt5fawOsRhCDCXe7ZwhpJc7gJEznoi/vM3Ydp62S+V0oBm0LF8Rni6V6MXnkhJPeUzoUakuGWzAChbuhd09sVsG/w4vEIZ7BPjI3mvPdEiV/tzirSeKx2yV9Bv8okH+DxJ4PvdyK/zZA6XlFFOPvnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com; spf=pass smtp.mailfrom=fastmail.com; dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b=IQ/5TWRU; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=f3fy02dw; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.com header.i=@fastmail.com header.b="IQ/5TWRU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="f3fy02dw"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E3E28140008A;
	Sat,  6 Dec 2025 06:55:53 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Sat, 06 Dec 2025 06:55:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
	cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1765022153; x=1765108553; bh=pGonFlrayv
	FihwWm8//bHczuFwjc4/40zwBuuT13S+0=; b=IQ/5TWRUJi0FzvOZbRQu+N9EhV
	wN4i+urI/Z4NJhqsnxHEM53ofASDR15nIJGFamqC4MyETSXthkIXhfEg+5S6FrTI
	lKBxLwenxkx+RMGKsNd9AZ0Uc4ZAFDrDAQqkjX368l7oIxYJXhUnHLK/UFvEgNeK
	1cwRrHvtJiyG4EoL5PJLnL4xW7EgtV+Xi5l6zWtkHmVxOEKDS74eix6ZiYUoTfcK
	HCKaIYkd/WyeO6zjtpELZHcFT8HBH38IWGEmGF+lxipQ9ezLpETQX7JsHwvVugHZ
	yWDz5yJmim+ajFZXG9t/8DXIoGo0PInWpHqkBWHWRYp5IfWKBJH8/64MUGBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1765022153; x=1765108553; bh=pGonFlrayvFihwWm8//bHczuFwjc4/40zwB
	uuT13S+0=; b=f3fy02dwkxfConBt0iHkzzjGDyQJxR6bNevRIGgfu83wluCYSHP
	T3bTo+ScW/Ds3rtvS9DbAV4NLjyl/F5HlAxh9d2fnNY7HKHIewPhCvfiECnUKkBF
	16WnTqhwTfgTYz9OX+GzbO/XKbNcZx0wbUo557t6MfH3kw2L5GpxVC4T7waamkeB
	U8q4wJYe07nrJ5gLsMOoB8c27znRsZVCtfiN8O86LTiknpmn687YygpYwpX8YQau
	GVce6Vk6OuuitiIoFzCI33L5OxTcifVefn38fG70h9mYH8uhQGa1zwiKodUZu5dr
	5asggDtbHNbHMMtRJN6evnT/oRovnS5al4Q==
X-ME-Sender: <xms:yRk0aUg3yOrL8BRUTyL4ZWbc4uYfvoY_2HRlsMmoGQrvuxn9mjv1PQ>
    <xme:yRk0aT9O6uWFSJAIUmUGjsjV8eeC_03NH96M7SNTVaPB4ectiXVwv1jsXwkPPTR7p
    WlP4pDKJzNJT4QKMkqhULxt8iFY5caRylypHgbSrNgb3XO1A3ACVA>
X-ME-Received: <xmr:yRk0aRtWRqeoin7cSk38LDsDZ4CWg30ebb27tdAkWeNJDAZR5SBZ8YMCGASTI__HmocVYCJOSCMt6FSI66J4OAE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddutdekkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjfgesthdtsfdttd
    erjeenucfhrhhomheplfgrnhcurfgrlhhushcuoehjphgrlhhushesfhgrshhtmhgrihhl
    rdgtohhmqeenucggtffrrghtthgvrhhnpeelhedtjeduteetteehtdehkedtgfelffdvle
    duveefkeeiieevveeutdekheeuheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehjphgrlhhushesfhgrshhtmhgrihhlrdgtohhmpdhnsggprh
    gtphhtthhopedupdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehnvghtfhhilhht
    vghrqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:yRk0aaZsqJ05tgwn1JVo3KJLMAab7eYQ_mNUNtvMJEOjp5MNjF1eBg>
    <xmx:yRk0aRpcgDC6PJwwN3X9ysLhOoN-0lEh7KZanhbQ_A7heypC0gi3sg>
    <xmx:yRk0af9_CS8uQMV-jsFlTTQ4paZsO10rY5PHfpeF2KU7_52LU8x0ww>
    <xmx:yRk0aQ-jHcD_I_P33cWJ1t2xEpMxYIfSX-N4zhWK-3f-LXK_p_T9Dg>
    <xmx:yRk0aZgxyTWE0aVYuG6yJ8ExK9ydI6y-pJEhvNc-eMythjYOjU5mzBuQ>
Feedback-ID: i01894241:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <netfilter-devel@vger.kernel.org>; Sat, 6 Dec 2025 06:55:53 -0500 (EST)
Date: Sat, 6 Dec 2025 12:55:50 +0100
From: Jan Palus <jpalus@fastmail.com>
To: netfilter-devel@vger.kernel.org
Subject: Re: [nftables PATCH] build: avoid bashism in configure
Message-ID: <wjxsfmnghbx6sqbulvsmkmoxu7vjl7hzirzis3rdreycpyamj7@oft6fqhzgw67>
References: <20251205234358.29622-1-jpalus@fastmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251205234358.29622-1-jpalus@fastmail.com>
User-Agent: NeoMutt/20250905

Sorry I've missed to indicate in subject it's a patch for nftables.

On 06.12.2025 00:43, Jan Palus wrote:
> Signed-off-by: Jan Palus <jpalus@fastmail.com>
> ---
>  configure.ac | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 6825474b..dd172e88 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -157,7 +157,7 @@ AC_CONFIG_COMMANDS([nftversion.h], [
>  	echo "	${STABLE_RELEASE}"
>  	echo "};"
>  	echo "static char nftbuildstamp[[]] = {"
> -	for ((i = 56; i >= 0; i-= 8)); do
> +	for i in `seq 56 -8 0`; do
>  		echo "	((uint64_t)MAKE_STAMP >> $i) & 0xff,"
>  	done
>  	echo "};"
> -- 
> 2.52.0
> 
