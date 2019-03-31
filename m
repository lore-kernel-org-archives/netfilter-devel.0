Return-Path: <SRS0=FgsC=SC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD59C43381
	for <netfilter-devel@archiver.kernel.org>; Sun, 31 Mar 2019 22:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2CD12086C
	for <netfilter-devel@archiver.kernel.org>; Sun, 31 Mar 2019 22:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731729AbfCaWKh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 31 Mar 2019 18:10:37 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:53509 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731696AbfCaWKh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 31 Mar 2019 18:10:37 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hAiev-0007mg-0D; Mon, 01 Apr 2019 00:10:35 +0200
Date:   Mon, 1 Apr 2019 00:10:32 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Flavio Leitner <fbl@sysclose.org>
Cc:     netdev@vger.kernel.org, Joe Stringer <joe@ovn.org>,
        Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 2/8] netfilter: add API to manage NAT helpers.
Message-ID: <20190331221032.szgoqplcd7nvvia6@salvia>
References: <20190326205715.22288-1-fbl@sysclose.org>
 <20190326205715.22288-3-fbl@sysclose.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326205715.22288-3-fbl@sysclose.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 26, 2019 at 05:57:09PM -0300, Flavio Leitner wrote:
> The API allows a conntrack helper to indicate its corresponding
> NAT helper which then can be loaded and reference counted.
> 
> Signed-off-by: Flavio Leitner <fbl@sysclose.org>
> ---
>  include/net/netfilter/nf_conntrack_helper.h |  19 +++-
>  net/netfilter/nf_conntrack_amanda.c         |   2 +
>  net/netfilter/nf_conntrack_ftp.c            |   6 +-
>  net/netfilter/nf_conntrack_helper.c         | 108 +++++++++++++++++++-
>  net/netfilter/nf_conntrack_irc.c            |   3 +-
>  net/netfilter/nf_conntrack_sane.c           |   4 +-
>  net/netfilter/nf_conntrack_sip.c            |  12 ++-
>  net/netfilter/nf_conntrack_tftp.c           |   6 +-
>  8 files changed, 147 insertions(+), 13 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> index e86fadf7e7c5..0d36d6bfb522 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -58,6 +58,8 @@ struct nf_conntrack_helper {
>  	unsigned int queue_num;
>  	/* length of userspace private data stored in nf_conn_help->data */
>  	u16 data_len;
> +	/* name of NAT helper module */
> +	char nat_mod_name[NF_CT_HELPER_NAME_LEN];
>  };
>  
>  /* Must be kept in sync with the classes defined by helpers */
> @@ -98,7 +100,8 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
>  				   enum ip_conntrack_info ctinfo),
>  		       int (*from_nlattr)(struct nlattr *attr,
>  					  struct nf_conn *ct),
> -		       struct module *module);
> +		       struct module *module,
> +		       const char *nat_mod_name);
>  
>  int nf_conntrack_helper_register(struct nf_conntrack_helper *);
>  void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
> @@ -157,4 +160,18 @@ nf_ct_helper_expectfn_find_by_symbol(const void *symbol);
>  extern struct hlist_head *nf_ct_helper_hash;
>  extern unsigned int nf_ct_helper_hsize;
>  
> +struct nf_conntrack_helper_nat {
> +	struct list_head list;
> +	char name[NF_CT_HELPER_NAME_LEN];
> +	struct module *module;		/* pointer to self */
> +};
> +
> +void nf_ct_helper_nat_init(struct nf_conntrack_helper_nat *nat,
> +			   const char *name, struct module *module);

Instead of this nf_ct_helper_nat_init() runtime initializer, define
the structure in C99 as static in the NAT helper module?

Telling this because we can probably also extend this structure to
remove the RCU hook between ct helper and nat helper at some point
through this new definition.

> +void nf_conntrack_helper_nat_register(struct nf_conntrack_helper_nat *nat);

Shorter name suggestion:

        nf_nat_helper_register()

> +void nf_conntrack_helper_nat_unregister(struct nf_conntrack_helper_nat *nat);

        nf_nat_helper_unregister()

> +int nf_conntrack_helper_nat_try_module_get(const char *name, u16 l3num,
> +					   u8 protonum);

        nf_nat_helper_try_module_get()

> +void nf_conntrack_helper_nat_put(struct nf_conntrack_helper *helper);

        nf_nat_helper_nat_put()
