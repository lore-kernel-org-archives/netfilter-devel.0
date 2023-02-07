Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4DF7C636CD
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Feb 2023 12:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjBGMFo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Feb 2023 07:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjBGMFo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Feb 2023 07:05:44 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 683D027986
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Feb 2023 04:05:43 -0800 (PST)
Date:   Tue, 7 Feb 2023 13:05:38 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [nft PATCH v4 13/32] evaluate: support shifts larger than the
 width of the left operand
Message-ID: <Y+I+khlMuL+kFoq9@salvia>
References: <20220404121410.188509-1-jeremy@azazel.net>
 <20220404121410.188509-14-jeremy@azazel.net>
 <YovHkOThO0KYRGda@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YovHkOThO0KYRGda@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Long time, no news.

On Mon, May 23, 2022 at 07:42:43PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> I just tested patches 9 and 14 alone, and meta mark set ip dscp ...
> now works fine.

I have applied 9 and 14, including one testcase for tests/py, so

        meta mark set ip dscp

works, so there is at least some progress on this, sorry about this :(
