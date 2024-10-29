Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A438920515F
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 12:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730204107; cv=none; b=hK5lIZpCH7p8+oLqjGB2d0EBTCul0cD5kK2wB7EMT12BL/WMPos78G5Gg/QEY1/y9idXmjn+QZWxaDKwcCK3ko2tLfqr711edAUzm2MHk836VPiZj+RzPKBpy/bQjRGDUuAfsjN2aRswBoqACFSU1CZCcoW9Kk59QGlrxI7wzjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730204107; c=relaxed/simple;
	bh=4GoCim1k1Tf5PL7qfOPLSyY0DukU30AiG6AGfU9kUQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETPxevrlHeV/XgEvvGi78QFrclB4Vcw68jMKCtelzK3tN21yHGPPBGq7covIMMQ1K3DIO5D9lJC3KcyBp0ACAWHW1QVkiQ1Du7nt9EAvuYJykFnXDzAqYAmmMVQObbQW+rrz8FMCMvfndwIOHcE4pe+0LnD6LitvWCdLkHIVzwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Fi3rzbOP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Fi3rzbOP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=98+cW93YBktd38ktVILsVftcMsPwFj2unfDwPGAi5qo=; b=Fi3rzbOPlshrAnHdO0TzXbNde6
	HWcczlIoUQEDznPHQ4ZcoTqhRYeKaai/U5w3oJJuyvc3WcFGk/FPWh+RL504k9+xxsk+0TWIJvde7
	jDgXtKdIWrdNvVxfZQ7qeX6FoU/vVFdX6cT/DgM8UP/d9w/vfyD6gmJcC617YFo6hAvZcqJJ1NBFt
	oov5/aRDm4sPJ6miffSElzSsVKFBJXx+6GgeyTqsmePKy326VVsvMjyM2SsFtsxKidQq8jsDYoUsK
	zPl50QPo78k1p81axdVMyrUHHn/3xfv2rf5SwMdrOxAvOTHJXNkp8shwGa0zQKhfWJJvS9YzZrFC0
	QEAKtgGg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t5l7n-000000007ME-2sU0;
	Tue, 29 Oct 2024 13:15:03 +0100
Date: Tue, 29 Oct 2024 13:15:03 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [libnftnl PATCH v2] Introduce struct nftnl_str_array
Message-ID: <ZyDRx6J2jnkh9ZdP@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20241023202119.27681-1-phil@nwl.cc>
 <ZyAXS49_WEHaXBRa@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyAXS49_WEHaXBRa@calendula>

On Mon, Oct 28, 2024 at 11:59:23PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Oct 23, 2024 at 10:21:04PM +0200, Phil Sutter wrote:
> [...]
> > @@ -325,12 +295,11 @@ void nftnl_flowtable_nlmsg_build_payload(struct nlmsghdr *nlh,
> >  
> >  	if (c->flags & (1 << NFTNL_FLOWTABLE_DEVICES)) {
> >  		struct nlattr *nest_dev;
> > +		const char *dev;
> >  
> >  		nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
> > -		for (i = 0; i < c->dev_array_len; i++) {
> > -			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME,
> > -					  c->dev_array[i]);
> > -		}
> > +		nftnl_str_array_foreach(dev, &c->dev_array, i)
> 
> Where is this nftnl_str_array_foreach defined? I don't find it in this
> patch.

Argh, not just did I forget to 'git add' the new files, I also missed
that it's about two files, not just one. I'll send a v3 which also
includes str_array.h. Sorry for the mess.

> [...]
> > +void nftnl_str_array_clear(struct nftnl_str_array *sa)
> > +{
> > +	while (sa->len > 0)
> > +		free(sa->array[--sa->len]);
> > +	free(sa->array);
> > +	sa->array = NULL;
> 
> This is new, I'm fine with this, but it is only defensive, right?
> This stale reference would not be reached because attribute flag is
> cleared.

Oh, you're right. A first approach used realloc_array() in
nftnl_str_array_set(), but I abandoned it and this is a left-over.
I'll drop it from v3.

> > +}
> [...]
> > diff --git a/src/utils.c b/src/utils.c
> > index 2f1ffd6227583..157b15f7afe8d 100644
> > --- a/src/utils.c
> > +++ b/src/utils.c
> > @@ -19,6 +19,7 @@
> >  
> >  #include <libnftnl/common.h>
> >  
> > +#include <libmnl/libmnl.h>
> >  #include <linux/netfilter.h>
> >  #include <linux/netfilter/nf_tables.h>
> 
> Remove this chunk? It looks unrelated.

ACK, sorry. Also a left-over.

Thanks, Phil
