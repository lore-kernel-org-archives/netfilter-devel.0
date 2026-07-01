Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88F73B27EA;
	Wed,  1 Jul 2026 06:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782887144; cv=none; b=PIRWNSswiKE1JHiZ0VpW1qnblZ9prCsnmDjYUrvbUjObubGPb7KI5VDp5y/rQAx7Oo/tGhsYQxhgqsGkfmtOqElq2XwLgWj1vJv3Cd0/3ylIEtMtPah2xGjiOjUck7pVDPDPAjxnfigq6zZlr9O5eq98MFfv4nMFxgZhZJST+eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782887144; c=relaxed/simple;
	bh=fIM8VNIc5pbfQTbkdZJbDhnsuKFyNWmh/ulSk4Y4MbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SgcQZ8QnxUCrupAZR3YoFE3Yx4d5UqfeP4a5EAmEPXkDLcdweTNpzsm5Si+gS4qr+EniID8vsaEFXfZsukpWsdCwXCvZLNok8U546uhY1uHTPMPLJntR+SgOyQ/weskHr5imEckVpzbalm67T8dnCzczzHAne6sDpsHkCokcRm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=RD3m2VWD; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DtoHmSNX; arc=none smtp.client-ip=202.12.124.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="RD3m2VWD";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DtoHmSNX"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 4C3C013000BB;
	Wed,  1 Jul 2026 02:25:39 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 01 Jul 2026 02:25:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1782887139; x=1782890739; bh=DgC5jJz7pQ
	Y2GqVx3z0JfLHlwr1nxJNvIHQlZet0Vng=; b=RD3m2VWDZpjXsQwtyhhz1dUeCL
	NI+o3BuiZUfnmNbxm2+Z01P6KpILN0ehUeg11LzQQAji4wYVkBnendY+VBisuA4s
	+wH2zY2JtDel1k9zpi3F2IUYTYxiE0n8DQ9c2wkI4sfdGm6qE8GlGSnb5H7/YlNe
	alAi8CMXtmTiJStVr9i5Kp7htAdlrfC2hdqxjI5zxz/yV8qNq8aJOkjdXScOm6Lw
	l17Xihz6AEVqTkIltxNOOzeCYqdeGaUNWKFmzfNVrH994AuPO8+29SJdkbdthXDi
	K3eDCsVxv5iYZC+IDcN1VkPMDTP1239ECxkxWtHHzOlf4xbsTQQkkLbOOpog==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1782887139; x=1782890739; bh=DgC5jJz7pQY2GqVx3z0JfLHlwr1nxJNvIHQ
	lZet0Vng=; b=DtoHmSNX4yCOvi1wUhx3zAuuZOPA5TqPrMOgRhc1fcsjKVnBF2O
	lqXHzxj5tkUx78ui75iSToCnjInqF/t/7jKYV1npT2HJeUemEESjAGc5MfedfKZC
	xx1nYAPAlU2T5RiUiHk7pKvf/JIFRX1FSCzd+JCw65aHAcQIuc9xxL4OnS5z+6XT
	wJ52ZBkkl8B81vQsJhNvvlxzDaVLVUkp+zojZSwM0aKy2DSHts5fehTD2TjBa28D
	1R7F5slFvo+DvkukeXQ+EubqxmM0P+8GrdsZoNNPqZvBXN/R4bxeKbEXQFP3WMTJ
	3FUkma1PQipF1H1DPlkzyWKH4ThF5+dRiLg==
X-ME-Sender: <xms:4rJEau8dS4lfIzUrsKrRqg4TRMGtqny79e2C11h2AhkGkwQyGyCpQQ>
    <xme:4rJEarH4FA2teqN680bhyQjmyk1c3Q6kvdjfOycFEHP_ePcfXf-2UyPk2qvQq_DRw
    q7bf6rULAc1vpoiVT-2MpPzEUK12R81PwENG-JTYxSJg2A_g3lz7Oo>
