Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB29C64E7B
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Nov 2020 22:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD4721527
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Nov 2020 22:09:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpKfEQps"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389805AbgK1VuG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Nov 2020 16:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387793AbgK1VYL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Nov 2020 16:24:11 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3652206B2;
        Sat, 28 Nov 2020 21:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606598610;
        bh=1QJiLc0tqdYPdxOvFcdphZImdNr3qdJ0OXWY9i1p17c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MpKfEQpsCBIbWz+aVRKw/MdkmuvilmLlyzNZVhl/SwFfBkrYMHplOyBwln5Skqbw5
         2tvMjSgOsVE/Mstqy78Gmco3XP3af3yqMSQeknoW3HRshI6ABQJMzZMNG+NGhrnSYY
         0h8gTwqlhi7F74LNS4G+HuSPdi7XQTKoBVlIiHg0=
Date:   Sat, 28 Nov 2020 13:23:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/5] Netfilter fixes for net
Message-ID: <20201128132329.4aa38d97@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127190313.24947-1-pablo@netfilter.org>
References: <20201127190313.24947-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 27 Nov 2020 20:03:08 +0100 Pablo Neira Ayuso wrote:
> 1) Fix insufficient validation of IPSET_ATTR_IPADDR_IPV6 reported
>    by syzbot.
> 
> 2) Remove spurious reports on nf_tables when lockdep gets disabled,
>    from Florian Westphal.
> 
> 3) Fix memleak in the error path of error path of
>    ip_vs_control_net_init(), from Wang Hai.
> 
> 4) Fix missing control data in flow dissector, otherwise IP address
>    matching in hardware offload infra does not work.
> 
> 5) Fix hardware offload match on prefix IP address when userspace
>    does not send a bitwise expression to represent the prefix.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks!
