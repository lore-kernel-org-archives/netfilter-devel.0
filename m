Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.6.0.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794761576;
	b=5pt8v6X4CH8ENu2LHqjx8CLwisETAUTrtWXoMawZHb3HNywLT47TakD1Y0BfjH7zBowG
	 NfGkSkDAe1rdHYDuCIh4XDHExuJRxHxMzMh+hGQVa48lqMt9eBAdoW9ApLGXm/B9X+ysv
	 bp21RdJIVpWJDXkkqty7ufbWzJNKHwhRbKgMvSZwGy/+YTs5dJ9FXEBwGSuqUD//JPhT1
	 zLtgyZ0Tjk970mcbkLNsTatOOBjvtreZcDayr+vfx2Ku+f/C2N4OZym3vzo5tGG/ynhHh
	 FkMxlh6n6LQtB48XiyHpiuZ5QFRxQFglmrOdOHfKKMeZoi9PoRnd5WGuKaXH52ZO1gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794761576;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type:X-deepspam;
	bh=pEMI8wqiG7zgqcsjLGJuotIPMiPWKfUi//5A85o0gmw=;
	b=oc/YmVCqMPVSCOa54mr4qf35v/WImz+iztk2NWRyMFsKI9LoKO/V3kE9DdX203bQs+Ei
	 odNvCQV4S6IHeKAiTNriCXX1ZGYLsGpyZ4GfqzaNMELlTK+5pEDcvIEx8uloYZBpGjl+t
	 /0ARVWy4Pou5xLRwYgT72ryJwoie/X/1FDWw+A0LiKj2hZ9T9gl6RVAHJj67RLnxmb69P
	 qwaUpll1IT17+NlfUKUdFDUjxsKBVUKJ2l5sCvvZOThGNtMpL5FtOyv05K1xD54UPv2sJ
	 Adg0cOw6vp53+tkfdrRRXHtjpfDKXaWkXUMU1BH01HQKPaiPVkIlsCk2wualdxT2A5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	arc=none smtp.remote-ip=148.6.0.49
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B89606A323
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 16:52:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91B89606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4jSH9X2MqDz3sb0W;
	Sun, 15 Nov 2026 17:52:48 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id MFVAseLapuQC; Sun, 15 Nov 2026 17:52:46 +0100 (CET)
Received: from mentat.rmki.kfki.hu (254C22F0.nat.pool.telekom.hu [37.76.34.240])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4jSH9V2Cbhz3sb0T;
	Sun, 15 Nov 2026 17:52:46 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 13173140554; Sun, 15 Nov 2026 17:52:45 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id 0FB6D140062;
	Sun, 15 Nov 2026 17:52:45 +0100 (CET)
Date: Sun, 15 Nov 2026 17:52:44 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Florian Westphal <fw@strlen.de>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ipset] tests: hash:net,iface.t: check wildcard refresh
 ordering
In-Reply-To: <20261105175810.22833-1-fw@strlen.de>
Message-ID: <0d44d680-726d-c454-2d9b-7037b911a8ff@netfilter.org>
References: <20261105175810.22833-1-fw@strlen.de>
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
X-deepspam: maybeham 6%

Hi Florian,

On Thu, 5 Nov 2026, Florian Westphal wrote:

> When the first wildcard element gets re-added while '-exist (-!)' option
> is given that request must not have side effects.
> 
> Check that the verdict isn't altered.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Yet another problem with the rewrite.
> 
>  tests/hash:net,iface.t | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/tests/hash:net,iface.t b/tests/hash:net,iface.t
> index 9f3d9e36e232..216f7e8a0253 100644
> --- a/tests/hash:net,iface.t
> +++ b/tests/hash:net,iface.t
> @@ -289,5 +289,17 @@
>  0 ipset del test 10.0.6.0/24,eth
>  # Check the wildcard element was removed
>  1 ipset test test 10.0.6.0/24,eth1
> +0 ipset flush test
> +# Wildcard refresh ordering: add first wildcard, marked nomatch
> +0 ipset add test 10.0.0.0/24,eth wildcard nomatch
> +# Wildcard refresh ordering: add second, overlapping wildcard, matching
> +0 ipset add test 10.0.0.0/24,et wildcard
> +# Wildcard refresh ordering: first-added wildcard must win: nomatch verdict
> +1 ipset test test 10.0.0.1,eth0

This also not handled with the current code: the wildcards are not ordered 
in the more-specific, then less specific order.

> +# Wildcard refresh ordering: refresh the first wildcard with -exist, data unchanged
> +0 ipset -! add test 10.0.0.0/24,eth wildcard nomatch
> +# Wildcard refresh ordering: verdict must still be nomatch.
> +1 ipset test test 10.0.0.1,eth0
> +# Wildcard refresh ordering: destroy set
>  0 ipset destroy test
>  # eof

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
