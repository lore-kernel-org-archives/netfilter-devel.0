Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534191B373A
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2024 18:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718909397; cv=none; b=WrTieAXUtDIyH/7QJSR5gdPdcn7isOIzaecIooqC7Q0m1L1fJMhr8q7UWFh4HepgvIJmNTai6IRP6FLliRErczrtkDT/MF+YmsVW47Cziqs2T1g+ng6GcaTHWaZm/FQtBsOhTbV1rimzwfG7W/pOzXF98XIokbdFNk7CoqXJMGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718909397; c=relaxed/simple;
	bh=EEOS7EIr0oF/SCh1xJIN2qBgUM7JVYx1GF+XZyGF3ns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hDi0Vs3zKeHmx4JbBiJapQvd70tJwy5i7IBm/5W+d/IQ+3wZRcstbWX8hdMbRrAlETOS7rqkajnymHwsw3YfauoXF4RqawcymmCJydxgf2GJEmZogA6oQ3trgpmxx8u64oEx88x1vJzSlPQ6KxOkX0baJEGOGswYTKF24mweaZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=YioOWn6U; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YioOWn6U"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52bc29c79fdso1393844e87.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2024 11:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1718909393; x=1719514193; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hL9JXgjXmozV00hpz2FPwQ9DP76wRXOzayxL+7uvpKU=;
        b=YioOWn6U9nZ4TX76Ae0wXINNtDpQ1+IHHfpFozSwsfOL8ziC7H+GjS5CnTae7BjWBG
         bBwhUk26MROwxg4eoLZrme09bce9Q8EsWbw6Q6alZBaYiODStCzQYLWJqsGuwnnvokBW
         skeMaPRQ3UAUNnm+jqorQQS+S4251DwqgqveY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718909393; x=1719514193;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hL9JXgjXmozV00hpz2FPwQ9DP76wRXOzayxL+7uvpKU=;
        b=ALzgrc+ubKdkWsfP9vrlmIuqhn5pA4H0cMPyculAEmkVM3RQIilFiyEfudOjtNoL8f
         juKF6dGuO+TUXZuJ3jEIvpTFCdB6hm8T7pfwlG+9F4u/ala4C6S3QxCKNorkz9PqjAHB
         TTw3N7ITI4VK+EvGMXmoa/OTNX1D6W8zzEBOBFb1gSRkKdQOL1WuipdEp5oOfVA/BEAd
         ynaVuMDzeL6dspN/T5OFBLKj85+KmZV0Dx2YwM1ZJPQ7MQ58rnjqXNIvnn2OGsTbYOTl
         svQsYghtdj6NVQ0plViPZpe8WmL+bbGl/ZPCo7b2Ipv6rR1wUvUq/V0spnDNd59I4Fu9
         j2hA==
X-Forwarded-Encrypted: i=1; AJvYcCUKBJztcLmv0XRc0x+QhDV3Kv3XOv8/tV7gkdQBeHiMbZeeUxvfh8NobBGnhXH6wLP7bUWy4YyDsz9/+WeImK8tmAWEyEtObGJpWjEHebia
X-Gm-Message-State: AOJu0YyhBk10CwkFxJF3J4vZ/pfIHa9xNXj8VTR27on3/DPwIsxBb5Ku
	pTjEoYmRaj5LCSIqmGew1FG5PPCvnbh/TKfw9mLLINTdKGdpoaBJJC91jAA82gbk0pIyhMih4ox
	SpXFw1VRdY9TpW898Ai2PEu4kfgkdJS7wSypZ
X-Google-Smtp-Source: AGHT+IGD8CE0uw6+jpXardgoPtrej/5EyEUGjkTiM+TfGEeQBlJlNeDXxliD+R62iK29WVQ9yA6w9M3LXS5jtNT5xcw=
X-Received: by 2002:a05:6512:124a:b0:52c:ab21:7c05 with SMTP id
 2adb3069b0e04-52ccaa599b7mr5856580e87.67.1718909393574; Thu, 20 Jun 2024
 11:49:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240607230146.47222-1-kuntal.nayak@broadcom.com> <ZmmffoZAlP2wRQJL@calendula>
In-Reply-To: <ZmmffoZAlP2wRQJL@calendula>
From: Kuntal Nayak <kuntal.nayak@broadcom.com>
Date: Thu, 20 Jun 2024 11:49:41 -0700
Message-ID: <CAA4K+2b6fAH2jKrxJGV8xHFupS6OkaJAFCtnZqjLvYXHNFA-Xw@mail.gmail.com>
Subject: Re: [PATCH v6.1] netfilter: nf_tables: use timestamp to check for set
 element timeout
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org, 
	ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com, 
	vasavi.sirnapalli@broadcom.com, kadlec@netfilter.org, fw@strlen.de, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

Thank you for the update and reviewing the patch. We will wait for
your patch to be applied to the LTS and then consume the latest 6.1
kernel.

------



Best regards,

Kuntal

On Wed, Jun 12, 2024 at 6:15=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> Hi,
>
> Thanks for your patch.
>
> rbtree GC chunk is not correct though. In 6.1, GC runs via workqueue,
> so the cached timestamp cannot be used in such case.
>
> Another possibility is to pull in the patch dependency to run GC
> synchronously.
>
> I am preparing a batch of updates for -stable, let me pick up on your
> patch.
>
> Thanks.
>
> On Fri, Jun 07, 2024 at 04:01:46PM -0700, Kuntal Nayak wrote:
> > diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbt=
ree.c
> > index 5bf5572e9..c4c92192c 100644
> > --- a/net/netfilter/nft_set_rbtree.c
> > +++ b/net/netfilter/nft_set_rbtree.c
> [...]
> > @@ -622,12 +624,14 @@ static void nft_rbtree_gc(struct work_struct *wor=
k)
> >       struct nft_set *set;
> >       unsigned int gc_seq;
> >       struct net *net;
> > +     u64 tstamp;
> >
> >       priv =3D container_of(work, struct nft_rbtree, gc_work.work);
> >       set  =3D nft_set_container_of(priv);
> >       net  =3D read_pnet(&set->net);
> >       nft_net =3D nft_pernet(net);
> >       gc_seq  =3D READ_ONCE(nft_net->gc_seq);
> > +     tstamp =3D nft_net_tstamp(net);
> >
> >       if (nft_set_gc_is_pending(set))
> >               goto done;
> > @@ -659,7 +663,7 @@ static void nft_rbtree_gc(struct work_struct *work)
> >                       rbe_end =3D rbe;
> >                       continue;
> >               }
> > -             if (!nft_set_elem_expired(&rbe->ext))
> > +             if (!__nft_set_elem_expired(&rbe->ext, tstamp))
> >                       continue;
> >
> >               nft_set_elem_dead(&rbe->ext);
> > --
> > 2.39.3
> >
