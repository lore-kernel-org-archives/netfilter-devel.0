Received: from mail1.fiberby.net (mail1.fiberby.net [193.104.135.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE663CDBA5;
	Thu, 27 Aug 2026 11:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.104.135.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787828729; cv=none; b=FdjeJ4VZb5ZW7wFm5dHJeF2FworxlFESAsI/Ebak1t8HgJ/0evje7W/QjaxxhbmHhw3TGCo9kC66TvRgvXf2IHzfaLSi6r5DCXpNpwEQzgDJ1TrCSK0BrUZNb7nf2Gwc59W8XYwJ6iG8bMw9zQWNH1IHSWGoQySQXZXOlez3Hx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787828729; c=relaxed/simple;
	bh=fmfXQZB0uXWgiiShpulwf1mMv7Yv65jiwQKkNRm5mPg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=tUqdZr9gwdEHAqbFxIueW1TPWCI4PBDJUVUpVYY65Fu4DMpvN3TxCabiifct5Ev40Zno/LMz4tXB2sMcrbQqmWEmGzi8pHhcwJSMbVsPkVo0AJQXcWMnGi2Yr69Cf0aa/0Fp2wRPxHKLU5YrudYyyVIDjYdqbpYtCOTYlSehBGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net; spf=pass smtp.mailfrom=fiberby.net; dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b=TeQhdhXS; arc=none smtp.client-ip=193.104.135.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fiberby.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fiberby.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fiberby.net header.i=@fiberby.net header.b="TeQhdhXS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fiberby.net;
	s=202008; t=1787828719;
	bh=fmfXQZB0uXWgiiShpulwf1mMv7Yv65jiwQKkNRm5mPg=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=TeQhdhXScGO7wJWYfousrDHMDNn41ARql6Q2fcKVZ1NgInejU1QrFM1LBUyhiS+LP
	 xYfNNhBjbsZTeepeY6pKvXkZLDMnDEEvA9S+gsFZIS97o20u1O/b/XqBytpQwPRB2W
	 7zmZrTNShKn0e+b8bZUnngcVMNYo6d+CifkhIVn/Mni1NrcQiXMntX4l387GUeT9lR
	 oTXKQRR3LaHWioxvWiTy230eU5xxymtki6my9CM8/ZjUGLa54HBCOWh6Wu1KzDs5bU
	 hPAiAgtrvi1YHirNZcaH5A9tfJy2eqdJHdcvBjpCsHOQ02/s6qoTplguc4T39QLpP2
	 guSFEc7InlB0g==
Received: from x201s (193-104-135-243.ip4.fiberby.net [193.104.135.243])
	by mail1.fiberby.net (Postfix) with ESMTPSA id B3C8F60075;
	Thu, 27 Aug 2026 11:05:18 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by x201s (Postfix) with ESMTP id 3920C201763;
	Thu, 27 Aug 2026 11:04:55 +0000 (UTC)
Message-ID: <94804df2-4b2d-4b2a-9a4c-9bc09a6a3f1d@fiberby.net>
Date: Thu, 27 Aug 2026 11:04:54 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: =?UTF-8?Q?Asbj=C3=B8rn_Sloth_T=C3=B8nnesen?= <ast@fiberby.net>
Subject: Re: [PATCH net v2 2/2] netlink: specs: add missing mask attributes
 for conntrack dump
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
 <20260826220444.4054714-3-i.maximets@ovn.org>
Content-Language: en-US
In-Reply-To: <20260826220444.4054714-3-i.maximets@ovn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/26/26 10:01 PM, Ilya Maximets wrote:
> 'mark-mask' and 'status-mask' are defined and supported by the
> conntrack dump, but missing from the list of arguments.
> 
> While at it, the order of the arguments should follow the order of
> their definition in the enum ctattr_type.  That appears to be a common
> convention for other spec files.
> 
> Fixes: 23fc9311a526 ("netlink: specs: add conntrack dump and stats dump support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>

LGTM, thanks.

Reviewed-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
