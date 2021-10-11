Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E910C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 23:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62C9B60F22
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 23:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbhJKXCv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 19:02:51 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39260 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbhJKXCu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 19:02:50 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8396D63EEE;
        Tue, 12 Oct 2021 00:59:13 +0200 (CEST)
Date:   Tue, 12 Oct 2021 01:00:39 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [libnetfilter_log PATCH 0/8] Build fixes
Message-ID: <YWTCF/rc+SAfNw6o@salvia>
References: <20211009113839.2765382-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211009113839.2765382-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Oct 09, 2021 at 12:38:30PM +0100, Jeremy Sowden wrote:
> An assortment of autotools and pkg-config updates.

Series applied, thanks.
