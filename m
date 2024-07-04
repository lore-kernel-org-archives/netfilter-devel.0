Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA847E9
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2024 13:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720099466; cv=none; b=AgeGG3aI7+4PLeVz2F9fAZsA3HeYjvDxJ9O/Zi3eaENzEvu4VpY8J4qsEmoPx7HRCtkSyVwM+TSoXcwQLsuL+DmeMEKfM1kOXsQf8VQv3RHSo/7NBZsFIOqgyrjqZ19A+ZhaIagbnMd+3nYFnvkjh+Ahqv80p7MajiVj8FeLqYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720099466; c=relaxed/simple;
	bh=mbx9DZwHxda+5bS9Xpu6z7owlTViZ1ULgqQnPiFNTvY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Vl7Lv0yrnbkTYutHrrrDn1qzPzKyf0ff9p6Z8y4sF1QdkBwKHjIt+UuKjR9gzZdUsZvQSBzFiPdUD1ps57cfxp3TzeqoM3x9e6bIYbkVVn6+hFmluu9IcU2jfSC0baWhZL7Qcr88eXpnozh4trA3TAfqqZnPVixURV1lcdSeffI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cImycJ28; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cImycJ28"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720099463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3VNkRS4T4Qkdi+6JYstZ8nIhr7pSi6qKqkoZuEjxvFQ=;
	b=cImycJ28NhEQ001KF7VWPwIyH1aFut5+1M1/k3+J0nFoLBEI84uWxEGtuXPcUqeIKJRVLS
	mDvT5u5O2L07cjyIDUuQ7Y7ZtaGN9ze+Vd9CSOZhGsxlHShdTA+NTUCCirwVC+MoJyTCdq
	t3NDw23F4Lz4H06toUEsaQmIXkGb4JM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-MDbhwhjvOMql3MfJKKkxFA-1; Thu, 04 Jul 2024 09:24:22 -0400
X-MC-Unique: MDbhwhjvOMql3MfJKKkxFA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4256e46d820so28215e9.3
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jul 2024 06:24:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720099461; x=1720704261;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3VNkRS4T4Qkdi+6JYstZ8nIhr7pSi6qKqkoZuEjxvFQ=;
        b=m+4erPDVvX9C9Qc4ISxKW1f7jbHrjk0REj2054BlL7P0vaDl9KVuQitZ5NDh7XZDX2
         fWWTjkC+duu51dshdgIZ34ueoqKkjTUJJrnokeG6pZ/EPDT01iAeg9T3hED2Lb1Fg4ht
         f/lQSGF+UJkgHZpKKXeEloLrW9j0Iw+UszqJeeYmu2XNqJlCfWCbbqeJ3jp9Y9X4Y7FO
         +qsU8t21SvSglJGzebe2awuTNj6cX+Godo3HORK5x6gWl64A2gNHVzyTOQzqUxzgk3wC
         KxNF9i8OM3Y2cL0HSJVpFgwW9+DM5BwqS2IgNaV10h48nWl4BO3OWPFv8ieLwfCh+MZM
         XMAA==
X-Forwarded-Encrypted: i=1; AJvYcCWm2hS46P674iBnTxL6z8YZbcxHcVj83ZDsOUiGCQqSzoUZUeymEyp2VucDBZDJKYDajuxmQJ3cJEodgaFluU8Ut4kS6Z8BhqknwksiMtJG
X-Gm-Message-State: AOJu0YwEY9QphxvK5RBEh+kd1r2Hte3dsX5/nubk1XW033LInTaW95GR
	4dDZePUwcnSsc5OK/cV14pM+sNmReC6Rw5Lu3xru3Kg0+pYY9P5FwPo7M7iDdvlnvJWjommfGyE
	XG7IwweUy72CCBkYPool2E+kz63foDIJDiXXWlQ8BpafAccQdBavEzMsLRJxNC9bIbw==
