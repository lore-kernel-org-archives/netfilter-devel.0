Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1403AC77B74
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Apr 2023 09:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbjDFJeV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Apr 2023 05:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbjDFJeT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2023 05:34:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 202D446BF
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2023 02:34:18 -0700 (PDT)
Date:   Thu, 6 Apr 2023 11:34:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Farid BENAMROUCHE <fariouche@yahoo.fr>
Subject: Re: [PATCH nf] netfilter: br_netfilter: fix recent physdev match
 breakage
Message-ID: <ZC6SFn3eJX+z/AIV@salvia>
References: <20230403115437.1923-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230403115437.1923-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 03, 2023 at 01:54:37PM +0200, Florian Westphal wrote:
> Recent attempt to ensure PREROUTING hook is executed again when a
> decrypted ipsec packet received on a bridge passes through the network
> stack a second time broke the physdev match in INPUT hook.
> 
> We can't discard the nf_bridge info strct from sabotage_in hook, as
> this is needed by the physdev match.
> 
> Keep the struct around and handle this with another conditional instead.

Applied to nf, thanks
