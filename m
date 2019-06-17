Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99DDEC31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 16:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C3BE2084D
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 16:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfFQQ2p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 12:28:45 -0400
Received: from mail.us.es ([193.147.175.20]:36710 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbfFQQ2p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 12:28:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2F1B015AEA4
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 18:28:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1DFC7DA70D
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 18:28:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 13496DA70A; Mon, 17 Jun 2019 18:28:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EB984DA703;
        Mon, 17 Jun 2019 18:28:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Jun 2019 18:28:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C8BEC4265A2F;
        Mon, 17 Jun 2019 18:28:40 +0200 (CEST)
Date:   Mon, 17 Jun 2019 18:28:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        fw@strlen.de
Subject: Re: [PATCH nft 3/5] src: add cache level flags
Message-ID: <20190617162840.pqeyndnjwh4amzwx@salvia>
References: <20190617122518.10486-1-pablo@netfilter.org>
 <20190617122518.10486-3-pablo@netfilter.org>
 <20190617161104.GT31548@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617161104.GT31548@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 17, 2019 at 06:11:04PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Mon, Jun 17, 2019 at 02:25:16PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > -int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
> > +unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
> >  {
> > -	unsigned int echo_completeness = CMD_INVALID;
> > -	unsigned int completeness = CMD_INVALID;
> > +	unsigned int flags = NFT_CACHE_EMPTY;
> >  	struct cmd *cmd;
> >  
> >  	list_for_each_entry(cmd, cmds, list) {
> >  		switch (cmd->op) {
> >  		case CMD_ADD:
> >  		case CMD_INSERT:
> > -		case CMD_REPLACE:
> > -			if (nft_output_echo(&nft->output))
> > -				echo_completeness = cmd->op;
> > -
> > +			flags |= NFT_CACHE_TABLE |
> > +				 NFT_CACHE_CHAIN |
> > +				 NFT_CACHE_SET |
> > +				 NFT_CACHE_FLOWTABLE |
> > +				 NFT_CACHE_OBJECT;
> 
> This means we start fetching the cache for simple 'add rule' commands
> again, right?

We need these for references to sets, eg.

        add rule x y ip saddr @x

same for other flowtable and object.

We should not use NFT_CACHE_RULE in this case, if this is what you
suggest.
