Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FA4CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 09:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F17DA20856
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 09:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733125AbfJXJOO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 05:14:14 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:58142 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbfJXJOO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 05:14:14 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iNZC7-0000GA-CP; Thu, 24 Oct 2019 11:14:11 +0200
Date:   Thu, 24 Oct 2019 11:14:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/4] py: add missing output flags.
Message-ID: <20191024091411.GO26123@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jeremy Sowden <jeremy@azazel.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20191022205855.22507-1-jeremy@azazel.net>
 <20191022205855.22507-3-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022205855.22507-3-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 22, 2019 at 09:58:53PM +0100, Jeremy Sowden wrote:
> `terse` and `numeric_time` are missing from the `output_flags` dict.
> Add them and getters and setters for them.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

Applied, thanks!
