Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E514DC43218
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0CC820651
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfDZQMW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:12:22 -0400
Received: from mail.us.es ([193.147.175.20]:47988 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbfDZQMV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 12:12:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 34BE0B6C6C
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 18:12:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25EEADA701
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 18:12:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 076D2DA70A; Fri, 26 Apr 2019 18:12:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C196EDA705;
        Fri, 26 Apr 2019 18:12:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 18:12:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9B7044265A32;
        Fri, 26 Apr 2019 18:12:16 +0200 (CEST)
Date:   Fri, 26 Apr 2019 18:12:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@mellanox.com,
        john.hurley@netronome.com, jakub.kicinski@netronome.com,
        ogerlitz@mellanox.com
Subject: Re: [PATCH net-next,RFC 7/9] net: use tcf_block_setup()
 infrastructure
Message-ID: <20190426161216.36i6aqv3hdk3jwnj@salvia>
References: <20190426003348.30745-1-pablo@netfilter.org>
 <20190426003348.30745-8-pablo@netfilter.org>
 <20190426142715.GB2249@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426142715.GB2249@nanopsycho.orion>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 26, 2019 at 04:27:15PM +0200, Jiri Pirko wrote:
> Fri, Apr 26, 2019 at 02:33:44AM CEST, pablo@netfilter.org wrote:
> >This allows us to register / unregister tcf_block_cb objects from the
> >core. The idea is to allocate the tcf_block_cb object from the driver,
> >attach it to the tc_block_offload->cb_list, then the core registers
> >them.
> >
> >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> >---
> 
> [...]
> 
> 
> >--- a/net/dsa/slave.c
> >+++ b/net/dsa/slave.c
> >@@ -902,6 +902,7 @@ static int dsa_slave_setup_tc_block_cb_eg(enum tc_setup_type type,
> > static int dsa_slave_setup_tc_block(struct net_device *dev,
> > 				    struct tc_block_offload *f)
> > {
> >+	struct tcf_block_cb *block_cb;
> > 	tc_setup_cb_t *cb;
> > 
> > 	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
> >@@ -913,9 +914,19 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
> > 
> > 	switch (f->command) {
> > 	case TC_BLOCK_BIND:
> >-		return tcf_block_cb_register(f->block, cb, dev, dev, f->extack);
> >+		block_cb = tcf_block_cb_alloc(f->block->index, cb, dev, dev,
> >+					      NULL);
> >+		if (!block_cb)
> >+			return -ENOMEM;
> >+
> >+		tcf_block_cb_list_add(block_cb, &f->cb_list);
> >+		return 0;
> > 	case TC_BLOCK_UNBIND:
> >-		tcf_block_cb_unregister(f->block, cb, dev);
> >+		block_cb = tcf_block_cb_lookup(f->block->index, cb, dev);
> >+		if (!block_cb)
> >+			return -ENOENT;
> >+
> >+		tcf_block_cb_list_move(block_cb, &f->cb_list);
> 
> What you are trying to achieve with list_move here, wrapped by
> tcf_block_cb_list_move() for some reason is a mystery for me.
> You are moving to &f->cb_list, but you are already there...
> 
> The whole work with lists here, including tcf_block_cb_list is very
> confusing for me.

The f->cb_list is a temporary list. The block_cb's are traveling back
to core through this list. Then, tcf_block_setup() takes these blocks
in this f->cb_list and place them in the right per-block and the
global block list.

So, instead of placing the block_cb's in the block list from the
driver, the driver just places block_cb in this temporary list, so the
core (either tc or netfilter) is responsible for attaching this to
either tcf_block or nft_chain.
