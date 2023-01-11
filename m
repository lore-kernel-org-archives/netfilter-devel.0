Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB6CC46467
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Jan 2023 18:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbjAKSJ4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Jan 2023 13:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235325AbjAKSJp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Jan 2023 13:09:45 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 736EB19024
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2023 10:09:31 -0800 (PST)
Date:   Wed, 11 Jan 2023 19:09:28 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: Re: [PATCH nf] selftests: netfilter: fix transaction test script
 timeout handling
Message-ID: <Y777WDRSvjKK7qE3@salvia>
References: <20230104115442.2427-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230104115442.2427-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 04, 2023 at 12:54:42PM +0100, Florian Westphal wrote:
> The kselftest framework uses a default timeout of 45 seconds for
> all test scripts.
> 
> Increase the timeout to two minutes for the netfilter tests, this
> should hopefully be enough,
> 
> Make sure that, should the script be canceled, the net namespace and
> the spawned ping instances are removed.

Applied to nf.git, thanks
