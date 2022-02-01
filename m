Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDD4C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Feb 2022 17:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240215AbiBARcG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Feb 2022 12:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiBARcF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Feb 2022 12:32:05 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FACDC061714
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Feb 2022 09:32:05 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id DC3AB58756139; Tue,  1 Feb 2022 18:32:02 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id D7E7C60C28F10;
        Tue,  1 Feb 2022 18:32:02 +0100 (CET)
Date:   Tue, 1 Feb 2022 18:32:02 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Philip Prindeville <philipp_subx@redfish-solutions.com>
cc:     Jeremy Sowden <jeremy@azazel.net>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] xt_ECHO, xt_TARPIT: make properly conditional on
 IPv6
In-Reply-To: <6961516B-8252-404F-B302-33E39EEBC9F3@redfish-solutions.com>
Message-ID: <o9236r6-q17s-4p97-r8o0-rnr66543s30@vanv.qr>
References: <20210926195734.702772-1-philipp@redfish-solutions.com> <5s32r847-4op5-70s2-7o9n-4968n7rso321@vanv.qr> <05A51779-4B94-49BA-B1B8-6CA5BE695D80@redfish-solutions.com> <Yfe48T7Nxpzp20wL@azazel.net> <E7F7FB17-246B-4EFF-9449-FE1764F9816E@redfish-solutions.com>
 <Yfgq6qWKgTV9NEkg@azazel.net> <6961516B-8252-404F-B302-33E39EEBC9F3@redfish-solutions.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Monday 2022-01-31 19:35, Philip Prindeville wrote:
>
>That would do it.
>When is 3.19 or 4.0 due out?

No particular plans, therefore I tagged 3.19 for your enjoyment.
