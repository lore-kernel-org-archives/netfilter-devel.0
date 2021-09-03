Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB391C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Sep 2021 12:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D67560249
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Sep 2021 12:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbhICM7a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Sep 2021 08:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbhICM73 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Sep 2021 08:59:29 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14894C061575
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Sep 2021 05:58:30 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mM8m4-0007eL-GT; Fri, 03 Sep 2021 14:58:28 +0200
Date:   Fri, 3 Sep 2021 14:58:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] Fix a few doc typos
Message-ID: <20210903125828.GL7616@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20210902113359.2369296-1-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210902113359.2369296-1-snemec@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 02, 2021 at 01:33:59PM +0200, Štěpán Němec wrote:
> Signed-off-by: Štěpán Němec <snemec@redhat.com>

Applied after adding a few words as description (between subject and
SoB).

Thanks, Phil
