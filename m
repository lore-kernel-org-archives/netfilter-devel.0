Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A8BC4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Nov 2023 07:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjKEHJD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Nov 2023 02:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjKEHJD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2023 02:09:03 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC40FF;
        Sun,  5 Nov 2023 00:08:57 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id BBC2C587232C6; Sun,  5 Nov 2023 08:08:53 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id B951760C1EA73;
        Sun,  5 Nov 2023 08:08:53 +0100 (CET)
Date:   Sun, 5 Nov 2023 08:08:53 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH net] net: xt_recent: fix (increase) ipv6 literal buffer
 length
In-Reply-To: <20231104210053.343149-1-maze@google.com>
Message-ID: <1654342n-nn1q-959p-s6r0-3846psss5on6@vanv.qr>
References: <20231104210053.343149-1-maze@google.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Saturday 2023-11-04 22:00, Maciej Żenczykowski wrote:
>
>IPv4 in IPv6 is supported by in6_pton [...]
>but the provided buffer is too short:

If in6_pton were to support tunnel traffic.. wait that sounds
unusual, and would require dst to be at least 20 bytes, which the 
function documentation contradicts.

As the RFCs make no precise name proposition

	(IPv6 Text Representation, third alternative,
	IPv4 "decimal value" of the "four low-order 8-bit pieces")

so let's just call it

	"low-32-bit dot-decimal representation"

which should avoid the tunnel term.
