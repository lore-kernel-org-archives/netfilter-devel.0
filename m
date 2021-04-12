Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDE7C433ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Apr 2021 06:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84EEA61210
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Apr 2021 06:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbhDLGvl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 02:51:41 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:60389 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236591AbhDLGvk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 02:51:40 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D683E5807E0;
        Mon, 12 Apr 2021 02:51:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 12 Apr 2021 02:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8QTFOI
        yr9MJuQFEnB+RcxpwckZhmHtj9u+km7KhiV8M=; b=RtS+PuSFSzvjD09tx7ebOT
        seKgNaJKxo5NqsHIq7zHPGwYne1waq8/s4THtCrseT8G9bV8vU+8VZDvoF0UXQyS
        QoOoL7MGNW6R9XNSGmcRjRVeGy5MGM2e2qEn9oa+d9H3XQKgVlo7VdyVSdxiLE2x
        2gbLYTo+15DTRLe+okX9qC2nke6GG94m7OmtAJ5QxGOPcAXPm7KdIARe3Rpp6T2/
        A1oLoL7gAbqeL1MSvlNu1FCtTP6hBW75EWvt8OBDhRvI0NtrcDHmwRGR/TVbhG71
        1+q9ISF5KTMc9fD2eWBXUr0ccaqEuYroZlw4r96Z2023FsV/gGrbg8xZF2Yk52LQ
        ==
X-ME-Sender: <xms:6u1zYJdwIRB7lOkXcSXzP-jeNXagMA_-PZoR6IkkPOa8b9fZqxms-Q>
    <xme:6u1zYHO2ju6IelR8RGMHI8sB6OWRbdEoIE8s551uAGKjbHv22FfY7ssnQoaIVDw8d
    KA2AtY_lvzNkDM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekiedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepkeejkeevkeefleettdejffeuteffveejgfehgedvteeggeeguedtvedtfffh
    iefgnecuffhomhgrihhnpehtvghsthhsrdhshhdpkhgvrhhnvghlrdhorhhgnecukfhppe
    ekgedrvddvledrudehfedrudekjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:6u1zYChZE66E0v0Icb-zDolXOnP_laycPOiLEwMm3o2Px1T9WUnvZQ>
    <xmx:6u1zYC9SGqZ_Cz9hSgrTAVYt5-6AFaEkCyFHM6ITRYT2vsVyi189zg>
    <xmx:6u1zYFv8oiBz0yq5wJXdhpBg0XAAbtwyKbU_z8vC1OuBYR2ccDbIbw>
    <xmx:6u1zYLDbavdf-nO-rlda-hKcpqblVaXBlyzKIfyHEyxb7WAN2sh4yw>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id A2C4F240057;
        Mon, 12 Apr 2021 02:51:21 -0400 (EDT)
Date:   Mon, 12 Apr 2021 09:51:18 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        dsahern@kernel.org, roopa@nvidia.com, nikolay@nvidia.com,
        msoltyspl@yandex.pl, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH nf-next] netfilter: Dissect flow after packet mangling
Message-ID: <YHPt5nyML4I51COy@shredder.lan>
References: <20210411193251.1220655-1-idosch@idosch.org>
 <be90fae7-f634-1f54-992e-226c442fb894@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be90fae7-f634-1f54-992e-226c442fb894@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Apr 11, 2021 at 06:18:05PM -0700, David Ahern wrote:
> On 4/11/21 1:32 PM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > Netfilter tries to reroute mangled packets as a different route might
> > need to be used following the mangling. When this happens, netfilter
> > does not populate the IP protocol, the source port and the destination
> > port in the flow key. Therefore, FIB rules that match on these fields
> > are ignored and packets can be misrouted.
> > 
> > Solve this by dissecting the outer flow and populating the flow key
> > before rerouting the packet. Note that flow dissection only happens when
> > FIB rules that match on these fields are installed, so in the common
> > case there should not be a penalty.
> > 
> > Reported-by: Michal Soltys <msoltyspl@yandex.pl>
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> > Targeting at nf-next since this use case never worked.
> > ---
> >  net/ipv4/netfilter.c | 2 ++
> >  net/ipv6/netfilter.c | 2 ++
> >  2 files changed, 4 insertions(+)
> > 
> 
> Once this goes in, can you add tests to one of the selftest scripts
> (e.g., fib_rule_tests.sh)?

Yes. I used Michal's scripts from here [1] to test. Will try to simplify
it for a test case.

[1] https://lore.kernel.org/netdev/6b707dde-c6f0-ca3e-e817-a09c1e6b3f00@yandex.pl/
