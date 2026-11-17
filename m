Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794913854;
	b=lyS6jws0SK3Os+xEY03bkRWwQ2G2vaX5dFOfi6fzEjkmnsOIBqtAaylayxee+p1Lexl7
	 Fp+uJ3Rqd9bPsGxqbKc3KtnCD4PyDzh0A+NAp8acB8K+hWwagbt50C4/On6e8DPqp1B09
	 YiBnrhVRPDO0yRR7e22a3hBWDZV7mXweYAqv+qpI0XyVDjGmV3Tc+UZ5Xkn/nKCiDFBlr
	 eO+dpvCq6MVBdXsAfrliVaE+q+2srXHOaltLqmuAp3s9THJuI5h7H1E+4ijmPaQEo+bUB
	 I06/o1WQ20Dy2gyuC8pAcE0WwZpE0xXvoJaWsbdWXtUEq1Z6Th5DZCOgcCAhrvsAP5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794913854;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Bar:X-Rspamd-Report:
	 X-Rspamd-Score:DKIM-Signature;
	bh=XBlaEP+ZZalLn+AMLvWxVAh3MLL2GxgeVb07XFzJTew=;
	b=JXL5EJagWb3fw6dEgPLQwGUeiaKcYpXxbhF6lZWRJabwWqIlc+RkPdssWxSKXpMY113S
	 Fwbp6iM15t+i/AaCCKL2Uxj/0lmKF8439e7zpYWn6hPsBjUoRodXVrSWD9ouNtb0xVMc7
	 g5RMVFuMkegIopWdVEJbQT/3kAbtwVHxuqRAMbyX3dU6syqIyKxsmAasuHmaNtdBiDC9V
	 YGgMKy73Rkz01ycTMBG7ZK7dJ+6PLF8e+1Zth9v7bhxT2hMFo2VULgx6Cgn6elvSuSjDG
	 3WsNSZtynec8chI49bEK5z2CVQUsxYWQgIDIW4aES5TS+pwJXCvif7MHrNcNundEsSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lausen.nl;
	spf=pass smtp.mailfrom=lausen.nl;
	dkim=pass header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=GcmRvluN;
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18964606A323
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:10:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18964606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lausen.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lausen.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=GcmRvluN
Received: from devico.uberspace.de (devico.uberspace.de [185.26.156.185])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id 74A3760CA0
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 12:10:52 +0100 (CET)
Received: (qmail 10627 invoked by uid 990); 17 Nov 2026 11:10:52 -0000
Authentication-Results: devico.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by devico.uberspace.de (Haraka/3.1.1) with ESMTPSA; Tue, 17 Nov 2026 12:10:52 +0100
Message-ID: <dd6010d1-c076-44b2-9f2d-b532a0981699@lausen.nl>
Date: Tue, 17 Nov 2026 12:10:50 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3 0/3] ipv6: Honor prefix suppression for FIB lookups
 and cached routes
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 Shuah Khan <shuah@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261116150132.9594-1-leonard@lausen.nl>
 <20261117091340.GA581197@shredder>
Content-Language: en-US
From: Leonard Lausen <leonard@lausen.nl>
In-Reply-To: <20261117091340.GA581197@shredder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Bar: ---
X-Rspamd-Report: BAYES_HAM(-2.999967) XM_UA_NO_VERSION(0.01) MIME_GOOD(-0.1)
X-Rspamd-Score: -3.089967
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=lausen.nl; s=uberspace;
	h=from:to:cc:subject:date;
	bh=eNHCyMzMjuTxFdiDys0ATKEpEOHWN3JbqfwqPu9B3g4=;
	b=GcmRvluNpm4yG+//tqMK3Dv5u4jTtT7PT4TzuyzAT3iQvi4Gm/bfjxiEPVINkZf7DbYR9BZrUc
	U6qaCOrJD8GyQDzlv3yuJDtNUtqi863BL0wSY3GrHaxu206a+4nig+GpGGzWYc86/oHr1ra46vSW
	EU4YRyUkVe1n6kx2ZZBDUXWfJFBDjJoLCoL8mzzSnHThcoE9zIUatyaHmpYOmNW+rW1cPOyuf219
	/89S7/9rZOftBpkpN3MuXzw7S4aDS2A8BaUN1dttP6Sl6+/sgvRfYhqz02PEghySC65cGrpHiGDu
	HO8qAWOr7toDFdA1TRrmZsyQu4KJpIlAVMcwucb/5LZnj9LuBPAiHec862cfAxwHkRD0+2dsw6/Y
	EJlDnCmme3bwZq10N+NqYGbKMmYucNbTMSg/O1xq2+ykovonWwQW87Ec+TNt6AERxVLX7OMPXnOw
	/HpgFYlUG5wI15i4FFZZ2WTI+hmTycfbOPrFqA2f3AzqamuwIrbR8o5UB0py2sokrS7dBPFJ1DHj
	435qEKSypspEnoHzVOWXRVsxbl/1pA+OIkL1kN77U7+mYbL2Xc0cszP3C7Mb+u28Pv9moT0/LCmE
	TMLjBnFUxO8qy+rEFVf8GsBg+nDt3LPa41Vj/BnIy6+oChpWBpwzWPkesk/MNfxB9jJpM65lvtEb
	8=

Hi Ido,

didn't realize it needs to be separated due to net-next and had included 
it in v3 as it seemed straightforward enough. Will resend to net-next 
after this series made it there. Apologies.

Best regards
Leonard

Am 17.11.26 um 10:13 schrieb Ido Schimmel:
> On Mon, Nov 16, 2026 at 03:01:27PM +0000, Leonard Lausen wrote:
>> Changes since v2:
>> - Add the separate cached-exception fix and PMTU regression case.
> 
> Why?
> 
> I said (twice) that I will take care of it. It's not net material
> (always broken) and should be routed via net-next. Please send v4
> without the exception "fix" and the related test case.
> 
> Given you already have a patch for this, send it to net-next *after* the
> fix is present there.

