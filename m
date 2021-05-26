Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89ECC47082
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 May 2021 14:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1F18611CD
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 May 2021 14:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhEZOg2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 May 2021 10:36:28 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:49826 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbhEZOg1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 May 2021 10:36:27 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2A3551FD29;
        Wed, 26 May 2021 14:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622039695; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4gXWHFKQGPYHv7N7qcoLtwu5J89+Ae3UOaubBiD22Ck=;
        b=e/jI8DZbcDNFql8JdxBVSXcyZfyV06Zp2KCX19+VFZkGy9zz7EiPhfc2cvOZd4y9n5WYx8
        KofZmCr+EPit1SC/bQT9Y6v2eyEhpqg7BQ9asPUV48j+U8ZV5ZIjANMzJp3DvbebQ5U+te
        3FQpcELWGa3DeDkQcamzeIrtMyziHeM=
Received: from director2.suse.de (director2.suse-dmz.suse.de [192.168.254.72])
        by imap.suse.de (Postfix) with ESMTPSA id 04CFB11A98;
        Wed, 26 May 2021 14:34:54 +0000 (UTC)
Date:   Wed, 26 May 2021 16:34:54 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack: add new sysctl to disable RST check
Message-ID: <20210526143454.2x3riukvcz4b322s@Fryzen495>
References: <20210526092444.lca726ghsrli5fpx@Fryzen495>
 <e48eac1e-dd8e-52c2-3a15-a9404933d1dd@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e48eac1e-dd8e-52c2-3a15-a9404933d1dd@6wind.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 26.05.2021 16:29, Nicolas Dichtel wrote:
> > +nf_conntrack_tcp_ignore_invalid_rst - BOOLEAN
> > +	- 0 - disabled (default)
> > +	- not 0 - enabled
> If I correctly read the patch, the only "not 0" possible value is 1. Why not
> using explicitly "1"?

That what the doc on nf_conntrack_tcp_be_liberal says as well, logically
not 0 is 1, so IMHO I don't think that can lead to confusion.

Kind regards,
Ali

