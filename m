Return-Path: <SRS0=SeaY=TH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3FEC004C9
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 May 2019 13:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1614320825
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 May 2019 13:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfEGNru (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 May 2019 09:47:50 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:60290 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfEGNru (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 May 2019 09:47:50 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id C939425AD8B;
        Tue,  7 May 2019 23:47:47 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id C90589403F2; Tue,  7 May 2019 15:47:45 +0200 (CEST)
Date:   Tue, 7 May 2019 15:47:45 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com
Subject: Re: [PATCHv2 net-next 0/3] Add UDP tunnel support for ICMP errors in
 IPVS
Message-ID: <20190507134745.ljijkwuu63wiqwxi@verge.net.au>
References: <20190505121440.16389-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505121440.16389-1-ja@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 05, 2019 at 03:14:37PM +0300, Julian Anastasov wrote:
> This patchset is a followup to the commit that adds UDP/GUE tunnel:
> "ipvs: allow tunneling with gue encapsulation".
> 
> What we do is to put tunnel real servers in hash table (patch 1),
> add function to lookup tunnels (patch 2) and use it to strip the
> embedded tunnel headers from ICMP errors (patch 3).
> 
> v1->v2:
> patch 1: remove extra parentheses
> patch 2: remove extra parentheses
> patch 3: parse UDP header into ipvs_udp_decap
> patch 3: v1 ignores forwarded ICMP errors for UDP, do not do that
> patch 3: add comment for fragment check
> 
> Julian Anastasov (3):
>   ipvs: allow rs_table to contain different real server types
>   ipvs: add function to find tunnels
>   ipvs: strip udp tunnel headers from icmp errors

Thanks Julian,

this looks good for me.
For all patches:

Signed-off-by: Simon Horman <horms@verge.net.au>

Pablo, could you consider applying these to nf-next when appropriate?

