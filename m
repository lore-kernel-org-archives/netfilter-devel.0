Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4623914884C
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2024 11:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712835578; cv=none; b=hzF4CFn0XxF2K7qekumlwX4Ac4+lZ/XoEjvJVocpAgMZUiqmzPWklOdQKBf+UgK8tjIiZr5RJVUwd14x1DQRu6dPtWrQkn1ApOsYECHfc4eR/cLMqAlhmgFK9OMVs6v2SShQfh93YzeJoUTf8vN7R+eKZop73Wf0dmFszrW8hLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712835578; c=relaxed/simple;
	bh=noEalZBIYzCs9zmlRMTYcMUa+afpaX08pi0vcR5GHE4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EotlGJcJavGLZAoQbLkWmEPA8ybwEoqp3upEjmsU/SXC50/G3nLQDkeWgVnipL8PZI4MkoCSuwu8AKAlqe2E9zIrNL5PD+BN63KRbGOwHajIl/tbvZ9jw9M8yMTAn7LAkjeV4QTVYW0fDQj+tH7M8CgapluzMfhUb3aYhmeJ0pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QPY47+4F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QPY47+4F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712835575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eaQWL06CknDETg8OSlie4jGlZP1iw8MzjkMLDRJ1fGI=;
	b=QPY47+4FA+Fu0q+2YnR77jo9JOE1psZxJSe5TOtt7m74NeERmUj33mz4JrINDBWxM4j6tM
	8PCqxYWQ5Lmk72Sd0S2ZY+2C6IOqGUl2CO04p6033RKZS09WR+/mgYYM8cNKidk0ovAgDg
	ymXBM57e/XlcZvDS2W3fxx6jWmJIKOU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-c2Dv6jIQNvSownggxD8bNg-1; Thu, 11 Apr 2024 07:39:33 -0400
X-MC-Unique: c2Dv6jIQNvSownggxD8bNg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-346b68157cdso210566f8f.0
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2024 04:39:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712835572; x=1713440372;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eaQWL06CknDETg8OSlie4jGlZP1iw8MzjkMLDRJ1fGI=;
        b=GnewXAhDf43CG/Ew2KrHuSStqirVWkGDhtEA2eGzZcOyecYcwuDOPH0cAeCGq+cfFu
         vaqHcb2wrzWQoqh9ybtQVRE+7qIeIpPDTdAJ2/9g83dwkdcvPvKIgcW1ETaiP/l/WRMc
         7sAG5UC3A2Ik91BCsRywQi1h0tm8oz9zkOSQBWUEbWkxbWZ3M/hNyo1ZVBgt1aXS5/Hv
         YvbNVA247Jv+F7C5+1WuqjfAerFDwkhejmdhgzvqsRbpocuprbowLtOogJLZf+A5IwJh
         Iimtr32o/zyESYdIVmKewvUfOOU4B9nnMlioLpbMTzTjqMbU4pEPy2NXjMQrw0SbsZJw
         oiHQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/js1WhAjatebGm4gOGo0v47ueHM3qFwaSJBxgPMPXhVDlfK/8jF2g8bN7k36dEsEUWUG4I0uJ7Ef9KyXbw81KSWHjLer5JnIDi0xW8Ruu
X-Gm-Message-State: AOJu0YydPwrTCuiELTCO7nID1pW/GsU8o73F95lzgs3Ae5ADJ8mdHD7s
	QRX8Ay7HSVnm0NbswLkWgdd9MGP9LCFEDsvB9xvOZQWQ+yePAK20rc5o9+yX9LgPd7dBkqC/tGH
	rfr6oRF89VEB2Zq3X4wYUDLnpvcGIuEFlqzDSQKGwVaS/4CoPKLjy7XVfmaT2Gf2XVA==
X-Received: by 2002:a05:600c:1c01:b0:416:5339:d114 with SMTP id j1-20020a05600c1c0100b004165339d114mr3758651wms.1.1712835572639;
        Thu, 11 Apr 2024 04:39:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkw/VpU0WvmAfxT0PCn50ojqtKb9Jcn5cXy1pkUlGczfonrDJZ0cxzAbX9uPmTm8ulGa416w==
