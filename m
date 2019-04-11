Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645E8C10F14
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 18:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D1342173C
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 18:42:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sysclose.org header.i=@sysclose.org header.b="kzlbSEIW";
	dkim=pass (2048-bit key) header.d=sysclose.org header.i=@sysclose.org header.b="J1zlQUEN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfDKSmB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 14:42:01 -0400
Received: from smtp.sysclose.org ([69.164.214.230]:50414 "EHLO sysclose.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbfDKSl7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 14:41:59 -0400
Received: by sysclose.org (Postfix, from userid 5001)
        id 7877A67D8; Thu, 11 Apr 2019 18:35:39 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 sysclose.org 7877A67D8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sysclose.org;
        s=201903; t=1555007739;
        bh=ug2hf7LuBY3QCjQuifNyiy6yIgLrmVn/jF54Qbdmxuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kzlbSEIWOdo76pKHL/pSJY03UP11XUTKIpV84TCMuXaiLbomONsZ0pNKTddVRmgGj
         Nq71rO1hNeYx0d1Ro9+3P1F7ADYzp5SYxGrtR3TlOmCbbCnbmg3dkaA/Naa9Z4wCf7
         /oLSkS3jbd8GRnDjNIZkRNiQv3U4+0wPHC+udCZ88gcNBm2lYLb4q6lDDFUvHWcogz
         McF9scmsYWCMOIjqty1GImCPnbQUXvzYPb+d1ztnf0nX0AYGLjVNvORhEUQXoZPK6u
         26u2UCEv7cCMPIQAgs1ov7MH6XWDqGSkUlMpu0+9GEZyz+/ErFlTFB+DU99+5mRJeJ
         HBBxIW65Dh/Aw==
Received: from localhost (unknown [177.183.215.126])
        by sysclose.org (Postfix) with ESMTPSA id BA1E767FF;
        Thu, 11 Apr 2019 18:35:37 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 sysclose.org BA1E767FF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sysclose.org;
        s=201903; t=1555007738;
        bh=ug2hf7LuBY3QCjQuifNyiy6yIgLrmVn/jF54Qbdmxuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J1zlQUENMbQBq3HFfqf48JTnmKlWrIIIfJhrYTXOD2HNjq8pBA9D2ZQs+E+FOuC+d
         0hTf7j/B2nfJag37efGPS2DEWvNKvw925S9c4hF8yY9farnOia7kRVmRP2/+ugYdez
         F8ucNGOXO7P6TbMjN7hNiYExkVriCDI+gSU9IjdffzsA1FI6z4ixpFbRqEYzFDe/mY
         mikMMEI3W7uRT0kObhD10ahKOsQP49K7s5UVsZm1GguzSYDTNcikPw5j/t+i6YJq6D
         DlIwcz0MAAkHqU9K2SLu4edmtxEQKYylG5RXe5iAQNf3rMo14aTmo8ArlZ37020HKJ
         lkHeEEvzUB6+w==
Date:   Thu, 11 Apr 2019 15:35:35 -0300
From:   Flavio Leitner <fbl@sysclose.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, Joe Stringer <joe@ovn.org>,
        Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 2/8] netfilter: add API to manage NAT helpers.
Message-ID: <20190411183534.GB21048@p50.lan>
References: <20190326205715.22288-1-fbl@sysclose.org>
 <20190326205715.22288-3-fbl@sysclose.org>
 <20190331221032.szgoqplcd7nvvia6@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190331221032.szgoqplcd7nvvia6@salvia>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 01, 2019 at 12:10:32AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Mar 26, 2019 at 05:57:09PM -0300, Flavio Leitner wrote:
> > The API allows a conntrack helper to indicate its corresponding
> > NAT helper which then can be loaded and reference counted.
> > 
> > Signed-off-by: Flavio Leitner <fbl@sysclose.org>
> > ---
> >  include/net/netfilter/nf_conntrack_helper.h |  19 +++-
> >  net/netfilter/nf_conntrack_amanda.c         |   2 +
> >  net/netfilter/nf_conntrack_ftp.c            |   6 +-
> >  net/netfilter/nf_conntrack_helper.c         | 108 +++++++++++++++++++-
> >  net/netfilter/nf_conntrack_irc.c            |   3 +-
> >  net/netfilter/nf_conntrack_sane.c           |   4 +-
> >  net/netfilter/nf_conntrack_sip.c            |  12 ++-
> >  net/netfilter/nf_conntrack_tftp.c           |   6 +-
> >  8 files changed, 147 insertions(+), 13 deletions(-)
> > 
> > diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> > index e86fadf7e7c5..0d36d6bfb522 100644
> > --- a/include/net/netfilter/nf_conntrack_helper.h
> > +++ b/include/net/netfilter/nf_conntrack_helper.h
> > @@ -58,6 +58,8 @@ struct nf_conntrack_helper {
> >  	unsigned int queue_num;
> >  	/* length of userspace private data stored in nf_conn_help->data */
> >  	u16 data_len;
> > +	/* name of NAT helper module */
> > +	char nat_mod_name[NF_CT_HELPER_NAME_LEN];
> >  };
> >  
> >  /* Must be kept in sync with the classes defined by helpers */
> > @@ -98,7 +100,8 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
> >  				   enum ip_conntrack_info ctinfo),
> >  		       int (*from_nlattr)(struct nlattr *attr,
> >  					  struct nf_conn *ct),
> > -		       struct module *module);
> > +		       struct module *module,
> > +		       const char *nat_mod_name);
> >  
> >  int nf_conntrack_helper_register(struct nf_conntrack_helper *);
> >  void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
> > @@ -157,4 +160,18 @@ nf_ct_helper_expectfn_find_by_symbol(const void *symbol);
> >  extern struct hlist_head *nf_ct_helper_hash;
> >  extern unsigned int nf_ct_helper_hsize;
> >  
> > +struct nf_conntrack_helper_nat {
> > +	struct list_head list;
> > +	char name[NF_CT_HELPER_NAME_LEN];
> > +	struct module *module;		/* pointer to self */
> > +};
> > +
> > +void nf_ct_helper_nat_init(struct nf_conntrack_helper_nat *nat,
> > +			   const char *name, struct module *module);
> 
> Instead of this nf_ct_helper_nat_init() runtime initializer, define
> the structure in C99 as static in the NAT helper module?
> 
> Telling this because we can probably also extend this structure to
> remove the RCU hook between ct helper and nat helper at some point
> through this new definition.

Sounds good, let me try that.


> > +void nf_conntrack_helper_nat_register(struct nf_conntrack_helper_nat *nat);
> 
> Shorter name suggestion:
> 
>         nf_nat_helper_register()
> 
> > +void nf_conntrack_helper_nat_unregister(struct nf_conntrack_helper_nat *nat);
> 
>         nf_nat_helper_unregister()
> 
> > +int nf_conntrack_helper_nat_try_module_get(const char *name, u16 l3num,
> > +					   u8 protonum);
> 
>         nf_nat_helper_try_module_get()
> 
> > +void nf_conntrack_helper_nat_put(struct nf_conntrack_helper *helper);
> 
>         nf_nat_helper_nat_put()

Ok to all the above.

Thanks,
fbl
