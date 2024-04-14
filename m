Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB95199B0
	for <netfilter-devel@vger.kernel.org>; Sun, 14 Apr 2024 05:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713071793; cv=none; b=Iy1MHa8kVSelc6b+An9zccpldOdfqPUR5YI1MQt0P4CVzt9CTr8qBYd2l7KKuxyAE0fanGknviGKg92/POtHVIpOx6aEk9BfoOBjArDnjXfwclASf8VLXbky55AYJ6OifXl34U8F+RNEeKigoTDWSyefej3afBzu5ZmI/ZtPNbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713071793; c=relaxed/simple;
	bh=8cav29WrCq1jDBsULq+CCGM6fsBAvatrXnZ+wHDoDvw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KjYHMe4ewFzxoieEAGSfmoWhuvlUVKKbrkNvbomMrOmSFgvKc53EDcn7MEeotX5spVW7xrMnT3AEj4u4SKNeh3cTqsAXbTMo/PdfWPtO7YIN6ACpvhxWp2dHWVqBwMv6KFzQuy0NyNz1YAxFVfVOxqxen0F3GBiVRRIp6twUpfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jve5jbed; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jve5jbed"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6ed112c64beso1734468b3a.1
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2024 22:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713071791; x=1713676591; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nz/9VCoKFaxXik7F8i1h/dMrDItX7nl4484C1/XWjnk=;
        b=jve5jbed2RC3iCSbtkVs2HyDBWSVVD4IrRIG7tensifhgfOJXwIkWqP2mvTEe3Z5eT
         p+XAoCYp4EPolmazvRACkVWUoTN6broK7nYJZkihkf0C5dv/qDaTpzlmqRv6rt3xK272
         V9fE469WIPTIb5oRcAPOFQ70UqmqRJIOjFk2/kfkl+ELjbCTUrk5Kg0y7J65VqId2i73
         vT5Nwi2LjSH2xA4CL2xi1A5Lqknrfah3GMMkNYNlW6rW3MFROopgkM6IolXn4ESTHYGI
         wEYLdS6iTWRoWJhJ8Fvm9ZhWYVBAJ+W/HDJoqdKB7q3IdYIKCZtI0NLVkIIGsf2KMe37
         ol+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713071791; x=1713676591;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nz/9VCoKFaxXik7F8i1h/dMrDItX7nl4484C1/XWjnk=;
        b=uNdFrEIG3l7cDVgRS6lRHEGzr7XNoolHdhcE5EmjP9RYpIzpZDC2gXEEguIM06cz3V
         rDtBtVU5i5HJv6xBAy5fastZD+D1RXqNlPn1ojNvhew65gPPRmM8IR/BZz1hDbjmu7wZ
         SqDVoQU+paebuO97PbGYJhfzwxBb5HmHC8c2ohRbyR78uUdc984bQW515lC9BnxZW6zK
         kyibmCTGxlADobyLgPePPs+rvxK4aILCP8tVeMIihwQZ+3lzBj5HPbHnT9dRtEINxee3
         Day1Bt/NaUdgeiAZTrcZoeh2IX3Ufqbf8eysp13LjoaSf6F3gjXNmveDZkohElZUGFh0
         CFSQ==
X-Gm-Message-State: AOJu0YzfvKdkklrLKDywRdAbKQh6/OwI5z8IdBj3O8xPx4CeA12rKlIx
	mpEq2KtGpaBpVVTZGfzt7fALjE48Nyv9j4UwLe3b4Cwq/vR8x3gLtwrO3hmE6YTw3H7h7tUuW+K
	yhrKp17cbsa+YoFcR7/NkCI3N3Bfo6mUm/9EP7A==
X-Google-Smtp-Source: AGHT+IE9G4+mC5YUwZr9Kwumyjb5yvsO+OIC7uLdDj5dLPwH40LYfkztcM5QfMRfb99mu1IvBgkUHgp3F9c259J/YAg=
X-Received: by 2002:a17:90a:f309:b0:2a5:f85b:8b2c with SMTP id
 ca9-20020a17090af30900b002a5f85b8b2cmr5602528pjb.14.1713071791295; Sat, 13
 Apr 2024 22:16:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALFUNymhWkcy2p9hqt7eO4H4Hm5t70Y02=XodnpH1zgAZ0cVSw@mail.gmail.com>
 <007a92b1-db83-4e8b-d05f-0feabb6bd7c4@netfilter.org>
In-Reply-To: <007a92b1-db83-4e8b-d05f-0feabb6bd7c4@netfilter.org>
From: keltargw <keltar.gw@gmail.com>
Date: Sun, 14 Apr 2024 10:16:20 +0500
Message-ID: <CALFUNyn4HSDGoK3t3yceU0NcOQSjrJctbti_Mogm5BTgqTeXHw@mail.gmail.com>
Subject: Re: Incorrect dependency handling with delayed ipset destroy ipset 7.21
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

Thanks for the suggestion. I'm not that familiar with ipset source
code, do you mean something like issuing a second rcu_barrier between
call_rcu and returning result code back to netlink (and only doing
that for list type)?

As I understand it there isn't much that could be done in e.g.
list_set_destroy as it might not be called yet, sitting in the rcu
wait queue.


On Sat, 13 Apr 2024 at 19:02, Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
>
> On Sat, 13 Apr 2024, keltargw wrote:
>
> > I have a problem with recent kernels. Due to delayed ipset destroy I'm
> > unable to destroy ipset that was recently in use by another (destroyed)
> > ipset. It is demonstrated by this example:
> >
> > #!/bin/bash
> > set -x
> >
> > ipset create qwe1 list:set
> > ipset create asd1 hash:net
> > ipset add qwe1 asd1
> > ipset add asd1 1.1.1.1
> >
> > ipset destroy qwe1
> > ipset list asd1 -t
> > ipset destroy asd1
> >
> > Second ipset destroy reports an error "ipset v7.21: Set cannot be
> > destroyed: it is in use by a kernel component".
> > If this command is repeated after a short delay, it deletes ipset
> > without any problems.
> >
> > It seems it could be fixed with that kernel module patch:
> >
> > Index: linux-6.7.9/net/netfilter/ipset/ip_set_core.c
> > ===================================================================
> > --- linux-6.7.9.orig/net/netfilter/ipset/ip_set_core.c
> > +++ linux-6.7.9/net/netfilter/ipset/ip_set_core.c
> > @@ -1241,6 +1241,9 @@ static int ip_set_destroy(struct sk_buff
> >   u32 flags = flag_exist(info->nlh);
> >   u16 features = 0;
> >
> > + /* Wait for flush to ensure references are cleared */
> > + rcu_barrier();
> > +
> >   read_lock_bh(&ip_set_ref_lock);
> >   s = find_set_and_id(inst, nla_data(attr[IPSET_ATTR_SETNAME]),
> >      &i);
> >
> > If you have any suggestions on how this problem should be approached
> > please let me know.
>
> I'd better solve it in the list type itself: your patch unnecessarily
> slows down all set destroy operations.
>
> Best regards,
> Jozsef
> --
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary
