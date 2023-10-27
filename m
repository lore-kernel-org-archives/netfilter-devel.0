Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86825C25B67
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Oct 2023 11:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345713AbjJ0LKm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Oct 2023 07:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345705AbjJ0LKl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Oct 2023 07:10:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEE718F
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Oct 2023 04:10:35 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qwKjY-0005tu-Ng; Fri, 27 Oct 2023 13:10:32 +0200
Date:   Fri, 27 Oct 2023 13:10:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 07/10] man: grammar fixes to some manpages
Message-ID: <ZTuaqMniOXYLI23N@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
References: <20231026085506.94343-1-jengelh@inai.de>
 <20231026085506.94343-7-jengelh@inai.de>
 <ZTphOV/bYuotL2l0@orbyte.nwl.cc>
 <nn5s78o8-170p-rn49-97np-4082so7q1s20@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nn5s78o8-170p-rn49-97np-4082so7q1s20@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 26, 2023 at 05:10:07PM +0200, Jan Engelhardt wrote:
> On Thursday 2023-10-26 14:53, Phil Sutter wrote:
> >> diff --git a/extensions/libxt_MASQUERADE.man b/extensions/libxt_MASQUERADE.man
> >> index e2009086..7cc2bb7a 100644
> >> --- a/extensions/libxt_MASQUERADE.man
> >> +++ b/extensions/libxt_MASQUERADE.man
> >> @@ -15,7 +15,7 @@ any established connections are lost anyway).
> >>  \fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
> >>  This specifies a range of source ports to use, overriding the default
> >>  .B SNAT
> >> -source port-selection heuristics (see above).  This is only valid
> >> +source port-selection heuristics (see above). This is only valid
> >
> >Do you miss a dash in:
> >
> >"default SNAT source port selection heuristics"? I lean towards putting
> >dashes everywhere, but my language spoils me. ;)
> 
> Third time's the charm, hopefully?

Did you intentionally revert from '\[-]' back to '\-' in math formulae?
Apart from that, your updated series looks good to me.

Thanks, Phil
