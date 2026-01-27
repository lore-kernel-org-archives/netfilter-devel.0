Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F3E221DB1
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 11:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769512824; cv=pass; b=obFcGBj97nbaV6+ajW9gcHR6HYYyFumI+PtKhV/42pTnrlXeOARJVL6tgMFX670uAyXQnf4pr+2X2w60zfS4eXuhML2cy9tG/QaNySZzIYlZctAwWrmDbY2e2KcJKmwbVrP4/S3JJn1ryyALSuF47YCgrwUOXQfIj1mqkgGXzaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769512824; c=relaxed/simple;
	bh=zBNT28+4+CnkaDGfblx6EkvQYJq2NjdkCYxFII6AVWU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lqUs4Xb0pblxYDoRRMDhL6FXTZJ2bH00FPbHAca9ti4TypVL1pz+PRWfpGY1+SZIcCIxI+AJno5msG/T/v271wAs07bJhmZ/RX9FK4Q+DurY/+X5pfbcwEIzYKdtgwttyIltw/+JS1Tfy24OolgaOSpLUdjgIqb/CZ3N5g0NWyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FZS54qkn; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZS54qkn"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-59dea72099eso4434787e87.0
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 03:20:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769512821; cv=none;
        d=google.com; s=arc-20240605;
        b=j7jeAE5yQeFEVVXqAWzMPj7X869SajqpmaUb+1MDNOAHezNmTdkGC3K2CuzyOCMbQa
         KWUSFobOjpTQU1dU+iMcU1Xb0ZAY0GUs5aQzvZ8gaLxDHfz1dGYB3aJ/XwYEFu/Gfwnj
         tAtc88oyITU44pJE3XU+TwH5ISJ6v/bUlCDgZ4oWLWfXwwu3WJXVxHxC5pb69MA7Uf1S
         M/MnyvMIJf9ziTbJMROLghICHuOEEnS/2YB7Br/0pc2t+03GK/zAYOH7NhtJmc3NmfFI
         S1SKNuXvXIoKGxM4PMqsunqqhVYQs/Hn2GoRL5AKZnWkW2RUJTf2c5YQeTuJpR/BGonv
         iUTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6wxWMezJ9jKdszgHjUeHRsmwzkli6JK/A21xled7GWU=;
        fh=w789GdbaeWqZhYfPX+t+IpV8Pg/IN7N2zjxlBF/CWrI=;
        b=ZxP/KsnrU/FJolGNhTVcLVWwQxe9jvTnTa1KsDrXBof/8h7+ZP56oCJnT4/GKrWzqG
         Xh0uhaddIMHEdGjN0OMoCI+wwm0E5twJN0kCiw1X60h9WMESuVXUpIlVrhYfWcsfwxXO
         ryQzeZdsRjpBMK8JQszCkyEtHJEur94fMZbTKo7SG7pWu88ZaJjL3MNBCSVQPwDHATcY
         seZMypF+QALo0niuk1kVB+ydEpjcb2fIeeiMKBDmEOL1/RxLmCBWZNp+zlyiA3WSc8tj
         gZb6OC/sNZYOHUTrkItPLBkbTV5jlcTAowhxPfAZQY6qT88jDwMo0IGo/8WftI/YSTqB
         Q7GQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769512821; x=1770117621; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6wxWMezJ9jKdszgHjUeHRsmwzkli6JK/A21xled7GWU=;
        b=FZS54qknz8Vk8upsTnF260EVTsOoEPhlUGSEqdBpw0mYeIwzAMXKCaq4QREjPeDoPg
         UeUQ5Gpxa+8dI+uElqJk8t4s9kn3Bzo0uSFe+7zd6GvYZBL17VXBzRJoioLKBUbR4nqI
         V33Jt/z7rQV1DtUCA4jCSQrMj9r34RKaxQotEMVmJVDgorEU8n/xxcCD7x+s02gwDyBl
         3ujV22HuYG6Spo61FkTy7MGbjsX/i6SWTihFaJMrstIJujUv9s+LcsfYNLUkqPYN1EYI
         UH1Ly2z2EQvqodkUvEweaknKTVhD5jNBfYtNFh8WyoPKn0ysLxDDDeGcXpB10+JmvGmw
         xG1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769512821; x=1770117621;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wxWMezJ9jKdszgHjUeHRsmwzkli6JK/A21xled7GWU=;
        b=N2wPxvwCa5V6gY4BhqXn3kUTcSI4J/qXmvYj4h0MNVi0Zq32yfcgzVdpG38q1WAwj/
         EyDCa4keshYOR3RbC02pozjKsUvrDYDhfv3DLA8jtW4aK1Z8uA1oAju1jsw7xeaL4NHS
         VB3o3y7vtGi/BqSOvrxV6eIBkY6lUDxVobWgK675wy9/7ZsZ8hCXO8xmn0Ds9TDr4uSt
         NtXZaTx8TX3tR9WyREbe4REXykEe7GeNMlBSujZwbGAAlVB/K45CvAL9OdO8lDBHMut6
         /h28URMGTlGrB+nIgMOrvlJkDGGJwk5f6Lk8J7Wl4gMItS6Ab8ADChRZAc8mhtlkKYaj
         +bBw==
X-Forwarded-Encrypted: i=1; AJvYcCVTb4z0MBSL5c12fwjiqcxb6qXcX5621JuUDIMVJPw47dAqtddinHsBBPKJq7bmaBiYwcF7ZjxjCTa7K0ZBFQU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmnYQCTnFwoy86acBjcWp7oqZ7k/5CgT1oLUDm1Rw+UlIP9xlr
	RQtlEs0UlJYzVra4YPkC17pB95cnmtFOLMU1xCxGiZQQzFtCGzEWw2k/oxMI/88/9zXBRuNoKmP
	GLXvKKGpPYH3ZaaSkQXO1qV2ineteRU4=
