Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC44CC48BD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 11:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEDEA20663
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 11:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfFZLMS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 07:12:18 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40150 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbfFZLMS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 07:12:18 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hg5qa-0001Ub-R4; Wed, 26 Jun 2019 13:12:16 +0200
Date:   Wed, 26 Jun 2019 13:12:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v6] netfilter: nf_tables: Add SYNPROXY support
Message-ID: <20190626111216.6va4t6nfkjkvof4a@breakpoint.cc>
References: <20190626105918.1142-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626105918.1142-1-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> Add SYNPROXY module support in nf_tables. It preserves the behaviour of the
> SYNPROXY target of iptables but structured in a different way to propose
> improvements in the future.

Looks good, thanks Fernando!

Just one note, this will cause conflicts with
https://patchwork.ozlabs.org/patch/1121798/

Normally this would need to wait until the fix has propagated to
nf-next.

Pablo, any suggestion on how to proceed?
I guess Fernando should resend a rebased v7 once the fix is in nf-next?
