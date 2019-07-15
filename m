Return-Path: <SRS0=suf1=VM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C61FC7618F
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 19:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E3EB20665
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 19:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732020AbfGOTyH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 15:54:07 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:53060 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729525AbfGOTyH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 15:54:07 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hn72z-0008B0-Mf; Mon, 15 Jul 2019 21:54:05 +0200
Date:   Mon, 15 Jul 2019 21:54:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_dynset: support for element deletion
Message-ID: <20190715195405.q26aslzk54kfwh4d@breakpoint.cc>
References: <20190713160302.31308-1-a@juaristi.eus>
 <20190713165940.gyqrhab4z3eookgl@breakpoint.cc>
 <3db3e09d-5e1e-5d12-0f96-f911eb40c769@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3db3e09d-5e1e-5d12-0f96-f911eb40c769@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> On 13/7/19 18:59, Florian Westphal wrote:
> > 
> >> +	if (he == NULL)
> >> +		return false;
> >> +
> >> +	rhashtable_remove_fast(&priv->ht, &he->node, nft_rhash_params);
> >> +	return true;
> > 
> > Perhaps add a small comment here that rhashtable_remove_fast retval
> > is ignored intentionally?
> > 
> > I.e., don't make this return false in case two cpus race to remove same
> > entry.
> 
> Hmm, this made me think. I don't know if this was all too intentional
> from me.
> 
> Maybe rather than ignoring it, it would be better to return true only if
> rhashtable_remove_fast returned 0, which will only happen if the element
> was actually deleted (locking is done internally so two cpus cannot race
> in there). Else, if return value is -ENOENT, we should return false.
> 
> And taking this reasoning further, maybe the initial call to
> rhashtable_lookup wouldn't be needed either?

You need it to obtain he->node, no?

Wrt. retval, I might be overthinking it indeed, so making this
a "return rhashtable_remove_fast() == 0;" seems fine too, saves the
comment :-)
