Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FFC9C06510
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 00:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FA8B21993
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 00:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfGCA2p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 20:28:45 -0400
Received: from mail.us.es ([193.147.175.20]:40508 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727268AbfGCA2o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 20:28:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7B31580788
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 01:51:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6BC10D1929
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 01:51:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 61579DA801; Wed,  3 Jul 2019 01:51:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A470DA4CA;
        Wed,  3 Jul 2019 01:51:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Jul 2019 01:51:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 46D1D4265A31;
        Wed,  3 Jul 2019 01:51:37 +0200 (CEST)
Date:   Wed, 3 Jul 2019 01:51:36 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     xiao ruizhu <katrina.xiaorz@gmail.com>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        alin.nastac@gmail.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v7] netfilter: nf_conntrack_sip: fix expectation clash
Message-ID: <20190702235136.shigmd7wxmhwaky4@salvia>
References: <20190617223713.36ozdeh4hm6efv4y@salvia>
 <1560846770-2644-1-git-send-email-katrina.xiaorz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560846770-2644-1-git-send-email-katrina.xiaorz@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch looks nice now.

One more change and we go:

On Tue, Jun 18, 2019 at 04:32:50PM +0800, xiao ruizhu wrote:
> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index 59c1880..7df6228 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -252,13 +252,22 @@ static inline int expect_clash(const struct nf_conntrack_expect *a,
>  static inline int expect_matches(const struct nf_conntrack_expect *a,
>  				 const struct nf_conntrack_expect *b)
>  {
> -	return a->master == b->master &&
> -	       nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
> +	return nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
>  	       nf_ct_tuple_mask_equal(&a->mask, &b->mask) &&
>  	       net_eq(nf_ct_net(a->master), nf_ct_net(b->master)) &&
>  	       nf_ct_zone_equal_any(a->master, nf_ct_zone(b->master));
>  }
>  
> +static bool master_matches(const struct nf_conntrack_expect *a,
> +			   const struct nf_conntrack_expect *b,
> +			   unsigned int flags)
> +{
> +	if (flags & NF_CT_EXP_F_CHECK_MASTER)

rename this to NF_CT_EXP_F_SKIP_MASTER.

Since semantics here is to skip the master check, rather than checking
for it.

> +		return true;
> +
> +	return a->master == b->master;
> +}

Thanks.
