Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C52C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jun 2022 10:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbiF0Kbp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jun 2022 06:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbiF0Kbo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jun 2022 06:31:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C85F86261
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jun 2022 03:31:43 -0700 (PDT)
Date:   Mon, 27 Jun 2022 12:31:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/3] parser_bison: fix error location for set elements
Message-ID: <YrmHDFXKj8bGvBdL@salvia>
References: <20220518180435.298462-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220518180435.298462-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 18, 2022 at 08:04:33PM +0200, Pablo Neira Ayuso wrote:
> opt_newline causes interfere since it points to the previous line.
> Refer to set element key for error reporting.

For the record, pushed out this series with minor comestic updates.
