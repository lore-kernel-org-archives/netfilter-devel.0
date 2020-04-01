Return-Path: <SRS0=ovZY=5R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE6AC10F26
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 13:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79A12206E9
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 13:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732678AbgDAND0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 09:03:26 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:58774 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732252AbgDANDZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 09:03:25 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id AFBE225B779;
        Thu,  2 Apr 2020 00:03:22 +1100 (AEDT)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 28A1C67C; Wed,  1 Apr 2020 15:03:20 +0200 (CEST)
Date:   Wed, 1 Apr 2020 15:03:20 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Julian Anastasov <ja@ssi.bg>,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ipvs: optimize tunnel dumps for icmp errors
Message-ID: <20200401130319.GG29376@vergenet.net>
References: <1584278741-13944-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
 <alpine.LFD.2.21.2003181333460.4911@ja.home.ssi.bg>
 <20200326140229.emeplg75xszpd7rs@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326140229.emeplg75xszpd7rs@salvia>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 26, 2020 at 03:02:29PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 18, 2020 at 01:36:32PM +0200, Julian Anastasov wrote:
> > 
> > 	Hello,
> > 
> > On Sun, 15 Mar 2020, Haishuang Yan wrote:
> > 
> > > After strip GRE/UDP tunnel header for icmp errors, it's better to show
> > > "GRE/UDP" instead of "IPIP" in debug message.
> > > 
> > > Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
> > 
> > 	Looks good to me, thanks!
> > 
> > Acked-by: Julian Anastasov <ja@ssi.bg>
> > 
> > 	Simon, this is for -next kernels...
> 
> Simon, if no objection, I'm going to include this in the next nf-next
> pull request.
> 

Sorry for being slow, I have no objections.
