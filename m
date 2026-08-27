Received: from mail1.fiberby.net (mail1.fiberby.net [193.104.135.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7134119E0;
	Thu, 27 Aug 2026 11:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.104.135.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787828727; cv=none; b=BDdZd8aYdrRglwdiRsJf+a9q0WU6DEtFsTg3OXqpuyRaK7mVjk/AXlN7pnGLOe5wn+F1B0ScVlw6L25KJx5gkepGzM7jpWKStyF+fnxgvJCmmKoupV/XMteLPGaIHC4VXWz7kH5CbkdK5gkiv+VDhcaBcHXdzKKhHypcqXmxZ6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787828727; c=relaxed/simple;
	bh=wrbO5xEko2/wPq3psOwt2Xe5JSaJqFn+y4oalO3VoGA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=AlYUeX6HeBZ9KyTAB1dBEukBbfPi4kVYHJKEfo+WV6FL5Kq8fPBbF8YHHHGToS04fdumMfj+BqpK1ceaSs0JZM/a9MNfxwrkxuXcRWOGn/vPyoo3sksE5XnfPXgmTpCig0md/lycB+tNx620BLWly2cfNucFzo+skQqJv27h3ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net; spf=pass smtp.mailfrom=fiberby.net; dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b=bK3KaqFT; arc=none smtp.client-ip=193.104.135.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fiberby.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b="bK3KaqFT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fiberby.net;
	s=202008; t=1787828719;
	bh=wrbO5xEko2/wPq3psOwt2Xe5JSaJqFn+y4oalO3VoGA=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=bK3KaqFTpC6wA8SjtEXcisn+m1s1a1T2cD+zLwipJ6+MgxX3h8/1YScHEEfn89Vtb
	 cL4j0gP6nnm4RvcU0CA7LTTam/1DKO1EW2Czl4z7Ta94vIBL8yET/TNjUxoscJWIT4
	 fB+f9xPnPabm0bPkmbMGTrg7ceCHMvCOKfQQ0HDgQzDzAQdMflONnKjU6tw/p06eKj
	 p0xb0rYD/RLbnHHgj06nDrErzaxUBjlBv5uuvWHtYelEIVHveL2NiGgVKK6FjMnuxP
	 zsd/vwGfiDdw2E/i/5fMmsIxN5rKcag0irIlk0646dJ0Xp1Ky9qYDrC5jSIxUIaIzj
	 OgzvxbC+i4yXg==
Received: from x201s (193-104-135-243.ip4.fiberby.net [193.104.135.243])
	by mail1.fiberby.net (Postfix) with ESMTPSA id E2EF0600BF;
	Thu, 27 Aug 2026 11:05:18 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by x201s (Postfix) with ESMTP id 5308C200890;
	Thu, 27 Aug 2026 11:04:42 +0000 (UTC)
Message-ID: <f051ab36-6b94-4b93-bf5e-387a62324bec@fiberby.net>
Date: Thu, 27 Aug 2026 11:04:42 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: =?UTF-8?Q?Asbj=C3=B8rn_Sloth_T=C3=B8nnesen?= <ast@fiberby.net>
Subject: Re: [PATCH net v2 1/2] netlink: specs: fix the conntrack filter type
To: Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Donald Hunter <donald.hunter@gmail.com>,
 "Remy D. Farley" <one-d-wide@protonmail.com>,
 "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
 Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, stable@vger.kernel.org
References: <20260826220444.4054714-1-i.maximets@ovn.org>
 <20260826220444.4054714-2-i.maximets@ovn.org>
Content-Language: en-US
In-Reply-To: <20260826220444.4054714-2-i.maximets@ovn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/26/26 10:01 PM, Ilya Maximets wrote:
> The CTA_FILTER doesn't contain nested tuple attributes, instead it
> contains bit masks that specify which tuple attributes to filter on.
> The values for filtering are taken from the top-level CTA_TUPLE_ORIG
> and CTA_TUPLE_REPLY, which are also missing in the attribute list
> for the dump request.
> 
> The bits themselves somehow are not in the public headers, so not
> defining them in the spec either for now.  Once they are public in
> uAPI, they can be added here with enum-as-flags.
> 
> Fixes: 23fc9311a526 ("netlink: specs: add conntrack dump and stats dump support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>

LGTM, thanks.

Reviewed-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
