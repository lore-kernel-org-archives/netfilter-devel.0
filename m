Return-Path: <SRS0=bD7Q=5E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBA3C4332E
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Mar 2020 10:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E252320722
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Mar 2020 10:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgCSKej (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Mar 2020 06:34:39 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:36744 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbgCSKej (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 06:34:39 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jEsVa-000400-4g; Thu, 19 Mar 2020 11:34:38 +0100
Date:   Thu, 19 Mar 2020 11:34:38 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Bug URGENT Report with new kernel 5.5.10-5.6-rc6
Message-ID: <20200319103438.GO979@breakpoint.cc>
References: <CALidq=XsQy66n-pTMOMN=B7nEsk7BpRZnUHery5RJyjnMsiXZQ@mail.gmail.com>
 <CALidq=VVpixeJFJFkUSeDqTW=OX0+dhA04ypE=y949B+Aqaq0w@mail.gmail.com>
 <CALidq=UXHz+rjiG5JxAz-CJ1mKsFLVupsH3W+z58L2nSPKE-7w@mail.gmail.com>
 <20200319003823.3b709ad8@elisabeth>
 <CALidq=Xow0EkAP4LkqvQiDOmVDduEwLKa4c-A54or3GMj6+qVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALidq=Xow0EkAP4LkqvQiDOmVDduEwLKa4c-A54or3GMj6+qVw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Martin Zaharinov <micron10@gmail.com> wrote:

[ trimming CC ]

Please revert

commit 28f8bfd1ac948403ebd5c8070ae1e25421560059
netfilter: Support iif matches in POSTROUTING

