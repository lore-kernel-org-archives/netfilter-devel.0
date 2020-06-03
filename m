Return-Path: <SRS0=kXi6=7Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096AAC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jun 2020 17:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3B8E2053B
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jun 2020 17:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgFCRq5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jun 2020 13:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgFCRq5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jun 2020 13:46:57 -0400
X-Greylist: delayed 1606 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 03 Jun 2020 10:46:56 PDT
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AA3C08C5C0;
        Wed,  3 Jun 2020 10:46:56 -0700 (PDT)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1jgX3c-0008EW-Ky; Wed, 03 Jun 2020 19:20:04 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.93)
        (envelope-from <laforge@gnumonks.org>)
        id 1jgX01-0032HP-Qy; Wed, 03 Jun 2020 19:16:21 +0200
Date:   Wed, 3 Jun 2020 19:16:21 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [MAINTENANCE] Shutting down FTP services at netfilter.org
Message-ID: <20200603171621.GC717800@nataraja>
References: <20200603113712.GA24918@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603113712.GA24918@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Jun 03, 2020 at 01:37:12PM +0200, Pablo Neira Ayuso wrote:
> So netfilter.org will also be shutting down FTP services by
> June 12th 2020.

I always find that somewhat sad, as with HTTP there is no real convenient
way to get directory listings in a standardized / parseable format.  But
of course I understand the rationale and I obviously respect your
decision in that matter.

> As an alternative, you can still reach the entire netfilter.org
> software repository through HTTP at this new location:
> 
>         https://netfilter.org/pub/

Maybe make http://ftp.netfilter.org/ an alias to it?

I think the important part would be some way to conveniently obtain a
full clone, e.g. by rsync.  This way both public and private mirrors
can exist in an efficient way, without having to resort to 'wget -r'
or related hacks, which then only use file size as an indication if a
file might have changed, ...

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
