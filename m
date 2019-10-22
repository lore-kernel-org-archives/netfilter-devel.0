Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D603CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 13:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 148CF21783
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 13:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730842AbfJVNZf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 09:25:35 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51098 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730749AbfJVNZf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 09:25:35 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iMuAH-0003rD-OY; Tue, 22 Oct 2019 15:25:33 +0200
Date:   Tue, 22 Oct 2019 15:25:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ttttabcd <ttttabcd@protonmail.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: How to implement transparent proxy in bridge through nftables
Message-ID: <20191022132533.GJ25052@breakpoint.cc>
References: <0nkwkdhigGlVkVliaeVhuQ2wMq-np7v0sEG1lwiwI8fKYJg8plX19uqIPiONNMpUQbIluwVsyIPsVyEs7MTE_zGRJWgaYCYdchwRs16fRHk=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0nkwkdhigGlVkVliaeVhuQ2wMq-np7v0sEG1lwiwI8fKYJg8plX19uqIPiONNMpUQbIluwVsyIPsVyEs7MTE_zGRJWgaYCYdchwRs16fRHk=@protonmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ttttabcd <ttttabcd@protonmail.com> wrote:
> In ebtables, I can pull the direct Layer 2 forwarding traffic to the network layer through the "broute" table, but I can't find the "broute" table in nftables.

Its not yet implemented, but this will be supported in nft as well at
some point.

> Later, I want to perform target MAC address redirection in PREROUTING, and change the target MAC to the bridge itself or the MAC of the slave interface, so that the data frame can reach the network layer.
> 
> But nftables doesn't seem to be able to perform MAC address redirection in bridge families, so there is no way to use it.
>
> Finally, I searched the Internet for a long time, found br_netfilter, can open bridge-nf-call-iptables to pass the bridge frame to the iptables hook processing, but nftables does not support this feature.
> 
> Now I have tried all the methods that I can think of and can search. All of them are not working. I can only come here for help.
> 
> Can someone tell me how to run transparent proxy in the bridge with nftables, and the transparent proxy uses the tproxy module.
> 
> Does anyone know how to do it?

You can try this example from nft man page, you need to replace the mac
address of course.

bridge prerouting meta pkttype set unicast ether daddr set 00:11:22:33:44:55

