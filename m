Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9671938B7D1;
	Fri, 14 Aug 2026 19:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786735548; cv=none; b=Rsov/Pxqw+aETXM+6wOHyc6D8rzuu/t+sip4q4Oi7S2aw1ULUdRHfi57j18E4O8ppdPKZv6hp8u79Vqda/lD8dxEVrSs7rS9U0H9muTp2P7KqhxrLbY4YcvO0dTUJd+J6pkfN8/wGgdnePuRZ41q4U0oYOAdnaZqvxzP+UA9bIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786735548; c=relaxed/simple;
	bh=cDgaJdV8GhDOvVH+J0bOo9RPyqDk9mN3ZpsMLANIbc0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mx+to0gjMUrUcS91UzQgrh5qnx9pzBwUF8+3PG4K56zEsLdtlpfuGEcGUapVxVOLqNA2Oe8Bv63fC1F1/UBrxIZEiRekBlkQN94R23EARe3iKPGLUsXI3c3PZF+lv9+jnNiWn7UL3l7DAfiDvtGa8i16845+2METejDruMvybJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUZV5ASt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUZV5ASt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FEF1F000E9;
	Fri, 14 Aug 2026 19:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786735547;
	bh=b/+fG3FlBI8lR/CHxPyr4Ng0uy7RIW3XT2g1yoOcrGs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OUZV5AStFhMLJKPppVoGVfW1CQDYlITZcQ7gPhBAqWcR4dK3Uk5Nxo87w8B1HK+nL
	 5EOxj1cc5PlqWHzLh91ctKqRP3v4X4IOc60mFC9cOSVFocRkXi35ExRatE0EjHF2Lx
	 wTkQoBq2s/yUNo+luh1JDnuyxo7NV1C4gjCFCrZZAYwD4PmFrJcR4wpjT7gnolQSKE
	 pqjJWZcj30FjBoi+suSpdxhYUZCVclqB1QNtEitwAUgd5+LtrNJEsXn3UmCpPq2uTL
	 hB+oojjDXMr5wO7/32pquXRLEx6NYSkaisVH7+JjUtVSQYg4JuC75TOwfgbbMO1u9m
	 nt0bK3iAnbZ5A==
Date: Fri, 14 Aug 2026 12:25:46 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 00/12] Netfilter updates for net
Message-ID: <20260814122546.4ee73be6@kernel.org>
In-Reply-To: <20260810194015.932627-1-pablo@netfilter.org>
References: <20260810194015.932627-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Aug 2026 21:40:03 +0200 Pablo Neira Ayuso wrote:
>       netfilter: flowtable: rename tun.l3_proto to tun.inner_proto
>       netfilter: flowtable: rename ctx.tun.proto to ctx.tun.inner_proto
>       netfilter: flowtable: store ethertype in flowtable context
>       netfilter: flowtable: move ipv4 and ipv6 xmit path to function
>       netfilter: flowtable: detach layer 2 encapsulation parser from lookup

Would be great to see more tests for this stuff.
Especially tests that could be run on real HW.
