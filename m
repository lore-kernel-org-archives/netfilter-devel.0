Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F8713CFA2
	for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 09:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716456415; cv=none; b=NGW3tgCh6PeMeyhqRqa7vrjccivFGk8DsHrW12AICPbOsN7eazbfLuCgC8x+HAaC/wMqGGk9lzKRGtqXxA6QjRnzBXdeLEc7HMz6fvWyiKuk13a7JHbSSTdWpWpfqLvnYjzH5apNXD4IkLKOpgdNnybiq6szbqIFGyheCIusM94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716456415; c=relaxed/simple;
	bh=JAYFrGgwYS8HfWrSnz/neCHT8hu2MGuUU/8snl7KE+o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sKi9idaBiQ6o65XP6BzVow//WE6FwuU4gJNRZJR/xnI3EcYpLsyrbTHS0qEwGFVn1LpWvBZI1EBAKMWM+w/nhNJP+UfbO7m6Xu1QUxaLV4Nz3J+z8Po9fLxpB5A2pL2zS9MvIr9OviI34KTsn/pEXndAOIDUvV2r+b3vCsnENcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ejU5X3O7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ejU5X3O7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716456412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HKdhJA1OuoIvsTtBmTZlDesLkRNCmxNuqAHFhZzRfDI=;
	b=ejU5X3O7EF/n4Hstxya8JthB2931BPkpyicaJZNvUXofb0RrPk3y/ofkj4mBYkxCfnyXh8
	RBIXmjUPwGFmNTZSHEeSsmZi8v3WfoLFErQtRjkyR2VMMkSJIHxQYRy5+31x/cD4oin8dj
	U+PgrZI8o4au8/CD89EM8/Y+2EXjOFY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-DX2UfksrOImk6NBJ7YchHA-1; Thu, 23 May 2024 05:26:48 -0400
X-MC-Unique: DX2UfksrOImk6NBJ7YchHA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-34e079eca20so1798179f8f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 02:26:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716456407; x=1717061207;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HKdhJA1OuoIvsTtBmTZlDesLkRNCmxNuqAHFhZzRfDI=;
        b=Rk4ETAJsNnwvABJ/46pys/NOJnzjEujMP2GG5GLIwEzc+GKRpxD7kegviu8lMNISwh
         bHwzJ6a/ebKLItsXD5CEKJhPqDQIOxHUAjWcP0SM04mEkHaCiq80fKFVM6l+KdE82jnu
         pYrlLSWMViIFHqXNuDVjU/kM5ia5gTiLYrRZrAYjk+x2T98sRTnn6XK3aKUOB55b1GBj
         XygUw1ZfWB/MloyZSdb/dW2u7auhPeECzoK4yCV2vBk77V1Zdj7gjynhtpouI00cvuzd
         UEgK4eqer0ukAMqT48jMt+8qzy/WSP2SAmdtmqsn+an24IVsZyUYAsNEoyhXGUZk7Iy5
         tD4A==
X-Forwarded-Encrypted: i=1; AJvYcCWq8wU1FKyhVNGL0NrMT4kMYXN/ZjgRh6v3Y3saKrenZIDAGZCAcWaP9DBehvr1PXgpp6P+45erP+gmsZSBrphG/txAJOJBDPz7lWIuKzvj
X-Gm-Message-State: AOJu0Yw8FsTKs5MQGOijnIsvxGlsf95A1dwO/YHGDK4K1LYezLSjKuIt
	OSbRCD9W6e8ayblvAFlobqedWvNgOYx4pBSaTMtRok42olRqai2chwIMsQnzPzaMO+JBfW1d2QZ
	dBY5LsO+2g45p6m0wEYrYzMfOFH+YdKMfjFGAzNHwMLXCPQsn0PSnbE0j6ItPQGC/XQ==
X-Received: by 2002:adf:eac5:0:b0:354:c3c0:e601 with SMTP id ffacd0b85a97d-354d8bb2529mr3233950f8f.0.1716456407656;
        Thu, 23 May 2024 02:26:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWcnLVYix1DRW7sXtNhoy2PeZnLMyU+nMP7RUVXyrj7h2EIeXu2Vz7KmipixkDTbIXF34p4A==
X-Received: by 2002:adf:eac5:0:b0:354:c3c0:e601 with SMTP id ffacd0b85a97d-354d8bb2529mr3233928f8f.0.1716456407260;
        Thu, 23 May 2024 02:26:47 -0700 (PDT)
Received: from gerbillo.redhat.com ([2a0d:3341:b094:ab10:29ae:cdc:4db4:a22a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-354fc599876sm591264f8f.10.2024.05.23.02.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 02:26:46 -0700 (PDT)
Message-ID: <e20cde161e014616d0b4969f2bec22cd80ca2c5a.camel@redhat.com>
Subject: Re: [PATCH net 4/6] netfilter: nft_payload: skbuff vlan metadata
 mangle support
From: Paolo Abeni <pabeni@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org, 
	edumazet@google.com, fw@strlen.de
Date: Thu, 23 May 2024 11:26:45 +0200
In-Reply-To: <20240522231355.9802-5-pablo@netfilter.org>
References: <20240522231355.9802-1-pablo@netfilter.org>
	 <20240522231355.9802-5-pablo@netfilter.org>
Autocrypt: addr=pabeni@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-05-23 at 01:13 +0200, Pablo Neira Ayuso wrote:
> @@ -801,21 +801,79 @@ struct nft_payload_set {
>  	u8			csum_flags;
>  };
> =20
> +/* This is not struct vlan_hdr. */
> +struct nft_payload_vlan_hdr {
> +        __be16          h_vlan_proto;
> +        __be16          h_vlan_TCI;
> +};
> +
> +static bool
> +nft_payload_set_vlan(const u32 *src, struct sk_buff *skb, u8 offset, u8 =
len,
> +		     int *vlan_hlen)
> +{
> +	struct nft_payload_vlan_hdr *vlanh;
> +	__be16 vlan_proto;
> +	__be16 vlan_tci;
> +
> +	if (offset >=3D offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto)=
) {
> +		*vlan_hlen =3D VLAN_HLEN;
> +		return true;
> +	}
> +
> +	switch (offset) {
> +	case offsetof(struct vlan_ethhdr, h_vlan_proto):
> +		if (len =3D=3D 2) {
> +			vlan_proto =3D nft_reg_load16(src);

I'm sorry but the above introduces build warning due to endianess
mismatch (host -> be)

> +			skb->vlan_proto =3D vlan_proto;
> +		} else if (len =3D=3D 4) {
> +			vlanh =3D (struct nft_payload_vlan_hdr *)src;
> +			__vlan_hwaccel_put_tag(skb, vlanh->h_vlan_proto,
> +					       ntohs(vlanh->h_vlan_TCI));
> +		} else {
> +			return false;
> +		}
> +		break;
> +	case offsetof(struct vlan_ethhdr, h_vlan_TCI):
> +		if (len !=3D 2)
> +			return false;
> +
> +		vlan_tci =3D ntohs(nft_reg_load16(src));

Similar things here htons() expect a be short int and is receiving a
u16, vlan_tci is 'be' and the assigned data uses host endianess.


Could you please address the above?

Thanks!

Paolo



