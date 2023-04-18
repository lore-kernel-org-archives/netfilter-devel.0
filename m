Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84807C77B76
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Apr 2023 10:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjDRKLJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Apr 2023 06:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjDRKLI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2023 06:11:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A148B619C
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Apr 2023 03:10:38 -0700 (PDT)
Date:   Tue, 18 Apr 2023 12:10:35 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dave Pifke <dave@pifke.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] src: try SO_SNDBUF before SO_SNDBUFFORCE
Message-ID: <ZD5smyBOR+HNKPSx@calendula>
References: <87wn2n8ghs.fsf@stabbing.victim.com>
 <ZDH0EJN9O0DrWp0W@calendula>
 <87r0sr8vih.fsf@stabbing.victim.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87r0sr8vih.fsf@stabbing.victim.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 10, 2023 at 12:03:34PM -0600, Dave Pifke wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
> > setsockopt() with SO_SNDBUF never fails: it trims the newbuffsiz that is
> > specified by net.core.wmem_max
> 
> Oh, good catch!  Your revised patch LGTM, and is closer to what was
> being done in the immediately proceeding function, mnl_set_rcvbuffer.
> 
> However, after thinking about it, I feel we should be checking the
> receiver value after setsockopt returns.  If someone is running
> e.g. AppArmor, it seems better to me to attempt the non-privileged
> operation first, to avoid adding noise in the logs.
> 
> Also, I don't think there are any current situations where
> SO_SNDBUFFORCE might also trim down the value, but after re-reading the
> man page, I'm not sure the contract precludes that in the future.
> 
> Attached is a V3 patch for consideration, which also changes the code to
> attempt the non-privileged SO_RCVBUF before SO_RCVBUFFORCE.  I defer to
> your judgment on which version is actually better; I tested both and
> they both work a) in a container where SO_SNDBUFFORCE fails, and b)
> outside a container with wmem_max set to a small-ish value where
> SO_SNDBUFFORCE is required.

Thanks for your patch.

setsockopt() does not update the &sndnlbuffsiz that is passed as
argument in Linux.

I have posted this patch:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230418100223.158964-1-pablo@netfilter.org/
