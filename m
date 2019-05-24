Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C53C072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 19:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12D892184E
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 19:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732078AbfEXTba (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 15:31:30 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:58622 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391669AbfEXTba (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 15:31:30 -0400
Received: from [31.4.219.201] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hUFuZ-0003KW-Kk; Fri, 24 May 2019 21:31:29 +0200
Date:   Fri, 24 May 2019 21:31:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v4 2/2] jump: Allow goto and jump to a variable using
 nft input files
Message-ID: <20190524193126.ukq2qs5w7ti6jicb@salvia>
References: <20190524130648.21520-1-ffmancera@riseup.net>
 <20190524130648.21520-2-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524130648.21520-2-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 24, 2019 at 03:06:50PM +0200, Fernando Fernandez Mancera wrote:
> This patch introduces the use of nft input files variables in 'jump' and 'goto'
> statements, e.g.
> 
> define dest = ber
> 
> add table ip foo
> add chain ip foo bar {type filter hook input priority 0;}
> add chain ip foo ber
> add rule ip foo ber counter
> add rule ip foo bar jump $dest
> 
> table ip foo {
>         chain bar {
>                 type filter hook input priority filter; policy accept;
>                 jump ber
>         }
> 
>         chain ber {
>                 counter packets 71 bytes 6664
>         }
> }

Also applied, thanks.
