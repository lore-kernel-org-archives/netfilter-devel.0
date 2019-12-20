Return-Path: <SRS0=tkBW=2K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E0DC43603
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 10:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1C9824679
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 10:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfLTKbg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 05:31:36 -0500
Received: from correo.us.es ([193.147.175.20]:44216 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbfLTKbg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 05:31:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C07DF20A53E
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2019 11:31:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1E57DA712
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2019 11:31:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B1018DA715; Fri, 20 Dec 2019 11:31:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9599DA712;
        Fri, 20 Dec 2019 11:31:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Dec 2019 11:31:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8B63242EF42D;
        Fri, 20 Dec 2019 11:31:31 +0100 (CET)
Date:   Fri, 20 Dec 2019 11:31:31 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2 1/3] netfilter: nf_flow_table_offload: fix
 dst_neigh lookup
Message-ID: <20191220103131.3lddvvq74yk4z3ay@salvia>
References: <1576572767-19779-1-git-send-email-wenxu@ucloud.cn>
 <1576572767-19779-2-git-send-email-wenxu@ucloud.cn>
 <20191219221816.rywke7de6izqrere@salvia>
 <25e03002-ba64-45aa-c94d-2588706ba6d8@ucloud.cn>
 <20191220091308.stmalopyx7cnmwxc@salvia>
 <3cfa870a-bb2b-5a8b-7c90-e11677d951ec@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3cfa870a-bb2b-5a8b-7c90-e11677d951ec@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 20, 2019 at 05:19:12PM +0800, wenxu wrote:
> 
> On 12/20/2019 5:13 PM, Pablo Neira Ayuso wrote:
> > On Fri, Dec 20, 2019 at 11:53:38AM +0800, wenxu wrote:
> >> Maybe the patch your suggestion is not correct?
> >>
> >> On 12/20/2019 6:18 AM, Pablo Neira Ayuso wrote:
> >>> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> >>> index 506aaaf8151d..8680fc56cd7c 100644
> >>> --- a/net/netfilter/nf_flow_table_offload.c
> >>> +++ b/net/netfilter/nf_flow_table_offload.c
> >>> @@ -156,14 +156,14 @@ static int flow_offload_eth_dst(struct net *net,
> >>>  				enum flow_offload_tuple_dir dir,
> >>>  				struct nf_flow_rule *flow_rule)
> >>>  {
> >>> -	const struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
> >>> +	const struct flow_offload_tuple *tuple = &flow->tuplehash[!dir].tuple;
> >>>  	struct flow_action_entry *entry0 = flow_action_entry_next(flow_rule);
> >>>  	struct flow_action_entry *entry1 = flow_action_entry_next(flow_rule);
> >>>  	struct neighbour *n;
> >>>  	u32 mask, val;
> >>>  	u16 val16;
> >>>  
> >>> -	n = dst_neigh_lookup(tuple->dst_cache, &tuple->dst_v4);
> >>> +	n = dst_neigh_lookup(tuple->dst_cache, &tuple->src_v4);
> >>                 The dst_cache should be flow->tuplehash[dir].tuple.dst_cache  but not peer dir's;
> > Hm, I think this is like your patch, but without the two extra new lines
> > and new variable definitions.
> 
> There is a little bit different. The dst_cache should get from  flow->tuplehash[dir].tuple.dst_cache
> 
> but not flow->tuplehash[!dir].tuple.dst_cache

                SNAT       mangling     ether dst
original        A -> B      C -> B      [!dir].src
reply           B -> C      B -> A      [!dir].src

                DNAT       mangling
original        A -> C      A -> B      [!dir].src
reply           B -> A      C -> A      [!dir].src

                SNAT+DNAT  mangling
original        A -> C2     C1 -> B     [!dir].src
reply           B -> C1     C2 -> A     [!dir].src
