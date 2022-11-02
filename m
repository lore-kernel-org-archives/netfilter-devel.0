Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DBCC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Nov 2022 18:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiKBSEr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 14:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiKBSEr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 14:04:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 503C7101DB;
        Wed,  2 Nov 2022 11:04:44 -0700 (PDT)
Date:   Wed, 2 Nov 2022 19:04:36 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-announce@lists.netfilter.org, lwn@lwn.net
Subject: Re: [ANNOUNCE] ulogd 2.0.8 release
Message-ID: <Y2KxNLwxbo2zN28J@salvia>
References: <Y2JE0PygwmrhC6Q1@salvia>
 <65o51noo-oo7n-5325-p7q-5734s0pr24os@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <65o51noo-oo7n-5325-p7q-5734s0pr24os@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 02, 2022 at 12:51:34PM +0100, Jan Engelhardt wrote:
> 
> On Wednesday 2022-11-02 11:22, Pablo Neira Ayuso wrote:
> >
> >You can download it from:
> >
> >https://www.netfilter.org/projects/ulogd/downloads.html
> 
> The git repo is still missing the 2.0.8 tag.

Just pushed out the commit and tag, sorry.

> Is it also possible to have git-over-https?

I'll try to take a look before end of year, but no promises.
