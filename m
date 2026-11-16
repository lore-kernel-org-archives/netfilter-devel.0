Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794827172;
	b=xOZpHvVg+ixyBxesA2WpRV4te8uKkjHdor1W5bvWMtuTqpRfYD3LPmvWgV4yvw/NTLAF
	 76FMAN+KpvipWlizi/fNHGw8W2HEgp7qVyy8i0AqrBF4uE+7ZICPTFicntB9DrTvD1wvw
	 ODHgWwvQjpET4PS/fQ+3ijbMS5j/LNuSd/HRlWmgXGtLYN9LR00iZMqKZaFaYE6YPHcwG
	 oP4++QIK4eNL72hUZArE5qz6iGrhnlxlesIvS4ZqjUlgpmpGtoI/3ZpGGANdDpj+B4ce3
	 ocnX7EwtFCsKcSqZ/xXPL0Guear+4YYUFrSKMZAoWlBk/iIwNUGIH7y8fUfhCDoYCaw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827172;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=dLN8aiRoaQl9Ve8XJrxdhrN1+k0tOuthcaE5ENMWVqk=;
	b=gw9mYThDV5Fqc2nbgX50GBKFvCb8NsR3f/03zPcLehXt0sCD/cmCPDmoGmfHY2geONQC
	 H2FCVNCnShTk/YBjKa12ORlKe3V/NEhp2sqR09yxAh9/6XnqZUGDs50I8O+D3GHh5x9+3
	 15oeM6TYm79MA+m4i8jiARN8ybL4sTIKMtboxI5+MpY9oFPQQv3q+oeYKxHBZnTP/TTKG
	 DcP7bRLKHHD5MZQbbS+vYkx6bRTtgDls4jfpbwwMEZIFz/+f8DLcARXVJW0y6zPxDTy6i
	 2Bt6uPQ0ekSQMNfj0TiVavvxPrHDFkVAFh01aOCiySzdKc9KtTvtwxkLmKCljX893OQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MM7aY2mS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6738606AB5C
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 11:06:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6738606AB5C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MM7aY2mS
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5c126fa1e3aso2655493e87.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 03:06:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794827170; cv=none;
        d=google.com; s=arc-20260327;
        b=NFrjuJnp9d80GVOR1dGof65ChP2sVKaGlcMmEDUz6Zt8CYSauesuebL/D8iwN6LC/2
         nDt416fQDxDaeH7HaL16at1VkCYtziGNQLXmr5//eyU5nJXcaF/0c4uJbhFC5MXAF1Zg
         Hfh1t/TpVArRhN9oy3qc/coZU31m5IX02stJeGiQsPUAneCm2ZUBd+Q4jpC1yZGWKed4
         mVTST0m9o5tERSlfR3p6BOdVd6ctETd7HGWwZIP8Cqq4NIiSRfJx4eIYqU9q8nGvgQK3
         seNnaksbPq8oeCUSlDhtJfo867GQQuvpMdl6O7YxA3r6LsSWNJVPaLDQj8RimZBn1uIB
         pAZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dLN8aiRoaQl9Ve8XJrxdhrN1+k0tOuthcaE5ENMWVqk=;
        fh=zK5gmfZa08e7fq4s6n9OCJTUVjvL1twUE8FIxnafOj0=;
        b=BfcUk5Jg0SZl4m4Py3xWashRk4qVZTymDr2azgffGxQjk31oZcdaaCIAwnOXbmgzja
         pRxMRz46DRGQN9aLVJipQsbdyoUk0aKuZfIbIQbqBZ7z7WuoL77Jx69x6FnmG82ghu5t
         U8lnUvB9f1Y5fBqwVyO0nCVsIP28MjK/VJ/NAEiOCdI6SKHApG0YiOKxaR/Xnx4gec6f
         QS1GUk/ry472OFnc1WzEex2QZ3NNOMKNcoS183lbvvo24jMm6K732juzCA538VwFIxlC
         cr830XiMxHj+wQcnn3+XW4+ZrbW40Efvlj1M2AbTEcOVrwTgft1ZGUdMLCUPpCT/FmEG
         Z86Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827170; x=1795431970; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dLN8aiRoaQl9Ve8XJrxdhrN1+k0tOuthcaE5ENMWVqk=;
        b=MM7aY2mSPEIQVllfpNqh5bwQ6QbU+aOeRwC7qRaM5rD5klClW3/VM1rOJGlbmpwv0m
         VbNtyOjqW+qjIa1vdDiDqjyuaRF3LaV4qNsG+xLJu466G1oeke4oJZE43pyO0yQRXsUT
         EXcFxoWpshrvLyPuKlh+M9hHMlR+NYb9OUdmyOHG3X1p/36rOa/onGLUJwFABHG5nYPO
         YUsY7kfBvBV2IDKkzlQM83sk90sNxfmkYWOCoiJcrX7F0nB5rblZQOM1l2YAZmQ67cUv
         nCLtEue31h4D+xqdaWnii1YKaRjJqeLGkvlRmS5iN/ayFSNyU6VbiIm7scCBxpkcA2ho
         S2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827170; x=1795431970;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dLN8aiRoaQl9Ve8XJrxdhrN1+k0tOuthcaE5ENMWVqk=;
        b=cnbm+bgSvLSYgsZ0AzFauqp9apWGWmg45QCbRg4fog9QpEA0W4ntcNtADj8LdK5lHh
         7/pC+JAfjxJghWCKPzbL5DeLgwdUacT8R+UO0mXA9wtTMBd+u1pBBg2wqm1CuSIESU2+
         51qjW7F8yrlJ6M81dkorrWD8Nwv+AqwohiDEFy7vfynEDNfqDK4UXKN4yYTdUppAO59h
         KOFxFfI6KJ8Eg6q3JfNlMjOpykK45tWxgYaAt6IVaTEWScfqxMi6bT1VHBVcl8DbU1ii
         +A3V4mUhMPAgJOJEF39kpr5TcSMLsl4eqY2VNoBhbZ4K4/CqZImZ4c9DwBRWmvmU7SXF
         +t3w==
