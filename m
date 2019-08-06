Return-Path: <SRS0=eApp=WC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F50C31E40
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Aug 2019 13:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93759208C3
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Aug 2019 13:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfHFNso (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 09:48:44 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48698 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726373AbfHFNso (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 09:48:44 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1huzpP-0002Uo-Ri; Tue, 06 Aug 2019 15:48:39 +0200
Date:   Tue, 6 Aug 2019 15:48:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC nf-next] Introducing stateful object update operation
Message-ID: <20190806134839.6o2dpp5e375pnkrf@breakpoint.cc>
References: <20190806102945.728-1-ffmancera@riseup.net>
 <20190806110648.khukqwbmxgbk5yfr@salvia>
 <146bb849-c4cf-1c88-cacf-fa909a626cac@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <146bb849-c4cf-1c88-cacf-fa909a626cac@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> > Use the existing nf_tables_newobj(), if NLM_F_EXCL is not set on and
> > the object exists, then this is an update.
> 
> I agree on that. But I think that if we use the NFT_MSG_NEWOBJ there
> will be some issues in the commit and the abort phase. That is why I
> think "NFT_MSG_UPDOBJ" would be needed.

See e.g. 'nft_trans_table_update()' -- we already do this for
other structures/entities.  You would need to extend the object handling
to not remove an already-existed-object in case of an update if an abort
is triggered.
