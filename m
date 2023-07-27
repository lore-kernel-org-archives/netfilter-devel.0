Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743F6C0015E
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jul 2023 13:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbjG0N6a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jul 2023 09:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbjG0N63 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2023 09:58:29 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8905430CF;
        Thu, 27 Jul 2023 06:58:28 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qP1VZ-0003OL-KQ; Thu, 27 Jul 2023 15:58:25 +0200
Date:   Thu, 27 Jul 2023 15:58:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH netfilter] netfilter: nfnetlink_log: always add a
 timestamp
Message-ID: <20230727135825.GF2963@breakpoint.cc>
References: <20230725085443.2102634-1-maze@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230725085443.2102634-1-maze@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Maciej Żenczykowski <maze@google.com> wrote:
> Compared to all the other work we're already doing to deliver
> an skb to userspace this is very cheap - at worse an extra
> call to ktime_get_real() - and very useful.

Reviewed-by: Florian Westphal <fw@strlen.de>
