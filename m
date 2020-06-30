Return-Path: <SRS0=CJVJ=AL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8DC2C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jun 2020 15:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9168820663
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jun 2020 15:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389358AbgF3PXw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:23:52 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:54636 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387869AbgF3PXw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jun 2020 11:23:52 -0400
Received: from madeliefje.horms.nl (unknown [83.161.246.101])
        by kirsty.vergenet.net (Postfix) with ESMTPA id A06C725B73E;
        Wed,  1 Jul 2020 01:23:50 +1000 (AEST)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id B58FC2E4F; Tue, 30 Jun 2020 17:23:48 +0200 (CEST)
Date:   Tue, 30 Jun 2020 17:23:48 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] ipvs: register hooks only with services
Message-ID: <20200630152348.GB12560@vergenet.net>
References: <20200621154030.10998-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200621154030.10998-1-ja@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 21, 2020 at 06:40:30PM +0300, Julian Anastasov wrote:
> Keep the IPVS hooks registered in Netfilter only
> while there are configured virtual services. This
> saves CPU cycles while IPVS is loaded but not used.
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>

Thanks Julian, this looks good to me.

Reviewed-by: Simon Horman <horms@verge.net.au>

Pablo, could you consider this for nf-next?
