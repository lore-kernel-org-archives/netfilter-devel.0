Return-Path: <SRS0=PMCV=CL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D43C433E2
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Sep 2020 14:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EBA620773
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Sep 2020 14:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgIBOZl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Sep 2020 10:25:41 -0400
Received: from correo.us.es ([193.147.175.20]:35524 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727866AbgIBOZX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Sep 2020 10:25:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5851915C10A
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2020 16:25:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4B6C7DA78F
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2020 16:25:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3F9EFDA789; Wed,  2 Sep 2020 16:25:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33F9CDA704;
        Wed,  2 Sep 2020 16:25:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 02 Sep 2020 16:25:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 15C9442EF42C;
        Wed,  2 Sep 2020 16:25:15 +0200 (CEST)
Date:   Wed, 2 Sep 2020 16:25:14 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        fw@strlen.de, eric@garver.life
Subject: Re: [PATCH] netfilter: nf_tables: coalesce multiple notifications
 into one skbuff
Message-ID: <20200902142514.GA6210@salvia>
References: <20200827172842.24478-1-pablo@netfilter.org>
 <20200902141639.GD23632@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200902141639.GD23632@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 02, 2020 at 04:16:39PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Thu, Aug 27, 2020 at 07:28:42PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > +static void nft_commit_notify(struct net *net, u32 portid)
> > +{
> > +	struct sk_buff *batch_skb = NULL, *nskb, *skb;
> > +	unsigned char *data;
> > +	int len;
> > +
> > +	list_for_each_entry_safe(skb, nskb, &net->nft.notify_list, list) {
> > +		if (!batch_skb) {
> > +new_batch:
> > +			batch_skb = skb;
> > +			NFT_CB(batch_skb).report = NFT_CB(skb).report;
> > +			len = NLMSG_GOODSIZE;
> 
> This doesn't account for the data in the first skb. After changing the
> line into 'len = NLMSG_GOODSIZE - skb->len;', the reported problem
> disappears and the patch works as expected.

Thanks for narrowing down the problem.

I'll send a v2 including this update.
