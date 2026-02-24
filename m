Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE9E3644CC
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2026 15:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771947639; cv=pass; b=TFyWP0xqZ4qY6ZH8efg1bkW3zf5od0nlN/b6IhimmjeNUAG6nnKpxgkzNSljRhY8EndVWHjXqdsYFx0vDxp1ixgskBCftbnEee6NfnW6vI737mZCWXcv2DHj7yh3dggQhkaAjTrmdSylFsRy6en7gkI4d7VAgqiIcj6d+g5BfSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771947639; c=relaxed/simple;
	bh=O3QyF9FLKTP6W6pa/p3xJuZO0tSDoqWpWsvRiZjDSKc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uY+FQMFBw6jLSutaahQiCNFwcRleSlvDyu0jP/PrWlVpdl7zziwC3M+puYW5JNXvFPE98WfVc4gzKj76G1xxNGywqA9EAmut0AN2wG9hFa3WnyrGMoM3mi5VpM8CCbIPAZH7SQZqzHoXdGkvGL/LH61rJWsB2eB2+yRNbjJqBac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qYtwN44p; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qYtwN44p"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-506bcb23a78so50286101cf.3
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2026 07:40:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771947635; cv=none;
        d=google.com; s=arc-20240605;
        b=e2ZGF1N4HIQ94IF8HiRWyS5P0CQnivBP2F0BCc4iBxoyf8qXIIdFhsESIrNqDN0G2j
         uQGLmOK8LfJXcbYKq4FyPrCmf63GaFyd3NbPOEevjez7euJd8LnPkBD+9QVQeLaFCjbb
         jJSMFqq/PUOHpr+AvTdcUJDrOzDac5tVTJFxauTjAx/GKeh5+RBvNePwPpFzf1QAtqzA
         uHMaz0KZ4w4eY0gCuOtri24ZrGI7VyoLT4SzDx/b6i0iOMZgmmKiEkZPlyMjwG8SdE26
         4IQ8jKJpf8fBj0Le3nNjDkttcQB9z00hvqko6vxLZ6fJhsDQSfwjcqVl7/qRUNd2BOA5
         AFdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s1imFveo5pSvSVBui0etS47YYyKWam8zfgbleGHkHh8=;
        fh=Py+jex/1fGlRsMZufnH1KOKedOTru/Kk8c+a6YEFf78=;
        b=iZVRY54G5dff4edxwU89A90KjHnoj0plluDn4V1VAtbVXgTNUzwFkOwPO1mXpgLWPj
         gpmBCHKGF4V4cXNcEl8N8LgrZaGItPnKyqKSnduuqiXu2X0aKi2wH0tlal4J521RtklU
         obImUWYWlMGYgB229Q+eelGchZfiUMSEITkDPvrZm/noW/uKuNkQzfrtQjJDaKDbFL+I
         bmo4eCAErBIBKKf6NuW/ZbV3CErF0+nX1gzO02WICcNsJ9rdkCzbIF5A/rNtgO1gy+2+
         MNGu/hvHDE5shQ/RHhfTIoivz+Onzb3hKTnt0hMKVBpBcctkHETVzZiA4/jVAjw20Y6z
         PujA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771947635; x=1772552435; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s1imFveo5pSvSVBui0etS47YYyKWam8zfgbleGHkHh8=;
        b=qYtwN44pAzzsRjFi4t7xLa0ihOwQ8nhRGHkL8576eBlADkU6wyLDBoOUpnRgQgcPEb
         PqnK7OgqBlt9NniKN6IZ3MdxpswrU4NMGgc6deoAezK5eOgmcYeiZQoyB6JwIg87cy2+
         ph7FB2Mr94J4WJin09SwjDWdlWPks611GwxrtsPXm2lE9Tkf73WjFIdtSx5OxNap6is3
         oUowm56NJPIYC74UYWwTGi4diPjOq5h1ExMjnzWDB+csjA6s4ExuWgN0KHXL4vxYEynt
         uOGVzM69ZdwzUNDEyerZYFFzr4+SEFBvZKm/Irq+MOC49sx2LooDjDVOBtSfTQInDVLF
         nSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771947635; x=1772552435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s1imFveo5pSvSVBui0etS47YYyKWam8zfgbleGHkHh8=;
        b=DcyVrblvPMujU9uIXSbj5WMVnmf/pfQUkxcaxWTUD3PjZ/a8hRxltFkTky3Zu92tE7
         SkZe0oshzQ9pWsJZ9nr/yq9WqulC8elVQ0OJ6BfCrq6LjQk+jAM+THJvjhuRYfIlv05U
         XnbJOwcZxHLl+52y94UMAJB0iV6jXD6qEgxrL2c2EbaDvBRlDa51Bb0+2jotOzlSEC+8
         nJ+I1sEBQlTzbfp3Vz/+9TW/Ptx5OKtsx/VPGVOihdW7CnzI17km5JP7W7ciRAma13xD
         IvLfanAR0ZPDvo+//HqxpTcM5lHElnEajqILyVwGepIaKsZ59yBRUQAJ4txj385zINFQ
         S88A==
