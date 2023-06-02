Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BCBC77B7A
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Jun 2023 23:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbjFBXUw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Jun 2023 19:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbjFBXUv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Jun 2023 19:20:51 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0DBC123
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Jun 2023 16:20:50 -0700 (PDT)
Date:   Sat, 3 Jun 2023 01:20:47 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables v2] exthdr: add boolean DCCP option matching
Message-ID: <ZHp5T9pWQ3u2Fugg@calendula>
References: <20230411204534.14871-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230411204534.14871-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 11, 2023 at 09:45:34PM +0100, Jeremy Sowden wrote:
> Iptables supports the matching of DCCP packets based on the presence
> or absence of DCCP options.  Extend exthdr expressions to add this
> functionality to nftables.

Applied, thanks.

Not related to this patch: there is 'ip options' and 'tcp option',
probably enhance parser to allow for 'ip option' to address this
inconsistency in the syntax?
