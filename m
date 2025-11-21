Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24340258EFC
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2025 11:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763726141; cv=none; b=fjMLlitVP3nM/3FFr2AJdFySjf7jXMsCXIHLiYJBiZhRB3OmodgEbYeLGInF9xbHu02BaivnEtNd4ZqO8p92jgFANyPGwQNPZZiJGf7RSzd9f0N/iqHc8dNFYZdC8whoveatexgRXX+tlH2LWuC85B8UVbnSQhwsl9Iovzw5jGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763726141; c=relaxed/simple;
	bh=BCuwsxN4wT9xb1KQ+7jRZodv0F6+z6Q1IawNA3LunJE=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=Gyh2pKo5DdxOJPhve6xPNM0tRrO50R1b5iUnT3ROMF4t3cJ4cqE0+Hy/uAUVR5eoY3tJ5ajZHshNgOn8Nn9fFQwrI8QFhYszSpkz9mEfu5xaF7s152jzy/XoNcJ66zYMuxEGx7COgIYhL8dBamGN0ORNhwx0yAcjDtgYFU1WasE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C5x9E16Q; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C5x9E16Q"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42b3377aaf2so1092882f8f.2
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2025 03:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763726138; x=1764330938; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oDriZHKoYlumz0kyJ+iuC42fqsgc1CZpksWMuirWE2A=;
        b=C5x9E16QbtpONLsKhXOr6T8ipoQ80MpBXXpx6SMwI0xySTR56AbMiv0ktergURdKJW
         u3VsjlsCIaTERQQx6+s2XYDzyWZHXpWzsKBjLNhqihZqHu6xvtFNgA5ZcTjzNZjxE56b
         Z8zAeMx4m+WKDGQLnwCfmTyF3qIEVkT0dPEfyi/2E/eFOdx7L4nbkQmJQhf2knTuxNlO
         jtWdVLMmyoIQN85xE/vBtl5BxvcMWATfwKP8CCeYPiVhxTcd5WL6oIvc3RNrymyMlfTT
         K16BzTGGZm3T3NNqkLPAV1wLZu3v3a3eZHcAlaLmICpWrNo6PkaU353gvNIyGbOmEaU3
         k/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763726138; x=1764330938;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oDriZHKoYlumz0kyJ+iuC42fqsgc1CZpksWMuirWE2A=;
        b=FRayU6a4YK2Q9dwOCU1Oef9Kht7PDOFKD31l+WWv2Tfz/qYkFzD6S3VZol9u+suQd5
         qFfy3FRa48EvhDT2VPnyH8W4xmYIMKF1q6PQCBThfr1jdJwHk0HxqfCOLaeoDmYWw62b
         9LYXxTxeYAIR9BczsIhMpr68vIuPUMPZv/SbIxnrcIYpin26oGDedIeaOoLa5n0SuxEp
         t/6ns3ciSNM4hKO5Sph8tDgg4FsEoYRkswnB8n8YvHXuO+Ez/ZLNxI4HNdzG8HRmIRM2
         l0Oo4N21ABqn93j8oag4/zCK7HlPFXI/HdULoLn7F+8Q1j4oSswRTIEbhK97PStOjecv
         ee+A==
X-Forwarded-Encrypted: i=1; AJvYcCWjtkPuz6AYeDXsHBs4AYNJl7bxiK1zLB4dX18vTjX9vmP6KuqXPtm3jPuxKlmp/SxzTv+Ru2yT+48HilTZ/Oo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjETFgU97eq3IAOwFnaz3iETJq5Irk1X828cviUPJxtuN2xMhy
	Xl/I3Zl0IrXkEWEN7cwIpGDTAVnDhssSpB7mhJ8Y61/QGIJ5dCSj/1e99wc2Fw==
X-Gm-Gg: ASbGncu3y1jx8muICFlkD01GgNHt0SIsG3n3hDl0t2uGbzXc2dV9vGkiyfSwDpbCXkO
	pBbCeOM1zn5m26FjQC/PJeEPc18hGzUpbAKG+CanXdLwvRiZ75SkVm0g6oOeGWk5xSO4tQ41Xku
	vqfVZMgNrXEofmpIpow2KIzv5/iNQb1HJPcl6BnBzX73ZByGuCtuEmeui8lw8zwnwMJoKhWxcEK
	CD/oUMSRZA4LurkP0lnwBb2/XYAhtxEzD0MxYgdysg//wcHITY7LgX0rZeEugUjg9Ybv6RkVmmk
	kvOnhy4e48vlZ7qFkxKhZSWZtzq8kQ1VybIsoVWw7rjyt5BShqipKdDeiHQmSluNgn4uohi3nYu
	P5Fk+onOl4tvytjESb8AaM381XNnqG1MqZQ0lJcC5F7qLHAop1t8sm63mMzAZ1nrRVoEmhwANi/
	xs+DOn4CIaj9BWOnrsGWYm/2YkP6e0LA41Dg==
X-Google-Smtp-Source: AGHT+IH0a0jaDfCVovpxy3z9csXD4B+JfYy/Q8r+BidsjxSKcegW0mK4p8CA8FZ7pwMUWQkuiKA/BQ==
X-Received: by 2002:a05:6000:2507:b0:42b:52c4:6631 with SMTP id ffacd0b85a97d-42cc19f5797mr2076239f8f.0.1763726138266;
        Fri, 21 Nov 2025 03:55:38 -0800 (PST)
Received: from imac ([2a02:8010:60a0:0:f819:b939:9ed6:5114])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fd8e54sm10802902f8f.40.2025.11.21.03.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 03:55:37 -0800 (PST)
From: Donald Hunter <donald.hunter@gmail.com>
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>,  netdev@vger.kernel.org,  Pablo Neira
 Ayuso <pablo@netfilter.org>,  Jozsef Kadlecsik <kadlec@netfilter.org>,
  Florian Westphal <fw@strlen.de>,  Phil Sutter <phil@nwl.cc>,
  netfilter-devel@vger.kernel.org,  coreteam@netfilter.org
Subject: Re: [PATCH v5 4/6] doc/netlink: nftables: Add sub-messages
In-Reply-To: <20251120151754.1111675-5-one-d-wide@protonmail.com>
Date: Fri, 21 Nov 2025 11:40:55 +0000
Message-ID: <m2ecpr4nqw.fsf@gmail.com>
References: <20251120151754.1111675-1-one-d-wide@protonmail.com>
	<20251120151754.1111675-5-one-d-wide@protonmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Remy D. Farley" <one-d-wide@protonmail.com> writes:

> New sub-messsages:
> - match
> - range
> - numgen
> - log
>
> Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
> ---
>  Documentation/netlink/specs/nftables.yaml | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/Documentation/netlink/specs/nftables.yaml b/Documentation/netlink/specs/nftables.yaml
> index 01f44da90..3cad6f857 100644
> --- a/Documentation/netlink/specs/nftables.yaml
> +++ b/Documentation/netlink/specs/nftables.yaml
> @@ -1471,6 +1471,21 @@ sub-messages:
>        -
>          value: tproxy
>          attribute-set: expr-tproxy-attrs
> +      -
> +        value: match
> +        attribute-set: compat-match-attrs

Prefer to keep the sub-message list sorted please.

> +      -
> +        value: range
> +        attribute-set: range-attrs
> +      -
> +        value: numgen
> +        attribute-set: numgen-attrs
> +      -
> +        value: log
> +        attribute-set: log-attrs
> +        # There're more sub-messages to go:
> +        #   grep -A10 nft_expr_type
> +        # and look for .name\s*=\s*"..."
>    -
>      name: obj-data
>      formats:
