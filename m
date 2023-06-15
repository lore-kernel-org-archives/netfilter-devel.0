Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B800BEB64D9
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Jun 2023 13:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240217AbjFONpl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Jun 2023 09:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237805AbjFONpk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jun 2023 09:45:40 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0000BE4D
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2023 06:45:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1q9nI7-0002JI-OY; Thu, 15 Jun 2023 15:45:35 +0200
Date:   Thu, 15 Jun 2023 15:45:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jacek Tomasiak <jacek.tomasiak@gmail.com>,
        netfilter-devel@vger.kernel.org,
        Jacek Tomasiak <jtomasiak@arista.com>
Subject: Re: [conntrack-tools PATCH] conntrack: Don't override mark in
 non-list mode
Message-ID: <20230615134535.GD13263@breakpoint.cc>
References: <20230614162405.30885-1-jacek.tomasiak@gmail.com>
 <ZIr2IyskRJKgSo5H@calendula>
 <20230615133643.GC13263@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615133643.GC13263@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> This should be
> 
> -                       tmpl->mark.value = status;
> -                       tmpl->filter_status_kernel.val = tmpl->mark.value;
> +                       tmpl->filter_status_kernel.val = status;
>                         tmpl->filter_status_kernel_set = true;

I've pushed Jaceks patch with the content amended as above.

Jan, please report if that doesn't resolve the bug you reported.

Thanks everyone.
