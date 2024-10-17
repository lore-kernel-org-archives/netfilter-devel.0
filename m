Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEDF1DD862;
	Thu, 17 Oct 2024 12:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729168770; cv=none; b=s9b/5KD3yAI5cKijS/DfRITI1sgwJOOPg04JHPFZT+NsL8M/91AB2j/tsbWzRKdTLa2H0b2I51UVixvYyM2wgANsUbvItQk5ei3DCktzYFsdCLxdWS34crekaKxAWiwpaHcKf2tlAkGZRZINthe4W4eFQCNJRxogqCKyzhVGH+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729168770; c=relaxed/simple;
	bh=58ZH9EysMGctJs6VFMx8+biSi2sHaIk63WBGxe5Y220=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kfDoTLgVwiw3CPOXBfT1YqVUlJ2LFw2yS0huVGzuxQyGX6rYRzyV3VuYQu6fD/TZs6VP13dkDOipPUVsze/Nt4vr0BJ5w9oJbS74NvUR0D4o/1DIeRAXLPC3k9VlpkjqAOg5L+CxTeez+OrGT3Xr0iqNhx3x6MuC6/7gGk3az8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=43634 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t1Pmg-00Eunf-4s; Thu, 17 Oct 2024 14:39:20 +0200
Date: Thu, 17 Oct 2024 14:39:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: Eric Woudstra <ericwouds@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Frank Wunderlich <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC v1 net-next 00/12] bridge-fastpath and related
 improvements
Message-ID: <ZxEFdX1uoBYSFhBF@calendula>
References: <20241013185509.4430-1-ericwouds@gmail.com>
 <9f9f3cf0-7a78-40f1-b8d5-f06a2d428210@blackwall.org>
 <a07cadd3-a8ff-4d1c-9dca-27a5dba907c3@gmail.com>
 <0b0a92f2-2e80-429c-8fcd-d4dc162e6e1f@nbd.name>
 <137aa23a-db21-43c2-8fb0-608cfe221356@gmail.com>
 <a7ab80d5-ff49-4277-ba73-db46547a8a8e@nbd.name>
 <d7d48102-4c52-4161-a21c-4d5b42539fbb@gmail.com>
 <b5739f78-9cd5-4fd0-ae63-d80a5a37aaf0@nbd.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b5739f78-9cd5-4fd0-ae63-d80a5a37aaf0@nbd.name>
X-Spam-Score: -1.9 (-)

On Thu, Oct 17, 2024 at 11:17:09AM +0200, Felix Fietkau wrote:
[...]
> By the way, based on some reports that I received, I do believe that the
> existing forwarding fastpath also doesn't handle roaming properly.
> I just didn't have the time to properly look into that yet.

I think it should work for the existing forwarding fastpath.

- If computer roams from different port, packets follow classic path,
  then new flow entry is created. The flow old entry expires after 30
  seconds.
- If route is stale, flow entry is also removed.

Maybe I am missing another possible scenario?

Thanks.
