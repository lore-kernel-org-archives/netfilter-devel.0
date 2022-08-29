Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CFE0ECAAD2
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Aug 2022 07:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiH2Hzb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Aug 2022 03:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiH2HzW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Aug 2022 03:55:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75C7913E91
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2022 00:55:16 -0700 (PDT)
Date:   Mon, 29 Aug 2022 09:55:11 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnftnl] rule, set_elem: fix printing of user data
Message-ID: <Ywxw3x6QA8hZXf9K@salvia>
References: <20220827171717.945191-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220827171717.945191-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 27, 2022 at 06:17:17PM +0100, Jeremy Sowden wrote:
> Hitherto, alphanumeric characters have been printed as-is, but anything
> else was replaced by '\0'.  However, this effectively truncates the
> output.  Instead, print any printable character as-is and print anything
> else as a hexadecimal escape sequence:
> 
>   userdata = { \x01\x04\x01\x00\x00\x00 }

Applied, thanks
