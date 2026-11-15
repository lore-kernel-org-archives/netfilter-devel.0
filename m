Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.6.0.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794761155;
	b=4H+dEaMHySFMA67PAn5vAP7PSD5zpJMxy6pRXbMfgvid1Djc/wO7a2Ee/HkFnIrEpxHI
	 fgjpMCYvQAywEIUZjQjmDAce+rU8TbNezcT+scUcVLQ+vwYyb2ThZcFla02EskhSxl28p
	 jU2bXfx5/htEQqdn8N1JE64E6gCq4kz9EOMaRq6QMY1eFZ3wLtw9VCCl1LB0AaKuvTjmg
	 1TISBfqbwVYuhsNugH3sX70Wy3x7hevtWrlU5sZh33+TMg0dv00fT2CSofXAlE+5mMWgH
	 R9O3Rl39rgqVe3NfZvHeFgJrm3pOIXlNnnynVh+la6+xsEqXJcu0UTMhV6UiWHhxxrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794761155;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type;
	bh=piXu8kkCIcszJ86E8iPiuXPu+7XX7JPPLbQ3Oobk604=;
	b=D0hYhrMUYH8A6Z4du7grlL6fzxstcPl0EmiRtkAygBaKaXkMeVl2u2iOYQPyzOTRORvU
	 YOThdXe6JYrcmQkx+K7aDf8hrg2mI90pjRNK7789fmGkP0sgku8z91Jk2tOub+141yeAX
	 wqiQsbQdfhEDhnrVB0F85YYWKSzx4o/5g9BVDvKYc7Uf0pDC4EdZF1TSLZ7EDlY2b9b3J
	 QI/ZZpDagWYPF4G9i6Onydt6+KBARPORyCPKwvYyUfrRp9Gt10Wrjiw2PLLSYH1NTLw2Z
	 fWRGFZi2fBWZq20FycCmza0jE/17dn9kQyuvrd7qtYTrce5uBdgdtjltUs0VQCY4Xsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	arc=none smtp.remote-ip=148.6.0.50
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36245606A31A
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 16:45:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36245606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4jSH1Y3BqCzGFDCV;
	Sun, 15 Nov 2026 17:45:53 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id svP8dBQLqz33; Sun, 15 Nov 2026 17:45:51 +0100 (CET)
Received: from mentat.rmki.kfki.hu (254C22F0.nat.pool.telekom.hu [37.76.34.240])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4jSH1W3WLSzGFDCR;
	Sun, 15 Nov 2026 17:45:51 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 19328140554; Sun, 15 Nov 2026 17:45:51 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 15D59140343;
	Sun, 15 Nov 2026 17:45:51 +0100 (CET)
Date: Sun, 15 Nov 2026 17:45:48 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ipset] tests: hash:net,iface.t: add test case for wildcard
 matching behaviour
In-Reply-To: <20261028130203.1398-1-fw@strlen.de>
Message-ID: <9744e2bf-d71b-0a1e-a170-45b9025d1584@netfilter.org>
References: <20261028130203.1398-1-fw@strlen.de>
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

Hi Florian,

On Wed, 28 Oct 2026, Florian Westphal wrote:

> Document the existing behaviour of wildcard matching.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  LLM generated.  Passes on nf, fails with
>  rhashtable conversion patches.
> 
>  tests/hash:net,iface.t | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/tests/hash:net,iface.t b/tests/hash:net,iface.t
> index 556d56df5c4b..b1d92bef26f8 100644
> --- a/tests/hash:net,iface.t
> +++ b/tests/hash:net,iface.t
> @@ -235,4 +235,30 @@
>  0 ipset list
>  # Counters and timeout: destroy set
>  0 ipset x test
> +# Re-Create the set for wildcard tests.
> +0 ipset create test hash:net,iface hashsize 128
> +# Add a specific entry first, a wildcard entry for the same net second.
> +0 ipset add test 10.0.1.0/24,eth0
> +0 ipset add test 10.0.1.0/24,eth wildcard
> +# Delete the specific entry.
> +0 ipset del test 10.0.1.0/24,eth0
> +# The wildcard entry should still be there and match eth1 via its prefix.
> +0 ipset test test 10.0.1.0/24,eth1

Just for the record: this is a variant of specific entry/overlapping 
wildcard matching and it fails in the original code, which is of 
course wrong.

Best regards,
Jozsef

> +0 ipset flush test
> +# Same layout: specific entry first, wildcard entry second.
> +0 ipset add test 10.0.2.0/24,eth0
> +0 ipset add test 10.0.2.0/24,eth wildcard
> +# Re-add the specific entry with -exist, expecting a no-op refresh.
> +0 ipset -exist add test 10.0.2.0/24,eth0
> +# The wildcard entry should have survived the refresh and still match eth1.
> +0 ipset test test 10.0.2.0/24,eth1
> +0 ipset flush test
> +# Add a nomatch exception first, a wildcard entry for the same net second.
> +0 ipset add test 10.0.3.0/24,eth0 nomatch
> +0 ipset add test 10.0.3.0/24,eth wildcard
> +# eth1 isn't excluded, so the wildcard should match it.
> +0 ipset test test 10.0.3.0/24,eth1
> +# eth0 is excluded by the nomatch entry; it must not match via the wildcard.
> +1 ipset test test 10.0.3.0/24,eth0
> +0 ipset destroy test
>  # eof
> -- 
> 2.55.0
> 
> 
> 

-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
