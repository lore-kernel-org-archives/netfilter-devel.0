Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9688EC10F00
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 15:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72AB620854
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 15:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfCRPEl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:04:41 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:51084 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfCRPEl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 11:04:41 -0400
Received: from [195.39.71.253] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1h5td9-0001Ae-P7; Mon, 18 Mar 2019 15:52:48 +0100
Date:   Mon, 18 Mar 2019 15:52:47 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Luis Ressel <aranea@aixah.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2 v2] configure.ac: Clean up AC_ARG_{WITH,ENABLE}
 invocations, s/==/=/
Message-ID: <20190318145247.xdhfqsiqs6qj322v@salvia>
References: <20190317182422.17738-1-aranea@aixah.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190317182422.17738-1-aranea@aixah.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Mar 17, 2019 at 07:24:22PM +0100, Luis Ressel wrote:
> * AC_ARG_ENABLE implicitly defines enable_debug; there's no point in
>   performing extra work just to define with_debug with an identical
>   value.
> 
> * The same applies to with_xtables and with_libxtables.
> 
> * The AS_IF block in the `AC_ARG_ENABLE([man-doc], ...` invocation is
>   essentially a noop. All it does is to set enable_man_doc to `yes` if
>   has a value that matches neither `yes` nor `no`. (This could happen if
>   a user calls `configure --enable-man-doc=foo`, but that'd be a user
>   error which we don't need to handle.)
> 
> * The correct operator for equality tests in `test` is `=`. Some
>   implementations also support `==`, but this is not portable.

Also applied, thanks.
