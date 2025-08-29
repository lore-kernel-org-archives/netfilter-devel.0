Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32237261B8F
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 21:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756504772; cv=none; b=TYzoGVJ/9HbMtayFaWFlfngFYiPuIsqGfHlZRI2NrP19rdl7FeSq++F8YFD9JNKgSeRT17OCbbfTlciWPcJ+skR06xQ1msRV4bko64LoP6f+Ya+kA8+rn0JuqLlCUu8uSpzeB/CWlHFMQPqbYLlEJU4pG7EJnWlr9wyQYFFMawQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756504772; c=relaxed/simple;
	bh=6guUlSEO2P5sITDKKs4imT0rY0qanON0FwrZD1w0t8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tQRLkYVFg6ktrT+UOOoGFpEZk/QEJ+x1DrTKU36ly0GqAcUO6Tm7u+9odoHnQ4wmrwESj15W9Qxlr9EhG1qx4OFUagVJ4Qvmjf9LDKl3RPWQftdf8jdDXTABehPfQtR69lO1HWoH1r5JlIYKb+LXiURWA1pVXqCgj1yGq894plw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WIjrRA0w; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WIjrRA0w"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3f33ecb34c0so6192785ab.0
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 14:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756504770; x=1757109570; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6guUlSEO2P5sITDKKs4imT0rY0qanON0FwrZD1w0t8E=;
        b=WIjrRA0wGgbBw5TDirmTWPFxNhJ9UGA1l77/mUlzINM2t1XmNC1ZrV2Fa9CGstTFMC
         7OUZBvFGylAxoh/CKxfYB5FBsJeUi9QpNBXkUcBAo2yMsw1V5qM4OKTK9j00GVp1xl1+
         qovUSo6KPoIyhSuqR2k2UAwF0r+z3HxNxpX2lDzeBf/Ntj8POZkTnu9549DX6/oVlmnU
         g0qTMhQq+Q1SYc8gF5WRlwTf68ajgqIw+MhvvfFJXPGvaaElQ//JQ77IqQplXgys/80S
         FY7NSUXOb/nCQtSzH/HvruGHQCa3L4Wa9k8G3b/LLabYc2Q5PP+FNGKtQVhpg8Lzpj6u
         oX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756504770; x=1757109570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6guUlSEO2P5sITDKKs4imT0rY0qanON0FwrZD1w0t8E=;
        b=k4V1txKoDzMKYtn+M4NqLucxT3T75x3Mp0KFe4SmePXfq4BWpHj9oS1pdSPlOk5uZ7
         tvnSMAY9ccp84QBLw5XGfOn1Nk07xmROTlH2H9LYNrZz1MvBG6fDI/7tqIH1lZQfdP7L
         sStIOnTyqUuvu4S9OpixIGIdvmp02I3236ltF278wwW9dnpmhCKq7NDrV8P6w0lGFRIl
         EYYcz8gi9jz4DXYn34P5AM53Vu+QDF9hZtbhoMaAD01MqQAnY5CMcIfSxH4d/G2WN5dW
         S5bicF6Smlgpf+cgFmKUoWap2l1MAX+9Rd7fjh+qUba1uOMx1NUyLUO8XROX7PLfS7El
         kflg==
X-Gm-Message-State: AOJu0Yy0a6jd13qmi6T9y7IzyttrBkg8gZ6PbFl26Iq17YOA6C5weImB
	VaHb/Ey3q+PhloJ2nkBpjvxepcfCXAKV4opConqTXhXqY2JdMbhaVCho/wGf32iAjKTP7f1KRVN
	f27iI8S2sjid1t1AJ+2gxtEqHiujoDL7uCp2UGsfzjg==
X-Gm-Gg: ASbGncu4yZ2F6qSMBrLv7X8UjD2vqTNVTUzNMTMwtKprhBQq/Uj8lXGGl4AFOh0r20R
	yceiSDKVQ1PfJahDqZ39D8gIiD22QIkCEKawb5F75aMFlsLxrV0lnNMwkXlQtIk75H6djUu7itf
	ZJ1WPddYY8g8N46eHMVVhd1Cfl2htRB9tsW+3UA8vKUlx6EwqXFoKrHHNP96U+lGcoPLOrhUiLC
	uQUzweZiQ8CnNrlf8d7bV6IctvumQWBp+NlBdrLmSRpoM99iyQ5FvWEqRMhZiLOMX9C2W+E29LZ
	waMHzeSQ5r+MrUcnG6rNXHuBhp8bK4VoyQ==
X-Google-Smtp-Source: AGHT+IHd3rJB8m00IdCqqsAFLVRyaGHrbUHrZz7ahAn64HGp88dsNKb3crJFUxH2Q9vROjzMqq8q3CUQbRBX+tGcgHg=
X-Received: by 2002:a05:6e02:144a:b0:3ed:6502:abc5 with SMTP id
 e9e14a558f8ab-3f401beb543mr3006005ab.21.1756504770171; Fri, 29 Aug 2025
 14:59:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250829065011.12936-1-nickgarlis@gmail.com> <aLHCe9QAViNEtwPi@strlen.de>
In-Reply-To: <aLHCe9QAViNEtwPi@strlen.de>
From: Nick Garlis <nickgarlis@gmail.com>
Date: Fri, 29 Aug 2025 23:59:19 +0200
X-Gm-Features: Ac12FXyArVCVmUtgvZ7iaZSEvD1TvL_mprKRu7DPrnA8YM-03PvxZv9XqCYStpE
Message-ID: <CA+jwDRkVb-qQq-PeYSF5HtLqTi9TTydrQh_OQF7tijiQ=Rh6iA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nft_ct: reject ambiguous conntrack expressions
 in inet tables
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2025 at 5:08=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
> It breaks nftables .py tests:
>
> tests/py/nft-test.py
> inet/rt.t: OK
> inet/ct.t: ERROR: line 7: add rule inet test-inet input meta nfproto ipv4=
 ct original saddr 1.2.3.4: This rule should not have failed.
> inet/ct.t: OK

Apologies, I didn=E2=80=99t run the nftables Python tests.
Thanks for pointing me in the right direction.

It seems I mistakenly assumed that NFT_CT_SRC and NFT_CT_DST were never
used in inet tables. I=E2=80=99ll look into this further and try to come up=
 with
a better approach.
