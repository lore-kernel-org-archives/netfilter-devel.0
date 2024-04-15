Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5FB823CE
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2024 17:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713201543; cv=none; b=DjUob7lLB0T4mgUAcaiKYjBcnb7VCxrMHrF/LxMdOudlg99N9rGM9cmqpQXCuBZbI8n2kH7+65jIM4P6jD/0a9eV3YFacSKd7dy0h1AT1iXOZeR6QOGaImcz02Gt0+sOoxx1/WLU6b+f7VQ4ekhlE33scB40d8DhrRKSsamDTuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713201543; c=relaxed/simple;
	bh=4qUFnaaF+82J6RMN1hDHoacOFu2m7adEbD0z30FKGDM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XCoJf4w229T9GjmQClbSE33ZsReN3vORwxAsyM1walYHAojOBFYyqS4oLDGfxnj/11iE3l2706poZE80rMPGOQtAuLvKsrQar2jCghCP5SCfcUMYWHiI/m9OnHlNaYecBrOnQ1uzs3tcgbV2dBh69Q9nOwuTC1KLLFNArobuTxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h5P/PZ8p; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h5P/PZ8p"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5c6bd3100fcso2046768a12.3
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2024 10:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713201541; x=1713806341; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pEAujIi9kf7GPO1hsu6c2PZsidDnghBUxDyDCtgWZsY=;
        b=h5P/PZ8pR6bvO5n9VCkvLmLyX2tj1wa0iWOdVi/vki65Uf9uN7HpgbimcGKNZK5Wm0
         OhqHyvxZ+3fts7GIBf2bRWs5NIuc0WasKFeSiHPEkN4XJmtn7OJzPY0KGFoQcfhDGULE
         4RvLt2smHB8GdCUyz/rwupp8n0dpbXP8dKWPFa3CYmyDsfKBMqxr+aQJqwMW3S40CsVP
         Cmb3o3Vy1FF+7ZncUe04Ro+bRKFBySpPVVQQEA98/rGlwCvrY7mzUwWD2MU1QlLwaeOJ
         YzStn4jW9JobyuRF7nJ346jRn98G7a4+Ayl8YrQvURz3sIjVaIarF00YOXPvC9OlnFUT
         rTTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713201541; x=1713806341;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pEAujIi9kf7GPO1hsu6c2PZsidDnghBUxDyDCtgWZsY=;
        b=siPzG7KawcZDdoKwcsETjn4S6f8s4WZfgKfSoRl6BodbK6CeCis2D+WV9xJIEMt2sW
         D5xvpVMFe+O0WbBcIH7oAdX2ONwcjLelszD/FEl6gzxC/ygNV2Z0+/j3S5E9O3vfp+jc
         9NTuoPM3eZOEuInOmAjEz4ztusa8KujIDy5tSkNGCOC1A3olEjawi3M1kQK2zDK5N3vh
         OHYi05s0b5cH2pvK/hhjHbUdRidSqchPTvQiVfW702fJa8tYKUYE5hQ7l5BrGziTrUrC
         B9GVW8Rqyat8Ne7ExHFmELZsdvDhN2/p81Ms4sXYrJd9mOqN0ndzufCj3b8JLwTsmkLo
         3E9A==
X-Gm-Message-State: AOJu0YzaDe2rgPzJTAkj1yc2sRNt/b0bTU/QGNhgSzid7tONHtDbo0y7
	LBCv/MXu3/P4sWx55hX93E+QLX4k2Peh0Rhws1f8PR5b9nxisBqmm/vEfDuPv7S/U1AP/whRWYH
	OrcAFequwFapnBP04FVLF9d8MoMccVvuvZythZw==
X-Google-Smtp-Source: AGHT+IEFwOVyPchwy0gbmcY27drdY0OY3X8H/meC0+sYAZVYCdPpEjMH8oK8Z8KX9i+ab8tw5lyyrVpr8UFdjTdmECM=
X-Received: by 2002:a05:6a20:4e29:b0:1a3:a8da:918b with SMTP id
 gk41-20020a056a204e2900b001a3a8da918bmr7808135pzb.47.1713201541068; Mon, 15
 Apr 2024 10:19:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALFUNymhWkcy2p9hqt7eO4H4Hm5t70Y02=XodnpH1zgAZ0cVSw@mail.gmail.com>
 <007a92b1-db83-4e8b-d05f-0feabb6bd7c4@netfilter.org> <CALFUNyn4HSDGoK3t3yceU0NcOQSjrJctbti_Mogm5BTgqTeXHw@mail.gmail.com>
 <1bc47ada-d95f-dc9e-f2b4-b0ed5875b069@netfilter.org>
