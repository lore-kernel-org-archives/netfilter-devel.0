Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72D4C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Apr 2022 15:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbiDFP0a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Apr 2022 11:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236069AbiDFP0T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Apr 2022 11:26:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB33C574C79
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2022 05:24:42 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id EB695642F8;
        Wed,  6 Apr 2022 13:53:21 +0200 (CEST)
Date:   Wed, 6 Apr 2022 13:57:01 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl 0/3] add description infrastructure
Message-ID: <Yk2ADSR5wr5k/1om@salvia>
References: <20220120000402.916332-1-pablo@netfilter.org>
 <Yk10JYXS/uGGqsxe@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yk10JYXS/uGGqsxe@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 06, 2022 at 01:06:13PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Thu, Jan 20, 2022 at 01:03:59AM +0100, Pablo Neira Ayuso wrote:
> > This is my proposal to address the snprintf data printing depending on
> > the arch. The idea is to add description objects that can be used to
> > build the userdata area as well as to parse the userdata to create the
> > description object.
> > 
> > This is revisiting 6e48df5329ea ("src: add "typeof" build/parse/print
> > support") in nftables which adds build and parse userdata callbacks to
> > expression in libnftables. My proposal is to move this to libnftnl.
> 
> Looking at your PoC again, I assume it was meant for use by applications
> to create and populate an nftnl_set_desc object and serialize it into
> nftnl_set's userdata using nftnl_set_desc_build_udata(). Since the
> information is needed within libnftnl though, the whole API does not
> make sense anymore and nftnl_set_desc must be serialized by libnftnl
> itself. This in turn means one may just integrate the data structure
> into nftnl_set's 'desc' field directly and extend nftnl_set_set_data()
> to allow populating the new fields, plus
> nftnl_set_desc_add_{expr,datatype}() I guess.
> 
> Am I on the right track there?
> 
> Maybe it's quicker for me to add the missing bits to my stuff instead of
> adjusting it to your series after making it work for the intended
> purpose. Especially since I'm not quite sure what goal we're trying to
> achieve.

Goal is to consolidate code. Move the existing code in nftables to
libnftnl so there is a desc object that can be use to build the
userdata and to all assist the libnftnl print functions.

This will take a bit of work.
