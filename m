Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5442DC3567B
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 10:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 306E920836
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 10:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbgBXKQu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 05:16:50 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48600 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727302AbgBXKQt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 05:16:49 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j6AnA-0008Lf-OX; Mon, 24 Feb 2020 11:16:48 +0100
Date:   Mon, 24 Feb 2020 11:16:48 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH libnetfilter_queue] src: add nfq_get_skbinfo()
Message-ID: <20200224101648.GF19559@breakpoint.cc>
References: <20200223234941.44877-1-fw@strlen.de>
 <20200224010344.GA3564@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224010344.GA3564@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> Can I suggest:
> 
>   > + *   example because this is an incoming packet and the NIC does not
>   > + *   perform checksum validation at hardware level.
> - > + * See nfq_set_queue_flags() documentation for more information.
>   > + *
>   > + * \return the skbinfo value
> + > + * \sa __nfq_set_queue_flags__(3)
>   > + */
>   > +EXPORT_SYMBOL
> 
> I think this will look better, especially on the man page.

Its does, thanks.  I've made this change in my local tree.