X-ME-Received: <xmr:4rJEaod6RG0QVUkvJps2bLlqLKngm63QcmOcfWhDUP4q3gL3sd0xczX2eUQ>
X-ME-Proxy-Cause: dmFkZTGyY6rHX/7AOhO9bWoyCyOEFK7DO0LPh2aMmnD2oP6TTN5atiZjlC4jZgF+24ocy+
    Qa4VJSRKALcCoZS16nGa1fA4udqt73Ge8WEUjBp2VJOgV1HXjgLonjbRoupgs7Tu1khnWY
    yc1v2PRZ0clY3Wqcz1XlXMa4gGsgA3dBprtDVKpg9PxfpxcTKKkPQ3IEkDb7KaOw1IGJQZ
    DhWsYdPWMQWOcGTfEk5vvol3ZMzLV25P4fa3VikVymX4fY12Jsq7ECEF634FKIAA1ZDx0I
    p7fI9JLuYQBr+Q3t7QDOy8ERF6TtiDSAI6s8vNuPYDIjTrWzXA3wCCsZFC70qYjeLS08Rd
    Ch+4r5Pz7XjmlT/l4OIAwd/gWnuykAxP54uxMMq2vU49+LylTJoE7QiQkuySZDD9NAvNzz
    1y0iK5WD9Pd1bKb8OT7xejLx5JE2RE2jxM9ATCl9NcIJyhIfvOdTOYx8BZJ8mB8IAmDVM0
    p3X0MYcu3553llOVoHL2WOiutNEb/Ff4AzWpCQhOHr2ELcGxAoekbM2OZ/e/YTgFr6ilEe
    TtIvcElPGLp0mLKlBq6aMRkwaYClNYVS+Yti8vZsq+k9DWfVCSdrLcE1O+D91UwQjrdmva
    cMA1csLYxJ2IoZub2kTxjJXV7Sb2ypCFl84jCFdnKZs13AFZI54P7oToJHaQ
X-ME-Proxy: <xmx:4rJEakmK5pmzMPXUBNt2xAMM-6OxtiSWb1jOKOLisRWVHTIppZsB7A>
    <xmx:4rJEavoWeR3DBqzFMo8Wvv68U0qPz_uCGzYR8JZT-Bwcu4WQ0VHI9Q>
    <xmx:4rJEapGIEm2XgLRplyqH_MUFS6phakYuxhDd-_NUMdhNnN7i304jTQ>
    <xmx:4rJEatRwbU_7PkQLmnbf1IL7nlflfs-V11uEHfMVUHUz5mz-x_DtRQ>
    <xmx:47JEat7e8IZA_ifgVw6Zdir4kCV_Vcb0PvnIWbePFcoONXx_JPIvg8Xe>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Jul 2026 02:25:38 -0400 (EDT)
Date: Wed, 1 Jul 2026 01:25:36 -0500
From: Ian Bridges <icb@fastmail.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] netfilter: x_tables: replace strlcat() with snprintf()
Message-ID: <akSy4AzKgPffteU7@dev>
References: <aj78X4Cjqcpbb8Co@dev>
 <20260627221643.1e837496@pumpkin>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260627221643.1e837496@pumpkin>

On Sat, Jun 27, 2026 at 10:16:43PM +0100, David Laight wrote:
> On Fri, 26 Jun 2026 17:25:35 -0500
> Ian Bridges <icb@fastmail.org> wrote:
> 
> > In preparation for removing the deprecated strlcat() API[1], replace the
> > strscpy()/strlcat() pairs in xt_proto_init() and xt_proto_fini() with
> > snprintf(), which builds each /proc file name in a single call.
> > 
> > Each name is "<prefix><suffix>", where <prefix> is the address-family
> > string xt_prefix[af] and <suffix> is one of the FORMAT_TABLES,
> > FORMAT_MATCHES or FORMAT_TARGETS literals. snprintf() with a "%s%s"
> > format produces the same NUL-terminated, length-bounded string as the
> > strscpy()/strlcat() chain it replaces, so the proc entry names are
> > unchanged.
> > 
> > Link: https://github.com/KSPP/linux/issues/370 [1]
> > Signed-off-by: Ian Bridges <icb@fastmail.org>
> > ---
> >  net/netfilter/x_tables.c | 24 ++++++++----------------
> >  1 file changed, 8 insertions(+), 16 deletions(-)
> > 
> > diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> > index 4e6708c23922..56f4546be336 100644
> > --- a/net/netfilter/x_tables.c
> > +++ b/net/netfilter/x_tables.c
> > @@ -2033,8 +2033,7 @@ int xt_proto_init(struct net *net, u_int8_t af)
> >  	root_uid = make_kuid(net->user_ns, 0);
> >  	root_gid = make_kgid(net->user_ns, 0);
> >  
> > -	strscpy(buf, xt_prefix[af], sizeof(buf));
> > -	strlcat(buf, FORMAT_TABLES, sizeof(buf));
> > +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_TABLES);
> 
> If you are going to use snprintf either paste the strings together:
> 	snprintf(buf, sizeof(buf), "%s" FORMAT_TABLES, xt_prefix[af]);
> or prepend the "%s" onto the #define of FORMAT_TABLES itself:
> 	snprintf(buf, sizeof(buf), FORMAT_TABLES, xt_prefix[af]);
>

