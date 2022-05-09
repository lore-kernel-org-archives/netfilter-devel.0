Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B0EC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 May 2022 06:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbiEIGZe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 May 2022 02:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235735AbiEIGKy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 May 2022 02:10:54 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B884D5FBC;
        Sun,  8 May 2022 23:06:59 -0700 (PDT)
Date:   Mon, 9 May 2022 08:06:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kevin Mitchell <kevmitch@arista.com>
Cc:     gal@nvidia.com, Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v3] netfilter: conntrack: skip verification of
 zero UDP checksum
Message-ID: <Ynivfw21/nr8PKVD@salvia>
References: <YmlVAXceuasAJjnN@salvia>
 <20220430034027.21286-1-kevmitch@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220430034027.21286-1-kevmitch@arista.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 29, 2022 at 08:40:27PM -0700, Kevin Mitchell wrote:
> The checksum is optional for UDP packets. However nf_reject would
> previously require a valid checksum to elicit a response such as
> ICMP_DEST_UNREACH.
> 
> Add some logic to nf_reject_verify_csum to determine if a UDP packet has
> a zero checksum and should therefore not be verified.

Applied.
