Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2BA2C10F11
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 00:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB276208E4
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 00:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfDYAyC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Apr 2019 20:54:02 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40310 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726455AbfDYAyC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Apr 2019 20:54:02 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hJSeG-0006Nj-Mc; Thu, 25 Apr 2019 02:54:00 +0200
Date:   Thu, 25 Apr 2019 02:54:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Brett Mastbergen <bmastbergen@untangle.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nft_ct: Add ct id support
Message-ID: <20190425005400.l4mlc3k4yvfo57hw@breakpoint.cc>
References: <20190424144844.20345-1-bmastbergen@untangle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424144844.20345-1-bmastbergen@untangle.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Brett Mastbergen <bmastbergen@untangle.com> wrote:
> The 'id' key returns the unique id of the conntrack entry as returned
> by nf_ct_get_id()
> 
> v2: Add nfct_is_confirmed check
> 
> Signed-off-by: Brett Mastbergen <bmastbergen@untangle.com>

Acked-by: Florian Westphal <fw@strlen.de>
