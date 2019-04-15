Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4547C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 05:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B2EC2073F
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 05:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfDOFuj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 01:50:39 -0400
Received: from mail.us.es ([193.147.175.20]:47110 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfDOFuj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 01:50:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9CC44DC9BA
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 07:50:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DAD2DA703
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 07:50:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 76175DA70D; Mon, 15 Apr 2019 07:50:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 700BCDA704;
        Mon, 15 Apr 2019 07:50:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 07:50:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4AC8C4265A31;
        Mon, 15 Apr 2019 07:50:35 +0200 (CEST)
Date:   Mon, 15 Apr 2019 07:50:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Flavio Leitner <fbl@redhat.com>
Cc:     netdev@vger.kernel.org, Joe Stringer <joe@ovn.org>,
        Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/8] netfilter: add API to manage NAT helpers.
Message-ID: <20190415055034.k23xtziyu64ywazj@salvia>
References: <20190413231716.28711-1-fbl@redhat.com>
 <20190413231716.28711-3-fbl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190413231716.28711-3-fbl@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 13, 2019 at 08:17:10PM -0300, Flavio Leitner wrote:
[...]
> +void nf_nat_helper_put(struct nf_conntrack_helper *helper)
> +{
> +	struct nf_conntrack_nat_helper *nat;
> +
> +	nat = nf_conntrack_nat_helper_find(helper->nat_mod_name);
> +	BUG_ON(nat == NULL);

We've been trying to avoid BUG_ON() in many spots recently. Could you
turn this into... ?

        if (WARN_ON(!nat))
                return;

> +	module_put(nat->module);
> +}
> +EXPORT_SYMBOL_GPL(nf_nat_helper_put);
> +
>  struct nf_conn_help *
>  nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
>  {
> @@ -430,6 +502,10 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
>  	helper->help = help;
>  	helper->from_nlattr = from_nlattr;
>  	helper->me = module;
> +	helper->nat_mod_name[0] = '\0';
> +	if (name)
> +		snprintf(helper->nat_mod_name, sizeof(helper->nat_mod_name),
> +			 NF_NAT_HELPER_PREFIX"%s", name);
>  
>  	if (spec_port == default_port)
>  		snprintf(helper->name, sizeof(helper->name), "%s", name);
> @@ -466,6 +542,26 @@ void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *helper,
>  }
>  EXPORT_SYMBOL_GPL(nf_conntrack_helpers_unregister);
>  
> +void nf_nat_helper_register(struct nf_conntrack_nat_helper *nat)
> +{
> +	BUG_ON(nat->module == NULL);

Same here.

> +
> +	mutex_lock(&nf_ct_nat_helpers_mutex);
> +	list_add_rcu(&nat->list, &nf_ct_nat_helpers);
> +	mutex_unlock(&nf_ct_nat_helpers_mutex);
> +}
> +EXPORT_SYMBOL_GPL(nf_nat_helper_register);
> +
> +void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
> +{
> +	BUG_ON(nat->module == NULL);

And here.

Thanks.
