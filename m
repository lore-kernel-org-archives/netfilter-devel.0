Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A7BEB64D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Jun 2023 11:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbjFPLce (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Jun 2023 07:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjFPLcd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jun 2023 07:32:33 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7D82710
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jun 2023 04:32:31 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qA7gq-0001CW-D8; Fri, 16 Jun 2023 13:32:28 +0200
Date:   Fri, 16 Jun 2023 13:32:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables v2] man: string: document BM false negatives
Message-ID: <ZIxITN9d5jDJ+r6y@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>, Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20230611083805.622038-1-jeremy@azazel.net>
 <20230611113429.633616-1-jeremy@azazel.net>
 <6n8s5ns3-768n-q58p-9798-p67s64502358@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6n8s5ns3-768n-q58p-9798-p67s64502358@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 11, 2023 at 02:07:57PM +0200, Jan Engelhardt wrote:
> On Sunday 2023-06-11 13:34, Jeremy Sowden wrote:
> 
> > iptables \-p udp \-\-dport 53 \-m string \-\-algo bm \-\-from 40 \-\-to 57 \-\-hex\-string '|03|www|09|netfilter|03|org|00|'
> >+.P
> >+NB since Boyer-Moore (BM) performs searches for matches from right to left and
> >+the kernel may store a packet in multiple discontiguous blocks, it's possible
> >+that a match could be spread over multiple blocks, in which case this algorithm
> >+won't find it.
> 
> It was better when it just said "Note" instead of NB (notebook, nota bene)

Applied after s/NB/Note:/, thanks everyone!
