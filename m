Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CA0C3A589
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 16:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C02072087E
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 16:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbfHTQOd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 12:14:33 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:36114 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725971AbfHTQOd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 12:14:33 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i06mF-0006DN-NE; Tue, 20 Aug 2019 18:14:31 +0200
Date:   Tue, 20 Aug 2019 18:14:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Jallot <ejallot@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] src: secmark: fix missing quotes in selctx
 strings output
Message-ID: <20190820161431.GU2588@breakpoint.cc>
References: <CAMV0XWGubiNxMu_HSgnXMCn75p92dMvLr9E+wBx3gx3gTE6GCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMV0XWGubiNxMu_HSgnXMCn75p92dMvLr9E+wBx3gx3gTE6GCA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eric Jallot <ejallot@gmail.com> wrote:
> Colon is not allowed in strings and breaks nft -f.
> So move to quoted string in selctx output.
> 
> Before patch:
>  # nft list ruleset > rules.nft; cat rules.nft
>  table inet t {
>          secmark s {
>                  system_u:object_r:ssh_server_packet_t:s0
>          }
>  }
>  # nft flush ruleset
>  # nft -f rules.nft
>  rules.nft:3:11-11: Error: syntax error, unexpected colon
>                 system_u:object_r:ssh_server_packet_t:s0
>                         ^
> 
> After patch:
>  # nft list ruleset > rules.nft; cat rules.nft
>  table inet t {
>          secmark s {
>                  "system_u:object_r:ssh_server_packet_t:s0"
>          }
>  }
>  # nft flush ruleset
>  # nft -f rules.nft
> 
> Fixes: 3bc84e5c ("src: add support for setting secmark")
> Signed-off-by: Eric Jallot <ejallot@gmail.com>

Thanks for the patches.  Something has mangled them in transit,
replacing tabs with spaces and adding line breaks.

I've applied this change manually and pushed the result out,
can you please double-check the result is correct?

If not, please submit a relative fix.

Thanks!
