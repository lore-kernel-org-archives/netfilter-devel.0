Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0638EC56202
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Nov 2020 11:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B126E2075A
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Nov 2020 11:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgKYLXq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Nov 2020 06:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgKYLXq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Nov 2020 06:23:46 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91371C0613D4
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2020 03:23:45 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1khsti-000120-NE; Wed, 25 Nov 2020 12:23:42 +0100
Date:   Wed, 25 Nov 2020 12:23:42 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: XFRM interface and NF_INET_LOCAL_OUT hook
Message-ID: <20201125112342.GA11766@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Steffen,

I am working on a ticket complaining about netfilter policy match
missing packets in OUTPUT chain if XFRM interface is being used.

I don't fully overlook the relevant code path, but it seems like
skb_dest(skb)->xfrm is not yet assigned when the skb is routed towards
XFRM interface and already cleared again (by xfrm_output_one?) before it
makes its way towards the real output interface. NF_INET_POST_ROUTING
hook works though.

Is this a bug or an expected quirk when using XFRM interface?

Cheers, Phil
