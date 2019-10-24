Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A31CA9EBB
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 11:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 303A521655
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 11:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439217AbfJXLq4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 07:46:56 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34308 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726389AbfJXLqz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 07:46:55 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iNbZt-0002jy-SO; Thu, 24 Oct 2019 13:46:53 +0200
Date:   Thu, 24 Oct 2019 13:46:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ttttabcd <ttttabcd@protonmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: How to implement transparent proxy in bridge through nftables
Message-ID: <20191024114653.GU25052@breakpoint.cc>
References: <0nkwkdhigGlVkVliaeVhuQ2wMq-np7v0sEG1lwiwI8fKYJg8plX19uqIPiONNMpUQbIluwVsyIPsVyEs7MTE_zGRJWgaYCYdchwRs16fRHk=@protonmail.com>
 <20191022132533.GJ25052@breakpoint.cc>
 <znxWvqNmfP1aG_VCHdCfvD3KssnJIXufwOon4sm9-IEv_z9umsB1zWs8rZIduSUMgGEwjF1fy7tgI4YCy7mGPPpa2bBSg78Ww8TxiySh_5A=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <znxWvqNmfP1aG_VCHdCfvD3KssnJIXufwOon4sm9-IEv_z9umsB1zWs8rZIduSUMgGEwjF1fy7tgI4YCy7mGPPpa2bBSg78Ww8TxiySh_5A=@protonmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ttttabcd <ttttabcd@protonmail.com> wrote:
> But there is a problem here, that is, the specified MAC address is fixed, this is not universal, I have to modify the command on different devices.

Yes.

> Is there a way for nftables to automatically get the MAC address of the interface?

Not yet, but we could extend nft/ nft_meta.c so you could do
"ether daddr set meta ifaddr" or something like that.
