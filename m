Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C489344D98
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 10:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769511591; cv=pass; b=r28mUYogjfp/y9l1h5R3fpaqYZkiYPO8nb9bYoROkpJy7RXgmEDpQUFWyfLbBltzVO/L7YbfEZeghRYjcZnfGjU8bC8SKHOBcRHNLrRRoK/X+J53XQxaZqlvh5y9igwyJuecVdcfC+Bb2TZMh4WEANivC7h7GA27wG6ZsMkzUSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769511591; c=relaxed/simple;
	bh=BECvrmATlKBwshE0pKD8YMPH0q22JCw7MblIaHu1gcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kEmECc+nGUMY8teZKu5nuJhnu6Dp2UJoayZRbdi2QpGxt9E6wd++BryIdMFCoWTsrRsUD9S9MtG1RoBCK1xpyzyfJX3NyBalQeYiJw8hdMBL5zihC+xg6GIqnx5fjLK5C+SNq+tGNfvUzfCqIH6VquKwFEe2ltyVj6QK8bJBZ6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YSiLfhmm; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YSiLfhmm"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59dd7bfeb8aso6810412e87.0
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 02:59:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769511587; cv=none;
        d=google.com; s=arc-20240605;
        b=DFBPTCY9YNqcBf/wKydfFiwxfbvlnkXR39/vQbugS/yZaPyrktAzfqoINvOoYZZ3x2
         XsgIakYkTC228RQllGSjHaqG3TfGEg3xNIptC7+c62pJtZkmw8FqffdMGXOtyTDLP3jm
         +9YeRlyRFcFEaLmRlW86U73aT90O/PO2fQ0/VZjGJ2wLJ9hqQW2X5lLNhxYficvK+6Wi
         XWr0Tk3Lc9ZD1CGFiqeOu5gUWaQr2PQtneA6SgtiVQ3O6MTy7Xv38A01CAVbSA7VbC54
         ksFmQ3MBZcS4JsQiz8UXfxXs5apBjCw+zPvARc6aiSFKBXjU5Ps8G5dgQZl5UQPB4EbK
         BEzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WYsfFHIplmOm9N2B0bIUCqqqwv0zYamUAJ//iJfYf5A=;
        fh=dlEy6MeOzAijlNB6HjKKYgSLDtiLzt+wwSwH2Kr1E3U=;
        b=i5azHoO/D7PAalEjQrdjyqI6s/4kMBj5M0RQe7knJbcK2ZztdAJ99Mr68x0wqtIV0P
         qzGZ+P25Goe6PsynJlkEq+3kIlaReJnS+Vt39bc7jFAIeOQksAe0X5La+O628jnZm1Rn
         fXGvwYjfvxpGQYsXv4s3Fd1PZK6sUI18/FQbSeoeiOqZZ4IAKJvxvTq33YqXpin4Xdyi
         Qu5foTf9YUN9Tl26AR82o2L+n/ANLTCr83wNcZWwCU5Gm9d3ZvnKVXQXFgaOrmrlA0Pk
         wCWxHsgppR71Ve4f6KIf9T6bVrj/kFXGqzCfgy8o/FSIm/yz/AUBDiN2J0vozJhqLlT2
         vJIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769511587; x=1770116387; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WYsfFHIplmOm9N2B0bIUCqqqwv0zYamUAJ//iJfYf5A=;
        b=YSiLfhmmUhBhJ8UB/7rA3oQQzDOCg2xveCdqBGs5si2z4aVjBS62qgHDsN3lauL78Z
         7a8SXQhs5LD8FtlQez2oIzL1s2g/Vkbfob6qvBVYWQx6kqT5npUxWnqX6PbCgf8+1hui
         RGnXEKFPZoskXbCn0WUacJYRBM8DykMMzaSWAOtnKFOz6G7sTkxp8sYtI1FzQLJt3bO/
         +vclPJxovWIzvDp1kn6J+dK4fi6qe8Hd7Xq0PPTGl22rRFZ+UTdOmCUYgIFZ6e2HHEyb
         i6UrgvesIMGqC3Heddylm9FFMwuwnQYq3aJnd5Gr7z/5UXh6sMLujSlhDjkykAsNFa81
         1NoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769511587; x=1770116387;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WYsfFHIplmOm9N2B0bIUCqqqwv0zYamUAJ//iJfYf5A=;
        b=dok2dsX1kZCblSae/kSceyO6Ddc9MrDNLYyhxD8cmO1SVMEtEB3MNltJwdJv61Iuq9
         pgAUa0lg6iT8JL8kkHQ+rox1xaruCGwlA6M2LVxpmMhu2oWoYkUdo4gB3/fwIwFjxSZc
         yT4d9XredhE6h+Ird4ZCQmZmMhE0773VNWmtuSseJHEQceJczY6l49A/TyHXEpHWItUe
         S0I2zMXPr8UVOFQmaYYZs3kI6FlGeF7uPRR7SGVTyUVwR8NaRWyz38f/TAiflWyAOcVe
         Cu7yxI5grnwd7ccs+JkbZvyQ03ltOuKSPbPSlzP8RMb9UI/h2TsjJJju4IEywmvO5XtV
         qBCw==
