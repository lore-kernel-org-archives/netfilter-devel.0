Return-Path: <SRS0=chdK=V2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BD9C433FF
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 00:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6CA3206BA
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 00:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfG2Ahl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 Jul 2019 20:37:41 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59600 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726216AbfG2Ahl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Jul 2019 20:37:41 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hrtfX-00080Q-KP; Mon, 29 Jul 2019 02:37:39 +0200
Date:   Mon, 29 Jul 2019 02:37:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Adel Belhouane <bugs.a.b@free.fr>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables v2]: restore legacy behaviour of
 iptables-restore when rules start with -4/-6
Message-ID: <20190729003739.lwqe3ng47malacyf@breakpoint.cc>
References: <dcef34f2-7271-72e3-e0c3-60844305dd62@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcef34f2-7271-72e3-e0c3-60844305dd62@free.fr>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adel Belhouane <bugs.a.b@free.fr> wrote:
> 
> v2: moved examples to testcase files
> 
> Legacy implementation of iptables-restore / ip6tables-restore allowed
> to insert a -4 or -6 option at start of a rule line to ignore it if not
> matching the command's protocol. This allowed to mix specific ipv4 and
> ipv6 rules in a single file, as still described in iptables 1.8.3's man
> page in options -4 and -6. The implementation over nftables doesn't behave
> correctly in this case: iptables-nft-restore accepts both -4 or -6 lines
> and ip6tables-nft-restore throws an error on -4.
> 
> There's a distribution bug report mentioning this problem:
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=925343
 
> Restore the legacy behaviour:
> - let do_parse() return and thus not add a command in those restore
>   special cases
> - let do_commandx() ignore CMD_NONE instead of bailing out
> 
> I didn't attempt to fix all minor anomalies, but just to fix the
> regression. For example in the line below, iptables should throw an error
> instead of accepting -6 and then adding it as ipv4:
> 
> % iptables-nft -6 -A INPUT -p tcp -j ACCEPT
> 
> Signed-off-by: Adel Belhouane <bugs.a.b@free.fr>

Applied, thank you for providing an updated patch with the test cases.
