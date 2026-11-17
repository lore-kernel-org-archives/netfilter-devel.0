Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794920490;
	b=3VIKMhECkNB1ajmhzqjJr7WuW+4Jdgu+FpbXMWkg5MoWvMSCnr/XRT+zIHpUChPJ/pcf
	 KcKrIBTf2MpzJu1H7P0aipGIm2GxGCpPO24quyHRGDzkZci48bbP2uLyrve3h+vDtcP54
	 o4XU0IM0xc1MO3+r87LHEZPR+W+zWNL85ilFJ2LmMUcFn3U8OOc4yV3UL3bdJuKSv7/Z8
	 rCcJVYG0TIQISfsGQCam/3vILYbWyEpzPLMH6gWfETermh3eNt1OfwYKAtT9AA67NOee4
	 5PUR0lW9Rm5YthBkxTYix47lMPGnlTpmA4RMDwNGmJ1bje6q84XDzZU0el4FhiCstXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794920490;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Bar:X-Rspamd-Report:
	 X-Rspamd-Score:DKIM-Signature;
	bh=ha/bB78+e8GQK0KzBRWXcQpUb3057CMIuHiE/No3ruY=;
	b=PJuKbMPfmvKH3vmTUfF3ZdCsYPh0o5frT3P7PDajji4/xraBCurOB7ngQDc887O5mILP
	 OHl/iS2iuz/Pm++0YNYZFHIMCTScac20hIUlhxblNGHgl3dbOx5g7Nk9d+K7qg6dxrAJH
	 G7tmSeR/Il9yGZwOpqWxH6lMEZ5j5aKQ7xfPcDlfm3ILyhX9hIdx9RIfVxMMwR02LLDWj
	 v0c3h+fF6QzHCEcDmehWr4PajXCjTjMRqnQTWdV6U+iIJ4ISvE3ne1LWwZPCG7bGzn/kp
	 OJAilgsnR4WQckigi0DxZtKgctqrHhF0pzSRpeprKCjxK0CJbHRSGWkjWvG8atg1YTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lausen.nl;
	spf=pass smtp.mailfrom=lausen.nl;
	dkim=pass header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b="O/s6qHOT";
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCDC606A335
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 13:01:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CCDC606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lausen.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lausen.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=O/s6qHOT
Received: from devico.uberspace.de (devico.uberspace.de [185.26.156.185])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id 245F560CCF
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 14:01:26 +0100 (CET)
Received: (qmail 31042 invoked by uid 990); 17 Nov 2026 13:01:25 -0000
Authentication-Results: devico.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by devico.uberspace.de (Haraka/3.1.1) with ESMTPSA; Tue, 17 Nov 2026 14:01:25 +0100
Message-ID: <94f4ea0e-c1bf-467c-94be-b65963410d30@lausen.nl>
Date: Tue, 17 Nov 2026 14:01:24 +0100
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
Subject: Re: [PATCH net v4 0/2] ipv6: Honor suppress_prefixlength in
 fib6_lookup()
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
 Ido Schimmel <idosch@nvidia.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 Shuah Khan <shuah@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261117110813.9894-2-leonard@lausen.nl>
 <avxPFYfEirXzTup8@chamomile>
Content-Language: en-US
From: Leonard Lausen <leonard@lausen.nl>
In-Reply-To: <avxPFYfEirXzTup8@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Bar: ---
X-Rspamd-Report: BAYES_HAM(-2.99765) XM_UA_NO_VERSION(0.01) MIME_GOOD(-0.1)
X-Rspamd-Score: -3.08765
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=lausen.nl; s=uberspace;
	h=from:to:cc:subject:date;
	bh=rADLIekbRc7DQulYm0UC7PjojxKYHO40B+NwALaMdzs=;
	b=O/s6qHOTjQMTi1wFZ46WSNmg8YUIFtWgtSm6vfaVuKKFRjjA25kuvNC7rUoMuSkBWDiYgK78Tc
	WnxCZcNwdXTSD0L7mk9GHor2kbSCMjgNryaR/UD6kAJEzKroSZhgJgHrc6V7goa00JLT+UAwxwOz
	oIc5W8IsNVnKgpB5v2Tfx8Rmm7gmCaZloALW2Jl9kwH/zkjNO2+CuMyKjoMKkR3lwfoiaYLb2k1w
	pM2jcUL/8CtbJvvhfv7W1ImCvB/YaBa6k+bPpuxLSJ+4mfO1n9KhcLybzPl2xe1VTljL7oJ6/wWH
	KNcVDEikgARutOgAfgNCCvVe9IuaNQAI/61uT+uW8TjZKJQ6u5K3mJkfxnASdKt21EAuvsMf9as5
	M9xObbNPEB2v8+uvky8vP2dmLSiDB9QMxQl3e0jiOIrPBwPkhrhw2DHasvKB5/5qNNTQ6HrIiov1
	LJgFihCo9JhtCuGD0SE1/1N6VUYnBVHbk3scLJfKfjeDjPiB83/MCw65rYKPJncYGhX0EDwjuZUn
	XiwBCCOcWmmgR3ce+RdNvWz263kG6Zt4xaTGrsya3UhmRt5KjjJgLObITHrC6LDVdUUkGoWNZQid
	BkbCj3/t+FS9Sby5lZpEZfxuzBYE5j8xXbTJUm9duwgOPvhUVu4SFAqOOfGrtUQk57j8pvFd+G48
	w=

Am 17.11.26 um 13:56 schrieb Pablo Neira Ayuso:
> On Tue, Nov 17, 2026 at 11:08:10AM +0000, Leonard Lausen wrote:
>> This revision removes the cached-exception patch and its PMTU test, as
>> requested. The series fixes the nftables regression introduced by
>> 1c32b24c234b and leaves dst-based prefix suppression unchanged.
> 
> Is this a LLM finding? Or a real issue in production?

This is a real issue. Without the fix, Wireguard VPN does not work with 
IPv6_rpfilter=strict firewalld setting (default setting). See 
https://github.com/firewalld/firewalld/issues/1600

