Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6C2C25B06
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Aug 2022 23:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiHDXfx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Aug 2022 19:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiHDXfw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Aug 2022 19:35:52 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059A39FD0
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Aug 2022 16:35:49 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id F2E475872D180; Fri,  5 Aug 2022 01:35:45 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id F080960C0485F;
        Fri,  5 Aug 2022 01:35:45 +0200 (CEST)
Date:   Fri, 5 Aug 2022 01:35:45 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jacob Keller <jacob.e.keller@intel.com>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Duncan Roe <duncan_roe@optusnet.com.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libmnl] libmnl: add support for signed types
In-Reply-To: <20220804220555.2681949-1-jacob.e.keller@intel.com>
Message-ID: <q7301nr-3q5r-q54s-o9o7-r19104226p3@vanv.qr>
References: <20220804220555.2681949-1-jacob.e.keller@intel.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


>+ * mnl_attr_get_s8 - returns 8-bit signed integer attribute payload
>+ *
>+ * This function returns the 8-bit value of the attribute payload.
>+ */

That's kinda redundant - it's logically the same thing, just written 
ever-so-slightly differently.


>+/**
>+ * mnl_attr_get_s64 - returns 64-bit signed integer attribute.
>    This
>+ * function is align-safe, since accessing 64-bit Netlink attributes is a
>+ * common source of alignment issues.

That sentence is self-defeating. If NLA access is a commn source of 
alignment issues, then, by transitivity, this function too would
be potentially affected. Just

  "This function reads the 64-bit nlattr in an alignment-safe manner."


