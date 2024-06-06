Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78A813AA32
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2024 06:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717656260; cv=none; b=AhmdjuCdIg8M/SbX//wxOjBy5sH2EiW1I9azutx94SPt0eJyMTHFf4q55dG53d0R/1qvnwSxhDGPLgMnP0nQ1dlYssQ86oTm7xto+A9JudULGV7n4HIK2z3IIIkNNO5LkgcgTw/OpNHebnk+V6wUvQz56rMoQkGt3AbAhsl5Lqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717656260; c=relaxed/simple;
	bh=SWmRMdy3u05kftU0o5c3t375R6Kk+A1vIHPcCHYK/XQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=EFa7qcYsV4EB8eDWgOxhePAlhp2FBSRZUQi//rlbpq58b1P37Kdvo6BIH639W1akd9PH4Wmz6xis1/pkgu+yX1XV4DMjSfK35xCPT6vQ4ph1qFEgBmLxIlkTMvxHkUpB2bCMnMcHYAkX8OOL9iVusqa+57k3sM53BIAO255SJVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 31FD2CC02BA;
	Thu,  6 Jun 2024 08:44:08 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Thu,  6 Jun 2024 08:44:06 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 05104CC02B5;
	Thu,  6 Jun 2024 08:44:06 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id F2A9A34316B; Thu,  6 Jun 2024 08:44:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id F144B34316A;
	Thu,  6 Jun 2024 08:44:05 +0200 (CEST)
Date: Thu, 6 Jun 2024 08:44:05 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: netfilter-devel@vger.kernel.org, Lion Ackermann <nnamrec@gmail.com>
Subject: Re: [PATCH 1/1] netfilter: ipset: Fix race between namespace cleanup
 and gc in the list:set type
In-Reply-To: <ZmDlqGtGv_LdMj6k@calendula>
Message-ID: <e35a8727-aea9-0f16-c344-74b301728482@netfilter.org>
References: <20240604135803.2462674-1-kadlec@netfilter.org> <20240604135803.2462674-2-kadlec@netfilter.org> <ZmDlqGtGv_LdMj6k@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Pablo,

On Thu, 6 Jun 2024, Pablo Neira Ayuso wrote:

> On Tue, Jun 04, 2024 at 03:58:03PM +0200, Jozsef Kadlecsik wrote:
> [...]
> > @@ -424,14 +428,8 @@ static void
> >  list_set_destroy(struct ip_set *set)
> >  {
> >  	struct list_set *map = set->data;
> > -	struct set_elem *e, *n;
> >  
> > -	list_for_each_entry_safe(e, n, &map->members, list) {
> > -		list_del(&e->list);
> > -		ip_set_put_byindex(map->net, e->id);
> > -		ip_set_ext_destroy(set, e);
> > -		kfree(e);
> > -	}
> > +	BUG_ON(!list_empty(&map->members));
> 
> It would probably be better to turn this is WARN_ON_ONCE, such as:
> 
>         WARN_ON_ONCE(!list_empty(&map->members);
> 
> BUG_ON is only allowed to be used in very particular cases these days.
> 
> I can update this patch if you are fine with it.

Yes, please update the patch. Thanks for noticing it!

Best regards,
Jozsef
-- 
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