X-Received: by 2002:a05:600c:3ba4:b0:424:a74b:32d3 with SMTP id 5b1f17b1804b1-4264a35314dmr13414025e9.0.1720099460925;
        Thu, 04 Jul 2024 06:24:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPPkCAbl8b7LnXMurHXjhXR0AWmRcpOQRv5pTP4HII+obm+7XFaogMq/sn0Iytpkv1YD4yMQ==
X-Received: by 2002:a05:600c:3ba4:b0:424:a74b:32d3 with SMTP id 5b1f17b1804b1-4264a35314dmr13413805e9.0.1720099460508;
        Thu, 04 Jul 2024 06:24:20 -0700 (PDT)
Received: from gerbillo.redhat.com ([2a0d:3344:172b:1510::f71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4264d6d41cesm9843115e9.16.2024.07.04.06.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 06:24:19 -0700 (PDT)
Message-ID: <af0c0ca73af3d4442d2de49c54fa58d3d2b759af.camel@redhat.com>
Subject: Re: [PATCH net 1/1] netfilter: nf_tables: unconditionally flush
 pending work before notifier
From: Paolo Abeni <pabeni@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org, 
	edumazet@google.com, fw@strlen.de
Date: Thu, 04 Jul 2024 15:24:17 +0200
In-Reply-To: <20240703223304.1455-2-pablo@netfilter.org>
References: <20240703223304.1455-1-pablo@netfilter.org>
	 <20240703223304.1455-2-pablo@netfilter.org>
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

Hi,

On Thu, 2024-07-04 at 00:33 +0200, Pablo Neira Ayuso wrote:
> From: Florian Westphal <fw@strlen.de>
>=20
> syzbot reports:
>=20
> KASAN: slab-uaf in nft_ctx_update include/net/netfilter/nf_tables.h:1831
> KASAN: slab-uaf in nft_commit_release net/netfilter/nf_tables_api.c:9530
> KASAN: slab-uaf int nf_tables_trans_destroy_work+0x152b/0x1750 net/netfil=
ter/nf_tables_api.c:9597
> Read of size 2 at addr ffff88802b0051c4 by task kworker/1:1/45
> [..]
> Workqueue: events nf_tables_trans_destroy_work
> Call Trace:
>  nft_ctx_update include/net/netfilter/nf_tables.h:1831 [inline]
>  nft_commit_release net/netfilter/nf_tables_api.c:9530 [inline]
>  nf_tables_trans_destroy_work+0x152b/0x1750 net/netfilter/nf_tables_api.c=
:9597
>=20
> Problem is that the notifier does a conditional flush, but its possible
> that the table-to-be-removed is still referenced by transactions being
> processed by the worker, so we need to flush unconditionally.
>=20
> We could make the flush_work depend on whether we found a table to delete
> in nf-next to avoid the flush for most cases.
>=20
> AFAICS this problem is only exposed in nf-next, with
> commit e169285f8c56 ("netfilter: nf_tables: do not store nft_ctx in trans=
action objects"),
> with this commit applied there is an unconditional fetch of
> table->family which is whats triggering the above splat.
>=20
> Fixes: 2c9f0293280e ("netfilter: nf_tables: flush pending destroy work be=
fore netlink notifier")
> Reported-and-tested-by: syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail=
.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D4fd66a69358fc15ae2ad
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.=
c
> index e8dcf41d360d..081c08536d0f 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -11483,8 +11483,7 @@ static int nft_rcv_nl_event(struct notifier_block=
 *this, unsigned long event,
> =20
>  	gc_seq =3D nft_gc_seq_begin(nft_net);
> =20
> -	if (!list_empty(&nf_tables_destroy_list))
> -		nf_tables_trans_destroy_flush_work();
> +	nf_tables_trans_destroy_flush_work();
>  again:
>  	list_for_each_entry(table, &nft_net->tables, list) {
>  		if (nft_table_has_owner(table) &&

It look like there is still some discussion around this patch, but I
guess we can still take it and in the worst case scenario a follow-up
will surface, right?

Thanks!

Paolo

