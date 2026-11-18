Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794991107;
	b=GAXvl/CjXrXkkO9kovwuDkFo/zGXUczk53H4rywEK4Y9nYRI/dBsGxaxDCnEMFrlIOoP
	 Sw4+x6hOx9c5OKnFCojb5TOprGGiV8SIQqp5z8Za+QLD1Eaq6ff/35iGQRkrOXse/mO50
	 2y2O9eaUdHc5Ckt4ofubbOYh1hqwa23hTkIGXe1hWZNn3ecpmDY9LWRaMxzxegr19t0vN
	 7Hm5RxjYqgNoYzGzN3InHYYlqczIeHz567Y0eQUzaW6OggxNY3aNZ4xfGyoCJLsVEJDzW
	 wHre+ii72P4o2RkKDIW1nM3opQsLkdQElI5K81ghQopSKZQ6OfSvqYEgu2BiG63FlgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794991107;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=KRtJKN4D7KTr1hM8wuPqB24BsqKEkGefeClnbMZYA8w=;
	b=F91iQ4jA93uEWaviIzwYOVzFSLJPr83yEgHnIkhH74sDEaRCVjqVylcXNWDxrhChd/Fz
	 9Q6sI5ubC3d1+7oy/LAipI0YsxmKKEhOsCqooPocnbBtd4mRPyRU8JNYynivxVDQ+sdQd
	 Yio2n50l+q7Vd8OCDf0FuecBYnN8ElhsGJ5o0FbskEbELing5jzvu4i6PbShQXRLUR1X+
	 7SCqKsuKDagI5zOyIpt7MbBBVpLLZg9dXYrSFiwpzUwfspz/HF3vAtO8M9PPLZlh/Krkh
	 KXheYFbSb4RSBJ8RQtGrzstg1Nj3PA9Y5rT99JDrkwWSC+9IVTHzdhxFJefH6Fv7wsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KpndDx47;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBED606A887
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 08:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KpndDx47
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1C41F000CE
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 08:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794991107;
	bh=KRtJKN4D7KTr1hM8wuPqB24BsqKEkGefeClnbMZYA8w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KpndDx47BE5PHN3YkOr4wC8d2bDJvwZ4SWTFzw18wMRjvayc1gsqvYI0hZDC95qEF
	 ALU6Ze17g/ca//vsoZfQitysDrcDOAqRb8C6Z9C6WWVMlGc8xxqYZnItOeZi4Qvy1u
	 THrX/P3h/6FWt0iKQM+SpbJKLRqZDrq4qceAioNTxpGQWMNfoeCUXpgcyOsBPjAIM4
	 +KAj4GEshy4eUi/SneVPy2sMqiVN5rC/rwY8bIsmDvIXhvcqiihnlY/ThlrEkJS0W2
	 p10X6mpZ/hOtZ/GIJmDZ11yXq9f4nlF+UxlERuE4BHt7Rws/1bZxmtcR44mlj//x/u
	 ugYQxA0b91DEg==
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-70b875f6f1fso653980eaf.2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 00:38:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHCdOj0f2jI4LpgvQ/zkj9/ZSg04SGLbgCksDAWFd+vuga8VpmZgHWOapxCuQprP0I/5WvhvrTrHgecQqxmRh0=@vger.kernel.org
X-Gm-Message-State: APuU4Z+D4Oh/nbbUnArjHivoFWEIdxdPICIDb2RMV2igzp65ATdZtRMb
	bJHay1+XYF+BF1yJHnEPNecll0FY8eyDRRHDOoUyA7fTUy4vZGzUhsbrAwhpUBcBxXJ81/66egF
	cpAcC8vfK5k6Xu2jdFdSme2u7k8Q5YjE=
X-Received: by 2002:a05:6820:1c8f:b0:71a:ecfc:4406 with SMTP id
 006d021491bc7-71b187ad482mr1476088eaf.64.1794991106787; Wed, 18 Nov 2026
 00:38:26 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118070524.310356-1-jiayuan.chen@linux.dev>
In-Reply-To: <20261118070524.310356-1-jiayuan.chen@linux.dev>
From: Eric Dumazet <edumazet@kernel.org>
Date: Wed, 18 Nov 2026 09:38:15 +0100
X-Gmail-Original-Message-ID: <CAL4WiioCxT9izsNuNAXWg4NPbJJMR3z8AXCSj=f+2_+frQ0mmQ@mail.gmail.com>
X-Gm-Features: AclHuK--9fXfiLB24KQhCJA7_PKXTYTcPONOafDRgYRYIXUHHUrYJaZBcAt_Dk8
Message-ID: <CAL4WiioCxT9izsNuNAXWg4NPbJJMR3z8AXCSj=f+2_+frQ0mmQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dropreason: add SKB_DROP_REASON_FRAG_MEM_LIMIT
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Stefan Schmidt <stefan@datenfreihafen.org>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, David Ahern <dsahern@kernel.org>, 
	Ido Schimmel <idosch@nvidia.com>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
	Phil Sutter <phil@nwl.cc>, linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mer. 18 nov. 2026 =C3=A0 08:05, Jiayuan Chen <jiayuan.chen@linux.dev> a =
=C3=A9crit :
>
> This is used to track fragments dropped when the reassembly memory is
> over the limit (ipfrag_high_thresh, ip6frag_high_thresh).
>
> Fragments dropped because high_thresh is 0 get this reason too, the
> same way they are counted in IPSTATS_MIB_REASMFAILS.
>
> Tested with pwru.
>
> Before:
>
> ... PROTO  MTU   LEN   FUNC
> ... 0x0800 65536 1500  ip_defrag
> ... 0x0800 65536 548   ip_defrag
> ... 0x0800 65536 548   sk_skb_reason_drop(SKB_DROP_REASON_NOT_SPECIFIED)
>
> After:
>
> ... PROTO  MTU   LEN   FUNC
> ... 0x0800 65536 1500  ip_defrag
> ... 0x0800 65536 548   ip_defrag
> ... 0x0800 65536 548   sk_skb_reason_drop(SKB_DROP_REASON_FRAG_MEM_LIMIT)
>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Reviewed-by: Eric Dumazet <edumazet@kernel.org>
