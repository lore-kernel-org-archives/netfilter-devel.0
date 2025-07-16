Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F74F17BA1
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 14:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752677120; cv=none; b=KQVVCefnQSn6/7p1FXR5PrefeaU7hEe+J+jzTmP+jxLKavmTk3O4Zs2J+Ge1XJmYrAWI0bGJDuz28b7jZ3UHWGxYAdzvt7rVYhMTcMcNp7KzeJCmoUDR/6AWZOB/bUoLvInmua+LIKAbi4/kL0Z6qSb5lzLcxK8zPflhNk+scg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752677120; c=relaxed/simple;
	bh=s3wEXnF45Cw7K723OGiPYFJADrsxx+DE7watXBVNCLg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=piu/8nGNVFglGuNzxQVzXkBwIOEJHaZX/YGMh1X+Edm/Fs6NewHtXoHIzq+68Ghv1bOLC31wdyr3jUqxGtAsTu3t8fKcJWZ2DX1X4ubIM0sPO9k+Uz1/ODlq76/o3MOEXyxWvNq0UCS+NvWqU9MeyfbilcixN6yax77/hfqOweQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ANBmMhTc; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FjuYqrWv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ANBmMhTc";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FjuYqrWv"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C2BB460275; Wed, 16 Jul 2025 16:45:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752677115;
	bh=7WlnHeG4bn3n/Y2t+cGo1dQYCxYExadU1aQsJDqjVpM=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=ANBmMhTcvf/OJCjj+fCheQPAw+JUGpaN4qXgtO1o754ZQ0lVZBz3YEZ+Xr4NSH2HP
	 34hVNBlSMYisjTs+SFQP6qtT4nFJopoGa+aKWG/fxsIOkiFKNBUSGQkOkWSxv3X+NF
	 ulSe3KUtCoB+3sdz5Lx0fCzWd7DrKvTDA4OKF2P0q8lBQDMj97vqbaksFGL7Z+EtuO
	 /Xqr6JDYAPOKhqd8p9xskCBch1UAG+pD/oX/DkqQSm3L3OWpmzV+D+VeAePWt9BoOX
	 QkTB3/r7haTV0KlCgp0dzyGjnxPpTQEw1FYHBFFxH3qqBil0SHAPMnuRjqZDNilvLS
	 vS5dqnOGxgafQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CBE206026E;
	Wed, 16 Jul 2025 16:45:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752677114;
	bh=7WlnHeG4bn3n/Y2t+cGo1dQYCxYExadU1aQsJDqjVpM=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=FjuYqrWv4zh9L7pVHNmcoKAFr3kuxSRmteDO1PG85op+vEMeuH8005vi2lxbge7fI
	 cejCFVw2Bu3Q9dN+tfiUq8+FKwGLZLJI6wbvkwnPJbrCiqz7jSbRkPmaYppdFSb2+j
	 LsweWOd1XX+bW3d9otEt/h/5/6RkNsiSj5qEDqHGWNmQFKGrZ1nlxT6lngW8C7TAYf
	 uMMVFaXMY9vCnr+KSwKpUfG80TFGND2yOUTwUb0FTLuqtuGyuMVpL02tk+8IiP+cSE
	 lEj63Htl63gdi27RGf6Cs4yIB/nNy0Gzlib9Lbw8W1AOKujDIM0SJgoXzwWPDba2Ld
	 Bgh5qxWPvWwtw==
Date: Wed, 16 Jul 2025 16:45:11 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH v2] utils: Add helpers for interface name
 wildcards
Message-ID: <aHe69yUQ3X_j--K6@calendula>
References: <20250715151526.14573-1-phil@nwl.cc>
 <aHd0mxVSp_cFcn16@strlen.de>
 <aHd4k3kkCfI2o4NV@orbyte.nwl.cc>
 <aHe5t9kb7fUWjAyQ@calendula>
 <aHe6cteE7g9zjBii@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aHe6cteE7g9zjBii@calendula>

On Wed, Jul 16, 2025 at 04:43:02PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 16, 2025 at 04:39:54PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Jul 16, 2025 at 12:01:55PM +0200, Phil Sutter wrote:
> > > Hi,
> > > 
> > > On Wed, Jul 16, 2025 at 11:44:59AM +0200, Florian Westphal wrote:
> > > > Phil Sutter <phil@nwl.cc> wrote:
> > > > >  #include <string.h>
> > > > >  #include <stdlib.h>
> > > > > +#include <libmnl/libmnl.h>
> > > > 
> > > > Why is this include needed?
> > > 
> > > Because of:
> > > 
> > > | In file included from udata.c:9:
> > > | ../include/utils.h:88:40: warning: 'struct nlattr' declared inside parameter list will not be visible outside of this definition or declaration
> > > |    88 | const char *mnl_attr_get_ifname(struct nlattr *attr);
> > > |       |                                        ^~~~~~
> > 
> > I think this helper belongs to src/netlink.c
> 
> Not a deal breaker, Florian's proposal is also fine.

Actually, my suggestion would be to add it to nftables/src/mnl.c with
mnl_nft_ prefix (not to src/netlink.c), if it turns out this is useful
to other projects, it could be moved there to libnftnl.
