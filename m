Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEA4C56201
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Nov 2020 01:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99E132075A
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Nov 2020 01:14:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jU8UT9S0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbgKZBO2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Nov 2020 20:14:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729131AbgKZBO2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Nov 2020 20:14:28 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CEF12075A;
        Thu, 26 Nov 2020 01:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606353267;
        bh=irYgvhS5ggOJ9DU5nPFPqVVF1MSg0FxcCYasg+a5t7k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jU8UT9S0D3hm0j4owmMEVJzLub2t0CdYVw4rTNb/d06Yg3pVnsnESZQ0y2bZpntbR
         ArlUIpjrnQ0Ocde9N8SQtK7RE0hPdt1MleIL7xMZXDIfDLQtAF54k4LxXHEcz3xLcU
         HIOcDA752BjDQcshgqs83L2raMC9kYIorubNAmEA=
Date:   Wed, 25 Nov 2020 17:14:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2 1/2] netfilter: nftables_offload: set address type
 in control dissector
Message-ID: <20201125171426.62c67dc4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201126004437.GA24061@salvia>
References: <20201125230446.28691-1-pablo@netfilter.org>
        <20201125152147.6f643149@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201126004437.GA24061@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 26 Nov 2020 01:44:37 +0100 Pablo Neira Ayuso wrote:
> > Still worries me this is done in a response to a match.
> > 
> > skb_flow_dissector_init() has a straight up BUG_ON() if the dissector
> > did not set the CONTROL or BASIC. It says in the comment that both must
> > be initialized. But nft does not call skb_flow_dissector_init()?
> > 
> > Are you 100% sure all cases will set CONTROL and BASIC now?  
> 
> Enforcing skb_flow_dissector_init() for software make sense, but in
> Netfilter this is used for hardware offload only.
> 
> All drivers in the tree check for:
> 
>         if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL))
> 
> before accessing struct flow_match_control.
> 
> I can set it on inconditionally, but the driver will get a value 0x0
> and mask 0x0, which is the same as leaving it unset.

Ack, I didn't realize you don't actually ever use the dissector other
than for offload.
