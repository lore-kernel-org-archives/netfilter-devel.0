Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D03C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 15:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AA4E20854
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 15:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfCRPEi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:04:38 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:60362 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfCRPEh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 11:04:37 -0400
Received: from [195.39.71.253] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1h5tcr-0001AR-LK; Mon, 18 Mar 2019 15:52:31 +0100
Date:   Mon, 18 Mar 2019 15:52:29 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Luis Ressel <aranea@aixah.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] configure.ac: Fix a2x check
Message-ID: <20190318144618.v3r2b45pwhz4qio4@salvia>
References: <20190317171912.14194-1-aranea@aixah.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190317171912.14194-1-aranea@aixah.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Mar 17, 2019 at 06:19:11PM +0100, Luis Ressel wrote:
> * If enable_man_doc is set, but a2x can't be found, configure should
>   fail instead of silently disabling man page creation.
> 
> * The AS_IF block checking $need_a2x is never active (need_a2x has been
>   removed from configure.ac in 13e44a608 and a277479dc).
> 
> * AC_CHECK_PROG(VAR, ...) is a noop if VAR is already set, allowing the
>   user to explicitly specify the (path to the) binary in VAR. Adjust the
>   AS_IF check to account for this.

Applied, thanks.
