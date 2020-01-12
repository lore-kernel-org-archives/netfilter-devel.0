Return-Path: <SRS0=PXZA=3B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E4DC32771
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Jan 2020 10:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7DA521744
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Jan 2020 10:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732616AbgALKkc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Jan 2020 05:40:32 -0500
Received: from correo.us.es ([193.147.175.20]:44782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732614AbgALKkc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Jan 2020 05:40:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C917DA73F
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jan 2020 11:40:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D2F4DA703
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jan 2020 11:40:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 82D54DA709; Sun, 12 Jan 2020 11:40:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A9A4DA703;
        Sun, 12 Jan 2020 11:40:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 12 Jan 2020 11:40:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6E7274251480;
        Sun, 12 Jan 2020 11:40:27 +0100 (CET)
Date:   Sun, 12 Jan 2020 11:40:27 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/3] libnftables: add nft_ctx_set_netns()
Message-ID: <20200112104027.ijjcv34glvnkhnvc@salvia>
References: <20200109172115.229723-1-pablo@netfilter.org>
 <20200109172115.229723-2-pablo@netfilter.org>
 <20200110125311.GP20229@orbyte.nwl.cc>
 <20200112102802.7bvwieqaza3zdbza@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200112102802.7bvwieqaza3zdbza@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jan 12, 2020 at 11:28:02AM +0100, Pablo Neira Ayuso wrote:
> On Fri, Jan 10, 2020 at 01:53:11PM +0100, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Thu, Jan 09, 2020 at 06:21:13PM +0100, Pablo Neira Ayuso wrote:
> > [...]
> > > diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
> > > index 765b20dd71ee..887628959ac6 100644
> > > --- a/include/nftables/libnftables.h
> > > +++ b/include/nftables/libnftables.h
> > > @@ -34,10 +34,13 @@ enum nft_debug_level {
> > >   * Possible flags to pass to nft_ctx_new()
> > >   */
> > >  #define NFT_CTX_DEFAULT		0
> > > +#define NFT_CTX_NETNS		1
> > 
> > What is this needed for?
> 
> The socket is initialized from nft_ctx_init(), and such initialization
> needs to happen after the netns switch.

s/nft_ctx_init()/nft_ctx_new()

> > >  struct nft_ctx *nft_ctx_new(uint32_t flags);
> > >  void nft_ctx_free(struct nft_ctx *ctx);
> > >  
> > > +int nft_ctx_set_netns(struct nft_ctx *ctx, const char *netns);
> > 
> > Is there a way to select init ns again?
> 
> AFAIK, setns() does not let you go back to init ns once set.
