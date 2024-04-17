Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E304D4685
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Apr 2024 10:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713349615; cv=none; b=la9fROVyhfLUlJASTz6un4LbNX1L3S651Q+3wNuIqP4NdR2fHpKp3rnHIbsRFoOCrL4y2LARXsvlE9sf8I38Uh0dF4oJR2vYku0g8qi7Jpee2S5Gw1YKbAY4SXvapndyjQVLAmDe1xH8Zoz6yj9xkY76Pn1lrZTZ+BprCnTKTQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713349615; c=relaxed/simple;
	bh=rN35f9Uq55hYfyGPSaoXp75dZp0AqdQRk44W7tOUmyc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=acFQfauZIcPgYsMO5FocGyxqA4FEQ+n9dWwxTgrz+AQE3ZqtlfbuJIov7Hsb+oqoYZzbOm/RB8V509r2Z6Km/5YORwrGkhYTnwdsLEwogwXn6JJgdBfQn6ACXNYFg+Pmn3cmPZ7zJT1N7zfw3zBfXYVNFprRxkIXeRt5kiNgBW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id A3C11CC0114;
	Wed, 17 Apr 2024 12:26:41 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Wed, 17 Apr 2024 12:26:39 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4E4E6CC00EA;
	Wed, 17 Apr 2024 12:26:39 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 47EA934316B; Wed, 17 Apr 2024 12:26:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 4592234316A;
	Wed, 17 Apr 2024 12:26:39 +0200 (CEST)
Date: Wed, 17 Apr 2024 12:26:39 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: keltargw <keltar.gw@gmail.com>
cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: Incorrect dependency handling with delayed ipset destroy ipset
 7.21
In-Reply-To: <CALFUNymuoZ=nZsiDoCcDdB21fFkpo3PBbHdwUKnOwd67ttxAig@mail.gmail.com>
Message-ID: <24710b7f-00ec-a7b2-7611-39118cace9a9@netfilter.org>
References: <CALFUNymhWkcy2p9hqt7eO4H4Hm5t70Y02=XodnpH1zgAZ0cVSw@mail.gmail.com> <007a92b1-db83-4e8b-d05f-0feabb6bd7c4@netfilter.org> <CALFUNyn4HSDGoK3t3yceU0NcOQSjrJctbti_Mogm5BTgqTeXHw@mail.gmail.com> <1bc47ada-d95f-dc9e-f2b4-b0ed5875b069@netfilter.org>
 <CALFUNymuoZ=nZsiDoCcDdB21fFkpo3PBbHdwUKnOwd67ttxAig@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 15 Apr 2024, keltargw wrote:

> Thank you. That seems to be working fine, but I'm not sure about how 
> readable it becomes, as destroy logic becomes splitted in two 
> inseparable parts.

Yes, that'd make reading the code harder but would be fast :-).

> How about adding list_set_flush() at the end of list_set_cancel_gc()
> instead, would that be too heavy? E.g.

Again yes and it'd result in a slower destroy operation for list type of 
sets. But the list type should be used very lightly (if at all in 
production) so I don't regard it as a performance critical area in ipset.

Your patch is fine for me. Please submit it in a form that can be applied 
in git with proper commit text part and such. Thanks!

Best regards,
Jozsef
 
> diff --git a/kernel/net/netfilter/ipset/ip_set_list_set.c
> b/kernel/net/netfilter/ipset/ip_set_list_set.c
> index cc2e5b9..1cdb68e 100644
> --- a/kernel/net/netfilter/ipset/ip_set_list_set.c
> +++ b/kernel/net/netfilter/ipset/ip_set_list_set.c
> @@ -552,6 +552,8 @@ list_set_cancel_gc(struct ip_set *set)
> 
>        if (SET_WITH_TIMEOUT(set))
>                timer_shutdown_sync(&map->gc);
> +
> +       list_set_flush(set);
> }
> 
> static const struct ip_set_type_variant set_variant = {
> 
> On Mon, 15 Apr 2024 at 14:28, Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> >
> > On Sun, 14 Apr 2024, keltargw wrote:
> >
> > > Thanks for the suggestion. I'm not that familiar with ipset source code,
> > > do you mean something like issuing a second rcu_barrier between call_rcu
> > > and returning result code back to netlink (and only doing that for list
> > > type)?
> > >
> > > As I understand it there isn't much that could be done in e.g.
> > > list_set_destroy as it might not be called yet, sitting in the rcu wait
> > > queue.
> >
> > No, I meant release the reference counter of the element sets immediately
> > when destroying a list type of set. Something like moving just the
> > ip_set_put_byindex() call
> >
> >         list_for_each_entry_safe(e, n, &map->members, list) {
> >                 ...
> >                 ip_set_put_byindex(map->net, e->id);
> >                 ...
> >         }
> >
> > from list_set_destroy() into list_set_cancel_gc(). That way the member
> > sets can be destroyed without waiting for anything.
> >
> > Best regards,
> > Jozsef
> >
> > > On Sat, 13 Apr 2024 at 19:02, Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > > >
> > > > On Sat, 13 Apr 2024, keltargw wrote:
> > > >
> > > > > I have a problem with recent kernels. Due to delayed ipset destroy I'm
> > > > > unable to destroy ipset that was recently in use by another (destroyed)
> > > > > ipset. It is demonstrated by this example:
> > > > >
> > > > > #!/bin/bash
> > > > > set -x
> > > > >
> > > > > ipset create qwe1 list:set
> > > > > ipset create asd1 hash:net
> > > > > ipset add qwe1 asd1
> > > > > ipset add asd1 1.1.1.1
> > > > >
> > > > > ipset destroy qwe1
> > > > > ipset list asd1 -t
> > > > > ipset destroy asd1
> > > > >
> > > > > Second ipset destroy reports an error "ipset v7.21: Set cannot be
> > > > > destroyed: it is in use by a kernel component".
> > > > > If this command is repeated after a short delay, it deletes ipset
> > > > > without any problems.
> > > > >
> > > > > It seems it could be fixed with that kernel module patch:
> > > > >
> > > > > Index: linux-6.7.9/net/netfilter/ipset/ip_set_core.c
> > > > > ===================================================================
> > > > > --- linux-6.7.9.orig/net/netfilter/ipset/ip_set_core.c
> > > > > +++ linux-6.7.9/net/netfilter/ipset/ip_set_core.c
> > > > > @@ -1241,6 +1241,9 @@ static int ip_set_destroy(struct sk_buff
> > > > >   u32 flags = flag_exist(info->nlh);
> > > > >   u16 features = 0;
> > > > >
> > > > > + /* Wait for flush to ensure references are cleared */
> > > > > + rcu_barrier();
> > > > > +
> > > > >   read_lock_bh(&ip_set_ref_lock);
> > > > >   s = find_set_and_id(inst, nla_data(attr[IPSET_ATTR_SETNAME]),
> > > > >      &i);
> > > > >
> > > > > If you have any suggestions on how this problem should be approached
> > > > > please let me know.
> > > >
> > > > I'd better solve it in the list type itself: your patch unnecessarily
> > > > slows down all set destroy operations.
> > > >
> > > > Best regards,
> > > > Jozsef
> > > > --
> > > > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > > > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > > > Address : Wigner Research Centre for Physics
> > > >           H-1525 Budapest 114, POB. 49, Hungary
> > >
> >
> > --
> > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> > PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> > Address : Wigner Research Centre for Physics
> >           H-1525 Budapest 114, POB. 49, Hungary
> 

-- 
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
