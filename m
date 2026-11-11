Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794416441;
	b=G3bvK1BMtslggewhcYCi+cQQa89FOtoCyZdV02yveSaJ9vXEUgO17B3BkjXtFK6dxJgG
	 LvTmtLbiWmaTva7vY70h6c+LFz2aZu+38AZVyGkfq3/IHSRjVH+sQ3wXUwDplLgjyQdVB
	 Kuk/Ws85TfrXe+Y5pIXdDtmtOGAOHrMVB0+WArmgxVJvowOWEoq+q47WW99wA5DLAwyJ6
	 OR0LcaZW8TFOzdJv5/ckoMbWSPF7ODRA8jy8bppFFFlw7nIr5P3N4UXF1GRwnah7QMFh7
	 dljwtcnb5zo7ZpEkw9VG4v+acfgncM+ZFuUop2ffCypi1sHk2EwCdzKyQcP6/Qh6Tnw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794416441;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=74FoFchhuSQQ2jSNjsBXa6BV1QiK2Fm+lk28fFAbdUE=;
	b=ipodcsCzmVjPbKfFR4jbdaivJwmkWIN+4foVwGP/8TcTPQRzIW/GCumq51gqYkwuUX1Z
	 2D0a28ROfqKeLe0CzBGHYF6/TAkz7/2wKkGUf8Kuzdr1UGnlxgCfpWqXtCnNgaJd9yOdh
	 cSMkL1CDwp0ICs8Y3lx27lycWwq62sgu1tUqlizJX5UNFnREifat/WojPucnXilYhnXoc
	 0GBcFGIYfV2eKn1BHqEPG434xMKHhUe2k3dH7JWmOIWY+T0j068D83tJGPZ2dqXexNVEx
	 3UqTb98U9au+MzhtulZ56wjlP7060/MDm6iAr1ahcS6ChhlXFZiz77SdBf7n/CX2M7A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=KKDUZEPW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513A8606A326
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 17:00:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 513A8606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=KKDUZEPW
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABF2j2j1280652
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 09:00:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=74FoFchhuSQ
	Q2jSNjsBXa6BV1QiK2Fm+lk28fFAbdUE=; b=KKDUZEPWjFxEuM39SyRtvJ/r0/c
	+hQ8uhEGP6gr2JUPPDpEGcq0NTiQEyQ9i8Y2g3dv39QgOtx59p8EVdbDUQLa6L+t
	94/0SvdQaKFzm4Cv+3qMAatvhm6L/NQDjRHUOOvxpSMqYTskbxEpPNPMbZb8J28Q
	VEnA6gATK7C0rGaA8Xc8mBs9uwKNehQFzrIi16cEvw7v7laleiJrStlzJ6yosvTH
	sB1t+/ZON2DzbCDWmVTFGDgroxRJzYUeSJWeXZaQlf4jqciqfQuDmTSiFxExpl88
	c+tWUz6RkiMrJFompExetsSO2R/KCDNAgyE+nnENK5DPuycgfbYUa5suUXQ==
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hvahfeugd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 09:00:40 -0800 (PST)
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4931c89d228so2276239f8f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 09:00:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794416439; cv=none;
        d=google.com; s=arc-20260327;
        b=nqbwBxIxGF2WCIfvwnhqe8zr0NUgxBIZxykDh9mGOF2NiQbkFxGT57QT47zLdBe5jr
         MpgShGy4AZPuvCRmcReWSdp0LlqeND9lF5OwvFZr66hFPGtcBNU9ci0chhfAv3JS+pOS
         E9/UjPDbguJiDh7aL7NFeXVqe/O4+Hp5UvEDl9JWbdtwbKZArjMu6Htir9ziRA+3Oy62
         DBM+vXHuI2p520uEVQvwKtUImwUYNUG8waWY1l186KYRFdG+7KkiIZyiFchEMTh0Xw3x
         j/1tn0o/qTJkO9EYg5IccZe3l2Zy4Mvd3sIti7+v8UJGMb4HuigEWfGgIQYjihDZvZ4X
         F/2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=74FoFchhuSQQ2jSNjsBXa6BV1QiK2Fm+lk28fFAbdUE=;
        fh=W0+DFQRg0rF4RB6zdQJyN42WAlkZ/k5z3aiOLDyU6ug=;
        b=E9nJE/NHoLrbUchlX/0TB9Q1qGnnyfYMBlp1QTYNeqF/X0iTS+WqjxsjfczxK2rsrQ
         jTephzbJW8j+T6rEZpHy9ahzYAuOWipEdMXjb8jaBDK8L2Idoy3KogN5iuVe0NM7FT4W
         f9yAa3e//e3XFsZAdCDAPAxNl//DrXc1/7DVPMlEh14KUM34l5OS3qLVtRcSWU6RMdud
         5lvtTsJrtNE4C/YLGc+uK5NaK5EnS+CNBOuGNor28sRFBPDXxTF9RW2GhGgt5SEYjp4O
         IxIsLNphVyqpdI4hM9PeEbwnCDn6b8idV1BUJjFVoK9OtZIWU1R7c7UI5fo5KWxXS+LN
         I/rw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794416439; x=1795021239;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=74FoFchhuSQQ2jSNjsBXa6BV1QiK2Fm+lk28fFAbdUE=;
        b=HypuzEPd6BtUCafWIGaDZLIHKhrHZCvfjitjwhQofui74F82gidZH+DF0SKVBFMgP8
         pF6YDH4oSLvzANdMabRjRkPH2mr75v480zdgPMiM8EJA74Q6zPYTXJlXOqlhG0pPKax5
         24123+09ABiEj6vXTw4eLDQGF0Jtd5QpTGfW+P82N5tJ8U7ImVfP38iCRKtlO/stUx9u
         hLLKRF118ijZkaB5uGJ8DeWlPMMOwClf81uZxoDpHFXmDkRFlTQJGVHRHkJX0rQFtVkK
         /eQfU+BDrgUNBMlFudLrq7ronc+qyC0xI0a2jovkI1Pr6CUEG4xvIxe74RLS6BqiHARQ
         vsdA==
