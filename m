Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF9A3C488
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2024 09:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713173703; cv=none; b=rLI7Z1QbRHDxBSvCCWe1PSPvKKqPFBTswVh4L/+0WNl2yfeDZMKa+DpCJ1G0aQ99zl3iH6Pj22ckyBv4QoDwQ6qOl72BIFCawa/WgTwy67gzKAGPDTrTmpWV/2LjciJhiuiXNrYGIqjzvkPlgKLFH47SJ0QEo5HZaAOR1UU0oFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713173703; c=relaxed/simple;
	bh=fMPninoTFZKzcCR9Q3TnlRqpq7kFSGI7/6/csqxB3HM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Huu/Ddm4ptktpMxqlJDdx2K6a8hNQklZp062IbPhWNLtFNNo0jJKRypaKzspEnyZygAtMh99R02XLbh0OezNJP7Ck8oWAZNO819yUcCqdvRNRdcMyBP6A7ueuq9ytArd7/jewPDx89xI+IfNtGChPo28X3STRYodf9NRhV0F4T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 87077CC02C3;
	Mon, 15 Apr 2024 11:28:44 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Mon, 15 Apr 2024 11:28:42 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4C57ECC02B7;
	Mon, 15 Apr 2024 11:28:42 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 44F7E34316B; Mon, 15 Apr 2024 11:28:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 41ECC34316A;
	Mon, 15 Apr 2024 11:28:42 +0200 (CEST)
Date: Mon, 15 Apr 2024 11:28:42 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: keltargw <keltar.gw@gmail.com>
cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: Incorrect dependency handling with delayed ipset destroy ipset
 7.21
In-Reply-To: <CALFUNyn4HSDGoK3t3yceU0NcOQSjrJctbti_Mogm5BTgqTeXHw@mail.gmail.com>
Message-ID: <1bc47ada-d95f-dc9e-f2b4-b0ed5875b069@netfilter.org>
References: <CALFUNymhWkcy2p9hqt7eO4H4Hm5t70Y02=XodnpH1zgAZ0cVSw@mail.gmail.com> <007a92b1-db83-4e8b-d05f-0feabb6bd7c4@netfilter.org> <CALFUNyn4HSDGoK3t3yceU0NcOQSjrJctbti_Mogm5BTgqTeXHw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sun, 14 Apr 2024, keltargw wrote:

> Thanks for the suggestion. I'm not that familiar with ipset source code, 
> do you mean something like issuing a second rcu_barrier between call_rcu 
> and returning result code back to netlink (and only doing that for list 
> type)?
> 
> As I understand it there isn't much that could be done in e.g. 
> list_set_destroy as it might not be called yet, sitting in the rcu wait 
> queue.

No, I meant release the reference counter of the element sets immediately 
when destroying a list type of set. Something like moving just the 
ip_set_put_byindex() call

        list_for_each_entry_safe(e, n, &map->members, list) {
		...
		ip_set_put_byindex(map->net, e->id);
		...
	}

from list_set_destroy() into list_set_cancel_gc(). That way the member 
sets can be destroyed without waiting for anything.

Best regards,
Jozsef 

> On Sat, 13 Apr 2024 at 19:02, Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> >
> > On Sat, 13 Apr 2024, keltargw wrote:
> >
> > > I have a problem with recent kernels. Due to delayed ipset destroy I'm
> > > unable to destroy ipset that was recently in use by another (destroyed)
> > > ipset. It is demonstrated by this example:
> > >
> > > #!/bin/bash
> > > set -x
> > >
> > > ipset create qwe1 list:set
> > > ipset create asd1 hash:net
> > > ipset add qwe1 asd1
> > > ipset add asd1 1.1.1.1
> > >
> > > ipset destroy qwe1
> > > ipset list asd1 -t
> > > ipset destroy asd1
> > >
> > > Second ipset destroy reports an error "ipset v7.21: Set cannot be
> > > destroyed: it is in use by a kernel component".
> > > If this command is repeated after a short delay, it deletes ipset
> > > without any problems.
> > >
> > > It seems it could be fixed with that kernel module patch:
> > >
> > > Index: linux-6.7.9/net/netfilter/ipset/ip_set_core.c
> > > ===================================================================
> > > --- linux-6.7.9.orig/net/netfilter/ipset/ip_set_core.c
> > > +++ linux-6.7.9/net/netfilter/ipset/ip_set_core.c
> > > @@ -1241,6 +1241,9 @@ static int ip_set_destroy(struct sk_buff
> > >   u32 flags = flag_exist(info->nlh);
> > >   u16 features = 0;
> > >
> > > + /* Wait for flush to ensure references are cleared */
> > > + rcu_barrier();
> > > +
> > >   read_lock_bh(&ip_set_ref_lock);
> > >   s = find_set_and_id(inst, nla_data(attr[IPSET_ATTR_SETNAME]),
> > >      &i);
> > >
> > > If you have any suggestions on how this problem should be approached
> > > please let me know.
> >
> > I'd better solve it in the list type itself: your patch unnecessarily
> > slows down all set destroy operations.
> >
> > Best regards,
> > Jozsef
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
