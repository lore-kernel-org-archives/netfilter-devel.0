Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D883CFF73
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 10:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788343733; cv=pass; b=psW2LF41ge3UMOG5y+CYm/C2Pmk0x/EEuLlV0QFQXU3JarSladVhUfE0tf5nWngcVAiMxpYPtdDh5sbsjPBt9vWnDGrjEeHAf2hGTXTSez7JERHK9iLIyk6hTJHBS+9Bdl6PnVjZZ0CwQF2s11wjeioiyBDRSEk7glqxuo3MgyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788343733; c=relaxed/simple;
	bh=e22SUgGgIJ3poJkGI8HTllTE/j2hDqd/FF+MOcjqrxQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YyzTPq6D0IXmZcOZOweLXOxc0xW8TSnRDvc3Nb7dEqWpU5g8+fYehzSYIqeBgzUExuUDdd2PpKBDlgy3mR9iXH5SjfypozkqsQ9Q2nGoqdSDQj1vUbTUFGd/glHpLdEwb7qvsATtxzmNSEO8HXiWL4f2rW+61TxvQijDeYfqKMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dfL+csT0; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nMnUnst2; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dfL+csT0";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nMnUnst2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788343730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e22SUgGgIJ3poJkGI8HTllTE/j2hDqd/FF+MOcjqrxQ=;
	b=dfL+csT0Nr7xjunVMrWBZlNCiQt7UH7K6PChQBnNvuEuySRDckDlJ6slanlDe6FfbOf1WG
	78itl4bxceY85d3W8oPm10HVAdyTciIwX6j7zoi3tgt1m2OvVDv+2/shiuKCGQ4svhYPtf
	xh9S8YZvYeJq+V7NubwuiFxdRO1l56M=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-ZB5SoaU2PVutq4_QFxDTzw-1; Wed, 02 Sept 2026 06:08:48 -0400
X-MC-Unique: ZB5SoaU2PVutq4_QFxDTzw-1
X-Mimecast-MFC-AGG-ID: ZB5SoaU2PVutq4_QFxDTzw_1788343727
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5b5e2f313cfso429348e87.3
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Sep 2026 03:08:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788343727; cv=none;
        d=google.com; s=arc-20260327;
        b=LDNE0udWjLAqZ6vpJRWwkPN2BcTifJHlT6Lc1VjT3lnS6oCaLX5D2Syc8IV6iHjPRJ
         K9IcdMr/RaAjhEGsh2cHXqpQHz3L1MJ39ZAmCJMsGF5qnfe8YfPJPFutx+e/EfwY+WgE
         gLUlLLcEG6Lc+cORjrOstLf24tWU+jbwj03PkKQe6Ilgndt3GNZaEqBfiNwDORokGF8V
         1z2RIDZWrnocSJ6IrOW4UhogrGPcQZMWVIdjfg+JGpA7bDQrMKwLPewHnP8j3c/N0rZQ
         lzlMFcr6VvyWE5rxARHJEQuiDORSEfMRyDXaCIVyHHxZR/2LSXSONxc8k1qBb/cCNXzl
         X9GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e22SUgGgIJ3poJkGI8HTllTE/j2hDqd/FF+MOcjqrxQ=;
        fh=m9ErU9OwZrBIFaNm+ZmOs7sTf7zhCMNlFnda7pw9/P8=;
        b=BzmIM8ZFfT4E1eDCSfA5GS3/bBILMPpaXBE9iAyrHo7ms/jPTQxUbvts78C6v54+ZL
         YCFd+aFvY80EY+hddGJ/a6V6WDHlIq6Hk1QFKpbGEYYS7U6FMbJEt4tGHkFkgqVUj+9g
         fx8bnq/K0GSeFpdNP1GqQCaeZmUrue0K7Q8YMpVcp4pK8Pu7JvZSUTNvJYw2BaV0jrWn
         TtO1ow9n43KGYtrvZ9vlzFsJIb8uj6XsfxeqcOPiQDyxTqClvTq/UnrrCnh5RXg0qJUu
         GTr7DCzng02A+AsQ3pvj5LsQ+SLZg8TIkFZDd+YzKj5a/2k25zSACQgjVl9MKPCyyYEY
         TuUQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788343727; x=1788948527; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e22SUgGgIJ3poJkGI8HTllTE/j2hDqd/FF+MOcjqrxQ=;
        b=nMnUnst2Yx0Msk7zIwj8FUlVvIvyw9uUohHRoadFQgmiUybQVvU7oCdIqVzEYZXI/M
         R9PlX28mc7pvtT/9xfKJzMhgP0PTJpjgWFFOywPEKu8Wb8D1RLWLQMuylGXcXThU9cLa
         3zMR9vPguuUufi079763jqFqQvHkCgS0lt0zKRclnvLZwruKDfQJ0Z+4SYN9kf1rH3vJ
         fHPqbyRlbodTVHZ1FEX5+98uxyF7o6UIKWqghYBjO+vL+AbAYkwLX4grefGEwnJmWfwT
         ufVM2IAtguMhAV95KRuQPNcoyC8LAhXss087Rf4EYTqhnLqxjE8+J+9dLI9Lei5Mzg1a
         hO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788343727; x=1788948527;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e22SUgGgIJ3poJkGI8HTllTE/j2hDqd/FF+MOcjqrxQ=;
        b=HSnQbDxKpa4ne7ayXP6zXxG/wbgAwjomjs9TgyP1NB6vKUrH4HxLoug/2MY2glW1b0
         KUIH+OA1nnwT0N5yDHs8f9dEvsCXZwvr5uKAcJXoNkSq2oBkz1VJaLiMOpE4cloG12Wb
         6fnW52dRkb3adoZkIqFbtg7MKvMUpj5Z8Y09E4FN7FC8NlwBbDxXJHUBWQ7CY4e5hkzZ
         wcWmxq7xnOBFTaj23ZrUHen99OyAwkLYGHVPbPhfttIyPvRB9WZKlplJf3QV6u+HHqag
         dlMhEsqV+uKtIOWV5VJFi5ymi6DFI1ddjp97rnKErhFCOBzHFUzuqcxNndQEDNVf/fgw
         4DZA==
