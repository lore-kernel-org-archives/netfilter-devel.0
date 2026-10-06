Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F16C352C51
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2026 06:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791269420; cv=pass; b=IM2LgaS5mpzr8Vdzaj/5pkhYzrQbeXtw94YW7LjJB+q/oSdpS8cYlbASrA/RPJlmnkD+qMLwOpxE9NnYpYZ4oCwfYWgRUR1HT1wTHPUDft5Ly+ZZfiU+IH+cwqRuDY1Y9F1c8oPGmy8cD/pAS7QbxS14UBTcgWl21ZTomFBwPVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791269420; c=relaxed/simple;
	bh=XJC8mnwuYM0KLaAKHJuhy0GpuAFopbEkJ/aam2wcfBA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=JndzP0A7JsrtpwETYoXCr7Hh7HeyWcrO2s6wj2xbnPdeiGWLTiVBo90Y3iEosoCndmS+8qnOpaoF0mTj55p+IcEuhQYf7lhb9iNoRhL/5lvNM0jKVoGxNU+5iLfbIe/dkkOlAF1JGXkYxRMXKS012R6lEmkMqVQTCoekBBDaqkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KaeMH66A; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KaeMH66A"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c2e8e738ae0so24855366b.1
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2026 23:50:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791269417; cv=none;
        d=google.com; s=arc-20260327;
        b=jVjw9xbwmLy4HmMazYddARTVDxEAbpmEM0A0zZzrM5coNV65y1AeHDnG+6qE9j2T/C
         SwMvV88J/Y11wkw1e6cn8d3nv0PP1AzlLDQU8gu6kxxVnwly5Cx3BGhMdxam+5uz/3Ny
         62CGkMWJcybT5WE73h8miYkUBKzTiCVhUmJiyEbYJSIvU8B4W3TihpGOs48xKiTId1nh
         YcUaya9i7flHwfF+vdmPyO/0sH1MI5TGFB3bzeb/YjEZPoc4AleFFzVdVmqwrItUfEKn
         1Eh2gTxcb+x6Foefcf7SpNG+4UMu2Queg8B8dBqBN//m4pbHWPt6EMKD1D2oivqU/Wq2
         Jhag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=tqsYm2RdTA8FFgoOM+5IDbbKZf3ev28pnZIlHkY/9I4=;
        fh=nOJbkLmOaZkWQ485QxUS5VRYX1iyTQJMxlnfwG87F8I=;
        b=DARzJeM5oYz78xnesSNLIfS+8Z4D1K/9FZOv2/CJsippxmad5JfKCjXKgPvDLEFS0s
         oRwMLV7AsrQNPjUXLCj42dzHEiCa9KT4anr8wjKiG+0ysCZtgyKZWANRNtmRpsvDTIJW
         lo0HRAQljqo0MtIitZFJA/mFv377+xh8Be8ivDdn3t+KB7oakaLEWkUSl/054htSeGvZ
         oNFxAQEwBAlKVJjqTMzU1DvhB8vfi2FXBF33uEoz6E7MIWZH04B2AYBX854/UwWxmeQo
         xko57sNS7XlmgEmFlfjuHkihTeD6lS2eVIwyNYH/IVMBOUlZNo6qViQXEkuEJA2pCBuS
         HXvw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791269417; x=1791874217; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tqsYm2RdTA8FFgoOM+5IDbbKZf3ev28pnZIlHkY/9I4=;
        b=KaeMH66AKwELWekBwEaCGSlQ2kIB2ySGAKVHaKUlw8wq319DLYUhxnVd7bKMEndGcu
         KYD2h1CxkmlO/YBkK72LkGFxWlt6hhzd+DXpHnjl6SpkuaGeuVgxa1SPU0A9RbTmwFBO
         nIxsGRANI+5cYbptMSI5DuCiNmd8hEWSZcRD9OzcP083O/Mkn4kvWBPMFhX3NeHQNs1I
         ekxkbH/s0x0cCsW55QvS6cH2ugsApTZo4eSI2DieRA2dP8hU65D9XiKUNKDLlCtbsHSb
         doSu4xVmOB3nTmONrhzmKMN1xpspH8/CQ5eJbDEtoPsKLZki6OPIfBZDs83JdS/6ZJu+
         2rew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791269417; x=1791874217;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tqsYm2RdTA8FFgoOM+5IDbbKZf3ev28pnZIlHkY/9I4=;
        b=qBgplXFT/r4MtdT6b+CUR6bA+UEiT88yM+veqcbX4Qb5QlRBEGfasFwxv3VyX10soj
         DPnpNXTSnXwDTpPJDuFCxjxDWv5F0KfZT5Itm8YwnzN0BdyRHG27iCCp3rdmxtUVzYz9
         nHl0SSn0OzMYTmYcrlkogHVefTPD6ygSJHycqJ1yqn0f4Dc46NSNc4SwSb251heyxfwk
         WFAMYEsQHc2EouTwtgoLrF3bOMueziXa3Y1Y0OhYkhuwvGm4QmlVzLD2C7P6YcaTpuvg
         qQktEtu1lbZwai2LDXMCtWudnESn3tRVT8+teD/r3U9nbBa289udwx+siSWaIkJwWT7J
         WlOw==