I learned something new today, thanks. I'll use the first form in v2.

> FORMAT_TABLES should also be FORMAT_NAMES.

The macro is already named FORMAT_TABLES today, so that rename would
be a cleanup of pre-existing code rather than part of the strlcat
conversion. I'm happy to fold it into v2 if a maintainer is fine
including the tidy-up in this patch.

Thanks for the review,
Ian

> 
> -- David
> 
> >  	proc = proc_create_net_data(buf, 0440, net->proc_net, &xt_table_seq_ops,
> >  			sizeof(struct seq_net_private),
> >  			(void *)(unsigned long)af);
> > @@ -2043,8 +2042,7 @@ int xt_proto_init(struct net *net, u_int8_t af)
> >  	if (uid_valid(root_uid) && gid_valid(root_gid))
> >  		proc_set_user(proc, root_uid, root_gid);
> >  
> > -	strscpy(buf, xt_prefix[af], sizeof(buf));
> > -	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
> > +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_MATCHES);
> >  	proc = proc_create_seq_private(buf, 0440, net->proc_net,
> >  			&xt_match_seq_ops, sizeof(struct nf_mttg_trav),
> >  			(void *)(unsigned long)af);
> > @@ -2053,8 +2051,7 @@ int xt_proto_init(struct net *net, u_int8_t af)
> >  	if (uid_valid(root_uid) && gid_valid(root_gid))
> >  		proc_set_user(proc, root_uid, root_gid);
> >  
> > -	strscpy(buf, xt_prefix[af], sizeof(buf));
> > -	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
> > +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_TARGETS);
> >  	proc = proc_create_seq_private(buf, 0440, net->proc_net,
> >  			 &xt_target_seq_ops, sizeof(struct nf_mttg_trav),
> >  			 (void *)(unsigned long)af);
> > @@ -2068,13 +2065,11 @@ int xt_proto_init(struct net *net, u_int8_t af)
> >  
> >  #ifdef CONFIG_PROC_FS
> >  out_remove_matches:
> > -	strscpy(buf, xt_prefix[af], sizeof(buf));
> > -	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
> > +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_MATCHES);
> >  	remove_proc_entry(buf, net->proc_net);
> >  
> >  out_remove_tables:
> > -	strscpy(buf, xt_prefix[af], sizeof(buf));
> > -	strlcat(buf, FORMAT_TABLES, sizeof(buf));
> > +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_TABLES);
> >  	remove_proc_entry(buf, net->proc_net);
> >  out:
> >  	return -1;
> > @@ -2087,16 +2082,13 @@ void xt_proto_fini(struct net *net, u_int8_t af)
> >  #ifdef CONFIG_PROC_FS
> >  	char buf[XT_FUNCTION_MAXNAMELEN];
> >  
> > -	strscpy(buf, xt_prefix[af], sizeof(buf));
> > -	strlcat(buf, FORMAT_TABLES, sizeof(buf));
> > +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_TABLES);
> >  	remove_proc_entry(buf, net->proc_net);
> >  
> > -	strscpy(buf, xt_prefix[af], sizeof(buf));
> > -	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
> > +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_TARGETS);
> >  	remove_proc_entry(buf, net->proc_net);
> >  
> > -	strscpy(buf, xt_prefix[af], sizeof(buf));
> > -	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
> > +	snprintf(buf, sizeof(buf), "%s%s", xt_prefix[af], FORMAT_MATCHES);
> >  	remove_proc_entry(buf, net->proc_net);
> >  #endif /*CONFIG_PROC_FS*/
> >  }
> 
