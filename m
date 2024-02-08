Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943E56A8DC
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2024 09:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707383303; cv=none; b=SFbYYnID4EKp14wsdyXhTkrkSSM10NRYYjwKl3RTWiRnloERUdnnzjQ7Af82EUsHtqDgxqTD3oMT85xcqlYJByfVg0BxsrQ8bxsMRdFP6IaNGlcPout0cPBLbbZWW9LqrMKIPY9KV6bXiTW/LBY66yY+I8CcfJ/O23QWZTnIs/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707383303; c=relaxed/simple;
	bh=2CSAufGywnpVwg3VfmdBkNqgQPouuCCADWJmKQm4sVo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KJ7d11YAxBSeQoGfcS6PMxiBofgsbbZj3E3EbDMjM4B/EEZMDR3pdAphFWCYrQe7ppa/877pSrzaA509BbWfX3BBQwvOuLLRTSYy75hZLsPnCe6Bh5ctNT4mrZxn3rrckx0qdkQVTI/GJYfbWOqpUEI4Y08yLdTYNxyIbWbZRis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eyI4y0IP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eyI4y0IP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707383300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wDY2mXZzOtw96devyPDs+QC0rfxdKOHyg7rW8Us9Bc8=;
	b=eyI4y0IPrDkKTCRsc4iqUPeE8WwC0gQb+1CYfwy6ubADaaLaglbRD7WOr1KZtFLdm68B6Y
	n6N57+OFSNLAXE89a9NxAg9LMpn2hCF3oQjPkBmNYm6inuLkTL8F9ZWpxe1+qigW8/NYq1
	gXH8x6Q67hGNcLOnW3H4beUObDSfEwg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-hkGjUQzPNkKr4Vf38XmHnA-1; Thu, 08 Feb 2024 04:08:18 -0500
X-MC-Unique: hkGjUQzPNkKr4Vf38XmHnA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4103bb38a68so737685e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Feb 2024 01:08:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707383297; x=1707988097;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wDY2mXZzOtw96devyPDs+QC0rfxdKOHyg7rW8Us9Bc8=;
        b=aBq/zAuqBXIKCg1Pcy9L53K6EQwHTmMMvScb7e+oFryeEy6cNyLpCMDrCeOYdpXB8d
         PrHqKaGdzvDSTiETFILgyDUbaBAGoBxVzB6r/sV9vp8xbxHC4g9jm97dJTNnnIAZG1pW
         wpUtkv6CLs+yMu8sjvE+eIJmizCH4j7x10gtSHWQw2W4djESlwqItPX+jKzAKF62XpFf
         x5oq8yyjGMEEXHqwUmXsIr88CrTpVxUVRuwhoifybmFU198C4/ju2MDyJu6LgdvU5BSb
         yv23SkZKOn2DFp4KY4ujqPJKJh7fQcQCqo1Wb29BDIry6Y+AgHYP+k7S/oA9gW/IigbS
         ASdg==
X-Forwarded-Encrypted: i=1; AJvYcCXjg5yUDbG7EQu5nJdh/ReC6MI/UTRYOZkrglx6hawbGZes3nrPVuNlBpxqbxsndCJbULDjH2KUeq088dfyNT0FR2+Q2HszGVHLQ2Cussoo
X-Gm-Message-State: AOJu0YxA80LwI5NCBnj074ozhQEnbgDFWmuOAuKjkntNvnUwlKDXRd6L
	4uhe6CE62ndMGNzNU8oaemBsCla68bfMPqceIy/dq4IyKGw+WXVHPhMMTKA27AqHuqgSkkQszP4
	NpNe6yJnTzN5HT3bdBMgZV46wIlcqJdn1ADl+aWWDisA4MihUnSpaoj5iaF1sfUAZNw==
X-Received: by 2002:a05:6000:a14:b0:33b:5898:e52 with SMTP id co20-20020a0560000a1400b0033b58980e52mr1154105wrb.3.1707383297643;
        Thu, 08 Feb 2024 01:08:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEzOfrPiaKgx8dNwGQCDbgZdQHVB2ZKZ2teDLFs/q4VEtPghSVcn9/omczOV6iIdEfhXZzJsw==
X-Received: by 2002:a05:6000:a14:b0:33b:5898:e52 with SMTP id co20-20020a0560000a1400b0033b58980e52mr1154085wrb.3.1707383297293;
        Thu, 08 Feb 2024 01:08:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX85VlU8MVH7tvyKbJJA9r+t7fNhqHpwkdYnnp/lK+1IuG0W7RlTsPCNmad9zxUCd6mVf5N76s3L02CphEd3+YHMXd/DWU9UOYtCFdSltVnqdCK4oCBmPt1ANgypXSeUsK8fH+g+3a/HJ16zwAUj7qoA7/C46HDe9Xn/+6LGCN4+U/KY3EytMWyjFYJROAYCa6cIUVxBtqZ7Wb2VA==
Received: from gerbillo.redhat.com (146-241-238-112.dyn.eolo.it. [146.241.238.112])
        by smtp.gmail.com with ESMTPSA id v5-20020adff685000000b0033b3ceda5dbsm3166304wrp.44.2024.02.08.01.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 01:08:16 -0800 (PST)
Message-ID: <f9541f0a7cacae213ec46cfac096aee386ab9a0b.camel@redhat.com>
Subject: Re: [PATCH net 08/13] netfilter: nf_tables: use timestamp to check
 for set element timeout
From: Paolo Abeni <pabeni@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org, 
	edumazet@google.com, fw@strlen.de
Date: Thu, 08 Feb 2024 10:08:15 +0100
In-Reply-To: <20240207233726.331592-9-pablo@netfilter.org>
References: <20240207233726.331592-1-pablo@netfilter.org>
	 <20240207233726.331592-9-pablo@netfilter.org>
Autocrypt: addr=pabeni@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 (3.50.3-1.fc39) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-02-08 at 00:37 +0100, Pablo Neira Ayuso wrote:
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipap=
o.c
> index f24ecdaa1c1e..7ee4e54fbb4b 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -513,7 +513,8 @@ bool nft_pipapo_lookup(const struct net *net, const s=
truct nft_set *set,
>   */
>  static struct nft_pipapo_elem *pipapo_get(const struct net *net,
>  					  const struct nft_set *set,
> -					  const u8 *data, u8 genmask)
> +					  const u8 *data, u8 genmask,
> +					  u64 tstamp)

(just if v2 is coming): the new argument lacks kdoc documentation.

Cheers,

Paolo

