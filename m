Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793294556;
	b=FnC8DU5w5ny8e5MdC9NLkHvKIlU3kKjz4DUKRMO/XTKKQ/wHL348iTWw6N4VYL7Z1JaE
	 gYcr+dlRq7bN2bcrtffVfRLx0m7R52xvZgvGpwRaMPje41K2GJ1PV9A7JIY0KpWpA0ItM
	 TXH4P3pwkHcW3EYn1KP2PQZQTi/GXgMdxTw4SnJeDRkXuV5RhQ8vL39ziG62nYKDbb7y9
	 b0GhuIPmjDA8etl7MN70QQem0/Whn6oETGomiJAKRa3QxC9qEEtwPuNJ5BHtAK2lM9zwz
	 fdN+8Tf4VXjI+lIewOZrcheleElieJJhBvpKHCxTDWABJBVHKHbq/ycXnm+2cHyKhHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793294556;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=TtXUgRJ6AZWhc7lqup45dcGmAdJLNd0r0lG+qAQqr84=;
	b=li3ag+c+yTHRwQNJSe1a/qfPZrStNzcfRgszDkV3aZdxgzb1TgoO7TZjlvv9DIyNvEUT
	 hNrutMPyUR9cwtzQLEMRecEmEeAQtLw8EUFCjHS3CUFQ85VTs0KK35JX7aylqwApFPYu9
	 Ixi2178EGKHTm5s/JysxQ/Qj85N4h4unmUGcBJfRgSvnk9jjW3m5EHXWopiWmnsT6HRdw
	 Hwl5MWCCp5mBOVG8clgE0ZFAMs8cSDA/2anxRPRbk89PrV+TbLGmqffN5wQIRZt4b6ung
	 4vUg+BjbhWLNrq5aGw9JJD9JwB0mj0MM9Eh4yTVCEB7uQbc9Bf4rQdIeTii+06oQiug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=hGt4PcVH;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C537C606A31F
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 17:22:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C537C606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=hGt4PcVH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793294553;
	bh=TtXUgRJ6AZWhc7lqup45dcGmAdJLNd0r0lG+qAQqr84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hGt4PcVHalcMl5QRs/qCRC91fnoC2NHsvP/SmgjfFIzC9dXVGvYsV8H7JYzNKJoXs
	 bzAGwY3PjKND2+H0lkF0L+GxW/mdSZxtzu1a6Kpa044ul5Hebc47wqlWZ6sp3knGas
	 4+WnPuq1V1vOJnxdWcksCXdY9bVSXIcneOi6EM7A8RMrKy73/YEwEapjfIfzZZ+M23
	 iUdGZQQ3Y8uyyRYF9fCzOZ5lcTkmzGUNIs9COToloBMD5XUSY9lvloNypeCij319vt
	 B6Skx8/jBDvRibNykpAMZ8/EAqRIuODnNRg6nVUqUXVp1PhXFjI2nCf56cCMy4JfAi
	 EyemijZyu/bqA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1FDD86005B;
	Thu, 29 Oct 2026 18:22:33 +0100 (CET)
Date: Thu, 29 Oct 2026 18:22:31 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Valentin Berezhnoy <dreyksmail@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, coreteam@netfilter.org
Subject: Re: [PATCH nf] netfilter: flowtable: fetch hardware counters before
 removing a flow
Message-ID: <auOA1wMtcfwMk0E_@chamomile>
References: <20261021175030.4800-1-dreyksmail@gmail.com>
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
In-Reply-To: <20261021175030.4800-1-dreyksmail@gmail.com>

On Wed, Oct 21, 2026 at 08:50:30PM +0300, Valentin Berezhnoy wrote:
> The counters of hardware offloaded flows are added to the conntrack
> entry by the stats work, which nf_flow_offload_stats() queues only once
> a tenth of the flow timeout has passed since the last update, i.e.
> about every 3 seconds with the default nf_flowtable_tcp_timeout of 30
> seconds. When a flow is torn down, e.g. after a TCP FIN or RST,
> flow_offload_work_del() removes the hardware entries without fetching
> their counters, so the traffic since the last update never reaches
> conntrack.

For the record, alternative approach for this series:

https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=530566
