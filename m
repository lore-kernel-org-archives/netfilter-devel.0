Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795688462;
	b=EIiII9BSx85RIpZZchVjXW/+FJYr4ZBwolUJBc8hJoVwMimM25cXLHq1JEGcL7dVfjf/
	 nHg80RJz8eqQrFSalFfKaUP5IYaSVozrsbfkibIpINXP/sbe32MDbnJMxhaQ2jjlNJeYU
	 os98QvqDbrcrcjtHlquDTxHi0bjqMofSIKtSFwRfE1XGhiIqzZxwVx6KD5P+UVNiqAE+w
	 S/BmnZrWh5mrrS5rRQcvsa1odc9jUf4VPPZfTBXk57Y961jWNVoWNXX+E0IfbVAhOxKbV
	 ST8zJj+X96NrqeForT2gPw1unxGWpDyJaKKd1GiIH/B18Lp+fvcei27G6lX1Rp1ssKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795688462;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Dz5Obh5lP0tOLHLiHWSWNzgVimL59XKVdrhzCbJPLAQ=;
	b=MyuM6W4Mehc0KUT5Mskber2MnrXjuu5An3ZsCyScpFG/NbaVil+L8G3c4FJAXDN5yRz/
	 A42DeC9xbEiVjJRDH/92d/NoeKhiIKdV8Oz9g6k2RX5qVqRIUJLzeW2lK+u9RZJ+C82BM
	 evhLSqQ9jUeK5+V/Qpp24dbfQUYMpVJZNkmPcUXG9Aom5yS2gRsTCryMjIwuaFPSjfq6p
	 XSzBfRv0ifGSaoas0vgvkGx6T2aPw030I97iuy80xgspa6g3gL6OGiwdV7g7UXZnl689d
	 6AnuQRwiApuya1QWoRYlZXA7vNsaH7eKRtWoEFt1CjkvxP+Ml2Nt6ePIsaIrla8hJ0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="CD7VT//B";
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C2B606A31E
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 10:21:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23C2B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CD7VT//B
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so46535865e9.0
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 02:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795688460; x=1796293260; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Dz5Obh5lP0tOLHLiHWSWNzgVimL59XKVdrhzCbJPLAQ=;
        b=CD7VT//BnwjcVd/x9W08z4hh0qia6Xph8wF/i4minXZySyXu8zsDolv0LFjazmM/6m
         pIGU6L76Mawk8H2KfnDIrG2oDmO7Tv7sO/LEOBXhymVTUcYfViwFwrXpTpNkkpHs8gl4
         otBJYE9GgyVPV2IUsre2NvaRLOV2zPcBDOjAv1YT/TJrss4Pq0CevX+URUlIVbdF1LB+
         iN55YZDkHNufNljGtkNuEStzk9IaQR+nbcYV+y7g4IE4bHodjC1+Z4Qpfkkd525fXANf
         yjTMIfngYNzhYLbG2HD7dSz7i6QkbKb7sIKmnwYNW0QDrTCnZACMi6z8+NrNv2a+YLfm
         iQJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795688460; x=1796293260;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dz5Obh5lP0tOLHLiHWSWNzgVimL59XKVdrhzCbJPLAQ=;
        b=LXohVvs+mV2KEUgb3JfagAUNtp4xd3rkZLvG8boFMSTUgzjcu+hQlNBJKNJyV3+GOW
         JwUBltwMLYJzvcn2kJzsJAGmADJBGw7cx7NAIqC2C0gxEGxcyqph2mVRJVpqEnV2uRJp
         ASUAydAfo7rZSGkCZp3UXsbPR7A+6SjA++ELCyJwpceI35kMEirtB7jxF8Mt4abUyyw4
         4VnqehJQN/LyJwwJe4Ek5l67Nc0Bc9FTws4dgGrtl6NyRI9WecFXqUJvW4PYx0LoF0gj
         Oc7Wj+Wd0P1dbJ25lZgEwjWrY229ERZCpEyw+iDO4rMuXA+iVZgDevjwaA8d6jEV6DFW
         85XQ==
X-Forwarded-Encrypted: i=1; AL+hErFcJghvERCyrB0VbTs0w97cvKc3jYbr2RTT07owz4kzijHg8dzl03GDlDUjawiyflC0oKR95sUDu/7zxTPp9SM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+HxLlLM1ay0lzTIe3qx+jHS0o0LD61fpgPg5E6oKUKdiI75Fxv
	Kq3mmf8RLNHZ/RzDvTJNJVu05JELl7gE3YEwBCZ3XO56E+RZ71xMcUoH
