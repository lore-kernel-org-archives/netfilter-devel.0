Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792538347;
	b=rxIryFLWD38xq498C6hVTFuA8SjuQwCFtzseF75fEhKN3c42FK9KwUqzciipztKzvQR9
	 Sfa9q+HJg9P+6F8T9mGvNM/l5I6yFmouaW+4qv9bOBzNzHUjB9Vr+0+NXg2b8B/+46+Hc
	 BwWBauK2zMl+ppXXubGXBNOczsneLHAdqj7kGCGFlTlQwz2BwthUeSBgn3beK/vJfwUC+
	 K2mGiccxGr5rYQXHBHwfnT8ihRHxH9SgVPXBImH63HmyVatmM2rWAZxsER6gXR+Uc0iG2
	 8atC9BkAy7+k58NSmZM/Nt84jf3EJmtWjwlZ4/JUzqUC4Q9yRtzUwgOx52c5WiKcrNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792538347;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=EgqdwcxRtCyIF6PcO23pgZyhNVrCNKMYPFsKJn80910=;
	b=llZJwHRZblbQO/ljpuWD7bj2puQynzPXOkczEvArUpQEXhol7Mu/F1WNs+JUvdZbYqrn
	 MraoLOFomeaMchvcoTGOsWFpGiDquHfbLWZjI7s2hIb5OBrwQtgXiH5jwISPw2ZdFQUGw
	 tuW5JSSioJieSPHB+HUY/fY4aflPE67Rkd2WxDqFOoRFbIAcy6/Ykz8V5Logd9d2ZOUCM
	 JvsAkZnnXbVPzke/X7353kHxntX10HY3/6rExej32FWVl2vO1oNdY/vp0ywRGhXsLAEnJ
	 MBimIrfLtagVLBXT1+hx3jUfTykKRBJgfJQLZJUXWKEEwWx7ODIjKV8fUZiNA7DhG3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=PPTOARoa;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6AD10606A319
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 23:19:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AD10606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=PPTOARoa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792538344;
	bh=EgqdwcxRtCyIF6PcO23pgZyhNVrCNKMYPFsKJn80910=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PPTOARoaJpBJzqKZQh8eAYUz0gfdZ8+PB0BQMoPXJV9BGNZnjAm3Dd4KhvK9dI/lD
	 tDRmAK0Z1+/P3d0h5ggtBIgvdlcBvBGw/q/d9HMh7+l4A8thNzJUzesZfE2fsghn3v
	 5NicLWtNwIEFLpayMrtipRPGFyVca+zaMufTPocEdS3G1nfd1pDYFAHL1mlfrgNCcZ
	 60FrI2XHWyvQrRafMdhwe2Ytk/zON7c1HBuP9roSU4750IY276TYUoOFkWpOI2iie2
	 TPUcx+Lh1bKNkiGh4XMBvt9qi3QG9R06vrWRKXZS29WfFb+ArChYEOQhpuwAe2Iuth
	 Ia8XvYJwAv0Uw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 181EA6005B;
	Wed, 21 Oct 2026 01:19:04 +0200 (CEST)
Date: Wed, 21 Oct 2026 01:19:00 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Yuen Su <zypulsecore@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] conntrack: apply the receive buffer size
 to the event socket
Message-ID: <atf25JhLxwTY8kha@chamomile>
References: <CAC9WPdyPZNTHOMmm+C2shvJntRytoD6Zj17Q3MWFmjZQTv5+QA@mail.gmail.com>
 <atf2bRP7z2j8gogm@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <atf2bRP7z2j8gogm@chamomile>

On Wed, Oct 21, 2026 at 01:17:04AM +0200, Pablo Neira Ayuso wrote:
> On Sat, Oct 17, 2026 at 09:03:09PM -0700, Yuen Su wrote:
> > CT_EVENT receives notifications on event_sock after socket
> > consolidation, but --buffer-size still configures and queries the
> > separate control socket. A larger value therefore leaves the active
> > event receive buffer unchanged while reporting success. Use event_sock
> > for the forced setting, fallback setting and effective-size readback.
> > 
> > Add an isolated real-kernel regression that traces all event masks and
> > two requested sizes. The original fails because the option targets fd 3
> > while the multicast listener is fd 4; the fix passes all eight cases.
> > The existing conntrack CLI suite also passes 286 cases. Prepared with AI
> > assistance and verified against actual netlink syscalls.
> 
> Applied, but I stripped off the test, a bit too specific for this bug.

BTW, author in git shows incorrect because patch was garbled by MUA
and I had to manually fix it.
