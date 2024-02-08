Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C866A8BE
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2024 09:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707382897; cv=none; b=K4w2nQijvhjpUV34t13BSMY0xitfZxzRjvWTfvRTFwbNdSDFxf/RyC8XbpQC7cQ456USb2PhtSfmRTmIi8ENwD0pDFHF4o7/oB2NX10r/lkqbN+UXKXI/I9XCZIRZ5VlHqa71tKaNsIgdZIf/V8Kf7fdYTgsV/qNuVQepan7d8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707382897; c=relaxed/simple;
	bh=OWe9RB+lXu6X3YOsp6WbD1IhjLdVI5LF9xOYUXXsJr8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HhxpirDCucDccezEH4gbf45Smrr/mK1nfUefZKH0Yjc59wB5DY+W8ZsvANaEwRY0htUn4IES3rgEk7PysG6NuXcQE0UaasjmXt0WUrJakUXK19vskvP8SZkTbIPgO9Ja9Wyg4a3l1k4NgdAYiyvlE9ZMBSTV+fa7/Cq9L2noyh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iGoB/2dL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iGoB/2dL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707382894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4/JqOjABGbJ9Vm9FDvp8u2Gkr9TWn4syrnCybYECDUw=;
	b=iGoB/2dLFUYqpZVgF5V+518EpBMz30VUNtuFXqvFIQ+cHTKrLOlZJxQV793aIT9ck360rV
	WrdaPlgb+0QDW1r9GZLOwoKUD65wSzGPGQnOal+B2Phtjur2Pg1hg8yJjbU0D0lJaxo716
	+Yrz3/gl/jmW9k7GCJMYUkDdkyaDkdU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-DfcYD87nNFmNb7nFIVHrLg-1; Thu, 08 Feb 2024 04:01:33 -0500
X-MC-Unique: DfcYD87nNFmNb7nFIVHrLg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4103bb38a68so722425e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Feb 2024 01:01:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707382892; x=1707987692;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4/JqOjABGbJ9Vm9FDvp8u2Gkr9TWn4syrnCybYECDUw=;
        b=s6x7TpRzaA+cqNchCCylpgfMktc7hZqJq5eilsy+yifAiW/XXMq94nyEmZbHvEVT28
         xC/9oebUyn1mBU02P6Un0ZMAixEiGS2fkZbkLELd8YxINalL39+Czp0OaeRWmPamNeUS
         yRgBrjPTEG8x5jpMfasLW4b9jsPzgbwvnfzGdd+BSsneh/EkFfW5t3kVB6XiYq9VjaZk
         DeK33vytU1manXkQxk7+g9QF2ZVZR64rykPEamyjXWxOZdT98fFWc+Kh64EbuGWO14x8
         665wvvQp10OOlZDhWqHQeQPEmrCAa8j15KAm5H8VA1BZjjuL8leye+J528aQqu4XxdNs
         iO6w==
X-Forwarded-Encrypted: i=1; AJvYcCXu3rQPAW64rLpYoF/shW1I+g3P3C9emvyV7rLemsvvi2vj3NH97NqqpiR3QzcQN382VNeqcP5VRCvTj0oDzn+y6qIe+lXoUuj5KeBNuGA7
X-Gm-Message-State: AOJu0Yx8NC6/95fCJMNof1JsLzVcvjAyIySQeIC6m7HSh3GW+VD5dxrf
	W1FW3ogfxFL5tFLCj8r9UJYJiOJANxYgpiaP46j/oBToetCuxKp6DbOlkcZ9gL6psCiuW3yn2BO
	3X67qFDXmJgUaP0ES0cJQA/QVC0di1MQxe+KXGfxbLDIBZ0gdDFNBZNpSp17cDHS7KA==
X-Received: by 2002:adf:ff92:0:b0:33b:5197:7182 with SMTP id j18-20020adfff92000000b0033b51977182mr2228619wrr.2.1707382892072;
        Thu, 08 Feb 2024 01:01:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFZnrKijswVPJcSUlOl45mv2Hv8o6L1FQvc/XOtNYAZOI/Y1HopPxQuYATmebdzXzFAXOvtgQ==
X-Received: by 2002:adf:ff92:0:b0:33b:5197:7182 with SMTP id j18-20020adfff92000000b0033b51977182mr2228598wrr.2.1707382891670;
        Thu, 08 Feb 2024 01:01:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUYo9vTErVLCzx3QOCnpjvmyojOuc0WKCN9RG0vA4j5+MMTAyFGc2wm3DOdT8MfJZ5rAjUh57w5Gs6cbYceE122xibDRqK4cyFP3RJqw1PoQOeiL/slTlzIgeyWudy3p2rnYxh3+yeHS45jsMQjJIKrJcdD5khUH3Ay73v+po+/Lp00CzaH6nn6r9Mr0W8ZNBPnDT3NEt+FnMmgRA==