X-Forwarded-Encrypted: i=1; AL+hErFXeBQPSN1mQS4Kqji39XpR9uFGeAsZueOA3V0NHtrzig+R7eaCGnm/A1wciLMY+Y0nIuIL8fOx35R/ow6FPDg=@vger.kernel.org
X-Gm-Message-State: APuU4Z/itqKciw1M8WtuxhxqA4LCfIMa6NHebWZnHRGF+RjFDoSu2W87
	5Jnjn6asFM/sZnIGSSSNq6q6v1MNv/r0oq/ior1A+yLJIDk0+CF5KgcCFat0o8PBi5nJCjZLg+j
	80XlR1Ipnub5Tdmz/GCp9txvzrrTHmk4=
X-Gm-Gg: AYBFou1csYfsX5LBSaJAPC3x4da8juFE7JFnk/Hqay0coSvLeGlN6DsjUJIKXqbRMv/
	38EGPuDBOe1RNsAyrqAIWwNyqqybAf9UobjBnZpF1jX6SX6Kee859JGQQHcQRXL1aecPw5KwCrT
	T9evKaPp8d8acqAg2HCYe0iHGDfZFUjGgAusWVMVQEDlZO9AX/AQaRTdltIJT7eX/uZ2xsX1lch
	pm2b7gjb2cJC1TCbOeebbMK2hxcr7WeSlNH7SvcbznbzBY/AfyT/HfwbvNOhP6hHHejWmhF4W9t
	uVWAOagisl4uGE90pArsKJU8YKYG/5qQEjW72xY/1SsLM2hA87meNphGOdIqSm4jkTSuOjCtFvZ
	po+eMmPakRShcroj7iVZnlHpIj2mec1Hqaw==
X-Received: by 2002:a05:6512:3095:b0:5c1:4f34:922b with SMTP id
 2adb3069b0e04-5c1709ce6b6mr3796099e87.54.1794827169503; Mon, 16 Nov 2026
 03:06:09 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116101506.98853-1-theodorlarionov@gmail.com> <avrgKSO8nfTnv4iL@chamomile>
In-Reply-To: <avrgKSO8nfTnv4iL@chamomile>
From: Theodor Arsenij Larionov-Trichkine <theodorlarionov@gmail.com>
Date: Mon, 16 Nov 2026 14:05:52 +0300
X-Gm-Features: Aa3M54pAiVYB-SF9S5tDgvqy7iruWpi8tRRbNav85gpBLByNWhJijCPsvbACwPk
Message-ID: <CAEZyMPB+oNBrnxV09Ji-Ao7Bcs93Qg=qx0B_b=3ULFx3nEFo+Q@mail.gmail.com>
Subject: Re: [PATCH nf v3] ipvs: ftp: do not link expectations to unconfirmed conntracks
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>, Florian Westphal <fw@strlen.de>, 
	Phil Sutter <phil@nwl.cc>, lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	netdev@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 1:51=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
> I think this is coming a bit late?
>
> Maybe it is possible to check this earlier in this path?

You mean returning at the top of ip_vs_ftp_out() if the ct is not
confirmed, and letting the packet through untouched? Or even before
ip_vs_ftp_out() gets called?