X-Gm-Message-State: APuU4Z83SV73+z+CAdrZVPDIsf+Gki0omMeFXHysJSarfd/Y8V47VmJw
	890hc+TkcLKLPrsQAchz360OctfJLL/1jfIfPF8+TbPDmP/40EB9rlnph/X2R+698NBjW22M7pw
	yygQBa/1PQiNpoG3I2dprqEi6WhTAxHuSv3T40s477zE9BdDrMfxdF2W2iu0YgE1vmeabLMHD7W
	j/oDqWm+KfL8C41fQLxP5QGcnaCiw0dHzDsXdf+JsCtY4=
X-Gm-Gg: AYBFou2VSig/jVWX1miJuYzKnVkYgmu6YkMLGLhJJ0NbIEMvVOZYDdLE5+OERwKgji1
	mCnIo31jChldinhekXyqyNNd+L89yn/OB+d6LI/JkQGrzRpts5igj+7t8h8dWaBfTy4OdAcninC
	9u7pyqrdwtqDS5QzeFfpCHuPj17Tx5I1NH/7Gb26S9xUEAeKkd8qwAg/wAxh/Ym2gwDChm+4pUb
	/z++2uQMjoxEvz42HdYwJGnhCg4J83b
X-Received: by 2002:a05:6000:401e:b0:495:5c83:51bc with SMTP id ffacd0b85a97d-499c3b9ff3emr5473705f8f.5.1794416439147;
        Wed, 11 Nov 2026 09:00:39 -0800 (PST)
X-Received: by 2002:a05:6000:401e:b0:495:5c83:51bc with SMTP id
 ffacd0b85a97d-499c3b9ff3emr5473639f8f.5.1794416438735; Wed, 11 Nov 2026
 09:00:38 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111003111.3826942-1-toddfreed@meta.com> <179435738198.2168702.12439855185550580348@kernel.org>
In-Reply-To: <179435738198.2168702.12439855185550580348@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Wed, 11 Nov 2026 09:00:26 -0800
X-Gm-Features: AclHuK8tjqwSs5WvfY5ngy_lWto0eQaig-gnzMnKLMUSIRvHhVTmNTSnDzSw4Ys
Message-ID: <CADh2yMyWd2JMajjp42yx-2JEa6NsMoX1JK+2qVaci9vths6WkA@mail.gmail.com>
Subject: Re: [PATCH nf-next 0/2] netfilter: don't send decrypted skbs in clear text
To: netdev-bot+sinfo@kernel.org
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        coreteam@netfilter.org, bridge@lists.linux.dev, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-ORIG-GUID: tA6jHlsDv-69aCF5NDGN34wj_rae9XUk
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA2NyBTYWx0ZWRfX6GG63+e/EKAe
 1bcS+Mw88jejz7uu1cjxA5n6vp8xpvvWbLN+DEp/Nb8f7tZZ/gs3OlAREjjJxJTGRXjHIkDaNoS
 uipPaRo+21sEr5YZlGwyQaOxSGx3nYA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA2NyBTYWx0ZWRfX5obI0sVHGNdg
 kcLn1t6JISRLORINncKP/ZDRAKocEi6TxX29USK43DNJH6CFXFDM8RF9p3Dl+c8OW6YY3xEhbqX
 Z2LqQcJOAiIysE9JZIOKREzzK1vcgmV9HosgOrKIrLXhrQeAbDdqNLeh1jcRk1AzOduyV9NzNDy
 bI4q46l/R3Ztdd3nw7GPsB708MnutRFhlP6fnlsbLa46+JVmznAxcvOTmo61c1aqY9US4IEGGWX
 U1/2OR/XPj8n314XJLNrifoqnY6PAWTckyIdT2TH2LKESWfOcZ9ON0XYE0SU3wsXxLTCqa+QNMq
 iGEem7+Zp7Rb8+olcqfFjqFrZUIN2UDefxLvW67PTchThMR5mzbfQ7ih+MSgC0E4itQ2SxQ5Ysd
 ZYhZ5+Gw8HFQ3hbAxQzq8YqRkXsGcaT5nrAF4Y8P5YzUWZeL6ipqgdLX7xORqCcoou8jsQ1eKrm
 Y8KLhiO9IIeti1SI3TQ==
X-Proofpoint-GUID: tA6jHlsDv-69aCF5NDGN34wj_rae9XUk
X-Authority-Analysis: v=2.4 cv=HuPjiETS c=1 sm=1 tr=0 ts=6af49f38 cx=c_pps
 a=I6ewnrIBtnKHmb6SxpX7Vg==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=4h92JMTCafKA-fb_NiOh:22
 a=v81qpcjm-LW16Aac8AIA:9 a=QEXdDO2ut3YA:10 a=MqNruPmfsT8GavliLQMe:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_04,2026-11-11_02,2025-10-01_01

>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.

Hit during development on crypto offloads on the net series that I
linked to.

-Todd