X-Forwarded-Encrypted: i=1; AKwUvBxh9eJ5u3Q37Qz/XzLI9ABpqydGI+8Vi3/BrajjBTp+Ng8OXYpuL3hBE2piNBxPtIL2cICx4eU6/hukVi63/HQ=@vger.kernel.org
X-Gm-Message-State: AFuF++kXR8I5K7hZmikZ5lk10uGbysZa65X+wG1CQ0lxDKNC/t+zkEuP
	Ld704TrwX0lh3yLhpshlD79dz0D4AWrZojPHr7McFa4dW2Aya9iftXY7Ow0Wt/zYZjJuDEoZ3ZH
	12mIfKBVZPDtOfrGhAGRpNBo5sBftM6A=
X-Gm-Gg: AYBFou0B8/cMbqhvhLCgkpsQ0OAka7DocmBqJ134YajYJa7N9z5X2DTHN5P35L239jF
	DsdXofZgD1v+y44T8HCwNMhItu4FqyXl5tzGAiaayDuDKWyNn9owN34S72dpkNBfrEULZf5PpgI
	MrgGYDDyKlImlVcGe3rF9i2TxgdoQocAAmSwdvNAgsA6DGmJN7eGViiUsEh8q8yugtWHbDO9N25
	63xdA5aWlnL+olfLwiq6NVzwossGeX3ATEsXzZuzQnBIaE/GKADdpZ+6oONsRqoIU2ndMnV9lZk
	l6AtaMIZ7qEUiIJwkD/7kwx3388HNnYeHG4LLfuJA+yYDnTT7Bqe5Jcz
X-Received: by 2002:a17:907:868b:b0:c2d:ca8d:435a with SMTP id
 a640c23a62f3a-c316a03a07cmr48107466b.38.1791269417167; Mon, 05 Oct 2026
 23:50:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Subham Pal <subhampal789@gmail.com>
Date: Tue, 6 Oct 2026 12:20:05 +0530
X-Gm-Features: AclHuK80foSKJUG9aXGi4lMnHGQEDESfSk-FDQU10Eg1rsE8o1J9c3o2lczDRbc
Message-ID: <CAHeizqGJ6WpknaU=WE+PB2A09jWi==-sUUgmc36qgStVDRdSLQ@mail.gmail.com>
Subject: [PATCH nf-next v2 0/2] netfilter: nf_conntrack_h323: fixes for NAT
 bypass and ASN.1 decode
To: Pablo Neira Ayuso <pablo@netfilter.org>, fw@strlen.de
Cc: phil@nwl.cc, kaber@trash.net, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	stable@vger.kernel.org, Subham Pal <subhampal789@gmail.com>
Content-Type: text/plain; charset="UTF-8"

This series resolves two separate issues in the Netfilter H.323 helper:

1. Overly restrictive tuple comparisons across expectation helpers
   (expect_h245, expect_rtp_rtcp, expect_t120, expect_callforwarding)
   that bypass NAT payload mangling under DNAT, hairpin routing, and
   reverse/reply traffic directions.
2. An ASN.1 PER decoding bug in decode_seq() where absent extension fields
   are processed before verifying their presence in the extension bitmap,
   leading to packet bitstream desynchronization or premature aborts.

v1 -> v2:
  - Retargeted series from net/nf to nf-next per maintainer feedback.
  - No functional changes to the code.

Subham Pal (2):
  netfilter: nf_conntrack_h323: do not bypass NAT helpers when tuple
    source matches reply destination
  netfilter: nf_conntrack_h323: check extension bitmap before decoding
    components

 net/netfilter/nf_conntrack_h323_asn1.c |  6 +++---
 net/netfilter/nf_conntrack_h323_main.c | 24 ++++++------------------
 2 files changed, 9 insertions(+), 21 deletions(-)
