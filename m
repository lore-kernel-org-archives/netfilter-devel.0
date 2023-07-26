Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69353C0015E
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jul 2023 22:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjGZWRm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jul 2023 18:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjGZWRl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2023 18:17:41 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A94270D
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2023 15:17:39 -0700 (PDT)
Received: from [46.222.17.104] (port=6972 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qOmp3-006kB3-Ml; Thu, 27 Jul 2023 00:17:35 +0200
Date:   Thu, 27 Jul 2023 00:17:31 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Netfilter -stable patches for 6.1.y
Message-ID: <ZMGbe24I9I+FOH57@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

Could you please cherry-pick:

 29ad9a305943 ("netfilter: nf_tables: fix underflow in chain reference counter")
 b8ae60de6fd3 ("netfilter: nf_tables: fix underflow in object reference counter"

into 6.1.y?

Other -stable kernels I have just audited do not need these updates,
since this fix have been already included in my recent -stable backports.

Thanks.

P.S: Moving forward, I will add the Cc: stable@vger.kernel.org tag to
     patches as Greg suggested.