X-Gm-Gg: AZuq6aK4XFtWptVt/JCZURSll7lzd65djXf+DK3xvosFq1R0HFsD8g/NMuwPcSX9+da
	SU1OJuszvUGxrYaM9n/mbuIrGX0Y7pN/575PfM+CVhwEpYVfH37Zrvrgjaf4YhqN1YwRCIpnJSi
	MgEJTr5GR6CBn9sbl96haCcrg1uBXYXxqMTXQom8jDM5VrsS6LikYNZPHdEfkOZp0Dg04NjBh/+
	gSTEGGJfZwqwNV3IWGbhKAUge2riV1FPKW1RCM0A8Vjhu/MXtE2NFOvcyD47oWElfU5BUPkuCra
	nhAEW0JVfLURp3JJKxHFm1IpXcbA1U9+PRo9
X-Received: by 2002:a05:6512:638c:10b0:59d:f669:c92d with SMTP id
 2adb3069b0e04-59e040241ddmr451049e87.28.1769512820779; Tue, 27 Jan 2026
 03:20:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121184621.198537-1-one-d-wide@protonmail.com> <20260121184621.198537-3-one-d-wide@protonmail.com>
In-Reply-To: <20260121184621.198537-3-one-d-wide@protonmail.com>
From: Donald Hunter <donald.hunter@gmail.com>
Date: Tue, 27 Jan 2026 11:20:09 +0000
X-Gm-Features: AZwV_QhQ2pk9JgBKx3M3vUShc5oQiyuV6V9zGNusr8w_3L7o4lXRWgxnXx-z-o8
Message-ID: <CAD4GDZwAuX+W5e36R0sSySf9jdCw20YwiO==3CB59d4fpFdRYA@mail.gmail.com>
Subject: Re: [PATCH v6 2/6] doc/netlink: nftables: Add definitions
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Jan 2026 at 18:47, Remy D. Farley <one-d-wide@protonmail.com> wrote:
>
> New enums/flags:
> - payload-base
> - range-ops
> - registers
> - numgen-types
> - log-level
> - log-flags
>
> Added missing enumerations:
> - bitwise-ops
>
> Annotated doc comment or associated enum:
> - bitwise-ops
>
> Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
> ---
>  Documentation/netlink/specs/nftables.yaml | 157 +++++++++++++++++++++-
>  1 file changed, 154 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netlink/specs/nftables.yaml
> index 17ad707fa..87cd4d201 100644
> --- a/Documentation/netlink/specs/nftables.yaml
> +++ b/Documentation/netlink/specs/nftables.yaml
> @@ -66,9 +66,17 @@ definitions:
>      name: bitwise-ops
>      type: enum
>      entries:
> -      - bool
> -      - lshift
> -      - rshift
> +      -
> +        name: mask-xor  # aka bool (old name)
> +        doc: >-
> +          mask-and-xor operation used to implement NOT, AND, OR and XOR boolean
> +          operations
> +      # Spinx docutils display warning when interleaving attrsets with strings

No need for the comment here. Better to explain the refactor in the
patch description

> +      - name: lshift
> +      - name: rshift
> +      - name: and
> +      - name: or
> +      - name: xor

I'd prefer to see the list marker and attribute on separate lines, we
only use the compact format for pure lists of names.

>    -
>      name: cmp-ops
>      type: enum
> @@ -132,6 +140,12 @@ definitions:
>        - object
>        - concat
>        - expr
> +  -
> +    name: set-elem-flags
> +    type: flags
> +    entries:
> +      - interval-end
> +      - catchall
>    -
>      name: lookup-flags
>      type: flags
> @@ -225,6 +239,127 @@ definitions:
>        - icmp-unreach
>        - tcp-rst
>        - icmpx-unreach
> +  -
> +    name: reject-inet-code
> +    doc: These codes are mapped to real ICMP and ICMPv6 codes.
> +    type: enum
> +    entries:
> +      - icmpx-no-route
> +      - icmpx-port-unreach
> +      - icmpx-host-unreach
> +      - icmpx-admin-prohibited
> +  -
> +    name: payload-base
> +    type: enum
> +    entries:
> +      - link-layer-header
> +      - network-header
> +      - transport-header
> +      - inner-header
> +      - tun-header
> +  -
> +    name: range-ops
> +    doc: Range operator
> +    type: enum
> +    entries:
> +      - eq
> +      - neq
> +  -
> +    name: registers
> +    doc: |
> +      nf_tables registers.
> +      nf_tables used to have five registers: a verdict register and four data
> +      registers of size 16. The data registers have been changed to 16 registers
> +      of size 4. For compatibility reasons, the NFT_REG_[1-4] registers still
> +      map to areas of size 16, the 4 byte registers are addressed using
> +      NFT_REG32_00 - NFT_REG32_15.
> +    type: enum
> +    entries:
> +      # Spinx docutils display warning when interleaving attrsets and strings

Same here, please remove sphinx comment and use the preferred list formatting.

> +      - name: reg-verdict
> +      - name: reg-1
> +      - name: reg-2
> +      - name: reg-3
> +      - name: reg-4
> +      - name: reg32-00
> +        value: 8
> +      - name: reg32-01
> +      - name: reg32-02
> +      - name: reg32-03
> +      - name: reg32-04
> +      - name: reg32-05
> +      - name: reg32-06
> +      - name: reg32-07
> +      - name: reg32-08
> +      - name: reg32-09
> +      - name: reg32-10
> +      - name: reg32-11
> +      - name: reg32-12
> +      - name: reg32-13
> +      - name: reg32-14
> +      - name: reg32-15
