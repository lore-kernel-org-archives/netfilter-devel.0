Return-Path: <SRS0=aNn+=SO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FECC10F0E
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 08:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E4C020818
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 08:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfDLIJ3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 04:09:29 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40426 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725973AbfDLIJ3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 04:09:29 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hErFQ-0007Ot-Rp; Fri, 12 Apr 2019 10:09:20 +0200
Date:   Fri, 12 Apr 2019 10:09:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Sinan Kaya <okaya@kernel.org>
Cc:     linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        keescook@chromium.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 5/5] net: Replace CONFIG_DEBUG_KERNEL with
 CONFIG_DEBUG_MISC
Message-ID: <20190412080920.wusq2va6zdbsf3v7@breakpoint.cc>
References: <20190412014355.25307-1-okaya@kernel.org>
 <20190412014355.25307-6-okaya@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190412014355.25307-6-okaya@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sinan Kaya <okaya@kernel.org> wrote:
> CONFIG_DEBUG_KERNEL should not impact code generation. Use the newly
> defined CONFIG_DEBUG_MISC instead to keep the current code.

Acked-by: Florian Westphal <fw@strlen.de>
