Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297FF6BFBA
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2024 09:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707383502; cv=none; b=fKRlipwPm8LZZnwnBLQLXQUAxVaA/nDja7UfCXKgGrfSttWl9RxadVOQaEskniXgmBNqvaG4ObnTEFKO0mh+whh+0XmVgblTI0go0S7lcNde4+rczVHepo0a1MYXI6RJuQZj+KwLx2q1AVVJW0vETLe8Ld8bpTBloHiu7dWa4nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707383502; c=relaxed/simple;
	bh=I8QES0h6STId6YvXwZzxlev8VjeO3+6+rMH4r2zY4AI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=plc/GXD7xuUlOy/tlBv2rweqRpH7a5aodwYHVjr6E2bmxxQ5NtAUUDGPFOwv7WHPvxW/GTX6CCLwUDoIbys+lH9dQ9OxmSsAcdx0Tlfur21rO/2wq36YVEIvF7BmjY0EAO3ya3Ue9aNUfXQWOeif7RLS7gMiTs/p+LDx/VJWg88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E/6VGe2+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E/6VGe2+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707383498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GjN3erzpeOu+lVqwFmAKx0QvgvU4nCXyPHeDUJyovt4=;
	b=E/6VGe2+lDduRP5IB1LfjitE0RokWejHN/8Vny/cU2MlobH8Vd0DgNHVG6rVlkqPA2xufx
	FiKz5ImIcifvncdx37fFrtvbeQpCkMsEDa70DsV+DAaYzgyBNQPEUL50Ms/UKytH7hrvic
	4Ea2ow3h++nze90Sts1sQ5lKN030idI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-6OoH_lGMMf-eHUaOQDHr5w-1; Thu, 08 Feb 2024 04:11:37 -0500
X-MC-Unique: 6OoH_lGMMf-eHUaOQDHr5w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40efaee41dbso904635e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Feb 2024 01:11:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707383496; x=1707988296;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GjN3erzpeOu+lVqwFmAKx0QvgvU4nCXyPHeDUJyovt4=;
        b=U4/I0Jf4sBYTUHSatjVCk1rwi5q8IM3rez7CBkasERVKT/61XNyQDoL1CJsTSMvDGN
         tUCezEmNCCMHIHtvVREzJWedHRlMmkIsb8lO9Y1snYecpURZL5FOZtN7CbzdV56nf/LF
         mWGKpynyUhy4a/hXqBQhI43sKtx4SzUMiIaOubV6wtf9Cedc1B5NQa6yMG/nx4l2UaCs
         vrICZ6tn01uCR1vYlGhaJoGTcvy09oTFL9OS9x3mPFRtA/Yh2d89YVxO0N16D0k7Ofqh
         +7fK/OKiy12x6VfV3644nxR2bSE3r58FjZHApR5Kg4PG4sr9DyCZDME7KzRognjWKQzZ
         337A==
X-Gm-Message-State: AOJu0YxRPLMKFsVsuHeGo9MPvQWB82or3s5mCCiAYeW1oQBOkhAAsa47
	CD4BBqvJgwEy9Hp8CnhqNN/lTjVAZdq7QM+oVLnFcMEvPUenfOhXaaoxGOeD+TjfKwqZIe1U9WI
	jMUc0euXOgUgZgj3LjwY9APF1Ifv+LCeo/7W74OBeKVCBKJxRQkFFFOyvVto+pWO/qQ==
X-Received: by 2002:a5d:4689:0:b0:33b:4d82:a472 with SMTP id u9-20020a5d4689000000b0033b4d82a472mr3338558wrq.5.1707383496149;
        Thu, 08 Feb 2024 01:11:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFE+4PNgUa34QIZV8YtlDoA1AXKgr4WL59rEhpLLEmRPcPeKpCnN0QnLIyQYwW3XZegi5vTOQ==
X-Received: by 2002:a5d:4689:0:b0:33b:4d82:a472 with SMTP id u9-20020a5d4689000000b0033b4d82a472mr3338539wrq.5.1707383495797;
        Thu, 08 Feb 2024 01:11:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUNYyR9sEr9YNRB+MkVd1dz861yjg0RjLc2Myck3wBtaAQUSN7f8IhlWC92YQ6Pmyv4Yune3Rmu0pBfHmiAFTl+HdtTNtsdt7iyGT6jaA+2jLd0iAwvXZFH8KOnv7YNNpzjjZR69RjZIX0R4WTxrIqCwkT8PO2J39vybiNW5bqJ6vS6cyHrl1/cNOnIL3YStnHwVhn3Lqf4n/xJXg==
Received: from gerbillo.redhat.com (146-241-238-112.dyn.eolo.it. [146.241.238.112])
        by smtp.gmail.com with ESMTPSA id x7-20020a5d54c7000000b0033b444a39a9sm3169465wrv.54.2024.02.08.01.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 01:11:35 -0800 (PST)
Message-ID: <ccd18502ced7c753a6783010416ff7fe65ca2746.camel@redhat.com>
Subject: Re: [PATCH net 11/13] netfilter: nft_set_pipapo: store index in
 scratch maps
From: Paolo Abeni <pabeni@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org, 
	edumazet@google.com, fw@strlen.de
Date: Thu, 08 Feb 2024 10:11:34 +0100
In-Reply-To: <20240207233726.331592-12-pablo@netfilter.org>
References: <20240207233726.331592-1-pablo@netfilter.org>
	 <20240207233726.331592-12-pablo@netfilter.org>
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
> diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipap=
o.h
> index 1040223da5fa..144b186c4caf 100644
> --- a/net/netfilter/nft_set_pipapo.h
> +++ b/net/netfilter/nft_set_pipapo.h
> @@ -130,6 +130,16 @@ struct nft_pipapo_field {
>  	union nft_pipapo_map_bucket *mt;
>  };
> =20
> +/**
> + * struct nft_pipapo_scratch - percpu data used for lookup and matching
> + * @map_index	Current working bitmap index, toggled between field matche=
s
> + * @map		store partial matching results during lookup

(just if v2 is coming): you need to add ':' after the field names to
please kdoc.

Cheers,

Paolo

