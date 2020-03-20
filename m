Return-Path: <SRS0=s0US=5F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089C4C4332B
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 13:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5BD92070A
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 13:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgCTNDl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Mar 2020 09:03:41 -0400
Received: from correo.us.es ([193.147.175.20]:59718 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgCTNDl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Mar 2020 09:03:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D1E8B19190A
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2020 14:03:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C347CDA3AA
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2020 14:03:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B8E8ADA3A9; Fri, 20 Mar 2020 14:03:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6407DA38F;
        Fri, 20 Mar 2020 14:03:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Mar 2020 14:03:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9682042EE38E;
        Fri, 20 Mar 2020 14:03:05 +0100 (CET)
Date:   Fri, 20 Mar 2020 14:03:36 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter:nf_flow_table: add HW stats type
 support in flowtable
Message-ID: <20200320130336.4ypzwv7ri6rac3rn@salvia>
References: <1584689657-17280-1-git-send-email-wenxu@ucloud.cn>
 <20200320121048.siaonqjufl4btb72@salvia>
 <84bc5ac8-0f3c-c609-84e0-035bdd979c6d@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84bc5ac8-0f3c-c609-84e0-035bdd979c6d@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 20, 2020 at 08:36:17PM +0800, wenxu wrote:
> 
> 在 2020/3/20 20:10, Pablo Neira Ayuso 写道:
> > On Fri, Mar 20, 2020 at 03:34:17PM +0800, wenxu@ucloud.cn wrote:
> > [...]
> > > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > > index ad54931..60289a6 100644
> > > --- a/net/netfilter/nf_flow_table_offload.c
> > > +++ b/net/netfilter/nf_flow_table_offload.c
> > > @@ -165,8 +165,16 @@ static void flow_offload_mangle(struct flow_action_entry *entry,
> > >   flow_action_entry_next(struct nf_flow_rule *flow_rule)
> > >   {
> > >   	int i = flow_rule->rule->action.num_entries++;
> > > +	struct flow_action_entry *entry;
> > > +
> > > +	BUILD_BUG_ON(NFTA_HW_STATS_TYPE_ANY != FLOW_ACTION_HW_STATS_ANY);
> > > +	BUILD_BUG_ON(NFTA_HW_STATS_TYPE_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
> > > +	BUILD_BUG_ON(NFTA_HW_STATS_TYPE_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
> > > +
> > > +	entry = &flow_rule->rule->action.entries[i];
> > > +	entry->hw_stats_type = flow_rule->hw_stats_type;
> > Please, use FLOW_ACTION_HW_STATS_ANY by now. Remove the uapi code,
> > from this patch.
> > 
> > I'm not sure how users will be using this new knob.
> > 
> > At this stage, I think the drivers knows much better what type to pick
> > than the user.
> Yes, I agree.
> > 
> > You also have to explain me how you are testing things.
> 
> I test the flowtable offload with mlnx driver. ALL the flow add in driver
> failed for checking

Thank you for explaining.

> the hw_stats_type of flow action.
> 
> 
> static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>                                 struct flow_action *flow_action,
>                                 struct mlx5e_tc_flow *flow,
>                                 struct netlink_ext_ack *extack)
> {
>         ................
> 
> 
>         if (!flow_action_hw_stats_check(flow_action, extack,
> FLOW_ACTION_HW_STATS_DELAYED_BIT))
>                 return -EOPNOTSUPP;
> 
> Indeed always set the hw_stats_type of flow_action to
> FLOW_ACTION_HW_STATS_ANY can fix this.

Please, do so and do not expose a knob for this yet.

> But maybe it can provide a knob for user? Curently with this patch
> the user don't need set any value with default value
> FLOW_ACTION_HW_STATS in the kernel.

My understanding is that hardware has no way to expose how many
delayed/immediate counters are available. Users will have to pick
based on something it does not know.

Many knobs in the kernel are just exposed because developers really do
not know how to autoselect the best tuning for their subsystem and
they assume users will know better.
