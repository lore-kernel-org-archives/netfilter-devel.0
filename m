Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFA7C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 11:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhLQL75 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 06:59:57 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60926 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhLQL75 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 06:59:57 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 04BE0605C2;
        Fri, 17 Dec 2021 12:57:25 +0100 (CET)
Date:   Fri, 17 Dec 2021 12:59:52 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [conntrack-tools PATCH 0/3] bison & flex autotools updates
Message-ID: <Ybx7uNJYUXFJco2F@salvia>
References: <20211216170513.180579-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211216170513.180579-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 16, 2021 at 05:05:10PM +0000, Jeremy Sowden wrote:
> The first two patches bring the use of bison and flex and their
> generated files more into line with the recommendations of automake.
> The third fixes an autoconf deprecation warning.

Series applied, thanks
