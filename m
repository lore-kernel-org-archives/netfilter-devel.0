Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2485AC10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 05:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F056D2073F
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 05:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfDOFs0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 01:48:26 -0400
Received: from mail.us.es ([193.147.175.20]:46898 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfDOFs0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 01:48:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D96FADC9B8
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 07:48:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3E1FDA709
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 07:48:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B92EBDA703; Mon, 15 Apr 2019 07:48:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BD2E7DA715;
        Mon, 15 Apr 2019 07:48:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 07:48:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 996AB4265A31;
        Mon, 15 Apr 2019 07:48:20 +0200 (CEST)
Date:   Mon, 15 Apr 2019 07:48:20 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Flavio Leitner <fbl@redhat.com>
Cc:     netdev@vger.kernel.org, Joe Stringer <joe@ovn.org>,
        Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/8] netfilter: add API to manage NAT helpers.
Message-ID: <20190415054820.p2vbw7itmr7gwmq5@salvia>
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

Sorry I didn't see this in the first review.

On Sat, Apr 13, 2019 at 08:17:10PM -0300, Flavio Leitner wrote:
[...]
> +int
> +nf_nat_helper_try_module_get(const char *name, u16 l3num, u8 protonum)
> +{
> +	struct nf_conntrack_helper *h;
> +	struct nf_conntrack_nat_helper *nat;
> +	char mod_name[NF_CT_HELPER_NAME_LEN];
> +	int ret = 0;
> +
> +	rcu_read_lock();
> +	h = __nf_conntrack_helper_find(name, l3num, protonum);
> +	if (h == NULL) {
> +		rcu_read_unlock();
> +		return -EINVAL;
> +	}
> +
> +	if (!strlen(h->nat_mod_name)) {
> +		rcu_read_unlock();
> +		return -EOPNOTSUPP;

Probably check for this at registration?

> +	}
> +
> +	nat = nf_conntrack_nat_helper_find(h->nat_mod_name);
> +	if (nat == NULL) {
> +		snprintf(mod_name, sizeof(mod_name), "%s", h->nat_mod_name);
> +		rcu_read_unlock();
> +		ret = request_module(mod_name);
> +		if (ret != 0)
> +			return ret;

Not sure it is worth checking for request_module() return value, the
code just below already is doing this.

> +
> +		rcu_read_lock();
> +		nat = nf_conntrack_nat_helper_find(mod_name);
> +		if (nat == NULL) {
> +			rcu_read_unlock();
> +			return -EINVAL;

ENOENT?

> +		}
> +	}
> +
> +	if (!try_module_get(nat->module))
> +		ret = -EINVAL;

ENOENT?

Telling this because we will at some point propagate this error value
to userspace by when we start using this infrastructure you're working
on. EINVAL is already very overload in netlink and we'll use it from
there.

> +
> +	rcu_read_unlock();
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(nf_nat_helper_try_module_get);
