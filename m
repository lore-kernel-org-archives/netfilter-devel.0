Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F2EC3DA78
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Jan 2023 15:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjAQP1l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Jan 2023 10:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbjAQP1N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2023 10:27:13 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2F5041B5A;
        Tue, 17 Jan 2023 07:27:04 -0800 (PST)
Date:   Tue, 17 Jan 2023 16:27:01 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Alok Tiwari <alok.a.tiwari@oracle.com>
Cc:     linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 6.1] netfilter: Null pointer dereference in
 nf_tables_updobj
Message-ID: <Y8a+RddrpMz7cUdC@salvia>
References: <20230117134537.3400252-1-alok.a.tiwari@oracle.com>
 <Y8at5Le5f4ifFYqk@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y8at5Le5f4ifFYqk@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 17, 2023 at 03:17:11PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 17, 2023 at 05:45:38AM -0800, Alok Tiwari wrote:
> > static analyzer detect null pointer dereference case for 'type'
> > function __nft_obj_type_get() can return NULL value which require to handle
> > if type is NULL pointer return -ENOENT
> 
> This should not ever happen, but it is good to have a failsafe in this
> path.
> 
> I'll take this into nf.git, thanks.

BTW, easier to read:

        if (WARN_ON_ONCE(!type))

instead of:

        if (!WARN_ON_ONCE(type))

I'll mangle the patch here before applying, unless you prefer to send a v2.
