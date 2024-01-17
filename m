Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEEE224C1
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2024 16:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705508949; cv=none; b=idiozp9KgV9+5+ODkKVd83IQ56pEIzrglYx56aC4Lym//n1Wj/UFECkB4NVyEXYcjy0yWPkuqRPdrhm4Q0NXvypdd+EqPk/uOgkL7v0pfwVwWy7IqTDEftp9VzFtJgNT+FXuC8Cz9ni5DXJ+z/4EA3xnyQI/CB2rQOb5sZAtX/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705508949; c=relaxed/simple;
	bh=b07Jp3UHXSYA14cQsXEAajOG7C6xS0I5AL/BU1uuAHw=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding; b=i/C1AdlDR143l9M9bWpaVqnrmEjE8QsSoNbrEF/Qg4Dv55QnDTcTgBnNcYnA8EOGCDOyH6xthi9MqDttFVljWuXK65QUTkutRHm4V6KVb2O9wY2bBu5VD9KwnHyCm48A0haXx+LHs9it1GTsUUqxb8CoiSH89ZpbAzK8eWvUOgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V0onXuhv; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V0onXuhv"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-50eaf2f00d1so2959e87.1
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2024 08:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705508946; x=1706113746; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ayzMxEKWODrb0jPlytcX75yGqSqm7F855h2iNMiZuno=;
        b=V0onXuhvGa6bI53OoV05p7pSgqDOyd122jNIxdeg8kxS4yQ6kkLURZxAc+AaFfOalV
         oPL4FMqiwED5nA433SHNG/sn78FJThwZy35D1yJyd0zCMbX8g9P3X3JgHV47xNlk5glc
         tQBH3uZNxiN7c/JLA4n5Eyy4BO1iHBhf8HnkrhFyevLiitoxwsRtUpZk47b+8tH/YEl/
         ppo1PJJNDfcWwE5jeuTemZ/IZtF2n9ti3mnsdj2p8l3tk1ZPLmt43KkNNbOIwkuVBgiQ
         EUnMKPUGKW7en9pHFy3zEZ2KfjpL6L8U3Kvi+goEoz7rWfjpUIh7CPFr5GlJGL6myI24
         Trog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705508946; x=1706113746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ayzMxEKWODrb0jPlytcX75yGqSqm7F855h2iNMiZuno=;
        b=ACdSpFHqnbqHwaWboDy+YBjCjU8TI6RvIL10CasRbCt+MyN/ufItLBRTOxXPfqZzcG
         ZvXP9fxugVYMv+MWkAIJhDMuJ0POgpImM4bxnlaWGfgeDw/17ePjFw8FflGWQ4zIdN8V
         muJBp4TwclY3ILpUSmtA7OH7TOzyRRUE/NgpwD/4VBJWXbNOwlGe1uT/o6UeDq3yGcPK
         gXc3FhyzAlV3HUOsBuxRZ++VgZphSr8rA0E37BwuhIRF2pdVd+NaA1Y1XEwT57hjl8oN
         D1feOyBk3MQ1mqp62W8mAs1tHvaR9BMnVLGS8NJ1UTJQIHOezsgU3nRPJ8hxcRg5IEI3
         JuKg==
X-Gm-Message-State: AOJu0YxBXLoDj1970NNcsdoDU+Ls5WrDRUsyQ6kJO33EbE9IULIbsKYM
	/27156Goy1hfPOeIHLCesMBfZIzA7blcaY+I9B6mjr0hwDaUOFYQhH+LLbtpJdKqBpHJ+BQMq7r
	f6fe0HI/HmEpT4rh5DM8FGJImIzlmcDIT/iDX
X-Google-Smtp-Source: AGHT+IH2SdaT3Qdcf+JM5rk8Wvy8xai7iQYR0tcoznElpDeAFxn63i0fLT69MgXZA3envFVHYw0M7Sw4RT0JZM/GLQ0=
X-Received: by 2002:a05:6512:281f:b0:50e:6186:3c23 with SMTP id
 cf31-20020a056512281f00b0050e61863c23mr91658lfb.7.1705508945668; Wed, 17 Jan
 2024 08:29:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240117160030.140264-1-pablo@netfilter.org> <20240117160030.140264-15-pablo@netfilter.org>
 <CANn89i+jS11sC6cXXFA+_ZVr9Oy6Hn1e3_5P_d4kSR2fWtisBA@mail.gmail.com> <54f00e7c-8628-1705-8600-e9ad3a0dc677@netfilter.org>
In-Reply-To: <54f00e7c-8628-1705-8600-e9ad3a0dc677@netfilter.org>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 17 Jan 2024 17:28:54 +0100
Message-ID: <CANn89iK_oa5CzeJVbiNSmPYZ6K+4_2m9nLqtSdwNAc9BtcZNew@mail.gmail.com>
Subject: Re: [PATCH net 14/14] netfilter: ipset: fix performance regression in
 swap operation
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org, 
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org, 
	pabeni@redhat.com, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024 at 5:23=E2=80=AFPM Jozsef Kadlecsik <kadlec@netfilter.=
org> wrote:
>
> Hi,
>
> On Wed, 17 Jan 2024, Eric Dumazet wrote:
>
> > On Wed, Jan 17, 2024 at 5:00=E2=80=AFPM Pablo Neira Ayuso <pablo@netfil=
ter.org> wrote:
> > >
> > > From: Jozsef Kadlecsik <kadlec@netfilter.org>
> > >
> > > The patch "netfilter: ipset: fix race condition between swap/destroy
> > > and kernel side add/del/test", commit 28628fa9 fixes a race condition=
.
> > > But the synchronize_rcu() added to the swap function unnecessarily sl=
ows
> > > it down: it can safely be moved to destroy and use call_rcu() instead=
.
> > > Thus we can get back the same performance and preventing the race con=
dition
> > > at the same time.
> >
> > ...
> >
> > >
> > > @@ -2357,6 +2369,9 @@ ip_set_net_exit(struct net *net)
> > >
> > >         inst->is_deleted =3D true; /* flag for ip_set_nfnl_put */
> > >
> > > +       /* Wait for call_rcu() in destroy */
> > > +       rcu_barrier();
> > > +
> > >         nfnl_lock(NFNL_SUBSYS_IPSET);
> > >         for (i =3D 0; i < inst->ip_set_max; i++) {
> > >                 set =3D ip_set(inst, i);
> > > --
> > > 2.30.2
> > >
> >
> > If I am reading this right, time for netns dismantles will increase,
> > even for netns not using ipset
> >
> > If there is no other option, please convert "struct pernet_operations
> > ip_set_net_ops".exit to an exit_batch() handler,
> > to at least have a factorized  rcu_barrier();
>
> You are right, the call to rcu_barrier() can safely be moved to
> ip_set_fini(). I'm going to prepare a new version of the patch.
>
> Thanks for catching it.

I do not want to hold the series, your fix can be built as another
patch on top of this one.

Thanks.
