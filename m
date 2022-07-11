Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70270C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Jul 2022 14:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiGKOk4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 10:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiGKOkm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 10:40:42 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECE3D6D2D8
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2022 07:40:14 -0700 (PDT)
Date:   Mon, 11 Jul 2022 16:40:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     James Yonan <james@openvpn.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: in nf_nat_initialized(), use const struct
 nf_conn *
Message-ID: <Ysw2Snc61eGytrj1@salvia>
References: <20220629192210.541840-1-james@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220629192210.541840-1-james@openvpn.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 29, 2022 at 01:22:10PM -0600, James Yonan wrote:
> nf_nat_initialized() doesn't modify passed struct nf_conn,
> so declare as const.
> 
> This is helpful for code readability and makes it possible
> to call nf_nat_initialized() with a const struct nf_conn *.

Applied, thanks
