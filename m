Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A54C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFBEB208CA
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfDZQ2m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:28:42 -0400
Received: from mail.us.es ([193.147.175.20]:52140 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbfDZQ2l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 12:28:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A20A5B6C64
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 18:28:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90DCBDA716
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 18:28:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 81553DA709; Fri, 26 Apr 2019 18:28:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F737DA70B;
        Fri, 26 Apr 2019 18:28:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 18:28:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3CC864265A31;
        Fri, 26 Apr 2019 18:28:37 +0200 (CEST)
Date:   Fri, 26 Apr 2019 18:28:36 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@mellanox.com,
        john.hurley@netronome.com, jakub.kicinski@netronome.com,
        ogerlitz@mellanox.com
Subject: Re: [PATCH net-next,RFC 0/9] net: sched: prepare to reuse per-block
 callbacks from netfilter
Message-ID: <20190426162836.6hy7q42b6itckzff@salvia>
References: <20190426003348.30745-1-pablo@netfilter.org>
 <20190426143258.GC2249@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426143258.GC2249@nanopsycho.orion>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 26, 2019 at 04:32:58PM +0200, Jiri Pirko wrote:
> Fri, Apr 26, 2019 at 02:33:37AM CEST, pablo@netfilter.org wrote:
> >Hi,
> >
> >This patchset aims to introduce changes to reuse the existing .ndo_setup_tc
> >netdev operations from netfilter.
> >
> >The idea is to move tcf_block_cb to net/core/flow_offload.c and rename
> >it to flow_block_cb. This object provides the minimal infrastructure to
> >set up per-block callbacks that are called to offload policies to
> >hardware.
> >
> >The tcf_block object is specific for TC to share policies between
> >ingress devices. This object has a list of tcf_block_cb objects that are
> >called to offload the policies to hardware. In netfilter, the idea is to
> >store the list of tcf_block_cb objects in a chain that would be bound to
> >several devices, eg.
> >
> >  chain x {
> >	type filter hook ingress devices = { eth0, eth1 } priority 0;
> >	...
> >  }
> >
> 
> Do you have the follow-up patchset somewhere? I'm curius about your
> goal. Without that, it is hard to understand what you are getting at.

Goal is to use the TC_SETUP_BLOCK logic in the existing drivers from
netfilter. So Netfilter calls TC_SETUP_BLOCK by when a chain is set up
to configure the driver, hence reuse your whole logic with minimal
changes.

Currently, the tcf_block_cb_register() call assumes there's a
tcf_block object in place and it internally invokes the tc
.reoffload() callback. This tcf_block corresponds to the nft_chain
object in netfilter, and I need to add my own .reoffload() callback
for the nft_chain object. This patch uses the block_index instead from
the driver, instead of exposing tcf_block.

This patchset updates the TC_SETUP_BLOCK path to only configure the
block_cb objects. The registration is done from the core, by iterating
the list of block_cb's that the driver offers in the temporary
tc_block_offload->cb_list, and then iterate over that list and
register them from the core.

My patchset moves the tcf_block_cb object to net/core/flow_offload.c
(it renames it to flow_block_cb) so it can be used both by tc and
netfilter.

Follow up patchset in netfilter calls TC_SETUP_BLOCK when the offloadi
flag is set on. Then, it has its own version of tc_setup_cb_call(),
which iterates over the block_cb() in this chain to reuse existing
driver codebase.

> >Hence, this emulates the shared blocks available in TC that Jiri made.
> >
> >Note that the list of tcf_block_cb objects will be called to offload
> >policies in this chain.
> 
> So you are going to use chain_id (if there is anything like that) as
> block_index during offload, right?

Yes. But I don't need to expose this chain_index to userspace though,
I can internally allocate it, I only need to make sure it does not
overlap with any of the existing tc block_indexed. I can just use a
different index space which does not overlap with the tc block index
space.

Thanks.
