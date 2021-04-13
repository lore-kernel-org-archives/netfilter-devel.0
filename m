Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F62C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Apr 2021 13:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24B376117A
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Apr 2021 13:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhDMN6g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Apr 2021 09:58:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:48966 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhDMN6b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Apr 2021 09:58:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618322291; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bKs/i+hQexe+h5jN4y7xGvN6I0a3r3vfjONAKEPOUC0=;
        b=VGhPxuB0qkigC7Ti2NqReCfSf0WiydY9W3ceAgN4e+x9WDocFgvxnTFkyOFMmfdC5P5pRV
        /Tc7aJrqjrbm4Zzx0aRkyM4AJnohN3oTT4w/prsSPFma1K1c+tf+bykBqd46RApu4qXEvu
        0HO+kX3Sdc0WXICnyEOapo7lFWnpz7Q=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 11119AC6A;
        Tue, 13 Apr 2021 13:58:11 +0000 (UTC)
Date:   Tue, 13 Apr 2021 15:58:10 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] conntrack_tcp: Reset the max ACK flag on SYN in ignore
 state
Message-ID: <20210413135810.pquz7skzqso6gden@Fryzen495>
References: <20210408061203.35kbl44elgz4resh@Fryzen495>
 <20210408090459.GQ13699@breakpoint.cc>
 <20210413122436.aejo4pwaafwrlzsh@Fryzen495>
 <20210413134517.GC14932@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210413134517.GC14932@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 13.04.2021 15:45, Florian Westphal wrote:
> Mhh, can you share a patch?  Your patch clears it when a SYN is
> observed, so I am not sure what you mean.

We are also seeing some RST drops during live migration of a NFS
server (whose traffic goes through the filter before reaching the NFS
clients). Basically the NFS server will send RSTs during live migration,
and some of them are dropped, but we still don't understand the root
cause in this case. I will send another patch in case it turns out to be
an issue in in tcp conntrack.

> I think the patch is good; we only need to handle the case where we
> let a SYN through, and might be out of state.
> 
> So, we only need to handle the reply dir, no?

Yes, for the moment the proposed patch avoids the SYN -> RST -> drop
situation, so many thanks for taking it.

-- 
Ali Abdallah | SUSE Linux L3 Engineer
GPG fingerprint: 51A0 F4A0 C8CF C98F 842E  A9A8 B945 56F8 1C85 D0D5

