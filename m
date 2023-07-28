Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95148C001E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 19:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjG1T4R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjG1T4R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 15:56:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1083C07
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 12:56:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qPTZO-0004z9-Sq
        for netfilter-devel@vger.kernel.org; Fri, 28 Jul 2023 21:56:14 +0200
Date:   Fri, 28 Jul 2023 21:56:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: nftables: syntax ambiguity with objref map and ct helper objects
Message-ID: <20230728195614.GA18109@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I wanted to allow creating objref maps that
return "ct timeout" or "ct helper" templates.

However:
  map .. {
    type ipv4_addr : ct timeout

  The above is fine, but this is not:

  map .. {
    type ipv4_addr : ct helper


It caues ambiguity in parser due to existing
"ct helper" expression, as in
"nft describe ct helper", not the freestanding
objref name.

I could just allow:
    type ipv4_addr : helper

... without "ct", but then we'd require different
keywords for the definition and the use as data
element in the key definition, and its inconsistent
with "ct timeout".

Should we add a new explicit keyword for
*both* objref names and the data element usage?

Perhaps:

object type ct helper "sip-external" {
    ....

And
    type ipv4_addr : object type ct helper

?

Any better ideas or suggesions on a sane syntax to avoid this?
