Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7255C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 14:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91BAC2087C
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 14:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbfDOOF6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 10:05:58 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34307 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbfDOOF5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 10:05:57 -0400
Received: by mail-qk1-f194.google.com with SMTP id n68so9902157qka.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 07:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eNa8L1C5JjxDSO6U8y+vlCKPasiQCyXm0cBNX0dnH1Q=;
        b=sh97TMUb1JOtP4xMW/fe9+WYwZRTw8zI+HDVSw4kBs4DM6qhLkzrICi+q37EdYEkYf
         0CWbHXrZHSqU/mYGdTj34ilK0gDQ6M42ZKmeouktlG+qyYY7CJAWqWN0DGBsAyoheZZq
         kFJ5I9Br03to22uAp/0oiB0aH5Q0s3q5kp3T0qcTz7IAMbOJxLVC50CZGFspX3SuwY2U
         m8SYtzOwhbve/DpQjd1sTATX+8q3/5tGYZezaOVkOpNlWz4+LqK9vUPe+sOY4rXbISrR
         2x5QyYCYz9k72Neu+8DYdc5uOnz3MXio82a0Gs1GeKi+bnxFmlck0jNPzU1NvdyJs7kQ
         xUqg==
X-Gm-Message-State: APjAAAUYWcRfe3E6bK1qQ6mNg7PFirKvXw2QSA0vmYTksZkQOak0B4sq
        sIb7RXwMJL2UKiD22wu86M6YVQ==
X-Google-Smtp-Source: APXvYqx4URY3vipa6x6069pfci+tExNVjptHcCiTXVzLznVFvMZXU5ryY7/mxR3e79i84inRfh825w==
X-Received: by 2002:a37:4c85:: with SMTP id z127mr55674409qka.180.1555337156893;
        Mon, 15 Apr 2019 07:05:56 -0700 (PDT)
Received: from localhost ([177.183.215.200])
        by smtp.gmail.com with ESMTPSA id 50sm22061379qtq.7.2019.04.15.07.05.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Apr 2019 07:05:56 -0700 (PDT)
Date:   Mon, 15 Apr 2019 11:05:54 -0300
From:   Flavio Leitner <fbl@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, Joe Stringer <joe@ovn.org>,
        Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/8] netfilter: add API to manage NAT helpers.
Message-ID: <20190415140554.GG3319@p50.lan>
References: <20190413231716.28711-1-fbl@redhat.com>
 <20190413231716.28711-3-fbl@redhat.com>
 <20190415055034.k23xtziyu64ywazj@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415055034.k23xtziyu64ywazj@salvia>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 15, 2019 at 07:50:34AM +0200, Pablo Neira Ayuso wrote:
> On Sat, Apr 13, 2019 at 08:17:10PM -0300, Flavio Leitner wrote:
> [...]
> > +void nf_nat_helper_put(struct nf_conntrack_helper *helper)
> > +{
> > +	struct nf_conntrack_nat_helper *nat;
> > +
> > +	nat = nf_conntrack_nat_helper_find(helper->nat_mod_name);
> > +	BUG_ON(nat == NULL);
> 
> We've been trying to avoid BUG_ON() in many spots recently. Could you
> turn this into... ?
> 
>         if (WARN_ON(!nat))
>                 return;

OK.


> 
> > +	module_put(nat->module);
> > +}
> > +EXPORT_SYMBOL_GPL(nf_nat_helper_put);
> > +
> >  struct nf_conn_help *
> >  nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
> >  {
> > @@ -430,6 +502,10 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
> >  	helper->help = help;
> >  	helper->from_nlattr = from_nlattr;
> >  	helper->me = module;
> > +	helper->nat_mod_name[0] = '\0';
> > +	if (name)
> > +		snprintf(helper->nat_mod_name, sizeof(helper->nat_mod_name),
> > +			 NF_NAT_HELPER_PREFIX"%s", name);
> >  
> >  	if (spec_port == default_port)
> >  		snprintf(helper->name, sizeof(helper->name), "%s", name);
> > @@ -466,6 +542,26 @@ void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *helper,
> >  }
> >  EXPORT_SYMBOL_GPL(nf_conntrack_helpers_unregister);
> >  
> > +void nf_nat_helper_register(struct nf_conntrack_nat_helper *nat)
> > +{
> > +	BUG_ON(nat->module == NULL);
> 
> Same here.


OK, no problem.

> 
> > +
> > +	mutex_lock(&nf_ct_nat_helpers_mutex);
> > +	list_add_rcu(&nat->list, &nf_ct_nat_helpers);
> > +	mutex_unlock(&nf_ct_nat_helpers_mutex);
> > +}
> > +EXPORT_SYMBOL_GPL(nf_nat_helper_register);
> > +
> > +void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
> > +{
> > +	BUG_ON(nat->module == NULL);
> 
> And here.

Sure.
Thanks!
fbl

> 
> Thanks.
