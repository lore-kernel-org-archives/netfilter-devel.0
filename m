Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEE1C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242372AbiBSN53 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:57:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242340AbiBSN52 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:57:28 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A783FDBE
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:57:08 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 5E6E259777A32; Sat, 19 Feb 2022 14:57:06 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 5BFC6619798A7;
        Sat, 19 Feb 2022 14:57:06 +0100 (CET)
Date:   Sat, 19 Feb 2022 14:57:06 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: add tcp option reset support
In-Reply-To: <20220219133750.13369-1-fw@strlen.de>
Message-ID: <sp5q78s5-723n-pq8q-np2s-nr279qpprs18@vanv.qr>
References: <20220219133750.13369-1-fw@strlen.de>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Saturday 2022-02-19 14:37, Florian Westphal wrote:

>This allows to replace a tcp tcp option with nops, similar

tcp tcp

> The extension header statement alters packet content in variable-sized headers.
> This can currently be used to alter the TCP Maximum segment size of packets,
>-similar to TCPMSS.
>+similar to TCPMSS target in iptables.

similar to the TCPMSS target in iptables

>+You can also remove tcp options via *reset* keyword.

via the reset keyword

