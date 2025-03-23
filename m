Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA0A1E9B2E
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Mar 2025 11:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742728131; cv=none; b=qKXhabruQn1TJmMpmo4xfI7JxyBKQbDGSPn1jAUKfAv7Gd16JhTMqk5tQ3rWKwc2oUp4bkfzIyHG9oS+60oQim9sO8arhXPmmbU2Me3Mqwg0XwXoE1CbOc+Axq/VNhftZbn4x8eVqb+5+mjh0IQmLwcCz97tSG16Ls1getz8UmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742728131; c=relaxed/simple;
	bh=ccPXreN8HjCwq5lyBIIfrMggFTrKpPWkiYo4UeIh8ak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WRWwIo57QgSv/forvxbCA5itT2VYY/3mZLrlFlUpxMtT4r5PupxnRsfaYf2fj77zjBkEYJCZLwFDKQXlv84wqV++ISq0ip2b3bSKhLlNkB+dYIi1wZHN8S13sGATwpS6PWZCBlifAIZ6LhpBsut0OZZAvtKXvQ0+LhBA3leMZos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B+d4WOt4; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B+d4WOt4"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-394780e98easo2041100f8f.1
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Mar 2025 04:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742728128; x=1743332928; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n9ptenctdzvLXuc0D1vlr7FWgfHZLh1YvCLYDc3fMxs=;
        b=B+d4WOt4fwZxUPKNQm91SgG078OZ8tG5zDFSkCuxOEnSj6B4bNcIR5vfRNYIUKykOK
         hCCmOlJ9OLClky0T+Gtq5paiMHVncdKsVkCXkCLAUGL/iGMJj3CjbNaSWgeWyOAhO2XS
         t6cA4sjBCeknC/Nn0EgmnxuNHv9c9lmuYBdY/UrO3VK8iZtDshWcsdxisFModI+q7ljc
         jlmwTDQBsHTLMuF3u4VQUBtR/HXmt3OBUTQ5ghe6tFDhr5l73ftD4sO5ZuaFh77lF/dd
         GJBY7XJ7DiAwZ0zHE9EiqvRwv9lGflDVXwocszjfnF0wfxuaG7DlZdL4RU3GpYioEwbP
         xToQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742728128; x=1743332928;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n9ptenctdzvLXuc0D1vlr7FWgfHZLh1YvCLYDc3fMxs=;
        b=D9fIlhEGIVrNfX2Eanv/5VptSL0IKVN4Fw9VDVB1dsIOf0CE/DAk7hjCml5FrxM+EI
         FPIeTbHCrgXdq8qvR8mphP5W5NcAOrHmr6ufKxRhzJxiGGtXMGzqvnRs1aVkU2a2osjD
         jklsyAkZ3PJgdoS6hZgeQzCWfd6nRmYzNxE4ZZGCHgB3TN2MbS1sd8g22F7qBVtkEuYO
         KmzY+gY9DJknAAaPdE7NTRnXjaBdklsK8CDUiLGCEIyWHdm6VBWd8p2p3y91RewSa442
         H5SGMzZCOe5Us5Yjy/p/iuINjajhs9dH+QIq+ZJDEL9a9LOXTACUWRUp4MBGKqmdwAfq
         rkPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaccDBHEOoVCh7LJJteNYhR8oKWEbzSKkcKlD8ku/zldWW2Y3Snf3kxHF/mdABlKQ2T//Ui6XuiLI6GLzYslE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4UEQn0paSGD1GKUg7Op7DMR9klC2hwip/ipQljH6kD8HAg7wW
	Y5UjeUJsc4uWf9mJKwK64xwxFgFSw5r3dMiCWkI3581hUSwrqZnrNCa23ou7TV1sBjP55ddD68D
	zlVJmtyhhDhpv6d9JxtI67lEFkuXr6AKPB/sb
X-Gm-Gg: ASbGnctV45JDVtrBWgVsJY+E5rQkeL5vhursit96t7aVByEAyhytJo2QHXter3uIeB/
	DqBlMGlrR83OX1GW0NLEPlZu55leeYH9othB6PA5hOQtLQH2pqAKygrtrgzVZKIlFqdi3bxBoza
	9eFGnh7O6Axp8vweIS/OE84Hbw
X-Google-Smtp-Source: AGHT+IGepZlqEAUQdF7N1rxChTn7j7BBsMW0Lr3trqsiOjdJxiiihNc+msXzX1OgcJXW8KK3/bRR5sNK3Qo7RLvtajA=
X-Received: by 2002:a05:6000:18ab:b0:399:737f:4df4 with SMTP id
 ffacd0b85a97d-3997f904f05mr9718803f8f.28.1742728127954; Sun, 23 Mar 2025
 04:08:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250318094138.3328627-1-aojea@google.com> <20250318163529.3585425-1-aojea@google.com>
 <Z9_cDLTSaGeXcG5X@calendula>
In-Reply-To: <Z9_cDLTSaGeXcG5X@calendula>
From: Antonio Ojea <aojea@google.com>
Date: Sun, 23 Mar 2025 12:08:36 +0100
X-Gm-Features: AQ5f1Jojm1dfbw3Xp8uLSGBXiYZA2Bgycaz5nVDRXzVnCG_-I46sCG2mqzwyp0o
Message-ID: <CAAdXToR2Sf1NsnE-n0ctdm0nVVT7NgMudqJKE5AVVEPNb1Vzng@mail.gmail.com>
Subject: Re: [PATCH v4] selftests: netfilter: conntrack respect reject rules
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

>
>
> I am testing with different stable kernels to uncover timing issues.
>
> With nf and nf-next kernels with instrumentions, **this works just fine**.
>
> But I triggered a weird issue with Debian's 6.1.0-31-amd64:
>
> # ./nft_conntrack_reject_established.sh
> ...
> ERROR: backend filter-ip6: fail to connect to [dead:2::99]:8080
> ERROR: backend filter-ip6: fail to connect over the established connection to [dead:4::a]:8080
> ERROR: backend filter-ip6: fail to connect to [dead:4::a]:8080
> ERROR: backend filter-ip6: fail to connect over the established connection to [dead:4::a]:8080
> ERROR: backend filter-ip6: fail to connect to [dead:2::99]:8080
>
> interestingly if I reversed the order, ie. I run ipv6 before ipv4
> test, then ipv4 fails:
>
> for testname in "${!testcases[@]}"; do
> -      test_conntrack_reject_established "ip" "$testname" "${testcases[$testname]}"
>        test_conntrack_reject_established "ip6" "$testname" "${testcases[$testname]}"
> +      test_conntrack_reject_established "ip" "$testname" "${testcases[$testname]}"
> done
>
> also, running standalone ipv4 test, ie.:
>
> for testname in "${!testcases[@]}"; do
>       test_conntrack_reject_established "ip" "$testname" "${testcases[$testname]}"
> done
>
> or ipv6 test, ie.:
>
> for testname in "${!testcases[@]}"; do
>       test_conntrack_reject_established "ip6" "$testname" "${testcases[$testname]}"
> done
>
> works perfectly fine.
>
> Hm, where is the issue? I have to double check, maybe -stable 6.1 is
> missing a backport fix.
>
>

Naive question, the nft client used on the tests is  the same in all
environments?

The fact that individually works but together doesn't and that the
test is using "inet" tables can point to something related to that
dual stack support?