X-Received: by 2002:a05:600c:1c01:b0:416:5339:d114 with SMTP id j1-20020a05600c1c0100b004165339d114mr3758637wms.1.1712835572295;
        Thu, 11 Apr 2024 04:39:32 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-235-217.dyn.eolo.it. [146.241.235.217])
        by smtp.gmail.com with ESMTPSA id bh12-20020a05600c3d0c00b00417e326ff3bsm858526wmb.36.2024.04.11.04.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 04:39:31 -0700 (PDT)
Message-ID: <07f609433f7248412abb184d826976a766cea2e8.camel@redhat.com>
Subject: Re: [PATCH net 0/7] Netfilter fixes for net
From: Paolo Abeni <pabeni@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org, 
	edumazet@google.com, fw@strlen.de
Date: Thu, 11 Apr 2024 13:39:30 +0200
In-Reply-To: <20240411112900.129414-1-pablo@netfilter.org>
References: <20240411112900.129414-1-pablo@netfilter.org>
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

On Thu, 2024-04-11 at 13:28 +0200, Pablo Neira Ayuso wrote:
> Hi,
>=20
> The following patchset contains Netfilter fixes for net:
>=20
> Patches #1 and #2 add missing rcu read side lock when iterating over
> expression and object type list which could race with module removal.
>=20
> Patch #3 prevents promisc packet from visiting the bridge/input hook
> 	 to amend a recent fix to address conntrack confirmation race
> 	 in br_netfilter and nf_conntrack_bridge.
>=20
> Patch #4 adds and uses iterate decorator type to fetch the current
> 	 pipapo set backend datastructure view when netlink dumps the
> 	 set elements.
>=20
> Patch #5 fixes removal of duplicate elements in the pipapo set backend.
>=20
> Patch #6 flowtable validates pppoe header before accessing it.
>=20
> Patch #7 fixes flowtable datapath for pppoe packets, otherwise lookup
>          fails and pppoe packets follow classic path.
>=20
> Please, pull these changes from:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-04=
-11
>=20
> Thanks.
>=20
> ----------------------------------------------------------------
>=20
> The following changes since commit 19fa4f2a85d777a8052e869c1b892a2f755656=
9d:
>=20
>   r8169: fix LED-related deadlock on module removal (2024-04-10 10:44:29 =
+0100)
>=20
> are available in the Git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-=
24-04-11
>=20
> for you to fetch changes up to 6db5dc7b351b9569940cd1cf445e237c42cd6d27:
>=20
>   netfilter: flowtable: incorrect pppoe tuple (2024-04-11 12:14:10 +0200)
>=20
> ----------------------------------------------------------------
> netfilter pull request 24-04-11
>=20
> ----------------------------------------------------------------
> Florian Westphal (1):
>       netfilter: nft_set_pipapo: do not free live element
>=20
> Pablo Neira Ayuso (4):
>       netfilter: br_netfilter: skip conntrack input hook for promisc pack=
ets
>       netfilter: nft_set_pipapo: walk over current view on netlink dump
>       netfilter: flowtable: validate pppoe header
>       netfilter: flowtable: incorrect pppoe tuple
>=20
> Ziyang Xuan (2):
>       netfilter: nf_tables: Fix potential data-race in __nft_expr_type_ge=
t()
>       netfilter: nf_tables: Fix potential data-race in __nft_obj_type_get=
()
>=20
>  include/net/netfilter/nf_flow_table.h      | 12 +++++++++++-
>  include/net/netfilter/nf_tables.h          | 14 ++++++++++++++
>  net/bridge/br_input.c                      | 15 +++++++++++----
>  net/bridge/br_netfilter_hooks.c            |  6 ++++++
>  net/bridge/br_private.h                    |  1 +
>  net/bridge/netfilter/nf_conntrack_bridge.c | 14 ++++++++++----
>  net/netfilter/nf_flow_table_inet.c         |  3 ++-
>  net/netfilter/nf_flow_table_ip.c           | 10 ++++++----
>  net/netfilter/nf_tables_api.c              | 22 ++++++++++++++++++----
>  net/netfilter/nft_set_pipapo.c             | 19 ++++++++++++-------
>  10 files changed, 91 insertions(+), 25 deletions(-)

Whoops, I'm finishing testing right now todays PR, I hope it's not a
big issue if this lands later?

Thanks,

Paolo

