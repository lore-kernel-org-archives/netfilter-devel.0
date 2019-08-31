Return-Path: <SRS0=T6Q7=W3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B82C3A59F
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Aug 2019 10:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABC8822D37
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Aug 2019 10:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfHaKlB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 31 Aug 2019 06:41:01 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60334 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726062AbfHaKlB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 31 Aug 2019 06:41:01 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i40oW-0001Aq-5L; Sat, 31 Aug 2019 12:41:00 +0200
Date:   Sat, 31 Aug 2019 12:41:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nft_socket: fix erroneous socket
 assignment
Message-ID: <20190831104100.GV20113@breakpoint.cc>
References: <20190831101453.1869-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190831101453.1869-1-ffmancera@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> This socket assignment was unnecessary and also added a missing sock_gen_put().

The socket assignment is wrong, see skb_orphan():
When skb->destructor callback is not set, but skb->sk is set, this hits BUG().

You could add a 'Link: ' to the bugzilla ticket if you like.
Patch looks good, thanks for fixing this Fernando!
