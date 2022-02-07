Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640BEC4167D
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Feb 2022 14:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbiBGOSC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 09:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358969AbiBGONz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 09:13:55 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BE37C0401C0
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Feb 2022 06:13:55 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id ECDA66018C;
        Mon,  7 Feb 2022 15:13:50 +0100 (CET)
Date:   Mon, 7 Feb 2022 15:13:51 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [libnetfilter_conntrack PATCH] build: update obsolete autoconf
 macros
Message-ID: <YgEpH3hGEO6ak6Jg@salvia>
References: <20220206094702.1513892-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220206094702.1513892-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Feb 06, 2022 at 09:47:02AM +0000, Jeremy Sowden wrote:
> `AC_CONFIG_HEADER` has been superseded by `AC_CONFIG_HEADERS`.
> 
> `AM_PROG_LIBTOOL` has been superseded by `LT_INIT`.
> 
> `AC_DISABLE_STATIC` can be replaced by an argument to `LT_INIT`.

Applied, thanks
