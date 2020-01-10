Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CD1C33CA2
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 13:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8693B2072E
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 13:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgAJNH1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 08:07:27 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:35206 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727301AbgAJNH1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 08:07:27 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ipu0b-0004kd-EV; Fri, 10 Jan 2020 14:07:25 +0100
Date:   Fri, 10 Jan 2020 14:07:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: better error notice when interval flag is
 not set on
Message-ID: <20200110130725.GQ20229@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200110105546.241847-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110105546.241847-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 10, 2020 at 11:55:46AM +0100, Pablo Neira Ayuso wrote:
> Users get confused with the existing error notice, let's try a different one:
> 
>  # nft add element x y { 1.1.1.0/24 }
>  Error: You must add 'flags interval' to your set declaration if you want to add prefix elements
>  add element x y { 1.1.1.0/24 }
>                    ^^^^^^^^^^

Not sure why "missing inverval flag on declaration" is more confusing
than "you must add 'flags interval' to ...", but maybe I'm just too much
into the topic to notice the difference. :)

> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1395

Unrelated? Did you pick the wrong ticket ID?

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Except for nfbz link:

Acked-by: Phil Sutter <phil@nwl.cc>
