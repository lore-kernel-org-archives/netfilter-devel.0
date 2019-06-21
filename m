Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AABAAC43613
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 14:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89675206B7
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 14:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfFUOXB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 10:23:01 -0400
Received: from mail.us.es ([193.147.175.20]:58832 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfFUOXB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 10:23:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B6001EA475
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 16:22:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4A96DA70A
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 16:22:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 27BDFDA7BA; Fri, 21 Jun 2019 16:22:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1AF08DA7B5;
        Fri, 21 Jun 2019 16:22:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 21 Jun 2019 16:22:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E9FBF4265A31;
        Fri, 21 Jun 2019 16:22:54 +0200 (CEST)
Date:   Fri, 21 Jun 2019 16:22:54 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2] netfilter: nf_tables: Add SYNPROXY support
Message-ID: <20190621142254.6edv2pbmeuz7s6nr@salvia>
References: <20190619180654.1432-1-ffmancera@riseup.net>
 <20190620141008.6dcgzgynbyfxkvf2@salvia>
 <08de40dd-b7eb-0cbe-823d-1e8d9679a148@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08de40dd-b7eb-0cbe-823d-1e8d9679a148@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 21, 2019 at 03:01:13PM +0200, Fernando Fernandez Mancera wrote:
> Hi Pablo, comments below.
> 
> On 6/20/19 4:10 PM, Pablo Neira Ayuso wrote:
> > On Wed, Jun 19, 2019 at 08:06:54PM +0200, Fernando Fernandez Mancera wrote:
> > [...]
> >> diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
> >> new file mode 100644
> >> index 000000000000..3ef7f1dc50be
> >> --- /dev/null
> >> +++ b/net/netfilter/nft_synproxy.c
> >> @@ -0,0 +1,327 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +
[...]
> >> +
> >> +static void nft_synproxy_destroy(const struct nft_ctx *ctx,
> >> +				 const struct nft_expr *expr)
> >> +{
> >> +	struct synproxy_net *snet = synproxy_pernet(ctx->net);
> >> +
> >> +	switch (ctx->family) {
> >> +	case NFPROTO_IPV4:
> >> +		nf_synproxy_ipv4_fini(snet, ctx->net);
> >> +		break;
> >> +#if IS_ENABLED(IPV6)
> > 
> > This should be CONFIG_IPV6, right?
> > 
> 
> Yes, but I think we should check CONFIG_NF_TABLES_IPV6 instead. What do
> you think?

I think nf_synproxy_ipv6 does not depend on CONFIG_NF_TABLES_IPV6.
This infrastructure is used by iptables, which should not have any
superfluous dependency.

So I'm inclined to place a CONFIG_IPV6 dependency there.
