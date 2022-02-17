Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF0BC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Feb 2022 23:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiBQXzZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Feb 2022 18:55:25 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiBQXzZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Feb 2022 18:55:25 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3A2411171;
        Thu, 17 Feb 2022 15:55:08 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0980F601F9;
        Fri, 18 Feb 2022 00:54:24 +0100 (CET)
Date:   Fri, 18 Feb 2022 00:55:04 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Paul Blakey <paulb@nvidia.com>, dev@openvswitch.org,
        netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        davem@davemloft.net, Jiri Pirko <jiri@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>, coreteam@netfilter.org
Subject: Re: [PATCH net 1/1] net/sched: act_ct: Fix flow table lookup failure
 with no originating ifindex
Message-ID: <Yg7gWIrIlGDDiVer@salvia>
References: <20220217093424.23601-1-paulb@nvidia.com>
 <Yg5Tz5ucVAI3zOTs@salvia>
 <20220217232708.yhigtv2ssrlfsexs@t14s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220217232708.yhigtv2ssrlfsexs@t14s.localdomain>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Feb 17, 2022 at 08:27:08PM -0300, Marcelo Ricardo Leitner wrote:
> On Thu, Feb 17, 2022 at 02:55:27PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Feb 17, 2022 at 11:34:24AM +0200, Paul Blakey wrote:
> > > After cited commit optimizted hw insertion, flow table entries are
> > > populated with ifindex information which was intended to only be used
> > > for HW offload. This tuple ifindex is hashed in the flow table key, so
> > > it must be filled for lookup to be successful. But tuple ifindex is only
> > > relevant for the netfilter flowtables (nft), so it's not filled in
> > > act_ct flow table lookup, resulting in lookup failure, and no SW
> > > offload and no offload teardown for TCP connection FIN/RST packets.
> > > 
> > > To fix this, allow flow tables that don't hash the ifindex.
> > > Netfilter flow tables will keep using ifindex for a more specific
> > > offload, while act_ct will not.
> > 
> > Using iif == zero should be enough to specify not set?
> 
> You mean, when searching, if search input iif == zero, to simply not
> check it? That seems dangerous somehow.

dev_new_index() does not allocate ifindex as zero.

Anyway, @Paul: could you add a tc_ifidx field instead in the union
right after __hash instead to fix 9795ded7f924?

Thanks.
