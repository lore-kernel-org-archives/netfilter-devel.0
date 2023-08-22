Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D887EE4993
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Aug 2023 09:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbjHVJM4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Aug 2023 05:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234202AbjHVJMz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2023 05:12:55 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EFF1A5
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2023 02:12:51 -0700 (PDT)
Received: from [78.30.34.192] (port=60136 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qYNRO-00HJzX-Dj; Tue, 22 Aug 2023 11:12:49 +0200
Date:   Tue, 22 Aug 2023 11:12:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        kadlec@netfilter.org
Subject: Re: [PATCH ipset] bash-completion: fix syntax error
Message-ID: <ZOR8DeYVvQkEWjCL@calendula>
References: <20230721221311.1582661-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230721221311.1582661-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 21, 2023 at 11:13:11PM +0100, Jeremy Sowden wrote:
> There is a syntax error in a redirection:
> 
>   $ bash -x utils/ipset_bash_completion/ipset
>   + shopt -s extglob
>   utils/ipset_bash_completion/ipset: line 365: syntax error near unexpected token `('
>   utils/ipset_bash_completion/ipset: line 365: `done < <(PATH=${PATH}:/sbin ( command ip -o link show ) )'
> 
> Move the environment variable assignment into the sub-shell.

Applied, thanks
