Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1ED3BE16E
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 04:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790137237; cv=pass; b=rFHWBUo3Co8XPmwxs52Cgr1ie65ElsJFUA8yEDTOvedhcxPVYX4rLfIKePv/Fz6DLlBT60c7OZZNxiZIMaKhMJsHR1WV9R5oPGxnfmNvbJZTJNhgrCqYFUY6T8ejKCWimzq2MlvwybgHdBwo+uIAOnjxHIgKMXF+Aw9/mmfH8wE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790137237; c=relaxed/simple;
	bh=Cwfh6nfa/UOLSAK3QY/khC+MQR1CKVHT9WrzBxS+zXE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=XeITAvwnN8mMTiiVWiLzaRKUcjVd7hFqvbfWNHEnGEs5OcldIdz+8p042cwYH2b2xh3PJ05PjKQzV3k2+U8m3A0o7uXfVR75cKmCcdchvmTqob3okV0gMc4h1OFORzE6dWNzMg+gg4E+7CIXafvPSmNY6fsNsil6TCmynlXksHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OjecdJLG; arc=pass smtp.client-ip=74.125.228.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OjecdJLG"
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6a9ab2a135dso731401a12.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 21:20:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790137234; cv=none;
        d=google.com; s=arc-20260327;
        b=hOFBaHe59q2s3NlM0hFkc0TdqccHleaJtoqZRiDOYLd3LT2iULUtjmTbL5KzopyodV
         8Hg38/InZIPpjoOsdQB8ax3/lbdw3l0fOorbzAz+tVEYqQeh//p28UPI1FfcEjFQRSmv
         8oIaEcEzSB3CSgJ+hGuj+ukhiq8m4IBc9VjudjBjfTjQqqGVIUz2B29O1EFrCNIIe3uu
         8B2dQqc3o7SalolM3ePuW7s6z+S3sTVE6UV196oc+eJQjfNaXCX4xKjt3hkn/IOQH33t
         EQvSh6qYu6Zc+yCvZL2IHcm9gelQO3Z21B3TW92117KFb4S2ggEhuZVQG9qkOkWi03Nl
         DNMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=hxbmvmkdJ5bEpGwujnz7ixCTU04WOXkGt5rmGXxVVrk=;
        fh=rsqR6ZNQLJdr9yozLGLi1t61ucnv2awO16aXY+HXRKE=;
        b=CrMPKGfBeFTTYHqHzMIqBUZPiwWZWJ77YyhlaWdkwjubGdEHtC8a2dLBb+h7Ela1TJ
         O/OXN8WDA3qHVmteKgU/rhQan1hqNPxQN2ULhlXiIHifvVFV5ZBQ7ith3uoqem++NXg+
         yd3QZw3sohiy7uAMRl893M/SKC+2WyVJs47MNQlrSkR28WuSduLhKyNBk9xWT7isNnsb
         4nNUpmv4ybwLnTdUf4ldvIGbuLkCGiUjglgh0VlCUutIH8yKluOemQ56Xt/kkazKHexV
         wDjomDvoK6dVttRbluUHmPI72mMY2rzBTk8sD/9EucMO5ruAtRjG64Z13J0Yrx8WlOjN
         QUXw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790137234; x=1790742034; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hxbmvmkdJ5bEpGwujnz7ixCTU04WOXkGt5rmGXxVVrk=;
        b=OjecdJLGniwn5ixF3L7m25rBu/x3lyzCN1jN7BNAas8lsSMvHxhhtk7vaeqIZsdibw
         yLyz2Lty3JGbGBCtgEW8Mkq91YrIrEw5+TzzKgixyUccV5cR70ds2HPgssnMc8Vh5F3G
         ltH0zR2n3iisQCLbJ5fxIC5TILhIbGokglBakR0Zzd4vH6A9Yc4xYPIJCdP5xv1ju/pC
         2Qq4S6Zv7FPXRJaSnS91b5tTGoUUWHeuSLhZkI70iXkoQYbaNfK5lAi/4nd74bSjWuoe
         HLMkXWVDbwginrskGF5mfAFcDTPlLhl1Eh2dfg+7fh+zjwPlqWpK7nkyv9uLHr5wbTCV
         9dEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790137234; x=1790742034;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hxbmvmkdJ5bEpGwujnz7ixCTU04WOXkGt5rmGXxVVrk=;
        b=HrgNB/Bw/pYZFDFuIRNtgj69wYbdI9qzRyuKZcRv0AJkD7POx4YzjFC+ciqtmX0YyR
         kuKCc+E3HFX/42wwSDCfGI9lhfULZTgdGAQYQGkKeJ9JyRPiLe/opuX5E5nIS32VwSHm
         uoHFFBJvMNbjJbjBzs5HbzqvPCVfLe7UL2AacL5Aq7lfyr+Vh/EqiAYtnHON1vksllyl
         w0mXoxBUnYkHvxCjSv64KMUBaDfVy52xPvJ8XQrUrNZfEGUiy/IGwP4kQBa67mC14TfB
         mIWBth3ujxsl/4WL0ICtTD6r56NL8oshtgxl33Ocl3JISkm6zfkjLXCKez8smuPrCvdg
         a/tQ==
