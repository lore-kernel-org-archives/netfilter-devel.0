Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C40C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 15:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB1DD6124D
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 15:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbhIOPC1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Sep 2021 11:02:27 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56940 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237842AbhIOPC1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 11:02:27 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id B87AE6000D;
        Wed, 15 Sep 2021 16:59:54 +0200 (CEST)
Date:   Wed, 15 Sep 2021 17:01:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf] netfilter: ip6_tables: zero-initialize fragment offset
Message-ID: <20210915150103.GA19119@salvia>
References: <20210912212433.45389-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210912212433.45389-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Sep 12, 2021 at 10:24:33PM +0100, Jeremy Sowden wrote:
> ip6tables only sets the `IP6T_F_PROTO` flag on a rule if a protocol is
> specified (`-p tcp`, for example).  However, if the flag is not set,
> `ip6_packet_match` doesn't call `ipv6_find_hdr` for the skb, in which
> case the fragment offset is left uninitialized and a garbage value is
> passed to each matcher.

Applied, thanks.