X-Forwarded-Encrypted: i=1; AJvYcCVowJVDvhW7EaMclIFctTH4WIeDRj+qDkktNPw0vgFn4ORn+yfqqBhc7apQWtzxNygaOOCLHIcHMziatqB6JSk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2Iyjtz2IOcescJYHKxPSGAzuWShbueUttIrh6evv43DIkjXb9
	4BJ5v9vhs4CNAO3pGXZOPcObqptUXRX5Og/wrvZo9PbVS4NVDdYvugQrmERiEELVnztpqXRVGAc
	ic7WjRlQXyuDZVZwrgF6ZZ8RuWfPfLKE=
X-Gm-Gg: AZuq6aL5PneLGoOBWMLFohrVegEa6rZrg5YXUayC7BrUCJQJP9hZUu/ZXvJokDzSDlv
	ZlAG9eSa7k/XUELZNAV9UiidPVJbSKSMMXBRxV+GO4j/3k2iSiK3SZmT4I5cv982iCItq8Tf8s6
	qYrTdcBTyeRR2Oee7mrTNkYn/zhGyZeCXIeoyY+rqEMBEsZ1d4yXam1N5okh1nuivDZKL3CFaS7
	akr2618uZ7pYARi5uLICW1jREXveymJAe7Lc2fjaAHbuYjw2TSCP5XaNlTYqXTfSU9ZMtpU/Ylp
	/KeFN2E9bjgp8KP52+5rHi+kdg==
X-Received: by 2002:a05:6512:234e:b0:59e:14f:a4d7 with SMTP id
 2adb3069b0e04-59e0412c504mr596109e87.27.1769511587201; Tue, 27 Jan 2026
 02:59:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121184621.198537-1-one-d-wide@protonmail.com> <20260121184621.198537-2-one-d-wide@protonmail.com>
In-Reply-To: <20260121184621.198537-2-one-d-wide@protonmail.com>
From: Donald Hunter <donald.hunter@gmail.com>
Date: Tue, 27 Jan 2026 10:59:35 +0000
X-Gm-Features: AZwV_QjjnqVDqp9AOjWvw9Flzx5vLDm-5nUzTQmwPn_FMTo536uddKntxFCb2_w
Message-ID: <CAD4GDZwy3B4pYH8q+MwY=NMNELjAcdwwk-trM+vAKhyvQCzH3w@mail.gmail.com>
Subject: Re: [PATCH v6 1/6] doc/netlink: netlink-raw: Add max check
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Jan 2026 at 18:47, Remy D. Farley <one-d-wide@protonmail.com> wrote:
>
> Add definitions for max check and len-or-limit type, the same as in other
> specifications.
>
> Suggested-by: Donald Hunter <donald.hunter@gmail.com>
> Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>

Reviewed-by: Donald Hunter <donald.hunter@gmail.com>

> ---
>  Documentation/netlink/netlink-raw.yaml | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/netlink/netlink-raw.yaml b/Documentation/netlink/netlink-raw.yaml
> index 0166a7e4a..dd98dda55 100644
> --- a/Documentation/netlink/netlink-raw.yaml
> +++ b/Documentation/netlink/netlink-raw.yaml
> @@ -19,6 +19,12 @@ $defs:
>      type: [ string, integer ]
>      pattern: ^[0-9A-Za-z_-]+( - 1)?$
>      minimum: 0
> +  len-or-limit:
> +    # literal int, const name, or limit based on fixed-width type
> +    # e.g. u8-min, u16-max, etc.
> +    type: [ string, integer ]
> +    pattern: ^[0-9A-Za-z_-]+$
> +    minimum: 0
>
>  # Schema for specs
>  title: Protocol
> @@ -270,7 +276,10 @@ properties:
>                      type: string
>                    min:
>                      description: Min value for an integer attribute.
> -                    type: integer
> +                    $ref: '#/$defs/len-or-limit'
> +                  max:
> +                    description: Max value for an integer attribute.
> +                    $ref: '#/$defs/len-or-limit'
>                    min-len:
>                      description: Min length for a binary attribute.
>                      $ref: '#/$defs/len-or-define'
> --
> 2.51.2
>
>