X-Gm-Gg: AZFdTZfvB+xWYPaxRjkVtlhgQaOruAcdTdfxHTQT8Tm+9u/jsNU7MMun0KoQL6ccKTf
	6RIDTh1Cina/cy8++G77expYzeYbpzysJGKnSFm7FdOuvNKS6s8kse7FNAnU4sJs6lVOgnN3/gh
	YOS5NVcpGTJ6INSoRMFqMy4qDDJn9Z20OQKAz4B3OcR3OwBS+etuT38Qk6Xet4JUOS4uobwh+j1
	3Nh5XiaoEAwEkNfo2uWrd4YzAKP0VAnHGebsxNy/5CPKg2u7Xdyxv5Y4A5ya0E65Vcw3BiOdDId
	mPtCq+BmccciObg+eItLDLbxhVW2xcywnVjcAqvhYidBVAfEEYyYAOilSolZyc9SExxMCxmLRFI
	udEJtNj3+77UqpRvEG7zgStW1UGcB/79HyFCLxFQYOesTYlOFbJfb3AM1uCbU2pcWR6HRch/Cy4
	c0w7wSzKxe/xJZzgf0ejKsV1i/vzWDGZQc4HxA/+/4SC1FyaP0SivM5YS/crIAbtsaOloo7bIfz
	oucE7jbUPELgLvFYxjPRWQwqAEzBRGgyuviCR1MO9HG1j2JNh0ubcVsNACrb0NABZVPovhRKzqa
	mWGlAPwmoYXPMLjJwp5NABVBqLY5DePcvqZcPCWI65/1KxHkKZl3NsX7eBSAr6Th7A==
X-Received: by 2002:a05:600c:3ac9:b0:4a2:a3b:7aa8 with SMTP id 5b1f17b1804b1-4bb887e068emr432378915e9.3.1795688460499;
        Thu, 26 Nov 2026 02:21:00 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b2c5sm581334935e9.5.2026.11.26.02.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 02:21:00 -0800 (PST)
Date: Thu, 26 Nov 2026 10:20:58 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Xuanqiang Luo <xuanqiang.luo@linux.dev>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, John
 Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi
 <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu
 <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa
 <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai
 <ihor.solodrai@linux.dev>, Matthieu Baerts <matttbe@kernel.org>, Mat
 Martineau <martineau@kernel.org>, Geliang Tang <geliang@kernel.org>, David
 Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, Stanislav
 Fomichev <sdf@fomichev.me>, Neal Cardwell <ncardwell@google.com>, Kuniyuki
 Iwashima <kuniyu@google.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org, mptcp@lists.linux.dev,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, Xuanqiang Luo
 <luoxuanqiang@kylinos.cn>
Subject: Re: [PATCH net-next v1 0/6] net: avoid stack canaries in TCP/IPv4
 fast paths
Message-ID: <20261126102058.1fecf50f@pumpkin>
In-Reply-To: <20261124130631.1886963-1-xuanqiang.luo@linux.dev>
References: <20261124130631.1886963-1-xuanqiang.luo@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 24 Nov 2026 22:06:25 +0900
Xuanqiang Luo <xuanqiang.luo@linux.dev> wrote:

> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> 
> With CONFIG_STACKPROTECTOR_STRONG=y, a function that has a local array or
> passes the address of one of its locals to another function needs a stack
> canary. The canary is set up and checked on every call, also when the
> local is only used on a path that almost never runs.
> 
> This series removes the canary from functions of the TCP/IPv4 fast paths,
> by returning results by value, by using storage that is not on the stack,
> or by not calling a function that has nothing to do.
> 
> Patch 1 returns the two mptcp_space() values in a structure, so that
> __tcp_select_window() no longer needs a canary.

While all (I think) architectures can return a big integer in two
registers (dx:ax on x86), not all ABI do the same for small structures.
For those architectures returning a struct by value is implemented by
passing the address of a hidden on stack structure.
So code generation may be worse than passing the values by reference.
I can't remember the list of architectures, mostly old ones - but not
32bit x86 because the compiler option was set when regparm=3 was added
for 2.6.
(Note that this is different from passing small structures by value.)

David
