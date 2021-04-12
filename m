Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E088C433B4
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Apr 2021 18:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 633DF61220
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Apr 2021 18:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhDLSTB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 14:19:01 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:57851 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229493AbhDLSTA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 14:19:00 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8D639580461;
        Mon, 12 Apr 2021 14:18:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 12 Apr 2021 14:18:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1eCjr5
        cFDFt16OHEX15BVw5hh7s353/Rz1tIY41a5IM=; b=ShMdxxFpACLyo4YO+FsBQ7
        y3d/k8Z7KMbYBsX3WXiEP96GE86TsbzHNiRdcngTC+AwzMGgM4+Nsdy7WGAkriT0
        2tHndcX8+K03AyAREyhjBbttSCbIF25VqPhZkKKD9Q1d1bfSBDJ3xm24UH3tW2Ed
        mvBAW27VbiuiIUh+nkWMrRMwdhnWiYMaRPCbW5WWftJk1PSJXC07MvCe0fTjmdcz
        ApcUgPhIvF+84HeDFRsRYVMSIE/LDmgTUzBbFRA2ZqHjlXB8f/fbmwLg+Ca+g2om
        Phyx3ty4NWu55Dv9rS3g0gtx2bJteUkTkghjvtbQQ/taCbFLgaFqyeMB8TiyW3AA
        ==
X-ME-Sender: <xms:_450YJz-sHSJP3-L8if3Pz4ZF-6wxjWa5j7dK2PB0AR8cXNSXitvIQ>
    <xme:_450YJSs4vupz8ZFTShTa7eUPJkTSArZIVGP05vA38SiQ8WthsXWiSw3EWusP3H5Q
    uIlg9k9mgvbNwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekjedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepkeejkeevkeefleettdejffeuteffveejgfehgedvteeggeeguedtvedtfffh
    iefgnecuffhomhgrihhnpehtvghsthhsrdhshhdpkhgvrhhnvghlrdhorhhgnecukfhppe
    ekgedrvddvledrudehfedrudekjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:_450YDXLYE6g-o_dD98VE4g2kPEDjBVjO5Eix8WuB9r1wLngPEnZdw>
    <xmx:_450YLiPh-UUhegKmZCFqYuKHlnk_ahcSNcpDibAP5Be8DYdRFhISw>
    <xmx:_450YLBFu8-Zef-yxLeD-bk-1oqxnm3pnCp8FIfevmNy5disv1OkiA>
    <xmx:AY90YP3q3NMSS3Rak-x7Hwt7Wio0eI9X8okaaaMgfJxrScHZnmWbGg>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6C5BC1080054;
        Mon, 12 Apr 2021 14:18:39 -0400 (EDT)
Date:   Mon, 12 Apr 2021 21:18:34 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Michal Soltys <msoltyspl@yandex.pl>
Cc:     David Ahern <dsahern@gmail.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, dsahern@kernel.org, roopa@nvidia.com,
        nikolay@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH nf-next] netfilter: Dissect flow after packet mangling
Message-ID: <YHSO+ieteZ6XHnjT@shredder.lan>
References: <20210411193251.1220655-1-idosch@idosch.org>
 <be90fae7-f634-1f54-992e-226c442fb894@gmail.com>
 <YHPt5nyML4I51COy@shredder.lan>
 <c1c83fb7-d074-a0a8-0766-f8844c1e7e23@yandex.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1c83fb7-d074-a0a8-0766-f8844c1e7e23@yandex.pl>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 12, 2021 at 03:28:21PM +0200, Michal Soltys wrote:
> On 4/12/21 8:51 AM, Ido Schimmel wrote:
> > On Sun, Apr 11, 2021 at 06:18:05PM -0700, David Ahern wrote:
> > > On 4/11/21 1:32 PM, Ido Schimmel wrote:
> > > > From: Ido Schimmel <idosch@nvidia.com>
> > > > <cut>
> > > > 
> > > 
> > > Once this goes in, can you add tests to one of the selftest scripts
> > > (e.g., fib_rule_tests.sh)?
> > 
> > Yes. I used Michal's scripts from here [1] to test. Will try to simplify
> > it for a test case.
> > 
> > [1] https://lore.kernel.org/netdev/6b707dde-c6f0-ca3e-e817-a09c1e6b3f00@yandex.pl/
> > 
> 
> Regarding those scripts:
> 
> - the commented out `-j TOS --set-tos 0x02` falls into ECN bits, so it's
> somewhat incorrect/obsolete
> - the uidrange selector (that was also ignored) is missing in the sequence
> of ip rules

I verified that with the patch, after adding mangling rules with
ip{,6}tables, packets continue to flow via right2. Can you test the
patch and verify it works as you expect?
