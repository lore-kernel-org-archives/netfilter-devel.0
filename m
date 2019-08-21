Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6038AC3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 11:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B99F22CE3
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 11:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfHULN7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 07:13:59 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39876 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfHULN7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 07:13:59 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i0OYw-0003ZV-2H; Wed, 21 Aug 2019 13:13:58 +0200
Date:   Wed, 21 Aug 2019 13:13:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Christian Ehrhardt <christian.ehrhardt@canonical.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC 1/1] nft: abort cache creation if mnl_genid_get fails
Message-ID: <20190821111358.GB13057@breakpoint.cc>
References: <20190821075611.30918-1-christian.ehrhardt@canonical.com>
 <20190821075611.30918-2-christian.ehrhardt@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821075611.30918-2-christian.ehrhardt@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Christian Ehrhardt <christian.ehrhardt@canonical.com> wrote:
> mnl_genid_get can fail and in this case not update the genid which leads
> to a busy loop that never recovers.
> 
> To avoid that check the return value and abort __nft_build_cache
> if mnl_genid_get fails.

mnl_genid_get() aborts in case there is an error from mnl_talk in
iptables.git master branch.

See
commit e5cab728c40be88c541f68e4601d39178c36111f
nft: exit in case we can't fetch current genid

So I don't think this change is needed.

In the reported case this happened when calling iptables with
non-root user.