X-Forwarded-Encrypted: i=1; AKwUvBwP884U/LAUarjaHyp0fbO72mfwSH2QqElkgoANgMXaJlfcnCazC+GC1pPRt+lH1v1gF1x8QENwuygZJtLsEtU=@vger.kernel.org
X-Gm-Message-State: AFuF++mD5Z3vKC0drvgctIP84ZQ7dDLN+/o6gvFu/5i5k6qplDCd4aZX
	gnx/y9vX9Zphcc1VbGhbP8DOqu6vlPdIiffxf5F4cnhWuWVN4PMFKFFqqV5A2Q+tH6zP8OTY/yf
	gZQdi7EtgJmWK+NPaOefgiVZ5dEzg7+U=
X-Gm-Gg: AYBFou3Dm0Foxq/VF+TesaS6NqLaXRL3XTgnQrA/je+o5xZiAfOub7PQlp12fhG14RT
	YfojqkIqH4A/kelxNzDRR2uWlrsgM8bITazZPVg3vXc1yoBtHLiCWl0TeOh5JmAcX8vXuXJvt7h
	JcYc1G+GHOHecnpuASCANNGPN1Dw2vid/XxKaOk82gN2Az2cz0psYqQR45KfO5HfLGQk3IJjZ2e
	+smfctWcORqcOy3CQytNNXo8OZu7jAE8NwBcwpCBTUlg9cZmr8Zbdv4Xbe/4C/I5zSMxR7AV0Lt
	iIrCpZ5GIt58GrwXnvdv0Y6L012+NqRNQ1BsKU+10Nk96EMkgLrFlq9n
X-Received: by 2002:a05:6402:3222:b0:69a:928:9405 with SMTP id
 4fb4d7f45d1cf-6aab3af7ef2mr1139431a12.1.1790137233714; Tue, 22 Sep 2026
 21:20:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Subham Pal <subhampal789@gmail.com>
Date: Wed, 23 Sep 2026 09:50:22 +0530
X-Gm-Features: AcwNN1WXi-EB5cWWmSS8F_wi0QtWAsORHAgh7vtdg2rXyF8E9Vr6ZcKlLvthKgQ
Message-ID: <CAHeizqHDqx3ue1=0QL92ef+6C63Ur+v1Z=d93smgdD5zTj_-Pw@mail.gmail.com>
Subject: [PATCH net 0/2] netfilter: nf_conntrack_h323: fixes for NAT bypass
 and ASN.1 decode
To: pablo@netfilter.org, fw@strlen.de
Cc: phil@nwl.cc, kaber@trash.net, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This series resolves two separate issues in the Netfilter H.323 helper:

1. Overly restrictive tuple comparisons across expectation helpers
   (expect_h245, expect_rtp_rtcp, expect_t120, expect_callforwarding)
   that bypass NAT payload mangling under DNAT, hairpin routing, and
   reverse/reply traffic directions.
2. An ASN.1 PER decoding bug in decode_seq() where absent extension fields
   are processed before verifying their presence in the extension bitmap,
   leading to packet bitstream desynchronization or premature aborts.

Subham Pal (2):
  netfilter: nf_conntrack_h323: do not bypass NAT helpers when tuple
    source matches reply destination
  netfilter: nf_conntrack_h323: check extension bitmap before decoding
    components

 net/netfilter/nf_conntrack_h323_asn1.c |  6 +++---
 net/netfilter/nf_conntrack_h323_main.c | 24 ++++++------------------
 2 files changed, 9 insertions(+), 21 deletions(-)