Received: from gerbillo.redhat.com (146-241-238-112.dyn.eolo.it. [146.241.238.112])
        by smtp.gmail.com with ESMTPSA id b14-20020adfee8e000000b0033af4848124sm3143463wro.109.2024.02.08.01.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 01:01:31 -0800 (PST)
Message-ID: <85a149ff1f960f59d11af20b5f0e25e5e074acdd.camel@redhat.com>
Subject: Re: [PATCH net 05/13] netfilter: ipset: Missing gc cancellations
 fixed
From: Paolo Abeni <pabeni@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org, 
	edumazet@google.com, fw@strlen.de
Date: Thu, 08 Feb 2024 10:01:29 +0100
In-Reply-To: <20240207233726.331592-6-pablo@netfilter.org>
References: <20240207233726.331592-1-pablo@netfilter.org>
	 <20240207233726.331592-6-pablo@netfilter.org>
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
> From: Jozsef Kadlecsik <kadlec@netfilter.org>
>=20
> The patch fdb8e12cc2cc ("netfilter: ipset: fix performance regression
> in swap operation") missed to add the calls to gc cancellations
> at the error path of create operations and at module unload. Also,
> because the half of the destroy operations now executed by a
> function registered by call_rcu(), neither NFNL_SUBSYS_IPSET mutex
> or rcu read lock is held and therefore the checking of them results
> false warnings.
>=20
> Reported-by: syzbot+52bbc0ad036f6f0d4a25@syzkaller.appspotmail.com
> Reported-by: Brad Spengler <spender@grsecurity.net>
> Reported-by: =D0=A1=D1=82=D0=B0=D1=81 =D0=9D=D0=B8=D1=87=D0=B8=D0=BF=D0=
=BE=D1=80=D0=BE=D0=B2=D0=B8=D1=87 <stasn77@gmail.com>
> Fixes: fdb8e12cc2cc ("netfilter: ipset: fix performance regression in swa=
p operation")
> Tested-by: Brad Spengler <spender@grsecurity.net>
> Tested-by: =D0=A1=D1=82=D0=B0=D1=81 =D0=9D=D0=B8=D1=87=D0=B8=D0=BF=D0=BE=
=D1=80=D0=BE=D0=B2=D0=B8=D1=87 <stasn77@gmail.com>
> Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/ipset/ip_set_core.c     | 2 ++
>  net/netfilter/ipset/ip_set_hash_gen.h | 4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
> index bcaad9c009fe..3184cc6be4c9 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -1154,6 +1154,7 @@ static int ip_set_create(struct sk_buff *skb, const=
 struct nfnl_info *info,
>  	return ret;
> =20
>  cleanup:
> +	set->variant->cancel_gc(set);
>  	set->variant->destroy(set);
>  put_out:
>  	module_put(set->type->me);
> @@ -2378,6 +2379,7 @@ ip_set_net_exit(struct net *net)
>  		set =3D ip_set(inst, i);
>  		if (set) {
>  			ip_set(inst, i) =3D NULL;
> +			set->variant->cancel_gc(set);
>  			ip_set_destroy_set(set);
>  		}
>  	}
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
> index 1136510521a8..cfa5eecbe393 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -432,7 +432,7 @@ mtype_ahash_destroy(struct ip_set *set, struct htable=
 *t, bool ext_destroy)
>  	u32 i;
> =20
>  	for (i =3D 0; i < jhash_size(t->htable_bits); i++) {
> -		n =3D __ipset_dereference(hbucket(t, i));

AFAICS __ipset_dereference() should not trigger any warning, as it
boils down to rcu_dereference_protected()

> +		n =3D hbucket(t, i);

This statement instead triggers a sparse warning.

>  		if (!n)
>  			continue;
>  		if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
> @@ -452,7 +452,7 @@ mtype_destroy(struct ip_set *set)
>  	struct htype *h =3D set->data;
>  	struct list_head *l, *lt;
> =20
> -	mtype_ahash_destroy(set, ipset_dereference_nfnl(h->table), true);
> +	mtype_ahash_destroy(set, h->table, true);

The same here. What about using always __ipset_dereference()?

Cheers,

Paolo