X-Forwarded-Encrypted: i=1; AKwUvBxQKLDKpoKhNvTzvUMyT5IYgACBC/qr4OuJ6uJ0jdu6v1A4smAG0lHdt3u40In+uNtZaZBxoU6T45wEWBeeIuc=@vger.kernel.org
X-Gm-Message-State: AFuF++mMvJ0OXTLj2MSsVRamR8mjLEwLMweBznoEKcZNXobfWRmvC3yc
	h4/fE8tY9NTxkS6jdGjGKFL7OBG765dNx3Fj7Pg3K8VzAEN3WuPsn6N9n9QEuV2QIICftlxiZVU
	nrFffv9s7LQz/qmxvv9dDZn96rUS5hLScLObKccJ6/cuUcEenqXYtxo1z1qR63WVaQOh51AsejW
	SDVf5KokLV3MuIcodCk47aH1YimRNug14M14ZQjCIYCO8P
X-Gm-Gg: AYBFou1t2aufwDfWX/xvPQyth/BFi2zhXSeATnjPQOsdqX8SNvn2QfaWDSB94DTBFUx
	GK+r7YWGSKaQKU2NEAlBNyRQ70V1d2eSeBgfQUdwsVMkH9M9LUGJPb+OJmx6AVWi3q/EukoFSf1
	PFcx5339y1T0cDcKR6JcAgdmmJmMYv8kD+FGnbMQPWym2wESAmbPTpW2CK
X-Received: by 2002:a05:6512:1252:b0:5ae:b0f0:c217 with SMTP id 2adb3069b0e04-5b60834b9bdmr1404119e87.9.1788343727393;
        Wed, 02 Sep 2026 03:08:47 -0700 (PDT)
X-Received: by 2002:a05:6512:1252:b0:5ae:b0f0:c217 with SMTP id
 2adb3069b0e04-5b60834b9bdmr1404086e87.9.1788343726954; Wed, 02 Sep 2026
 03:08:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260901115021.50057-1-ihuguet@riseup.net> <3d8ef804-efc1-46c7-bbb4-f1a6c26fed8b@kernel.org>
In-Reply-To: <3d8ef804-efc1-46c7-bbb4-f1a6c26fed8b@kernel.org>
From: =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date: Wed, 2 Sep 2026 12:08:34 +0200
X-Gm-Features: AcwNN1WWjJG56_BD-BZvMi7yD139IVOfUkEJ5Q53fMWfoLWzhUAroA5GHqaqbfc
Message-ID: <CACT4oueX-g20hKft6Z1Aj3rNK2Fi7MYHZz=LdBd3RKWu+YK-0A@mail.gmail.com>
Subject: Re: [PATCH net] net/ipv6: don't route packets with unknown source address
To: Matthieu Baerts <matttbe@kernel.org>
Cc: =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@riseup.net>, 
	David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Neal Cardwell <ncardwell@google.com>, Ido Schimmel <idosch@nvidia.com>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>, Simon Horman <horms@kernel.org>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Phil Sutter <phil@nwl.cc>, Daniel Borkmann <daniel@iogearbox.net>, 
	Fernando Fernandez Mancera <fmancera@suse.de>, Alexei Starovoitov <ast@kernel.org>, Junseo Lim <zirajs7@gmail.com>, 
	Leon Hwang <leon.hwang@linux.dev>, Xuanqiang Luo <luoxuanqiang@kylinos.cn>, 
	Willem de Bruijn <willemb@google.com>, Kees Cook <kees@kernel.org>, Qi Tang <tpluszz77@gmail.com>, 
	Jeff Layton <jlayton@kernel.org>, Joe Damato <joe@dama.to>, Breno Leitao <leitao@debian.org>, 
	Li RongQing <lirongqing@baidu.com>, "open list:VRF" <netdev@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:NETFILTER" <netfilter-devel@vger.kernel.org>, 
	"open list:NETFILTER" <coreteam@netfilter.org>, 
	"open list:BPF [MISC] :Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2026 at 7:41=E2=80=AFPM Matthieu Baerts <matttbe@kernel.org>=
 wrote:
> Thank you for looking at this, but I think your patch is causing
> multiple KASAN warnings, e.g.
>
> https://netdev-ctrl.bots.linux.dev/logs/vmksft/net-extra-dbg/results/8045=
84/24-connect-deny-ipv6/stderr
>
> And a few more, see:
>
> https://netdev.bots.linux.dev/branch_deltas/net-next-2026-09-01--15-01.ht=
ml

As far as I can see all the warnings are in the tcp_v6_send_response
function. I guess that sk may be a request socket there, so it's not
valid to treat it as a inet_sk in all cases. I will send a v2 with the
fix.

Thanks!


--=20
=C3=8D=C3=B1igo Huguet