In-Reply-To: <1bc47ada-d95f-dc9e-f2b4-b0ed5875b069@netfilter.org>
From: keltargw <keltar.gw@gmail.com>
Date: Mon, 15 Apr 2024 22:18:49 +0500
Message-ID: <CALFUNymuoZ=nZsiDoCcDdB21fFkpo3PBbHdwUKnOwd67ttxAig@mail.gmail.com>
Subject: Re: Incorrect dependency handling with delayed ipset destroy ipset 7.21
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

Thank you. That seems to be working fine, but I'm not sure about how
readable it becomes, as destroy logic becomes splitted in two
inseparable parts.
How about adding list_set_flush() at the end of list_set_cancel_gc()
instead, would that be too heavy? E.g.

diff --git a/kernel/net/netfilter/ipset/ip_set_list_set.c
b/kernel/net/netfilter/ipset/ip_set_list_set.c
index cc2e5b9..1cdb68e 100644
--- a/kernel/net/netfilter/ipset/ip_set_list_set.c
+++ b/kernel/net/netfilter/ipset/ip_set_list_set.c
@@ -552,6 +552,8 @@ list_set_cancel_gc(struct ip_set *set)

       if (SET_WITH_TIMEOUT(set))
               timer_shutdown_sync(&map->gc);
+
+       list_set_flush(set);
}

static const struct ip_set_type_variant set_variant = {

On Mon, 15 Apr 2024 at 14:28, Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
>
> On Sun, 14 Apr 2024, keltargw wrote:
>
> > Thanks for the suggestion. I'm not that familiar with ipset source code,
> > do you mean something like issuing a second rcu_barrier between call_rcu
> > and returning result code back to netlink (and only doing that for list
> > type)?
> >
> > As I understand it there isn't much that could be done in e.g.
> > list_set_destroy as it might not be called yet, sitting in the rcu wait
> > queue.
>
> No, I meant release the reference counter of the element sets immediately
> when destroying a list type of set. Something like moving just the
> ip_set_put_byindex() call
>
>         list_for_each_entry_safe(e, n, &map->members, list) {
>                 ...
>                 ip_set_put_byindex(map->net, e->id);
>                 ...
>         }
>
> from list_set_destroy() into list_set_cancel_gc(). That way the member
> sets can be destroyed without waiting for anything.
>
> Best regards,
> Jozsef
>
> > On Sat, 13 Apr 2024 at 19:02, Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > >
> > > On Sat, 13 Apr 2024, keltargw wrote:
> > >
> > > > I have a problem with recent kernels. Due to delayed ipset destroy I'm
> > > > unable to destroy ipset that was recently in use by another (destroyed)
> > > > ipset. It is demonstrated by this example:
> > > >
> > > > #!/bin/bash
> > > > set -x
> > > >
> > > > ipset create qwe1 list:set
> > > > ipset create asd1 hash:net
> > > > ipset add qwe1 asd1
> > > > ipset add asd1 1.1.1.1
> > > >
> > > > ipset destroy qwe1
> > > > ipset list asd1 -t
> > > > ipset destroy asd1
> > > >
> > > > Second ipset destroy reports an error "ipset v7.21: Set cannot be
> > > > destroyed: it is in use by a kernel component".
> > > > If this command is repeated after a short delay, it deletes ipset
> > > > without any problems.
> > > >
> > > > It seems it could be fixed with that kernel module patch:
> > > >
> > > > Index: linux-6.7.9/net/netfilter/ipset/ip_set_core.c
> > > > ===================================================================
> > > > --- linux-6.7.9.orig/net/netfilter/ipset/ip_set_core.c
> > > > +++ linux-6.7.9/net/netfilter/ipset/ip_set_core.c
> > > > @@ -1241,6 +1241,9 @@ static int ip_set_destroy(struct sk_buff
> > > >   u32 flags = flag_exist(info->nlh);
> > > >   u16 features = 0;
> > > >
> > > > + /* Wait for flush to ensure references are cleared */
> > > > + rcu_barrier();
> > > > +
> > > >   read_lock_bh(&ip_set_ref_lock);
> > > >   s = find_set_and_id(inst, nla_data(attr[IPSET_ATTR_SETNAME]),
> > > >      &i);
> > > >
> > > > If you have any suggestions on how this problem should be approached
> > > > please let me know.
> > >
> > > I'd better solve it in the list type itself: your patch unnecessarily
> > > slows down all set destroy operations.
> > >
> > > Best regards,
> > > Jozsef
> > > --
> > > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > > Address : Wigner Research Centre for Physics
> > >           H-1525 Budapest 114, POB. 49, Hungary
> >
>
> --
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary
