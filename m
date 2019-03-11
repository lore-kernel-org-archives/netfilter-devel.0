Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CAFC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 13:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F5E8206BA
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 13:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfCKNpX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:45:23 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42686 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727320AbfCKNpW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 09:45:22 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h3LF2-0003Dd-Nx; Mon, 11 Mar 2019 14:45:20 +0100
Date:   Mon, 11 Mar 2019 14:45:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: return immediately on empty
 commit
Message-ID: <20190311134520.n5czfeauq4efh3ua@breakpoint.cc>
References: <20190307222011.25091-1-fw@strlen.de>
 <20190311131300.45t6rdmz25ff3kid@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311131300.45t6rdmz25ff3kid@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> term1# nft add table x
> term1# nft add table x
> 
> term2# nft monitor
> add table ip x
> # new generation 1587 by process 14422 (nft)
> # new generation 1588 by process 14423 (nft)
> 
> So re-insertion of existing objects should not trigger unnecessary
> generation counter bump. We can probably count the number of events
> that have been sent from the commit path before we bump it.

Thats strange.  Why does the second add result in the creation
of a transaction object in the first place?

2nd add should result in a call to "upd_table", and it should
find that no attributes are being changed, and no transaction
object should be created, i.e. the commit should end up with
empty transaction list.
