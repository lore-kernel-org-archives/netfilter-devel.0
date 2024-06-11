Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB6317721
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Jun 2024 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718124324; cv=none; b=qrcKzn6iF+DV6SvMNM8vvVYBCgCtDq3hpab1VhkleG3knt4ReT/FOo7Y7tPOVZ6/fq8ynDPVDINwIzdQLR88dUq0U3UkLQJHC8AWpp3aWAZ0J2jFLBRGfAiJI4omXxN4g7rahnmuP7L9b7hDgtklrwDW3OCbFY9wBm6vIY0qHdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718124324; c=relaxed/simple;
	bh=Dndc2lS9iAFM8Oy5FsXudpGjuC+OrQCSnQPqy9SLL8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GERIszipj4qiAl3hj1eUGYuUXucMgSARv/SbUxOp9Ep+2A7dWs3jtZ/rz8dcgmnhkL5cvRUaJvZWBcJmQ9c5aBnQ6egN+ukvATCKB7/gSoHWgiA227L31bnz8IvpIO14i6tDsR36LJes21fRDOd/YJdxxPey2DQ5DDn9uXEGKDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=34488 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sH4cV-002WNe-EO; Tue, 11 Jun 2024 18:45:17 +0200
Date: Tue, 11 Jun 2024 18:45:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Lion Ackermann <nnamrec@gmail.com>
Subject: Re: [PATCH 1/1] netfilter: ipset: Fix race between namespace cleanup
 and gc in the list:set type
Message-ID: <Zmh_Gn0bSkeshGOo@calendula>
References: <20240604135803.2462674-1-kadlec@netfilter.org>
 <20240604135803.2462674-2-kadlec@netfilter.org>
 <ZmDlqGtGv_LdMj6k@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZmDlqGtGv_LdMj6k@calendula>
X-Spam-Score: -1.9 (-)

On Thu, Jun 06, 2024 at 12:24:40AM +0200, Pablo Neira Ayuso wrote:
> Hi Jozsef,
> 
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

Applied to nf.git, I am sorry for the delay, traveling last week.
