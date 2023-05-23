Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F48C7EE23
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 May 2023 08:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbjEWIm0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 May 2023 04:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbjEWImF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 May 2023 04:42:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 765E3E49;
        Tue, 23 May 2023 01:41:58 -0700 (PDT)
Date:   Tue, 23 May 2023 10:41:54 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH -stable,4.14 0/8] more stable fixes for 4.14
Message-ID: <ZGx8UtcLQC65FTaG@calendula>
References: <20230516151606.4892-1-pablo@netfilter.org>
 <ZGusoFuQqgzDWXAx@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZGusoFuQqgzDWXAx@sashalap>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 22, 2023 at 01:55:44PM -0400, Sasha Levin wrote:
> On Tue, May 16, 2023 at 05:15:58PM +0200, Pablo Neira Ayuso wrote:
> > Hi Greg, Sasha,
> > 
> > This is second round of -stable backport fixes for 4.14. This batch
> > includes dependency patches which are not currently in the 4.14 branch.
> > 
> > The following list shows the backported patches, I am using original
> > commit IDs for reference:
> > 
> > 1) 08a01c11a5bb ("netfilter: nftables: statify nft_parse_register()")
> > 
> > 2) 6e1acfa387b9 ("netfilter: nf_tables: validate registers coming from userspace.")
> > 
> > 3) 20a1452c3542 ("netfilter: nf_tables: add nft_setelem_parse_key()")
> > 
> > 4) fdb9c405e35b ("netfilter: nf_tables: allow up to 64 bytes in the set element data area")
> > 
> > 5) 7e6bc1f6cabc ("netfilter: nf_tables: stricter validation of element data")
> > 
> > 6) 215a31f19ded ("netfilter: nft_dynset: do not reject set updates with NFT_SET_EVAL")
> > 
> > 7) 36d5b2913219 ("netfilter: nf_tables: do not allow RULE_ID to refer to another chain")
> > 
> > 8) 470ee20e069a ("netfilter: nf_tables: do not allow SET_ID to refer to another table")
> 
> I've applied the 5.4 and 4.19 series, but it looks like patch #1 here
> fails to apply. Could you please re-send the 4.14 series?

Sure, I'll rebase and resend v2. Thanks.
