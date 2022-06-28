Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A06DC43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jun 2022 17:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiF1RRK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 13:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiF1RRJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 13:17:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5461C2ED6E
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2022 10:17:09 -0700 (PDT)
Date:   Tue, 28 Jun 2022 19:17:06 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Daniel =?utf-8?Q?Gr=C3=B6ber?= <dxld@darkboxed.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] Allow resetting the include search path
Message-ID: <Yrs3kkbc4z5AMF+W@salvia>
References: <20220627222304.93139-1-dxld@darkboxed.org>
 <Yrs2nn/amfnaUDk8@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yrs2nn/amfnaUDk8@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 28, 2022 at 07:13:05PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Tue, Jun 28, 2022 at 12:23:04AM +0200, Daniel Gröber wrote:
> > Currently there is no way to disable searching in DEFAULT_INCLUDE_PATH
> > first. This is needed when testing nftables configurations spanning
> > multiple files without overwriting the globally installed ones.
> 
> You can do
> 
> # cat x.nft
> include "./z.nft"
> # cat z.nft
> add table x
> 
> then:
> 
> # nft -f x.nft
> 
> using ./ at the beginning of the path overrides DEFAULT_INCLUDE_PATH.

Absolute path also overrides DEFAULT_INCLUDE_PATH:

# cat x.nft
include "/foo/z.nft"

search_in_include_path() deals with this in scanner.l.

Relative path also overrides DEFAULT_INCLUDE_PATH.