X-Forwarded-Encrypted: i=1; AJvYcCWHOGeBgtnjcI+gflcF6vZguCwvoGuT8G8nxroIA9w/BuObTiciHqF1KL17bxt4gFv2DOSd6aQ7SokOfkAGQQ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwLXICV7xKiBi7HLboOABnOUy3iNY0X35vDTWxr41O7e/x0ek8
	Ye14ja4llbnl2NjtoyiiVT+JCvJqntWhyYZSHthqbziYZVCHINVR0xGJE+obWWQfUMR7lxQXKkU
	ddrIy648geAkqd/OP2U1UUcTpUY8x7AHqgPlOf83K
X-Gm-Gg: AZuq6aKb2Hueuf3x5ZmUGqTlA1crJ+BAQPtdVK9f6TqjrFj7+L2myz4jF+XE2awrONT
	afMmEkcaxZuabh1HmTZ8tDGMpSANlKyYcrI7w01ee9YGwss4t7XOYj5/rtZLlL6SLeatIQcxgFg
	IzFfFw6pgYDUuczSvyg9V0AGT+Vht8GPMWcNdn+F0wNWq3ywvE0IE73XqfwpWjB6m79OJTWI7yy
	N0eO3f9jQKzyC5j7rkbslsDETN/3hIvr2uPcMI/rcVnxhLmE7Nm5ofSVvcsybwC4JqlbRM7i555
	SFDow6bLEhrrejxVl/j5RZTSOvFSwkEGDRRCb0eHbw==
X-Received: by 2002:a05:622a:155:b0:501:466b:513f with SMTP id
 d75a77b69052e-5070bb81aecmr170572891cf.15.1771947634673; Tue, 24 Feb 2026
 07:40:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224122856.3152608-1-edumazet@google.com> <aZ2fA2x5nHsnQoBu@strlen.de>
In-Reply-To: <aZ2fA2x5nHsnQoBu@strlen.de>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 24 Feb 2026 16:40:21 +0100
X-Gm-Features: AaiRm533J9ZDgyKQm7SRyYWq-5zpwgDCD5gGsi5iohdc-GX4zvKgIhR8q5fnwgE
Message-ID: <CANn89iLP2xFerYywu=x8bnox_+vjrDVUxkEf-nUEJM0VmNfVdA@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: xt_owner: no longer acquire
 sk_callback_lock in mt_owner()
To: Florian Westphal <fw@strlen.de>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 24, 2026 at 1:52=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Eric Dumazet <edumazet@google.com> wrote:
> > After commit 983512f3a87f ("net: Drop the lock in skb_may_tx_timestamp(=
)")
> > from Sebastian Andrzej Siewior, apply the same logic in mt_owner()
> > to avoid touching sk_callback_lock.
> > -     read_lock_bh(&sk->sk_callback_lock);
> > -     filp =3D sk->sk_socket ? sk->sk_socket->file : NULL;
> > +     /* The sk pointer remains valid as long as the skb is. The sk_soc=
ket and
> > +      * file pointer may become NULL if the socket is closed. Both str=
uctures
> > +      * (including file->cred) are RCU freed which means they can be a=
ccessed
> > +      * within a RCU read section.
> > +      */
> > +     rcu_read_lock();
> > +     sock =3D READ_ONCE(sk->sk_socket);
> > +     filp =3D sock ? READ_ONCE(sock->file) : NULL;
>
> Thanks for doing this Eric!
>
> Minor nit: rcu_read_lock is already acquired from nf_hook() helper, so
> we aleays have it in both iptables and nftables.
>
> Reviewed-by: Florian Westphal <fw@strlen.de>

Sure, I will remove the rcu_read_lock()/rcu_read_unlock()

Do you think adding lockdep_assert_in_rcu_read_lock() would be useful
or would it be too much, iptables/nftables willl always be run under RCU
and this is well understood ?

Thanks.
