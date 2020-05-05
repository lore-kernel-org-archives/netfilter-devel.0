Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E46C47247
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 19:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EE102068E
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 19:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgEETbu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 15:31:50 -0400
Received: from correo.us.es ([193.147.175.20]:34316 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgEETbu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 15:31:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9FFC0508CCE
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:31:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8E838115417
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:31:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 84057115416; Tue,  5 May 2020 21:31:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A49F2004A;
        Tue,  5 May 2020 21:31:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 05 May 2020 21:31:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2A68142EE38E;
        Tue,  5 May 2020 21:31:46 +0200 (CEST)
Date:   Tue, 5 May 2020 21:31:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us, ecree@solarflare.com
Subject: Re: [PATCH net,v2] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200505193145.GA9789@salvia>
References: <20200505174736.29414-1-pablo@netfilter.org>
 <20200505114010.132abebd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505114010.132abebd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 05, 2020 at 11:40:10AM -0700, Jakub Kicinski wrote:
> On Tue,  5 May 2020 19:47:36 +0200 Pablo Neira Ayuso wrote:
> > This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
> > that the frontend does not need counters, this hw stats type request
> > never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly requests
> > the driver to disable the stats, however, if the driver cannot disable
> > counters, it bails out.
> > 
> > TCA_ACT_HW_STATS_* maintains the 1:1 mapping with FLOW_ACTION_HW_STATS_*
> > except by disabled which is mapped to FLOW_ACTION_HW_STATS_DISABLED
> > (this is 0 in tc). Add tc_act_hw_stats() to perform the mapping between
> > TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*.
> > 
> > Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: define FLOW_ACTION_HW_STATS_DISABLED at the end of the enumeration
> >     as Jiri suggested. Keep the 1:1 mapping between TCA_ACT_HW_STATS_*
> >     and FLOW_ACTION_HW_STATS_* except by the disabled case.
> > 
> >  include/net/flow_offload.h |  9 ++++++++-
> >  net/sched/cls_api.c        | 14 ++++++++++++--
> >  2 files changed, 20 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> > index 3619c6acf60f..efc8350b42fb 100644
> > --- a/include/net/flow_offload.h
> > +++ b/include/net/flow_offload.h
> > @@ -166,15 +166,18 @@ enum flow_action_mangle_base {
> >  enum flow_action_hw_stats_bit {
> >  	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
> >  	FLOW_ACTION_HW_STATS_DELAYED_BIT,
> > +	FLOW_ACTION_HW_STATS_DISABLED_BIT,
> >  };
> >  
> >  enum flow_action_hw_stats {
> > -	FLOW_ACTION_HW_STATS_DISABLED = 0,
> > +	FLOW_ACTION_HW_STATS_DONT_CARE = 0,
> 
> Why not ~0? Or ANY | DISABLED? 
> Otherwise you may confuse drivers which check bit by bit.

I'm confused, you agreed with this behaviour:

https://lore.kernel.org/netfilter-devel/20200427111220.7b07aae1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/T/#m6091486b2b0ddac512fe6c17f5508f280f630b60
